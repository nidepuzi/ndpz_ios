//
//  JMPersonAllOrderController.m
//  XLMM
//
//  Created by zhang on 17/4/13.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "JMPersonAllOrderController.h"
#import "JMBaseGoodsCell.h"
#import "JMFetureFansModel.h"
#import "JMOrderGoodsModel.h"
#import "JMAllOrderModel.h"
#import "JMOrderDetailController.h"
#import "JMReloadEmptyDataView.h"


@interface JMPersonAllOrderController ()<UITableViewDataSource,UITableViewDelegate,CSTableViewPlaceHolderDelegate, JMOrderDetailControllerDelegate> {
    BOOL _isShowSettingOrder;
}

/**
 *  订单详情模型
 */
@property (nonatomic,strong) JMAllOrderModel *orderDetailModel;
/**
 *  订单中商品信息模型
 */
@property (nonatomic,strong) JMOrderGoodsModel *orderGoodsModel;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *sectionDataSource;
@property (nonatomic, strong) JMReloadEmptyDataView *reload;
//下拉的标志
@property (nonatomic) BOOL isPullDown;
//上拉的标志
@property (nonatomic) BOOL isLoadMore;
/**
 *  组头视图
 */
@property (nonatomic, strong) UILabel *orderStatusLabel;
@property (nonatomic, strong) UILabel *orderPament;
@property (nonatomic, strong) UIImageView *shareRenpageImage;

@property (nonatomic, assign) BOOL isPopToRootView;


@end

@implementation JMPersonAllOrderController {
    NSString *_urlStr;
    NSMutableArray *_goodsArray;
}

#pragma 懒加载
- (JMAllOrderModel *)orderDetailModel {
    if (_orderDetailModel == nil) {
        _orderDetailModel = [[JMAllOrderModel alloc] init];
    }
    return _orderDetailModel;
}
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (NSMutableArray *)sectionDataSource {
    if (_sectionDataSource == nil) {
        _sectionDataSource = [NSMutableArray array];
    }
    return _sectionDataSource;
}
#pragma mark 生命周期函数
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isPopToRootView = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.isPopToRootView) {
        [JMNotificationCenter postNotificationName:@"kuaiquguangguangButtonClick" object:nil];
    }
    [MBProgressHUD hideHUD];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBarWithTitle:@"全部订单" selecotr:@selector(backBtnClicked:)];
    [self createTabelView];
    [self createPullHeaderRefresh];
    [self createPullFooterRefresh];
    
