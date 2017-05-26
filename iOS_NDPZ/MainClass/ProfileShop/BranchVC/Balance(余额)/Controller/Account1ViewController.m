//
//  Account1ViewController.m
//  XLMM
//
//  Created by apple on 16/2/26.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "Account1ViewController.h"
#import "AccountModel.h"
#import "JMWithdrawCashController.h"
#import "JMWithDrawDetailController.h"
#import "JMAccountCell.h"
#import "CSTableViewPlaceHolderDelegate.h"
#import "JMReloadEmptyDataView.h"



@interface Account1ViewController () <CSTableViewPlaceHolderDelegate> {
    BOOL navigationBarClick;
}
@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSString *nextPage;
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, assign)BOOL isFirstLoad;

@property (nonatomic, assign)CGFloat headerH;

@property (nonatomic, strong)UILabel *moneyLabel;

@property (nonatomic, strong) JMReloadEmptyDataView *reload;
/**
 *  返回顶部按钮
 */
@property (nonatomic,strong) UIButton *topButton;
/**
 *  下拉刷新的标志
 */
@property (nonatomic, assign) BOOL isPullDown;
/**
 *  上拉加载的标志
 */
@property (nonatomic, assign) BOOL isLoadMore;

@property (nonatomic, assign) BOOL isPopToRootView;



@end

@implementation Account1ViewController {
    NSMutableArray *_imageArray;
    UIView *emptyView;
    CGFloat accountMoneyValue;
    NSArray *sectionFirstArr;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        self.dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArr;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isPopToRootView = NO;
    if (!navigationBarClick) {
        [self.tableView.mj_header beginRefreshing];
    }
    navigationBarClick = NO;
    [JMNotificationCenter addObserver:self selector:@selector(updateMoneyLabel:) name:@"drawCashMoeny" object:nil];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isPopToRootView) {
        [JMNotificationCenter postNotificationName:@"kuaiquguangguangButtonClick" object:nil];
    }
    [MBProgressHUD hideHUD];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createNavigationBarWithTitle:@"钱包" selecotr:@selector(backBtnClicked:)];
    
    navigationBarClick = NO;
    
    [self createTableView];
    [self createButton];
    [self createPullHeaderRefresh];
    [self createPullFooterRefresh];
    accountMoneyValue = [self.accountMoney floatValue];
//    [self.tableView.mj_header beginRefreshing];
}


#pragma mark 刷新界面
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
#pragma mark 数据请求
- (void)loadDataSource {
    NSString *url = [NSString stringWithFormat:@"%@/rest/v1/users/get_budget_detail", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:url WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject)return;
        [self.dataArr removeAllObjects];
        [self dataAnalysis:responseObject];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}
- (void)loadMore {
    if ([NSString isStringEmpty:self.nextPage]) {
        [self endRefresh];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:self.nextPage WithParaments:nil WithSuccess:^(id responseObject) {
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
    self.nextPage = data[@"next"];
    NSArray *results = data[@"results"];
    if (results.count != 0 ) {
        for (NSDictionary *account in results) {
            AccountModel *accountM = [[AccountModel alloc] init];
            [accountM setValuesForKeysWithDictionary:account];
            [self.dataArr addObject:accountM];
        }
    }
    [self.tableView cs_reloadData];
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
    [self.tableView registerClass:[JMAccountCell class] forCellReuseIdentifier:JMAccountCellIdentifier];
    
}

- (UIView *)createPlaceHolderView {
    return self.reload;
}
- (JMReloadEmptyDataView *)reload {
    if (!_reload) {
        __block JMReloadEmptyDataView *reload = [[JMReloadEmptyDataView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) Title:@"你的钱包空空如也" DescTitle:@"" ButtonTitle:@"快去逛逛" Image:@"data_empty" ReloadBlcok:^{
            self.isPopToRootView = YES;
            [self.navigationController popToRootViewControllerAnimated:YES];
//            [JMNotificationCenter postNotificationName:@"kuaiquguangguangButtonClick" object:nil];
        }];
        _reload = reload;
    }
    return _reload;
}


#pragma mark --邀请好友
- (void)backBtnClicked:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateMoneyLabel:(NSNotification *)center {
    self.moneyLabel.text = center.object;
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
    [self.topButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
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

#pragma mark ---UItableView的代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JMAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:JMAccountCellIdentifier];
    if (!cell) {
        cell = [[JMAccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JMAccountCellIdentifier];
    }
    AccountModel *accountM = self.dataArr[indexPath.row];
    [cell fillDataOfCell:accountM];
    
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountModel *accountM = self.dataArr[indexPath.row];
    JMWithDrawDetailController *detailVC = [[JMWithDrawDetailController alloc] init];
    detailVC.drawDict = [accountM mj_keyValues];
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountModel *accountM = self.dataArr[indexPath.row];
    return accountM.cellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 60)];
    sectionView.layer.borderColor = [UIColor lineGrayColor].CGColor;
    sectionView.layer.borderWidth = 1.;
    UILabel *hengxianL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 15)];
    hengxianL.backgroundColor = [UIColor countLabelColor];
    [sectionView addSubview:hengxianL];
    UILabel *tixianjilu = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, SCREENWIDTH, 45)];
    tixianjilu.backgroundColor = [UIColor whiteColor];
    [sectionView addSubview:tixianjilu];
    tixianjilu.textColor = [UIColor buttonTitleColor];
    tixianjilu.font = CS_UIFontSize(16.);
    tixianjilu.textAlignment = NSTextAlignmentCenter;
    tixianjilu.text = @"提现记录";
    
    return sectionView;
}

- (void)dealloc {
    [JMNotificationCenter removeObserver:self];
}





@end
























//微信红包提现入口
//    NSString *vipStatus = [JMUserDefaults valueForKey:kUserVipStatus];
//    if (![NSString isStringEmpty:vipStatus]) {
//        if ([vipStatus isEqual:@"15"]) { // 试用期 弹出框
//            [self cs_presentPopView:self.popView animation:[CSPopViewAnimationSpring new] dismiss:^{
//            }];
//            return;
//        }
//
//    }
//    JMWithdrawCashController *drawCash = [[JMWithdrawCashController alloc] init];
//    drawCash.personCenterDict = self.personCenterDict;
//    drawCash.isMaMaWithDraw = NO;
//
//    [self.navigationController pushViewController:drawCash animated:YES];





































































