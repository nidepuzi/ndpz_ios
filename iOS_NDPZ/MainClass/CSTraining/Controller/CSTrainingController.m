//
//  CSTrainingController.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/9.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSTrainingController.h"
#import "CSTrainingCell.h"
#import "CSTrainingModel.h"
#import "JMReloadEmptyDataView.h"
#import "WebViewController.h"

@interface CSTrainingController () <CSTableViewPlaceHolderDelegate, UITableViewDelegate, UITableViewDataSource> {
    NSString *_nextPageUrlString;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
//下拉的标志
@property (nonatomic) BOOL isPullDown;
//上拉的标志
@property (nonatomic) BOOL isLoadMore;

@property (nonatomic, strong) JMReloadEmptyDataView *reload;

@end

@implementation CSTrainingController

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"铺子课堂" selecotr:nil];
    
    [self createTableView];
    [self createPullHeaderRefresh];
    [self createPullFooterRefresh];
    [self.tableView.mj_header beginRefreshing];
    
}
#pragma mrak 刷新界面
- (void)createPullHeaderRefresh {
    kWeakSelf
    self.tableView.mj_header = [MJAnimationHeader headerWithRefreshingBlock:^{
        _isPullDown = YES;
        [self.tableView.mj_footer resetNoMoreData];
        [weakSelf loadDataSource];
    }];
}
- (void)createPullFooterRefresh {
    kWeakSelf
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{  //  MJRefreshBackNormalFooter -- > 空视图隐藏点击加载更多   MJRefreshAutoNormalFooter -- > 空视图不会隐藏点击加载更多
        _isLoadMore = YES;
        [weakSelf loadMore];
    }];
}
- (void)endRefresh {
    if (_isPullDown) {
        _isPullDown = NO;
        [self.tableView.mj_header endRefreshing];
    }
    if (_isLoadMore) {
        _isLoadMore = NO;
        [self.tableView.mj_footer endRefreshing];
    }
}
- (void)loadDataSource {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/lesson/lessontopic",Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return;
        [self.dataSource removeAllObjects];
        [self fetchData:responseObject];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        NSLog(@"%@",error);
        [self endRefresh];
    } Progress:^(float progress) {
    }];
}
- (void)loadMore {
    if ([NSString isStringEmpty:_nextPageUrlString]) {
        [self endRefresh];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:_nextPageUrlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return;
        [self fatchMoreData:responseObject];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}
- (void)fetchData:(NSDictionary *)responseDic {
    _nextPageUrlString = responseDic[@"next"];
    NSArray *resultsArr = responseDic[@"results"];
    if (resultsArr.count != 0) {
        for (NSDictionary *dic in resultsArr) {
            CSTrainingModel *model = [CSTrainingModel mj_objectWithKeyValues:dic];
            [self.dataSource addObject:model];
        }
    }
    [self.tableView cs_reloadData];
}
- (void)fatchMoreData:(NSDictionary *)responseDic {
    _nextPageUrlString = responseDic[@"next"];
    NSArray *resultsArr = responseDic[@"results"];
    if (resultsArr.count != 0) {
        for (NSDictionary *dic in resultsArr) {
            CSTrainingModel *model = [CSTrainingModel mj_objectWithKeyValues:dic];
            [self.dataSource addObject:model];
        }
    }
    [self.tableView cs_reloadData];
}
- (void)createTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.
    backgroundColor = [UIColor countLabelColor];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[CSTrainingCell class] forCellReuseIdentifier:@"CSTrainingCellIdentifier"];
    
    self.tableView = tableView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CSTrainingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSTrainingCellIdentifier"];
    if (!cell) {
        cell = [[CSTrainingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSTrainingCellIdentifier"];
    }
    CSTrainingModel *model = self.dataSource[indexPath.row];
    [cell config:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CSTrainingModel *model = self.dataSource[indexPath.row];
    return model.cellHeight + SCREENWIDTH / 2 + 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CSTrainingModel *model = self.dataSource[indexPath.row];
    WebViewController *webVC = [[WebViewController alloc] init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:model.content_link forKey:@"web_url"];
    [dict setValue:model.title forKey:@"titleName"];
    webVC.webDiction = dict;
    webVC.isShowNavBar = true;
    webVC.isShowRightShareBtn = false;
    [self.navigationController pushViewController:webVC animated:YES];
}



- (UIView *)createPlaceHolderView {
    return self.reload;
}
- (JMReloadEmptyDataView *)reload {
    if (!_reload) {
        __block JMReloadEmptyDataView *reload = [[JMReloadEmptyDataView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) Title:@"暂时没有课程哦~" DescTitle:@"" ButtonTitle:@"" Image:@"data_empty" ReloadBlcok:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        _reload = reload;
    }
    return _reload;
}

//- (void)backClick {
//    [self.navigationController popViewControllerAnimated:YES];
//}




@end





//培训接口 rest/v1/lesson/lessontopic?lesson_type=x&orderingBy=y，可分页，      `lesson_type`: 课程类型filter（3:基础课程,0: 课程,1: 实战, 2:知识）
//`ordering`: 排序（num_attender：　参加人数排序, created：　创建时间排序 ）




















































































