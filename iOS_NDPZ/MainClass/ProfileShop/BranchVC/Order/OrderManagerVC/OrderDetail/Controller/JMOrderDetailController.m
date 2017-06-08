//
//  JMOrderDetailController.m
//  XLMM
//
//  Created by zhang on 17/4/7.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "JMOrderDetailController.h"
#import "JMOrderDetailHeaderView.h"
#import "JMOrderDetailFooterView.h"
#import "JMOrderDetailModel.h"
#import "JMOrderGoodsModel.h"
#import "JMEditAddressModel.h"
#import "JMPackAgeModel.h"
#import "JMBaseGoodsCell.h"
#import "CSLogisticsInformationController.h"
#import "ShenQingTuikuanController.h"
#import "JMApplyForRefundController.h"
#import "ShenQingTuiHuoController.h"
#import "JMRefundView.h"
#import "JMPopViewAnimationSpring.h"
#import "JMOrderPayOutdateView.h"
#import "JMPopLogistcsController.h"
#import "JMModifyAddressController.h"
#import "JMOrderDetailSectionView.h"
#import "JMRefundController.h"
#import "JMPayShareController.h"
#import "WXApi.h"
#import "JMGoodsDetailController.h"
#import "WebViewController.h"
#import "JMClassPopView.h"
#import "JMPopViewAnimationDrop.h"
#import "JMPayment.h"
#import "JMGoodsCountTime.h"
#import "JMOrderListController.h"
#import "CSShareManager.h"
#import "QYPOPSDK.h"
#import "CSCustomerServiceManager.h"
#import "JMStoreManager.h"


@interface JMOrderDetailController ()<NSURLConnectionDataDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,JMOrderDetailHeaderViewDelegate,JMBaseGoodsCellDelegate,JMRefundViewDelegate,JMOrderPayOutdateViewDelegate,JMPopLogistcsControllerDelegate,JMOrderDetailSectionViewDelegate,JMRefundControllerDelegate> {
    BOOL _isPopChoiseRefundWay;                // 是否弹出选择退款方式
    BOOL _isTeamBuy;                           // 是否为团购订单
    
    NSInteger _sectionCount;
    NSInteger _rowCount;
    NSString *_checkTeamBuy;                   // 查看开团进展
    bool _isCanRefund;                         // 开团后是否可以退款
    NSInteger redPageNumber;                   // 红包数量
    BOOL isChakanWuliu;
}

@property (nonatomic, strong) QYSessionViewController *sessionViewController;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *orderGoodsDataSource;
/**
 *  tableHeaderView
 */
@property (nonatomic, strong) JMOrderDetailHeaderView *orderDetailHeaderView;
/**
 *  tableFooterView
 */
@property (nonatomic, strong) JMOrderDetailFooterView *orderDetailFooterView;
/**
 *  订单详情模型
 */
@property (nonatomic,strong) JMOrderDetailModel *orderDetailModel;

/**
 *  包裹信息模型
 */
@property (nonatomic,strong) JMPackAgeModel *packageModel;
//下拉的标志
@property (nonatomic) BOOL isPullDown;
/**
 *  蒙版视图
 */
@property (nonatomic,strong) UIView *maskView;
@property (nonatomic, strong) JMRefundView *popView;
@property (nonatomic, strong) JMOrderPayOutdateView *outDateView;
@property (nonatomic, strong) JMClassPopView *classPopView;
/**
 *  修改物流视图
 */
@property (nonatomic,strong) JMPopLogistcsController *showViewVC;
/**
 *  退款选择弹出框视图
 */
@property (nonatomic,strong) JMRefundController *refundVC;


@property (nonatomic, assign)BOOL isInstallWX;
@property (nonatomic, strong) NSMutableArray *logisticsArr;  //包裹分组信息
@property (nonatomic, strong) NSMutableArray *dataSource;    //商品分组信息

@property (nonatomic, strong) JMShareModel *shareModel;
@property (nonatomic, strong) CSSharePopController *sharPopVC;

@property (nonatomic, strong) CSOrderDetailChannels *channelsModel;

