//
//  CSProfileShopController.m
//  NDPZ
//
//  Created by zhang on 17/4/24.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSProfileShopController.h"
#import "CSProfileShopHeaderView.h"
#import "CSProfileShopFooterView.h"
#import "CSProfilerSettingController.h"
#import "MaMaOrderListViewController.h"
#import "JMEarningListController.h"
#import "TodayVisitorViewController.h"
#import "JMMaMaFansController.h"
#import "CSDevice.h"
#import "Account1ViewController.h"
#import "JMCouponController.h"
#import "JMOrderListController.h"
#import "JMRefundBaseController.h"
#import "JMAddressViewController.h"
#import "ProductSelectionListViewController.h"
#import "JMCartViewController.h"
#import "CSMineMessageController.h"
#import "JMMaMaCenterModel.h"

#define Max_OffsetY  50
#define  Statur_HEIGHT   [[UIApplication sharedApplication] statusBarFrame].size.height
#define  NAVIBAR_HEIGHT  (self.navigationController.navigationBar.frame.size.height)
#define  INVALID_VIEW_HEIGHT (Statur_HEIGHT + NAVIBAR_HEIGHT)

@interface CSProfileShopController () <UITableViewDelegate, UITableViewDataSource, CSProfileShopHeaderViewDelegte, CSProfileShopFooterViewDelegte> {
    BOOL _isPullDown;
    BOOL isShowRefresh;
    
    NSString *_orderRecord;             // 订单记录
    NSString *_fansWebUrl;              // 关于粉丝入口
    NSDictionary *_persinCenterDict;    // 用户信息
    NSNumber *_accountMoney;            // 零钱
    
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CSProfileShopHeaderView *proHeaderView;
@property (nonatomic, strong) CSProfileShopFooterView *proFooterView;
@property (nonatomic, strong) UIView *naviBarView;

@property (nonatomic, strong) JMMaMaCenterModel *mamaCenterModel;


@end

@implementation CSProfileShopController

#pragma mark -- 视图生命周期
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    if (isShowRefresh) {
        isShowRefresh = NO;
        [self refresh];
    }else {
        [self setUserInfo];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [JMNotificationCenter addObserver:self selector:@selector(quitLogin) name:@"logout" object:nil];
    self.automaticallyAdjustsScrollViewInsets = NO;
    isShowRefresh = YES;
    [self createTableView];
    [self createPullHeaderRefresh];
    [self loadDataSource];
    [self createNavi];
    
    
}
- (void)dealloc {
    [JMNotificationCenter removeObserver:self];

}
- (void)quitLogin {
    
}
#pragma mark 刷新界面
- (void)createPullHeaderRefresh {
    kWeakSelf
    self.tableView.mj_header = [MJAnimationHeader headerWithRefreshingBlock:^{  // MJAnimationHeader
        _isPullDown = YES;
        [self.tableView.mj_footer resetNoMoreData];
        [weakSelf setUserInfo];
    }];
}
- (void)endRefresh {
    if (_isPullDown) {
        _isPullDown = NO;
        [self.tableView.mj_header endRefreshing];
    }
}
- (void)refresh {
    [self.tableView.mj_header beginRefreshing];
}
#pragma ========== 妈妈页面主数据请求 ==========
- (void)loadDataSource {
    NSString *str = [NSString stringWithFormat:@"%@/rest/v2/mama/fortune", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:str WithParaments:nil WithSuccess:^(id responseObject) {
        if (responseObject == nil) return;
        [self updateMaMaHome:responseObject];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}
- (void)updateMaMaHome:(NSDictionary *)dic {
    NSDictionary *fortuneDic = dic[@"mama_fortune"];
    self.mamaCenterModel = [JMMaMaCenterModel mj_objectWithKeyValues:fortuneDic];
    self.proHeaderView.mamaCenterModel = self.mamaCenterModel;
    
    
}
// 折线图数据请求
- (void)loadfoldLineData {
    NSString *chartUrl = [NSString stringWithFormat:@"%@/rest/v2/mama/dailystats?from=0&days=14", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:chartUrl WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject)return ;
        NSArray *arr = responseObject[@"results"];
        if (arr.count == 0)return;
        self.proHeaderView.mamaResults = arr;
    } WithFail:^(NSError *error) {
    } Progress:^(float progress) {
    }];
}

- (void)setUserInfo {
    [[JMGlobal global] upDataLoginStatusSuccess:^(id responseObject) {
        [self updateUserInfo:responseObject];
        [self endRefresh];
    } failure:^(NSInteger errorCode) {
        _accountMoney = @0.00;
        self.proHeaderView.userInfoDic = @{};
        self.proFooterView.accountMoney = _accountMoney;
        if (errorCode == 403) {
            //            [self quitLogin];
            [self endRefresh];
        }else {
            [MBProgressHUD showError:@"请求失败,请手动刷新"];
            [self endRefresh];
        }
    }];
    
}
- (void)updateUserInfo:(NSDictionary *)dic {
    _persinCenterDict = dic;
    [self loadDataSource];
    [self loadfoldLineData];
    //判断是否为0
    if ([[dic objectForKey:@"user_budget"] isKindOfClass:[NSNull class]]) {
        _accountMoney = [NSNumber numberWithFloat:0.00];
    }else {
        NSDictionary *xiaolumeimei = [dic objectForKey:@"user_budget"];
        NSNumber *num = [xiaolumeimei objectForKey:@"budget_cash"];
        _accountMoney = num;
    }
    self.proHeaderView.userInfoDic = dic;
    self.proFooterView.accountMoney = _accountMoney;
}

#pragma ========== UI处理 ==========
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - kAppTabBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.proHeaderView = [[CSProfileShopHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 260)];
    self.proHeaderView.delegate = self;
    self.tableView.tableHeaderView = self.proHeaderView;
    