//    [self emptyView];
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
- (void)refresh {
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark 网络请求,数据处理
- (void)loadDataSource {
//    NSString *string = [self urlStr];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:self.urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return;
        [self.dataSource removeAllObjects];
        [self.sectionDataSource removeAllObjects];
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
    NSArray *allArr = data[@"results"];
    if (allArr.count != 0) {
        for (NSDictionary *allDic in allArr) {
            JMAllOrderModel *allModel = [JMAllOrderModel mj_objectWithKeyValues:allDic];
            [self.dataSource addObject:allModel];
            
//            _goodsArray = [NSMutableArray array];
//            NSArray *goodsArr = allDic[@"orders"];
//            for (NSDictionary *goodsDic in goodsArr) {
//                JMOrderGoodsModel *fetureModel = [JMOrderGoodsModel mj_objectWithKeyValues:goodsDic];
//                [_goodsArray addObject:fetureModel];
//            }
//            [self.dataSource addObject:_goodsArray];
        }
    }
    [self.tableView cs_reloadData];
}
- (void)setNavigaButton:(UIButton *)navigaButton {
    _navigaButton = navigaButton;
    navigaButton.selected = NO;
    [navigaButton addTarget:self action:@selector(naviButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)naviButtonClick:(UIButton *)button {
    button.selected = !button.selected;
    _isShowSettingOrder = button.selected;
    [self.tableView cs_reloadData];
}
#pragma 创建UI 实现 UITableView 代理
- (void)createTabelView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64 - 45) style:UITableViewStyleGrouped];
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    self.tableView.tableFooterView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 110.;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    JMAllOrderModel *allModel = self.dataSource[section];
    return allModel.orders.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *JMPersonAllOrderControllerIdentifier = @"JMPersonAllOrderControllerIdentifier";
    JMBaseGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:JMPersonAllOrderControllerIdentifier];
    if (!cell) {
        cell = [[JMBaseGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JMPersonAllOrderControllerIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    JMAllOrderModel *allModel = self.dataSource[indexPath.section];
    JMOrderGoodsModel *orderGoodsModel = allModel.orders[indexPath.row];
    [cell configWithAllOrder:orderGoodsModel];
    cell.earningButton.hidden = !_isShowSettingOrder;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JMAllOrderModel *allModel = self.dataSource[indexPath.section];
    JMOrderDetailController *orderDetailVC = [[JMOrderDetailController alloc] init];
    orderDetailVC.allOrderModel = allModel;
    orderDetailVC.orderTid = allModel.tid;
    orderDetailVC.urlString = [NSString stringWithFormat:@"%@/rest/v2/trades/%@?device=app", Root_URL, allModel.goodsID];
    orderDetailVC.delegate = self;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    JMAllOrderModel *allModel = self.dataSource[section];
    
    UIView *sectionView = [UIView new];
    UIView *lineView = [UIView new];
    [sectionView addSubview:lineView];
    lineView.backgroundColor = [UIColor countLabelColor];
    
    UIView *sectionShowView = [UIView new];
    [sectionView addSubview:sectionShowView];
    sectionShowView.backgroundColor = [UIColor whiteColor];
    
    UIView *bottomView = [UIView new];
    [sectionShowView addSubview:bottomView];
    
    UILabel *orderStatusLabel = [UILabel new];
    [sectionShowView addSubview:orderStatusLabel];
    self.orderStatusLabel = orderStatusLabel;
    self.orderStatusLabel.font = [UIFont systemFontOfSize:13.];
    self.orderStatusLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    self.orderStatusLabel.text = allModel.status_display;
    
//    CGFloat payment = [allModel.payment floatValue];
    NSString *timeStr = [NSString jm_cutOutSec:allModel.created];
    
    UILabel *orderPament = [UILabel new];
    [sectionShowView addSubview:orderPament];
    self.orderPament = orderPament;
    self.orderPament.font = [UIFont systemFontOfSize:13.];
    self.orderPament.textColor = [UIColor buttonTitleColor];
    self.orderPament.text = [NSString stringWithFormat:@"%@",timeStr];
    
    
    UIImageView *shareRenpageImage = [UIImageView new];
    [sectionShowView addSubview:shareRenpageImage];
    self.shareRenpageImage = shareRenpageImage;
    
    
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(sectionView);
        make.height.mas_equalTo(@15);
    }];
    
    [sectionShowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(sectionView);
        make.top.equalTo(lineView.mas_bottom);
        make.height.mas_equalTo(@35);
    }];
    
    [self.orderStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sectionShowView).offset(-10);
        make.centerY.equalTo(sectionShowView.mas_centerY);
    }];
    
    [self.orderPament mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectionShowView).offset(10);
        make.centerY.equalTo(sectionShowView.mas_centerY);
    }];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(sectionShowView);
        make.bottom.equalTo(sectionShowView).offset(-1);
        make.height.mas_equalTo(@1);
    }];
    
    return sectionView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (_isShowSettingOrder) {
        return 80;
    }
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    JMAllOrderModel *allModel = self.dataSource[section];
    CGFloat sectionH = _isShowSettingOrder ? 80 : 40;
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, sectionH)];
    sectionView.backgroundColor = [UIColor whiteColor];
    
    UIView *totlaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    [sectionView addSubview:totlaView];
    CGFloat payment = [allModel.payment floatValue];
    CGFloat postFee = [allModel.post_fee floatValue];
    
    UILabel *orderPament = [UILabel new];
    [totlaView addSubview:orderPament];
    orderPament.font = [UIFont systemFontOfSize:13.];
    orderPament.textColor = [UIColor buttonTitleColor];
    orderPament.text = [NSString stringWithFormat:@"实付款:¥ %.2f(运费:¥ %.2f)",payment,postFee];
    
    [orderPament mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(totlaView.mas_centerY);
        make.right.equalTo(totlaView).offset(-10);
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 40, SCREENWIDTH - 40, 1)];
    lineView.backgroundColor = [UIColor countLabelColor];
    
    UIView *settingView = [[UIView alloc] initWithFrame:CGRectMake(0, 41, SCREENHEIGHT, 39)];
    [sectionView addSubview:lineView];
    [sectionView addSubview:settingView];