@end

@implementation JMOrderDetailController

#pragma mark 懒加载
- (CSSharePopController *)sharPopVC {
    if (!_sharPopVC) {
        _sharPopVC = [[CSSharePopController alloc] init];
    }
    return _sharPopVC;
}
- (JMShareModel *)shareModel {
    if (!_shareModel) {
        _shareModel = [[JMShareModel alloc] init];
    }
    return _shareModel;
}
- (JMPackAgeModel *)packageModel {
    if (_packageModel == nil) {
        _packageModel = [[JMPackAgeModel alloc] init];
    }
    return _packageModel;
}
- (NSMutableArray *)logisticsArr {
    if (_logisticsArr == nil) {
        _logisticsArr = [NSMutableArray array];
    }
    return _logisticsArr;
}
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (JMPopLogistcsController *)showViewVC {
    if (_showViewVC == nil) {
        _showViewVC = [[JMPopLogistcsController alloc] init];
        _showViewVC.delegate = self;
    }
    return _showViewVC;
}
- (JMRefundController *)refundVC {
    if (_refundVC == nil) {
        _refundVC = [[JMRefundController alloc] init];
        self.refundVC.delegate = self;
    }
    return _refundVC;
}
- (NSMutableArray *)orderGoodsDataSource {
    if (_orderGoodsDataSource == nil) {
        _orderGoodsDataSource = [NSMutableArray array];
    }
    return _orderGoodsDataSource;
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [JMGoodsCountTime initCountDownWithCurrentTime:0];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createNavigationBarWithTitle:@"订单详情" selecotr:@selector(popToview)];
    
    _isTeamBuy = NO;
    isChakanWuliu = NO;
    
    [self createTableView];
    [self createPullHeaderRefresh];
    [self createTableHeaderView];
//    [self createTableFooterView];
}


