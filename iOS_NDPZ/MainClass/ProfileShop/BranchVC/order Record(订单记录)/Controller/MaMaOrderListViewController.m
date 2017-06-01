//
//  MaMaOrderListViewController.m
//  XLMM
//
//  Created by 张迎 on 16/1/18.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "MaMaOrderListViewController.h"
#import "MaMaOrderModel.h"
#import "JMMaMaOrderListCell.h"
#import "CSLogisticsInformationController.h"
#import "JMReloadEmptyDataView.h"
#import "CSTableViewPlaceHolderDelegate.h"
#import "CarryLogHeaderView.h"


@interface MaMaOrderListViewController () <UITableViewDelegate, UITableViewDataSource, CSTableViewPlaceHolderDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong)NSMutableDictionary *dataDic;

@property (nonatomic, strong)NSString *nextPage;

@property (nonatomic,strong) UIButton *topButton;
//下拉的标志
@property (nonatomic) BOOL isPullDown;
//上拉的标志
@property (nonatomic) BOOL isLoadMore;

@property (nonatomic, strong) JMReloadEmptyDataView *reload;


@end

@implementation MaMaOrderListViewController
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        self.dataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArr;
}

- (NSMutableDictionary *)dataDic {
    if (!_dataDic) {
        self.dataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _dataDic;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
//    [self.tableView.mj_header beginRefreshing];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    [MBProgressHUD hideHUD];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createNavigationBarWithTitle:@"" selecotr:@selector(backClickAction)];
    
    [self createTableView];
    [self createButton];
    [self createPullHeaderRefresh];
    [self createPullFooterRefresh];
    [self.tableView.mj_header beginRefreshing];
}

- (void)backClickAction {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mrak 刷新界面
- (void)createPullHeaderRefresh {
    kWeakSelf
    self.tableView.mj_header = [MJAnimationHeader headerWithRefreshingBlock:^{
        _isPullDown = YES;
        [self.tableView.mj_footer resetNoMoreData];
        [weakSelf loadDate];
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
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 90;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    
    //添加header
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 120)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH * 0.5 - 50, 15, 100, 20)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, SCREENWIDTH, 40)];
    moneyLabel.textColor = [UIColor orangeThemeColor];
    moneyLabel.font = [UIFont systemFontOfSize:32];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.text = self.orderRecord;
    [headerV addSubview:titleLabel];
    [headerV addSubview:moneyLabel];
    headerV.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, SCREENWIDTH, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.alpha = 0.3;
    [headerV addSubview:lineView];
    
    UILabel *descLabel = [UILabel new];
    descLabel.font = [UIFont systemFontOfSize:12.];
    descLabel.textColor = [UIColor dingfanxiangqingColor];
    descLabel.numberOfLines = 0;
    descLabel.textAlignment = NSTextAlignmentCenter;
    [headerV addSubview:descLabel];
    
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerV.mas_centerX);
        make.bottom.equalTo(headerV).offset(-10);
        make.width.mas_equalTo(SCREENWIDTH - 20);
    }];
    
    self.tableView.tableHeaderView = headerV;
    
    if (self.orderListType == orderListWithToday) {
        titleLabel.text = @"订单记录";
        descLabel.text = @"备注:累计收益未考虑可能退换货,以实际到账收益为准";
        self.title = @"今日订单";
    }else if (self.orderListType == orderListWithShare) {
        titleLabel.text = @"累计分享佣金";
        descLabel.text = @"备注:未签收订单暂不计入佣金;累计收益未考虑可能退换货,以实际到账收益为准";
        self.title = @"分享佣金";
    }else {
        titleLabel.text = @"累计自购佣金";
        descLabel.text = @"备注:未签收订单暂不计入佣金;累计收益未考虑可能退换货,以实际到账收益为准";
        self.title = @"自购佣金";
    }
    [self createNavigationBarWithTitle:self.title selecotr:@selector(backClickAction)];
    
}

#pragma mark -- 请求数据
- (void)loadDate {
    NSString *url = @"";
    if (self.orderListType == orderListWithToday) {
        url = [NSString stringWithFormat:@"%@/rest/v2/mama/ordercarry/today",Root_URL];
    }else if (self.orderListType == orderListWithShare) {
        url = [NSString stringWithFormat:@"%@/rest/v2/mama/ordercarry?carry_type=share",Root_URL];
    }else {
        url = [NSString stringWithFormat:@"%@/rest/v2/mama/ordercarry?carry_type=self",Root_URL];
    }
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:url WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject)return;
        [self.dataArr removeAllObjects];
        [self.dataDic removeAllObjects];
        [self dataAnalysis:responseObject];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}
