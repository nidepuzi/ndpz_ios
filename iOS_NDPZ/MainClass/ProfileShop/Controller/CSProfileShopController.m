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
#import "JMNowFansController.h"
#import "CSDevice.h"
#import "Account1ViewController.h"
#import "JMCouponController.h"
#import "JMOrderListController.h"
#import "JMRefundBaseController.h"
#import "JMAddressViewController.h"
#import "CSPerformanceManagerController.h"
#import "JMCartViewController.h"
#import "CSMineMessageController.h"
#import "JMMaMaCenterModel.h"
#import "CSSalesManagerController.h"
#import "CSAddressManagerController.h"
#import "JMWithdrawCashController.h"
#import "CSInviteViewController.h"
#import "CSPersonalInfoController.h"
#import "CSWithDrawPopView.h"
#import "CSPopAnimationViewController.h"
#import "JMTotalEarningController.h"
#import "CSCreateBankCardController.h"
#import "CSBankWithdrawRecordingController.h"
#import "NSArray+Reverse.h"
#import "JMMaMaFansController.h"
#import "CSEarningManageController.h"
#import "WebViewController.h"

#define Max_OffsetY  50
#define  Statur_HEIGHT   [[UIApplication sharedApplication] statusBarFrame].size.height
#define  NAVIBAR_HEIGHT  (self.navigationController.navigationBar.frame.size.height)
#define  INVALID_VIEW_HEIGHT (Statur_HEIGHT + NAVIBAR_HEIGHT)

@interface CSProfileShopController () <UITableViewDelegate, UITableViewDataSource, CSProfileShopHeaderViewDelegte, CSProfileShopFooterViewDelegte> {
    BOOL _isPullDown;
    BOOL isShowRefresh;
    
    NSString *_orderRecord;             // 订单记录
    NSString *_orderRecordToday;        // 今日订单记录
    NSString *_fansWebUrl;              // 关于粉丝入口
    NSDictionary *_persinCenterDict;    // 用户信息
    NSNumber *_accountMoney;            // 零钱
    NSString *_earningsRecord;          // 收益记录
    NSString *_earningsRecordToday;     // 今日收益记录
    NSString *_visitorsToday;           // 今日访客
    