    self.proFooterView = [[CSProfileShopFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 130 + 320)];
    self.proFooterView.delegate = self;
    self.tableView.tableFooterView = self.proFooterView;
    
    
    
}
- (void)createNavi {
    self.naviBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    [self.view addSubview:self.naviBarView];
    self.naviBarView.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    self.naviBarView.alpha = 0.;
    
    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    [self.view addSubview:naviView];
    naviView.backgroundColor = [UIColor clearColor];

    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageButton setImage:[UIImage imageNamed:@"navigation_message_image"] forState:UIControlStateNormal];
    [messageButton setImage:[UIImage imageNamed:@"navigation_message_image"] forState:UIControlStateHighlighted];
    messageButton.tag = 10;
    [messageButton addTarget:self action:@selector(navigationBarButton:) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:messageButton];
    
    UIButton *shopCartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shopCartButton setImage:[UIImage imageNamed:@"cs_profileShop_shopCart"] forState:UIControlStateNormal];
    [shopCartButton setImage:[UIImage imageNamed:@"cs_profileShop_shopCart"] forState:UIControlStateHighlighted];
    shopCartButton.tag = 11;
    [shopCartButton addTarget:self action:@selector(navigationBarButton:) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:shopCartButton];
    
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingButton setImage:[UIImage imageNamed:@"cs_profileShop_shezhi"] forState:UIControlStateNormal];
    [settingButton setImage:[UIImage imageNamed:@"cs_profileShop_shezhi"] forState:UIControlStateHighlighted];
    settingButton.tag = 12;
    [settingButton addTarget:self action:@selector(navigationBarButton:) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:settingButton];
    
    UILabel *naviTitleLabel = [UILabel new];
    naviTitleLabel.textColor = [UIColor whiteColor];
    naviTitleLabel.text = @"店铺";
    naviTitleLabel.font = CS_UIFontBoldSize(18.);
    [naviView addSubview:naviTitleLabel];
    
    [messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(naviView.mas_centerY).offset(10);
        make.left.equalTo(naviView);
        make.width.height.mas_equalTo(@(44));
    }];
    [shopCartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(messageButton.mas_centerY);
        make.right.equalTo(settingButton.mas_left);
        make.width.height.mas_equalTo(@(44));
    }];
    [settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(messageButton.mas_centerY);
        make.right.equalTo(naviView);
        make.width.height.mas_equalTo(@(44));
    }];
    [naviTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(naviView.mas_centerX);
        make.centerY.equalTo(messageButton.mas_centerY);
    }];
    
}
#pragma mark == UITableView 代理实现 ==
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return self.activeArray.count;
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    cell.model = self.activeArray[indexPath.row];
    return cell;
}
/**
 *  100 --> 头像
 *  101 --> 今日订单
 *  102 --> 本月销量
 *  103 --> 累计访问
 *  104 --> 粉丝人数
 */
- (void)composeProfileShopHeader:(CSProfileShopHeaderView *)headerView ButtonActionClick:(UIButton *)button {
    if (![[CSDevice defaultDevice] userIsLogin]) {
        [[JMGlobal global] showLoginViewController];
        return;
    }
    NSInteger currentIndex = button.tag;
    switch (currentIndex) {
        case 100: {
            CSProfilerSettingController *settingVC = [[CSProfilerSettingController alloc] init];
            [self.navigationController pushViewController:settingVC animated:YES];
        }
            
            break;
        case 101: {
            MaMaOrderListViewController *order = [[MaMaOrderListViewController alloc] init];
            order.orderRecord = _orderRecord;
            [self.navigationController pushViewController:order animated:YES];
            
        }
            
            break;
        case 102: {
            JMEarningListController *carry = [[JMEarningListController alloc] init];
            [self.navigationController pushViewController:carry animated:YES];
        }
            
            break;
        case 103: {
            TodayVisitorViewController *today = [[TodayVisitorViewController alloc] init];
            today.visitorDate = [NSNumber numberWithInteger:kAppVisitoryDay];
            [self.navigationController pushViewController:today animated:YES];
        }
            
            break;
        case 104: {
            JMMaMaFansController *mamaCenterFansVC = [[JMMaMaFansController alloc] init];
            mamaCenterFansVC.aboutFansUrl = _fansWebUrl;
            [self.navigationController pushViewController:mamaCenterFansVC animated:YES];
        }
            
            break;
            
        default:
            break;
    }
}
/**
 *  100 --> 提现
 *  101 --> 代收收益
 *  102 --> 累计收益
 *  103 --> 优惠券
 *  104 --> 客户管理
 *  105 --> 业绩管理
 *  106 --> 销售管理
 *  107 --> 收货地址
 *  108 --> 全部订单
 *  109 --> 待付款
 *  110 --> 待发货
 *  111 --> 已完成
 */