//加载更多
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
#pragma mark ---数据处理
- (void)dataAnalysis:(NSDictionary *)data {
    self.nextPage = data[@"next"];
    NSArray *results = data[@"results"];
    if (results.count != 0) {
        if (self.orderListType == orderListWithToday) {
            for (NSDictionary *orderDic in results) {
                MaMaOrderModel *orderM = [MaMaOrderModel mj_objectWithKeyValues:orderDic];
                [self.dataArr addObject:orderM];
            }
        }else {
            for (NSDictionary *order in results) {
                MaMaOrderModel *orderM = [MaMaOrderModel mj_objectWithKeyValues:order];
                NSString *date = [self dateDeal:orderM.date_field];
                self.dataArr = [[self.dataDic allKeys] mutableCopy];
                //判断对应键值的数组是否存在
                if ([self.dataArr containsObject:date]) {
                    NSMutableArray *orderArr = self.dataDic[date];
                    [orderArr addObject:orderM];
                }else {
                    NSMutableArray *orderArr = [NSMutableArray arrayWithCapacity:0];
                    [orderArr addObject:orderM];
                    [self.dataDic setObject:orderArr forKey:date];
                }
            }
            self.dataArr = [[self.dataDic allKeys] mutableCopy];
            self.dataArr = [self sortAllKeyArray:self.dataArr];
        }
    }
    
    [self.tableView cs_reloadData];
    
}

//将日期去掉－
- (NSString *)dateDeal:(NSString *)str {
    NSString *date = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return date;
}

//将所有的key排序
- (NSMutableArray *)sortAllKeyArray:(NSMutableArray *)keyArr {
    for (int i = 0; i < keyArr.count; i++) {
        for (int j = 0; j < keyArr.count - i - 1; j++) {
            if ([keyArr[j] intValue] < [keyArr[j + 1] intValue]) {
                NSNumber *temp = keyArr[j + 1];
                keyArr[j + 1] = keyArr[j];
                keyArr[j] = temp;
            }
        }
    }
    return keyArr;
}


#pragma mark ---UItableView的代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.orderListType == orderListWithToday) {
        return 1;
    }else {
        return self.dataArr.count;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.orderListType == orderListWithToday) {
        return self.dataArr.count;
    }else {
        NSString *key = self.dataArr[section];
        NSMutableArray *orderArr = self.dataDic[key];
        return orderArr.count;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"MaMaOrder";
    JMMaMaOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[JMMaMaOrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (self.orderListType == orderListWithToday) {
        MaMaOrderModel *orderM = self.dataArr[indexPath.row];
        [cell fillDataOfCell:orderM];
    }else {
        NSString *key = self.dataArr[indexPath.section];
        NSMutableArray *orderArr = self.dataDic[key];
        MaMaOrderModel *orderM = orderArr[indexPath.row];
        [cell fillDataOfCell:orderM];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.orderListType == orderListWithToday) {
        return nil;
    }else {
        NSArray *nibView = [[NSBundle mainBundle] loadNibNamed:@"CarryLogHeaderView"owner:self options:nil];
        CarryLogHeaderView *headerV = [nibView objectAtIndex:0];
        headerV.frame = CGRectMake(0, 0, SCREENWIDTH, 30);
        //计算金额
        NSString *key = self.dataArr[section];
        NSMutableArray *orderArr = self.dataDic[key];
        MaMaOrderModel *orderM = [orderArr firstObject];
        
        [headerV yearLabelAndTotalMoneyLabelText:orderM.date_field total:[NSString stringWithFormat:@"%.2f", [orderM.today_carry floatValue]]];
        return headerV;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.orderListType == orderListWithToday) {
        return 0;
    }else {
        return 35;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = self.dataArr[indexPath.section];
    NSMutableArray *orderArr = self.dataDic[key];
    MaMaOrderModel *orderM = orderArr[indexPath.row];
//    MaMaOrderModel *orderM = self.dataArr[indexPath.row];
//    NSLog(@"%@",[orderM mj_keyValues]);
    BOOL isComanyCode = [NSString isStringEmpty:orderM.company_code];
    BOOL isPacketId = [NSString isStringEmpty:orderM.packetid];
    if (isComanyCode || isPacketId) {
        
    }else {
        CSLogisticsInformationController *vc = [[CSLogisticsInformationController alloc] init];
        vc.packetID = orderM.packetid;
        vc.companyCODE = orderM.company_code;
        [self.navigationController pushViewController:vc animated:YES];
    }

}

- (UIView *)createPlaceHolderView {
    return self.reload;
}
- (JMReloadEmptyDataView *)reload {
    if (!_reload) {
        __block JMReloadEmptyDataView *reload = [[JMReloadEmptyDataView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) Title:@"您暂时还没有订单哦～" DescTitle:@"" ButtonTitle:@"快去逛逛" Image:@"data_empty" ReloadBlcok:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        _reload = reload;
    }
    return _reload;
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














































