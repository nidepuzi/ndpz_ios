//
//  JMNowFansController.m
//  XLMM
//
//  Created by zhang on 17/4/27.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "JMNowFansController.h"
#import "CSFansModel.h"
#import "JMFetureFansCell.h"
#import "JMReloadEmptyDataView.h"
#import "CSTableViewPlaceHolderDelegate.h"

@interface JMNowFansController () <UITableViewDelegate,UITableViewDataSource,CSTableViewPlaceHolderDelegate>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic,strong) UIButton *topButton;

//下拉的标志
@property (nonatomic) BOOL isPullDown;
//上拉的标志
@property (nonatomic) BOOL isLoadMore;
@property (nonatomic, strong) JMReloadEmptyDataView *reload;


@end

@implementation JMNowFansController {
    NSString *_urlStr;
    
}


- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"我的掌柜" selecotr:@selector(backBtnClicked:)];
    
    [self createTableView];
    [self createButton];
    
    [self createPullHeaderRefresh];
    [self createPullFooterRefresh];
    [self.tableView.mj_header beginRefreshing];
    
}
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorColor = [UIColor lineGrayColor];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    
    [self.view addSubview:self.tableView];
}
#pragma mrak 刷新界面
- (void)createPullHeaderRefresh {
//    kWeakSelf
    self.tableView.mj_header = [MJAnimationHeader headerWithRefreshingBlock:^{
        _isPullDown = YES;
        [self.tableView.mj_footer resetNoMoreData];
        [self loadDataSource];
    }];
}
- (void)createPullFooterRefresh {
//    kWeakSelf
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _isLoadMore = YES;
        [self loadMore];
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
- (NSString *)urlStr {
    return [NSString stringWithFormat:@"%@/rest/v1/pmt/xlmm/get_referal_mama", Root_URL];
}
- (void)loadDataSource {
//    NSString *string = [self urlStr];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:self.urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return;
        if (self.dataArray.count > 0) {
            [self.dataArray removeAllObjects];
        }
        [self refetch:responseObject];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}
- (void)loadMore {
    if ([NSString isStringEmpty:_urlStr]) {
        [self endRefresh];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:_urlStr WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return;
        [self refetch:responseObject];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}
- (void)refetch:(NSDictionary *)data {
    _urlStr = data[@"next"];
    NSArray *arr = data[@"results"];
    if (arr.count != 0) {
        for (NSDictionary *dic in arr) {
            CSFansModel *fetureModel = [CSFansModel mj_objectWithKeyValues:dic];
            [self.dataArray addObject:fetureModel];
        }
    }
    [self.tableView cs_reloadData];
}


- (UIView *)createPlaceHolderView {
    return self.reload;
}
- (JMReloadEmptyDataView *)reload {
    if (!_reload) {
        __block JMReloadEmptyDataView *reload = [[JMReloadEmptyDataView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) Title:@"您还没有邀请掌柜哦" DescTitle:@"分享您的精选给好友就可以啦~" ButtonTitle:@"快去邀请" Image:@"data_empty" ReloadBlcok:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        _reload = reload;
    }
    return _reload;
}


#pragma mark --UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 380;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"FensiCell";
    JMFetureFansCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[JMFetureFansCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    CSFansModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell configNowFnas:model];
    
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MBProgressHUD hideHUD];
}
- (void)backBtnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 返回顶部  image == >backTop
- (void)createButton {
    UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:topButton];
    self.topButton = topButton;
    [self.topButton addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view).offset(-20);
        make.width.height.mas_equalTo(@50);
    }];
    [self.topButton setImage:[UIImage imageNamed:@"backTop"] forState:UIControlStateNormal];
    self.topButton.hidden = YES;
    [self.topButton bringSubviewToFront:self.view];
}
- (void)topButtonClick:(UIButton *)btn {
    self.topButton.hidden = YES;
    [self searchScrollViewInWindow:self.view];
}
- (void)searchScrollViewInWindow:(UIView *)view {
    for (UIScrollView *scrollView in view.subviews) {
        if ([scrollView isKindOfClass:[UIScrollView class]]) {
            CGPoint offect = scrollView.contentOffset;
            offect.y = -scrollView.contentInset.top;
            [scrollView setContentOffset:offect animated:YES];
        }
        [self searchScrollViewInWindow:scrollView];
    }
}
#pragma mark -- 添加滚动的协议方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.topButton.hidden = scrollView.contentOffset.y > SCREENHEIGHT * 2 ? NO : YES;
}


@end





