- (void)composeProfileShopFooter:(CSProfileShopFooterView *)headerView ButtonActionClick:(UIButton *)button {
    if (![[CSDevice defaultDevice] userIsLogin]) {
        [[JMGlobal global] showLoginViewController];
        return;
    }
    switch (button.tag) {
        case 100: {
            Account1ViewController *account = [[Account1ViewController alloc] init];
            account.accountMoney = _accountMoney;
            account.personCenterDict = _persinCenterDict;
            [self.navigationController pushViewController:account animated:YES];
        }
            break;
        case 101: {
            JMEarningListController *carry = [[JMEarningListController alloc] init];
            [self.navigationController pushViewController:carry animated:YES];
        }
            
            break;
        case 102: {
            JMEarningListController *carry = [[JMEarningListController alloc] init];
            [self.navigationController pushViewController:carry animated:YES];
        }
            
            break;
        case 103: {
            JMCouponController *couponVC = [[JMCouponController alloc] init];
            [self.navigationController pushViewController:couponVC animated:YES];
        }
            
            break;
        case 104: {
            ProductSelectionListViewController *product = [[ProductSelectionListViewController alloc] init];
            [self.navigationController pushViewController:product animated:YES];
        }
            
            break;
        case 105: {
            ProductSelectionListViewController *product = [[ProductSelectionListViewController alloc] init];
            [self.navigationController pushViewController:product animated:YES];
        }
            
            break;
        case 106: {
            ProductSelectionListViewController *product = [[ProductSelectionListViewController alloc] init];
            [self.navigationController pushViewController:product animated:YES];
        }
            
            break;
        case 107: {
            JMAddressViewController *addressVC = [[JMAddressViewController alloc] init];
            addressVC.isSelected = NO;
            [self.navigationController pushViewController:addressVC animated:YES];
        }
            
            break;
        case 108: {
            [self pushOrderIndexVC:0];
        }
            
            break;
        case 109: {
            [self pushOrderIndexVC:1];
        }
            
            break;
        case 110: {
            [self pushOrderIndexVC:2];
        }
            break;
        case 111: {
            JMRefundBaseController *refundVC = [[JMRefundBaseController alloc] init];
            [self.navigationController pushViewController:refundVC animated:YES];
        }
            
            break;
            
        default:
            break;
    }
}
- (void)pushOrderIndexVC:(NSInteger)index {
    JMOrderListController *order = [[JMOrderListController alloc] init];
    order.currentIndex = index;
    order.ispopToView = YES;
    [self.navigationController pushViewController:order animated:YES];
}
/**
 *  100 --> 消息
 *  101 --> 购物车
 *  102 --> 设置
 */
- (void)navigationBarButton:(UIButton *)button {
    if (![[CSDevice defaultDevice] userIsLogin]) {
        [[JMGlobal global] showLoginViewController];
        return;
    }
    switch (button.tag) {
        case 10: {
            CSMineMessageController *messageVC = [[CSMineMessageController alloc] init];
            [self.navigationController pushViewController:messageVC animated:YES];
        }
            break;
        case 11: {
            JMCartViewController *cartVC = [[JMCartViewController alloc] init];
            cartVC.cartType = @"0";
            [self.navigationController pushViewController:cartVC animated:YES];
        }
            break;
        case 12: {
            CSProfilerSettingController *settingVC = [[CSProfilerSettingController alloc] init];
            [self.navigationController pushViewController:settingVC animated:YES];
        }
            break;
        default:
            break;
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset_Y = scrollView.contentOffset.y;
    if (offset_Y > Max_OffsetY) {
        CGFloat alpha = MIN(1, 1 - ((Max_OffsetY + INVALID_VIEW_HEIGHT - offset_Y) / INVALID_VIEW_HEIGHT));
//        self.naviView.backgroundColor = [UIColor buttonEnabledBackgroundColor];
        self.naviBarView.alpha = alpha;
//        self.navigationItem.title = alpha > 0.8 ? @"我的店铺" : @"";
    }else {
        self.naviBarView.alpha = 0;
    }
    
    
}




@end























































