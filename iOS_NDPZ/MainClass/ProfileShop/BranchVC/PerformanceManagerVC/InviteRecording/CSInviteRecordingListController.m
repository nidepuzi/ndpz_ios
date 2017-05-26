//
//  CSInviteRecordingListController.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/26.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSInviteRecordingListController.h"
#import "JMReloadEmptyDataView.h"
#import "CSFansModel.h"
#import "CSInviteRecordingCell.h"

@interface CSInviteRecordingListController () <UITableViewDelegate, UITableViewDataSource> {
    BOOL _isPullDown;       // 下拉刷新的标志
    BOOL _isLoadMore;       // 上拉加载的标志
    NSString *_nextPageUrl; // 下一页数据
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) JMReloadEmptyDataView *reload;




@end

@implementation CSInviteRecordingListController




#pragma mark ==== 懒加载 ====
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark ==== 生命周期函数 ====
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"钱包" selecotr:@selector(backClick)];
    [self createcustomizeUI];
    [self createPullHeaderRefresh];
    [self createPullFooterRefresh];
    [self.tableView.mj_header beginRefreshing];
    
}

#pragma mark ==== 下拉刷新,上拉加载 ====
- (void)createPullHeaderRefresh {
    kWeakSelf
    self.tableView.mj_header = [MJAnimationHeader headerWithRefreshingBlock:^{  // MJAnimationHeader
        _isPullDown = YES;
        [self.tableView.mj_footer resetNoMoreData];
        [weakSelf loadDataSource];
    }];
}
- (void)createPullFooterRefresh {
    kWeakSelf
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
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
#pragma mark ==== 网络请求 ====
- (void)loadDataSource {
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:self.urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject)return;
        [self.dataSource removeAllObjects];
        [self dataAnalysis:responseObject];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}
- (void)loadMore {
    if ([NSString isStringEmpty:_nextPageUrl]) {
        [self endRefresh];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:_nextPageUrl WithParaments:nil WithSuccess:^(id responseObject) {
        [self.tableView.mj_footer endRefreshing];
        if (!responseObject)return;
        [self dataAnalysis:responseObject];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}
- (void)dataAnalysis:(NSDictionary *)data {
    _nextPageUrl = data[@"next"];
    NSArray *results = data[@"results"];
    if (results.count != 0 ) {
        for (NSDictionary *account in results) {
            CSFansModel *accountM = [CSFansModel mj_objectWithKeyValues:account];
            [self.dataSource addObject:accountM];
        }
    }
    [self.tableView cs_reloadData];
}


#pragma mark ==== 自定义UI ====
- (void)createcustomizeUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[CSInviteRecordingCell class] forCellReuseIdentifier:@"CSInviteRecordingCellIdentifier"];
    self.tableView = tableView;
}


#pragma mark ==== 代理事件 ====
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CSInviteRecordingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSInviteRecordingCellIdentifier"];
    if (!cell) {
        cell = [[CSInviteRecordingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSInviteRecordingCellIdentifier"];
    }
    cell.model = self.dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 60)];
    sectionView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH * 0.28, 60)];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(label1.cs_max_X, 0, SCREENWIDTH * 0.28, 60)];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(label2.cs_max_X, 0, SCREENWIDTH * 0.16, 60)];
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(label3.cs_max_X, 0, SCREENWIDTH * 0.28, 60)];
    [self label:label1 Text:@"用户手机"];
    [self label:label2 Text:@"用户姓名"];
    [self label:label3 Text:@"状态"];
    [self label:label4 Text:@"购买日期"];
    
    [sectionView addSubview:label1];
    [sectionView addSubview:label2];
    [sectionView addSubview:label3];
    [sectionView addSubview:label4];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor lineGrayColor];
    [sectionView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREENWIDTH);
        make.bottom.equalTo(sectionView);
        make.centerX.equalTo(sectionView.mas_centerX);
        make.height.mas_equalTo(@1);
    }];
    
    return sectionView;
}
- (void)label:(UILabel *)label Text:(NSString *)text {
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor dingfanxiangqingColor];
    label.font = CS_UIFontSize(16.);
    label.text = text;
}


- (UIView *)createPlaceHolderView {
    return self.reload;
}
- (JMReloadEmptyDataView *)reload {
    if (!_reload) {
        kWeakSelf
        __block JMReloadEmptyDataView *reload = [[JMReloadEmptyDataView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) Title:@"" DescTitle:@"暂时还没有哦~" ButtonTitle:@"" Image:@"data_empty" ReloadBlcok:^{
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }];
        _reload = reload;
    }
    return _reload;
}




#pragma mark ==== 自定义点击事件 ====
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}








@end