    NSDictionary *extraFiguresDic;      //
    
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CSProfileShopHeaderView *proHeaderView;
@property (nonatomic, strong) CSProfileShopFooterView *proFooterView;
@property (nonatomic, strong) UIView *naviBarView;

@property (nonatomic, strong) JMMaMaCenterModel *mamaCenterModel;
@property (nonatomic, strong) CSWithDrawPopView *popView;

@end

@implementation CSProfileShopController

- (CSWithDrawPopView *)popView {
    if (_popView == nil) {
        _popView = [CSWithDrawPopView defaultWithdrawPopView];
        _popView.typeStatus = popTypeStatusWithdraw;
        _popView.parentVC = self;
    }
    return _popView;
}

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
    _orderRecord = [NSString stringWithFormat:@"%@", self.mamaCenterModel.order_num];
    _earningsRecord = [NSString stringWithFormat:@"%.2f", [self.mamaCenterModel.carry_value floatValue]];
    extraFiguresDic = self.mamaCenterModel.extra_figures;
    
}
// 折线图数据请求
- (void)loadfoldLineData {
    NSString *chartUrl = [NSString stringWithFormat:@"%@/rest/v2/mama/dailystats?from=0&days=14", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:chartUrl WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject)return ;
        NSArray *arr = responseObject[@"results"];
        if (arr.count == 0)return;
        self.proHeaderView.mamaResults = arr;
        NSInteger index = arr.count - 1;
        NSDictionary *dic = arr[index];
        _earningsRecordToday = [NSString stringWithFormat:@"%.2f",[dic[@"carry"] floatValue]];  // 今日收益
        _orderRecordToday = [dic[@"order_num"] stringValue];
        _visitorsToday = [dic[@"visitor_num"] stringValue];
        
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
    
    CGFloat itemHeight = 160;
    NSString *vipStatus = [JMUserDefaults valueForKey:kUserVipStatus];
    if (![NSString isStringEmpty:vipStatus]) {
        if ([vipStatus isEqual:@"15"]) { // 试用期 弹出框
            itemHeight = 240;
        }
    }
    self.proFooterView.mj_h = 130 + itemHeight;
    if (itemHeight == 160) {
        self.proFooterView.statusType = profileStatusZhengshi;
    }else {
        self.proFooterView.statusType = profileStatusShiyong;
    }
    self.tableView.tableFooterView = self.proFooterView;
    
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
    
    CGFloat itemHeight = 160;
    NSString *vipStatus = [JMUserDefaults valueForKey:kUserVipStatus];
    if (![NSString isStringEmpty:vipStatus]) {
        if ([vipStatus isEqual:@"15"]) { // 试用期 弹出框
            itemHeight = 240;
        }
    }
    if (itemHeight == 160) {
        self.proFooterView = [[CSProfileShopFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 130 + itemHeight) Type:profileStatusZhengshi];
    }else {
        self.proFooterView = [[CSProfileShopFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 130 + itemHeight) Type:profileStatusShiyong];
    }
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

//    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [messageButton setImage:[UIImage imageNamed:@"navigation_message_image"] forState:UIControlStateNormal];
//    [messageButton setImage:[UIImage imageNamed:@"navigation_message_image"] forState:UIControlStateHighlighted];
//    messageButton.tag = 10;
//    [messageButton addTarget:self action:@selector(navigationBarButton:) forControlEvents:UIControlEventTouchUpInside];
//    [naviView addSubview:messageButton];
    
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
    
//    [messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(naviView.mas_centerY).offset(10);
//        make.left.equalTo(naviView);
//        make.width.height.mas_equalTo(@(44));
//    }];
    [shopCartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(naviView.mas_centerY).offset(10);
        make.right.equalTo(settingButton.mas_left);
        make.width.height.mas_equalTo(@(44));
    }];
    [settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(naviView.mas_centerY).offset(10);
        make.right.equalTo(naviView);
        make.width.height.mas_equalTo(@(44));
    }];
    [naviTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(naviView.mas_centerX);
        make.centerY.equalTo(naviView.mas_centerY).offset(10);
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
 *  102 --> 累计销量
 *  103 --> 累计访问
 *  104 --> 粉丝人数
 */
- (void)composeProfileShopHeaderTap:(CSProfileShopHeaderView *)headerView { // 邀请好友
    NSDictionary *tempDict = @{@"code" : [NSString stringWithFormat:@"%@",@"邀请好友"]};
    [MobClick event:@"CSProfileShopController_ButtonClick" attributes:tempDict];
    
    CSInviteViewController *inviteVC = [[CSInviteViewController alloc] init];
    [self.navigationController pushViewController:inviteVC animated:YES];
}
- (void)composeProfileShopHeader:(CSProfileShopHeaderView *)headerView ButtonActionClick:(UIButton *)button {
    if (![[CSDevice defaultDevice] userIsLogin]) {
        [[JMGlobal global] showLoginViewController];
        return;
    }
    NSInteger currentIndex = button.tag;
    NSArray *itemArr = @[@"头像",@"今日订单",@"今日收益",@"今日访客",@"今日粉丝"];
    NSDictionary *tempDict = @{@"code" : [NSString stringWithFormat:@"%@",itemArr[currentIndex - 100]]};
    [MobClick event:@"CSProfileShopController_ButtonClick" attributes:tempDict];
    
    switch (currentIndex) {
        case 100: {
            CSPersonalInfoController *vc = [[CSPersonalInfoController alloc] init];
            vc.profileInfo = _persinCenterDict;
            [self.navigationController pushViewController:vc animated:YES];
        }
            
            break;
        case 101: {
            MaMaOrderListViewController *order = [[MaMaOrderListViewController alloc] init];
            order.orderRecord = _orderRecordToday;
            order.orderListType = orderListWithToday;
            [self.navigationController pushViewController:order animated:YES];
            
        }
            
            break;
        case 102: {
            JMTotalEarningController *vc = [[JMTotalEarningController alloc] init];
            vc.earningsRecord = _earningsRecordToday;
            [self.navigationController pushViewController:vc animated:YES];
        }
            
            break;
        case 103: {
            TodayVisitorViewController *today = [[TodayVisitorViewController alloc] init];
            today.visitorsToday = _visitorsToday;
            today.visitorDate = [NSNumber numberWithInteger:kAppVisitoryDay];
            [self.navigationController pushViewController:today animated:YES];
        }
            
            break;
        case 104: {
            JMMaMaFansController *mamaCenterFansVC = [[JMMaMaFansController alloc] init];
//            mamaCenterFansVC.aboutFansUrl = _fansWebUrl;
            [self.navigationController pushViewController:mamaCenterFansVC animated:YES];
        }
            
            break;
            
        default:
            break;
    }
}
/**
 *  99  --> 提现记录
 *  100 --> 提现
 *  101 --> 收益管理
 *  102 --> 业绩管理
 *  103 --> 优惠券
 *  104 --> 收货地址
 *  105 --> 全部订单
 *  106 --> 待付款
 *  107 --> 待发货
 *  108 --> 已完成
 */
- (void)composeProfileShopFooter:(CSProfileShopFooterView *)headerView ButtonActionClick:(UIButton *)button {
    if (![[CSDevice defaultDevice] userIsLogin]) {
        [[JMGlobal global] showLoginViewController];
        return;
    }
    NSArray *itemArr = @[@"提现记录",@"提现",@"收益管理",@"业绩管理",@"优惠券",@"收货地址",@"全部订单",@"待付款",@"待发货",@"退款退货",@"加入正式掌柜"];
    NSDictionary *tempDict = @{@"code" : [NSString stringWithFormat:@"%@",itemArr[button.tag - 99]]};
    [MobClick event:@"CSProfileShopController_ButtonClick" attributes:tempDict];
    
    switch (button.tag) {
        case 99: {
            
            
            
//            CSBankWithdrawRecordingController *vc = [[CSBankWithdrawRecordingController alloc] init];
//            vc.accountMoney = [NSString stringWithFormat:@"%.2f",[_accountMoney floatValue]];
//            [self.navigationController pushViewController:vc animated:YES];
            Account1ViewController *account = [[Account1ViewController alloc] init];
//            account.accountMoney = _accountMoney;
//            account.personCenterDict = _persinCenterDict;
            [self.navigationController pushViewController:account animated:YES];
        }
            break;
        case 100: {
//            NSString *vipStatus = [JMUserDefaults valueForKey:kUserVipStatus];
//            if (![NSString isStringEmpty:vipStatus]) {
//                if ([vipStatus isEqual:@"15"]) { // 试用期 弹出框
//                    [self cs_presentPopView:self.popView animation:[CSPopViewAnimationSpring new] dismiss:^{
//                    }];
//                    return;
//                }
//            }
//            CSCreateBankCardController *vc = [[CSCreateBankCardController alloc] init];
//            vc.accountMoney = [NSString stringWithFormat:@"%.2f",[_accountMoney floatValue]];
//            [self.navigationController pushViewController:vc animated:YES];
            
            CSBankWithdrawRecordingController *vc = [[CSBankWithdrawRecordingController alloc] init];
            vc.accountMoney = [NSString stringWithFormat:@"%.2f",[_accountMoney floatValue]];
            [self.navigationController pushViewController:vc animated:YES];
            
            
//            JMWithdrawCashController *drawCash = [[JMWithdrawCashController alloc] init];
//            drawCash.personCenterDict = _persinCenterDict;
//            drawCash.isMaMaWithDraw = NO;
//            [self.navigationController pushViewController:drawCash animated:YES];
            
            
//            Account1ViewController *account = [[Account1ViewController alloc] init];
//            account.accountMoney = _accountMoney;
//            account.personCenterDict = _persinCenterDict;
//            [self.navigationController pushViewController:account animated:YES];
        }
            break;
        case 101: {
            CSEarningManageController *vc = [[CSEarningManageController alloc] init];
            vc.totalEarning = _earningsRecord;
            vc.weekEarning = [NSString stringWithFormat:@"%.2f",[extraFiguresDic[@"week_duration_total"] floatValue]];
            vc.monthEarning = [NSString stringWithFormat:@"%.2f",[extraFiguresDic[@"month_duration_total"] floatValue]];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 102: {
            CSPerformanceManagerController *product = [[CSPerformanceManagerController alloc] init];
            product.profileInfo = _persinCenterDict;
            [self.navigationController pushViewController:product animated:YES];
        }
            
            break;
        case 103: {
            JMCouponController *couponVC = [[JMCouponController alloc] init];
            [self.navigationController pushViewController:couponVC animated:YES];
        }
            
            break;
        case 104: {
            CSAddressManagerController *addressVC = [[CSAddressManagerController alloc] init];
            //            addressVC.isSelected = NO;
            [self.navigationController pushViewController:addressVC animated:YES];
        }
            
            break;
        case 105: {
            [self pushOrderIndexVC:0];
        }
            
            break;
        case 106: {
            [self pushOrderIndexVC:1];
        }
            
            break;
        case 107: {
            [self pushOrderIndexVC:2];
        }
            
            break;
        case 108: {
            JMRefundBaseController *refundVC = [[JMRefundBaseController alloc] init];
            [self.navigationController pushViewController:refundVC animated:YES];
        }
            
            break;
        case 109: {
            NSLog(@"加入正式掌柜");
            NSString *urlString = @"https://m.nidepuzi.com/mall/boutiqueinvite";
            NSString *active = @"myInvite";
            NSString *titleName = @"我的邀请";
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:@8 forKey:@"activity_id"];
            [dict setValue:urlString forKey:@"web_url"];
            [dict setValue:active forKey:@"type_title"];
            [dict setValue:titleName forKey:@"name_title"];
            [self pushWebView:dict ShowNavBar:YES ShowRightShareBar:YES Title:nil];
            
        }
            break;
        default:
            break;
    }
}
- (void)pushWebView:(NSMutableDictionary *)dict ShowNavBar:(BOOL)isShowNavBar ShowRightShareBar:(BOOL)isShowRightShareBar Title:(NSString *)title {
    WebViewController *activity = [[WebViewController alloc] init];
    if (title != nil) {
        activity.titleName = title;
    }
    activity.webDiction = dict;
    activity.isShowNavBar = isShowNavBar;
    activity.isShowRightShareBtn = isShowRightShareBar;
    [self.navigationController pushViewController:activity animated:YES];
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
    NSArray *itemArr = @[@"购物车",@"设置"];
    NSDictionary *tempDict = @{@"code" : [NSString stringWithFormat:@"%@",itemArr[button.tag - 11]]};
    [MobClick event:@"CSProfileShopController_ButtonClick" attributes:tempDict];
    
    switch (button.tag) {
//        case 10: {
//            CSMineMessageController *messageVC = [[CSMineMessageController alloc] init];
//            [self.navigationController pushViewController:messageVC animated:YES];
//        }
//            break;
        case 11: {
            JMCartViewController *cartVC = [[JMCartViewController alloc] init];
            cartVC.cartType = @"0";
            [self.navigationController pushViewController:cartVC animated:YES];
        }
            break;
        case 12: {
            CSProfilerSettingController *settingVC = [[CSProfilerSettingController alloc] init];
            settingVC.profileInfo = _persinCenterDict;
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























