#pragma mrak 刷新界面
- (void)createPullHeaderRefresh {
    kWeakSelf
    self.tableView.mj_header = [MJAnimationHeader headerWithRefreshingBlock:^{
        _isPullDown = YES;
        [weakSelf loadDataSource];
    }];
}
- (void)endRefresh {
    if (_isPullDown) {
        _isPullDown = NO;
        [self.tableView.mj_header endRefreshing];
    }
}
#pragma mark 创建视图
- (void)createTableView {
//    kWeakSelf
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64 - 60) style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.rowHeight = 110.f;
    self.tableView.backgroundColor = [UIColor countLabelColor];
    [self.tableView registerClass:[JMBaseGoodsCell class] forCellReuseIdentifier:JMBaseGoodsCellIdentifier];
    
    JMOrderPayOutdateView *outDateView = [[JMOrderPayOutdateView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 60, SCREENWIDTH, 60)];
    [self.view addSubview:outDateView];
    self.outDateView = outDateView;
    self.outDateView.delegate = self;
    
}
- (void)createTableHeaderView {
    JMOrderDetailHeaderView *orderDetailHeaderView = [[JMOrderDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 390)];
    self.orderDetailHeaderView = orderDetailHeaderView;
    self.orderDetailHeaderView.delegate = self;
    self.tableView.tableHeaderView = self.orderDetailHeaderView;
}
- (void)createTableFooterView {
    JMOrderDetailFooterView *orderDetailFooterView = [[JMOrderDetailFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 260)];
    self.orderDetailFooterView = orderDetailFooterView;
    self.tableView.tableFooterView = self.orderDetailFooterView;
}
#pragma mark 分享红包接口数据
- (void)loadShareRedpage:(NSString *)orderTid {
    NSString *string = [NSString stringWithFormat:@"%@/rest/v2/sharecoupon/create_order_share?uniq_id=%@", Root_URL,orderTid];
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:string WithParaments:nil WithSuccess:^(id responseObject) {
        [MBProgressHUD hideHUD];
        if (!responseObject) return;
        [self shareRedpageData:responseObject];
    } WithFail:^(NSError *error) {
        [MBProgressHUD hideHUD];
    } Progress:^(float progress) {
        
    }];
}
- (void)shareRedpageData:(NSDictionary *)shareDict {
    self.shareModel.share_type = [NSString stringWithFormat:@"%@",[shareDict objectForKey:@"code"]];
    self.shareModel.share_img = [shareDict objectForKey:@"post_img"]; //图片
    self.shareModel.desc = [shareDict objectForKey:@"description"]; // 文字详情
    self.shareModel.title = [shareDict objectForKey:@"title"]; //标题
    self.shareModel.share_link = [shareDict objectForKey:@"share_link"];
    redPageNumber = [shareDict[@"share_times_limit"] integerValue];
    self.sharPopVC.model = self.shareModel;
}
#pragma mark 请求数据
- (void)loadDataSource {
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:self.urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        [self.orderGoodsDataSource removeAllObjects];
        [self.dataSource removeAllObjects];
        [self.logisticsArr removeAllObjects];
        [self refetchData:responseObject];
        [self.tableView reloadData];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [self endRefresh];
        [MBProgressHUD showError:@"获取数据失败"];
    } Progress:^(float progress) {
        
    }];
}
- (void)refetchData:(NSDictionary *)dicJson {
    JMOrderDetailModel *orderDetailModel = [JMOrderDetailModel mj_objectWithKeyValues:dicJson];
    self.orderDetailModel = orderDetailModel;
    if ([orderDetailModel.order_type integerValue] == 3) {
        _isTeamBuy = YES;
    }
    _isCanRefund = orderDetailModel.can_refund;
    
    self.showViewVC.logisticsStr = self.orderDetailModel.goodsID;
    self.showViewVC.goodsID = self.orderDetailModel.user_adress.userAddressID;
    // ===== 订单退款选择是否弹出选择退款方式 ===== //
    if (self.orderDetailModel.extras.channels.count < 2) {
        _isPopChoiseRefundWay = NO;
    }else {
        _isPopChoiseRefundWay = YES;
    }
    self.orderGoodsDataSource = self.orderDetailModel.orders;
    self.logisticsArr = self.orderDetailModel.package_orders;
    
    // 这里对数据进行赋值,当订单详情为团购的时候,底部不显示继续支付或者分享红包,只显示查看进度
    self.orderDetailHeaderView.orderDetailModel = self.orderDetailModel;
//    self.orderDetailFooterView.orderDetailModel = self.orderDetailModel;
    NSInteger statusCount = [self.orderDetailModel.status integerValue];
    self.outDateView.statusCount = statusCount;
    if (statusCount >= 6) {
        self.tableView.cs_h = SCREENHEIGHT - 64;
        self.outDateView.cs_h = 0.;
    }else if (statusCount == 1) {
        self.outDateView.createTimeStr = self.orderDetailModel.created;
    }
    
    NSInteger statusCode = [self.orderDetailModel.status integerValue];
    bool isCanChangeAddress = self.orderDetailModel.can_change_address;
    if (statusCode == 2 && isCanChangeAddress) {
        self.orderDetailHeaderView.addressView.userInteractionEnabled = YES;
        isChakanWuliu = YES;
    }else {
        isChakanWuliu = NO;
    }
    JMOrderGoodsModel *goodsModel = self.orderDetailModel.orders[0];
    NSInteger goodsCount = self.orderDetailModel.orders.count;
    NSInteger number = 0;
    NSString *package = goodsModel.package_order_id;
    NSMutableArray *dataArr = [NSMutableArray array];
    for (int i = 0; i < goodsCount; i++) {
        [dataArr addObject:self.orderGoodsDataSource[number]];
        number ++;
        if (number == goodsCount) {
            [self.dataSource addObject:dataArr];
        }else {
            JMOrderGoodsModel *goodsModel = self.orderDetailModel.orders[number];
            NSString *package2 = goodsModel.package_order_id;
            if ([package isEqual:package2]) {
            }else {
                package = package2;
                [self.dataSource addObject:dataArr];
                dataArr = [NSMutableArray array];
            }
        }
    }
    _checkTeamBuy = [NSString stringWithFormat:@"%@/mall/order/spell/group/%@?from_page=order_detail",Root_URL,self.orderDetailModel.tid];
    
}
#pragma mark tableHeaderView点击事件 ->修改地址/物流
- (void)composeHeaderTapView:(JMOrderDetailHeaderView *)headerView TapClick:(NSInteger)index {
    if (index == 100) {
        // 修改地址
        JMModifyAddressController *editVC = [[JMModifyAddressController alloc] init];
        editVC.orderEditAddress = YES;
        editVC.cartsPayInfoLevel = 1;
        editVC.addressLevel = 1;
        editVC.orderAddressModel = self.orderDetailModel.user_adress;
        [self.navigationController pushViewController:editVC animated:YES];
    }else {
        // 修改物流  (如果需要判断是否可以更改物流在这里弹出一个提示)
//        [self createClassPopView:@"提示" Message:orderDetailModifyLogistics Index:0];
    }
}
- (void)createChangeLogisticsView {  // Index == 0  修改物流
    [[JMGlobal global] showpopBoxType:popViewTypeBox Frame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 240) ViewController:self.showViewVC WithBlock:^(UIView *maskView) {
    }];
}
- (void)ClickLogistics:(JMPopLogistcsController *)click Title:(NSString *)title {
    [self.tableView.mj_header beginRefreshing];
//    self.orderDetailHeaderView.logisticsStr = title;
}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JMBaseGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:JMBaseGoodsCellIdentifier];
    if (!cell) {
        cell = [[JMBaseGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JMBaseGoodsCellIdentifier];
    }
    JMOrderGoodsModel *orderGoodsMOdel = self.dataSource[indexPath.section][indexPath.row];
    if (self.logisticsArr.count == 0) {
        self.packageModel = nil;
    }else {
        self.packageModel = self.logisticsArr[indexPath.section];
    }
    cell.isTeamBuy = _isTeamBuy;
    cell.isCanRefund = _isCanRefund;
//    [cell configWithModel:self.orderGoodsModel PackageModel:self.packageModel SectionCount:indexPath.section RowCount:indexPath.row];
    [cell configWithModel:orderGoodsMOdel SectionCount:indexPath.section RowCount:indexPath.row];
    cell.delegate = self;
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];//刷新行
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.logisticsArr.count == 0) {
        return 0;
    }else {
        if (self.logisticsArr.count > section) {
            return 35;
        }else {
            return 0;
        };
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.logisticsArr.count == 0) {
        return nil;
    }else {
        JMOrderDetailSectionView *sectionView = [[JMOrderDetailSectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 35)];
        sectionView.indexSection = section;
        self.packageModel = self.logisticsArr[section];
        sectionView.packageModel = self.packageModel;
        sectionView.delegate = self;
        return sectionView;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (isChakanWuliu) {
        return 40;
    }else {
        return 0.01;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (!isChakanWuliu) {
        return nil;
    }
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENHEIGHT, 40)];
    sectionView.backgroundColor = [UIColor whiteColor];
    sectionView.layer.borderColor = [UIColor lineGrayColor].CGColor;
    sectionView.layer.borderWidth = 1.;

    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sectionView addSubview:settingButton];
    settingButton.frame = CGRectMake(SCREENWIDTH - 80, 7, 60, 25);
    settingButton.layer.cornerRadius = 2.;
    settingButton.layer.borderColor = [UIColor dingfanxiangqingColor].CGColor;
    settingButton.layer.borderWidth = 0.5f;
    settingButton.titleLabel.font = CS_UIFontSize(12.);
    [settingButton setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    settingButton.tag = 1 + section;
    
    [settingButton setTitle:@"查看物流" forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(settingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return sectionView;
}
// 查看物流
- (void)settingButtonClick:(UIButton *)button {
    NSInteger sectionIndex = button.tag - 1;
    if (isChakanWuliu) {
        [self queryLogInfo:sectionIndex];
    }else {
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    [self queryLogInfo:section];
}
- (void)composeSectionView:(JMOrderDetailSectionView *)sectionView Index:(NSInteger)index {
    NSInteger section = index - 100;
    [self queryLogInfo:section];
}
- (void)queryLogInfo:(NSInteger)section {
    CSLogisticsInformationController *vc = [[CSLogisticsInformationController alloc] init];
    vc.orderDataSource = self.dataSource[section];
    if (self.logisticsArr.count == 0) {
    }else {
        vc.packageModel = self.logisticsArr[section];
    }
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)composeOptionClick:(JMBaseGoodsCell *)baseGoods Tap:(UITapGestureRecognizer *)tap Section:(NSInteger)section Row:(NSInteger)row {
    JMGoodsDetailController *detailVC = [[JMGoodsDetailController alloc] init];
    JMOrderGoodsModel *model = self.dataSource[section][row];
    detailVC.goodsID = model.model_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark 商品可选状态
- (void)composeOptionClick:(JMBaseGoodsCell *)baseGoods Button:(UIButton *)button Section:(NSInteger)section Row:(NSInteger)row {
    _sectionCount = section;
    _rowCount = row;
    // 100 申请退款 101 确认收货 102 退货退款 103 秒杀不退不换
    NSArray *arr = self.dataSource[section];
    JMOrderGoodsModel *model = arr[row];
    if (button.tag == 100) {
        self.packageModel = self.logisticsArr.count > 0 ? self.logisticsArr[section] : nil;
        if (_isPopChoiseRefundWay) {
            self.refundVC.ordergoodsModel = model;
            self.refundVC.channelsArr = self.orderDetailModel.extras.channels;
            self.refundVC.isRefund = YES;
            [[JMGlobal global] showpopBoxType:popViewTypeBox Frame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 260) ViewController:self.refundVC WithBlock:^(UIView *maskView) {
            }];
        }else {
            [self refundEntry];
        }
    }else if (button.tag == 101) {
        NSString *string = [NSString stringWithFormat:@"%@/rest/v1/order/%@/confirm_sign", Root_URL, model.orderGoodsID];
        NSLog(@"url string = %@", string);
        [JMHTTPManager requestWithType:RequestTypePOST WithURLString:string WithParaments:nil WithSuccess:^(id responseObject) {
            if (responseObject == nil) return;
            NSDictionary *dic = responseObject;
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"签收成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            if ([[dic objectForKey:@"ok"]boolValue] == YES) {
                alterView.message = @"签收成功";
                [button setTitle:@"退货退款" forState:UIControlStateNormal];
                button.tag = 102;
            } else {
                alterView.message = @"签收失败";
            }
            [alterView show];
        } WithFail:^(NSError *error) {
            
        } Progress:^(float progress) {
            
        }];
    }else if (button.tag == 102) {
        ShenQingTuiHuoController *tuiHuoVC = [[ShenQingTuiHuoController alloc] initWithNibName:@"ShenQingTuiHuoController" bundle:nil];
        tuiHuoVC.refundPrice = [model.payment floatValue];
        tuiHuoVC.dingdanModel = model;
        tuiHuoVC.tid = self.orderDetailModel.goodsID;
        tuiHuoVC.oid = model.orderGoodsID;
        tuiHuoVC.status = model.status_display;
        tuiHuoVC.button = button;
        [self.navigationController pushViewController:tuiHuoVC animated:YES];
    }else {
    }
}
/**
 *  选择退款方式 -> 极速退款 审核退款
 */
- (void)Clickrefund:(JMRefundController *)click OrderGoods:(JMOrderGoodsModel *)goodsModel Refund:(CSOrderDetailChannels *)channelsModel {
//    [self createClassPopView:@"铺子退款说明" Message:orderDetailReturnMoney Index:1];
    self.channelsModel = channelsModel;
    [self refundEntry];
}
#pragma mark 订单倒计时点击时间
- (void)composeOutDateView:(JMOrderPayOutdateView *)outDateView Index:(NSInteger)index {
    if (index == 100) { // 取消支付
        [self createClassPopView:@"你的铺子" Message:orderDetailCancelOrder Index:2];
    }else if (index == 101) { // 继续支付
        self.refundVC.channelsArr = self.orderDetailModel.extras.channels;
        self.refundVC.isRefund = NO;
        [[JMGlobal global] showpopBoxType:popViewTypeBox Frame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 260) ViewController:self.refundVC WithBlock:^(UIView *maskView) {
        }];
    }else if (index == 102) {
        [[CSCustomerServiceManager defaultManager] showCustomerService:self];
        kWeakSelf
        [CSCustomerServiceManager defaultManager].popBlock = ^() {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }else {
    }
}


- (void)Clickrefund:(JMRefundController *)click ContinuePay:(NSDictionary *)continueDic {
    [MBProgressHUD showLoading:@"支付处理中....."];
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/v2/trades/%@",Root_URL,self.orderDetailModel.goodsID];
    NSMutableString *string = [[NSMutableString alloc] initWithString:urlStr];
    [string appendString:@"/charge"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"channel"] = continueDic[@"id"];
    if ([continueDic[@"id"] isEqualToString:@"wx"]) {
        if (!self.isInstallWX) {
            [MBProgressHUD showError:@"亲，没有安装微信哦"];
            return;
        }
    }
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:string WithParaments:params WithSuccess:^(id responseObject) {
        if (!responseObject)return;
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code != 0) {
            [MBProgressHUD showError:responseObject[@"info"]];
        }else {
            [MBProgressHUD hideHUD];
            NSDictionary *dic = responseObject[@"charge"];
//            JMOrderDetailController * __weak weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [JMPayment createPaymentWithType:thirdPartyPayMentTypeForWechat Parame:dic URLScheme:kUrlScheme ErrorCodeBlock:^(JMPayError *error) {
                    NSLog(@"%ld",error.errorStatus);
                    if (error.errorStatus == payMentErrorStatusSuccess) {
                        [self paySuccessful];
                    }else if(error.errorStatus == payMentErrorStatusFail) { // 取消
                        [self popview];
                    }else { }
                }];
            });
            
        }
    } WithFail:^(NSError *error) {
        [MBProgressHUD hideHUD];
    } Progress:^(float progress) {
        
    }];
}
- (void)pushShareVC {
    JMPayShareController *payShareVC = [[JMPayShareController alloc] init];
    payShareVC.ordNum = self.orderDetailModel.goodsID;
    [self.navigationController pushViewController:payShareVC animated:YES];
}
- (void)popToview {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --- 支付成功的弹出框
- (void)paySuccessful{
    [MobClick event:@"JMOrderDetailController_PaySuccess"];
    [self pushShareVC];
    [JMNotificationCenter removeObserver:self name:@"ZhifuSeccessfully" object:nil];
    [JMNotificationCenter removeObserver:self name:@"CancleZhifu" object:nil];
}
- (void)popview {
    [MobClick event:@"JMOrderDetailController_PayCancle"];
    JMOrderListController *orderVC = [[JMOrderListController alloc] init];
    orderVC.currentIndex = 1;
    [self.navigationController pushViewController:orderVC animated:YES];
    NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in marr) {
        if ([vc isKindOfClass:[JMOrderListController class]]) {
            [marr removeObject:vc];
            break;
        }
    }
    self.navigationController.viewControllers = marr;
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [JMNotificationCenter addObserver:self selector:@selector(paySuccessful) name:@"ZhifuSeccessfully" object:nil];
    [JMNotificationCenter addObserver:self selector:@selector(popview) name:@"CancleZhifu" object:nil];
    UIApplication *app = [UIApplication sharedApplication];
    [JMNotificationCenter addObserver:self
                                             selector:@selector(purchaseViewWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:app];
    [self.tableView.mj_header beginRefreshing];
    if ([WXApi isWXAppInstalled]) {
        //  NSLog(@"安装了微信");
        self.isInstallWX = YES;
    }
    else{
        self.isInstallWX = NO;
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MBProgressHUD hideHUD];
    UIApplication *app = [UIApplication sharedApplication];
    [JMNotificationCenter removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:app];
}
- (void)purchaseViewWillEnterForeground:(NSNotification *)notification {

}
#pragma mark 弹出视图公共用法
- (void)createClassPopView:(NSString *)title Message:(NSString *)message Index:(NSInteger)index {
    kWeakSelf
    self.maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0.3;
//    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideClassPopView)]];
    self.classPopView = [JMClassPopView shareManager];
    self.classPopView = [[JMClassPopView alloc] initWithFrame:self.view.bounds Title:title DescTitle:message Cancel:@"取消" Sure:@"确定"];
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.classPopView];
    [self showClassPopVoew];
    if (index == 0) {
    }else if (index == 1) {
    }else if (index == 2) {
        self.classPopView.block = ^(NSInteger index) {
            [weakSelf hideClassPopView];
            if (index == 101) {
                [weakSelf deletePayOrder];
            }
        };
    }else if (index == 3) {
    }else if (index == 4) {
        self.classPopView.block = ^(NSInteger index) {
            [weakSelf hideClassPopView];
            if (index == 101) {
            }
        };
    }else { }
}
- (void)showClassPopVoew {
    [JMPopViewAnimationDrop showView:self.classPopView overlayView:self.maskView];
}
- (void)hideClassPopView {
    [JMPopViewAnimationDrop dismissView:self.classPopView overlayView:self.maskView];
}
#pragma mark 选择进入退款界面
- (void)refundEntry {
    NSArray *arr = self.dataSource[_sectionCount];
    JMOrderGoodsModel *model = arr[_rowCount];
    if (_isPopChoiseRefundWay == YES) {
        JMApplyForRefundController *refundVC = [[JMApplyForRefundController alloc] init];
        refundVC.dingdanModel = model;
        refundVC.channelsModel = self.channelsModel;
        [self.navigationController pushViewController:refundVC animated:YES];
    }else {
        JMApplyForRefundController *refundVC = [[JMApplyForRefundController alloc] init];
        refundVC.dingdanModel = model;
        if (self.orderDetailModel.extras.channels.count > 0) {
            refundVC.channelsModel = self.orderDetailModel.extras.channels[0];
        }
        [self.navigationController pushViewController:refundVC animated:YES];
    }
}
#pragma mark 取消待支付订单
- (void)deletePayOrder {
    [MBProgressHUD showLoading:@""];
    [JMHTTPManager requestWithType:RequestTypeDELETE WithURLString:self.urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject)return;
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 0) {
            [MBProgressHUD hideHUD];
            [self popToview];
            if (_delegate && [_delegate respondsToSelector:@selector(composeWithPopViewRefresh:)]) {
                [_delegate composeWithPopViewRefresh:self];
            }
        }else {
            [MBProgressHUD showWarning:responseObject[@"info"]];
        }
    } WithFail:^(NSError *error) {
        [MBProgressHUD showError:@"订单取消失败~!"];
    } Progress:^(float progress) {
        
    }];
}


@end



































//                [Pingpp createPayment:charge viewController:weakSelf appURLScheme:kUrlScheme withCompletion:^(NSString *result, PingppError *error) {
//                    NSLog(@"completion block: %@", result);
//
//                    if (error == nil) {
//                        [MBProgressHUD showSuccess:@"支付成功"];
//                        [MobClick event:@"buy_succ"];
//                        [self pushShareVC];
//                    } else {
//                        if ([[error getMsg] isEqualToString:@"User cancelled the operation"] || error.code == 5) {
//                            [MBProgressHUD showError:@"用户取消支付"];
//                            [MobClick event:@"buy_cancel"];
//                            [self popview];
//                        } else {
//                            [MBProgressHUD showError:@"支付失败"];
//                            NSDictionary *temp_dict = @{@"return" : @"fail", @"code" : [NSString stringWithFormat:@"%ld",(unsigned long)error.code]};
//                            [MobClick event:@"buy_fail" attributes:temp_dict];
//                            NSLog(@"%@",error);
//                            [self performSelector:@selector(popToview) withObject:nil afterDelay:1.0];
//                        }
//                    }
//                }];


