//    settingView.backgroundColor = [UIColor redColor];
    
    UIButton *xiangqingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingView addSubview:xiangqingButton];
    xiangqingButton.frame = CGRectMake(SCREENWIDTH - 80, 7, 60, 25);
    xiangqingButton.layer.cornerRadius = 2.;
    xiangqingButton.layer.borderColor = [UIColor dingfanxiangqingColor].CGColor;
    xiangqingButton.layer.borderWidth = 0.5f;
    xiangqingButton.titleLabel.font = CS_UIFontSize(12.);
    [xiangqingButton setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    xiangqingButton.tag = 1 + section;
    
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingView addSubview:settingButton];
    settingButton.frame = CGRectMake(SCREENWIDTH - 160, 7, 60, 25);
    settingButton.layer.cornerRadius = 2.;
    settingButton.layer.borderColor = [UIColor dingfanxiangqingColor].CGColor;
    settingButton.layer.borderWidth = 0.5f;
    settingButton.titleLabel.font = CS_UIFontSize(12.);
    [settingButton setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    settingButton.tag = 1000 + section;
    
    
    [xiangqingButton addTarget:self action:@selector(sectionFooterClick:) forControlEvents:UIControlEventTouchUpInside];
    [settingButton addTarget:self action:@selector(settingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([allModel.status integerValue] == 3 || [allModel.status integerValue] == 4 || [allModel.status integerValue] == 2) {
        xiangqingButton.hidden = NO;
        settingButton.hidden = YES;
        CGFloat sizeW = [@"物流/详情" widthWithHeight:25 andFont:12.].width;
        [xiangqingButton setTitle:@"物流/详情" forState:UIControlStateNormal];
        xiangqingButton.cs_w = sizeW + 10;
    }else if ([allModel.status integerValue] == 1) {
        xiangqingButton.hidden = NO;
        settingButton.hidden = NO;
//        CGFloat sizeW = [@"去付款" widthWithHeight:25 andFont:12.].width;
        [xiangqingButton setTitle:@"详情" forState:UIControlStateNormal];
        [settingButton setTitle:@"去付款" forState:UIControlStateNormal];
        settingButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
        [settingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        settingButton.cs_w = sizeW + 10;
    }else {
        xiangqingButton.hidden = NO;
        settingButton.hidden = YES;
        [xiangqingButton setTitle:@"详情" forState:UIControlStateNormal];
        [settingButton setTitle:@"删除" forState:UIControlStateNormal];
    }
    if (!_isShowSettingOrder) {
        settingView.cs_h = 0.;
        xiangqingButton.hidden = YES;
        settingButton.hidden = YES;
    }
    
    
    return sectionView;
}
- (void)sectionFooterClick:(UIButton *)button {
    NSInteger sectionIndex = button.tag - 1;
    JMAllOrderModel *allModel = self.dataSource[sectionIndex];
    JMOrderDetailController *orderDetailVC = [[JMOrderDetailController alloc] init];
    orderDetailVC.allOrderModel = allModel;
    orderDetailVC.orderTid = allModel.tid;
    orderDetailVC.urlString = [NSString stringWithFormat:@"%@/rest/v2/trades/%@?device=app", Root_URL, allModel.goodsID];
    orderDetailVC.delegate = self;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}
- (void)settingButtonClick:(UIButton *)button {
    NSInteger sectionIndex = button.tag - 1000;
    JMAllOrderModel *allModel = self.dataSource[sectionIndex];
    JMOrderDetailController *orderDetailVC = [[JMOrderDetailController alloc] init];
    orderDetailVC.allOrderModel = allModel;
    orderDetailVC.orderTid = allModel.tid;
    orderDetailVC.urlString = [NSString stringWithFormat:@"%@/rest/v2/trades/%@?device=app", Root_URL, allModel.goodsID];
    orderDetailVC.delegate = self;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}



- (void)composeWithPopViewRefresh:(JMOrderDetailController *)orderVC {
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark 没有订单显示空视图
//- (void)emptyView {
//    kWeakSelf
//    JMEmptyView *empty = [[JMEmptyView alloc] initWithFrame:CGRectMake(0, 99, SCREENWIDTH, SCREENHEIGHT - 99) Title:@"亲,您暂时还没有订单哦～快去看看吧!" DescTitle:@"再不抢购，就卖光啦～!" BackImage:@"dingdanemptyimage" InfoStr:@"快去逛逛"];
//    [self.view addSubview:empty];
//    self.empty = empty;
//    self.empty.hidden = YES;
//    empty.block = ^(NSInteger index) {
//        if (index == 100) {
//            self.isPopToRootView = YES;
//            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
////            [JMNotificationCenter postNotificationName:@"kuaiquguangguangButtonClick" object:nil];
//        }
//    };
//}
#pragma 无数据展示空视图
- (UIView *)createPlaceHolderView {
    return self.reload;
}
- (JMReloadEmptyDataView *)reload {
    if (!_reload) {
        __block JMReloadEmptyDataView *reload = [[JMReloadEmptyDataView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) Title:@"亲,您暂时还没有订单哦～快去看看吧!" DescTitle:@"再不抢购，就卖光啦～!" ButtonTitle:@"快去逛逛" Image:@"data_empty" ReloadBlcok:^{
            self.isPopToRootView = YES;
            [self.navigationController popViewControllerAnimated:YES];
        }];
        _reload = reload;
    }
    return _reload;
}



-(void)gotoLandingPage{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)backBtnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

@end




























































