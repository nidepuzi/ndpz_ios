//
//  CSLogisticsInformationController.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/23.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSLogisticsInformationController.h"
#import "JMOrderGoodsModel.h"
#import "JMPackAgeModel.h"
#import "JMTimeInfoModel.h"
#import "JMBaseGoodsCell.h"
#import "JMTimeListCell.h"


@interface CSLogisticsInformationController ()  <UITableViewDelegate, UITableViewDataSource> {
    BOOL _isPullDown;       // 下拉刷新的标志
    NSString *_companyCode;
    NSString *_packetId;
    
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic,strong) UILabel *logNameLabel;
@property (nonatomic,strong) UILabel *logNumLabel;

@end

@implementation CSLogisticsInformationController

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
    [self createNavigationBarWithTitle:@"物流信息" selecotr:@selector(backClick)];
    
    [self createcustomizeUI];
    [self createPullHeaderRefresh];
    if ([NSString isStringEmpty:_packetId] || [NSString isStringEmpty:_companyCode]) {
        [self dataAnalysis:nil];
    }else {
        [self loadDataSource];
    }
    
}

- (void)setPacketID:(NSString *)packetID {
    _packetID = packetID;
    _packetId = packetID;
}
- (void)setCompanyCODE:(NSString *)companyCODE {
    _companyCODE = companyCODE;
    _companyCode = companyCODE;
}
- (void)setPackageModel:(JMPackAgeModel *)packageModel {
    _packageModel = packageModel;
    NSDictionary *dic = packageModel.logistics_company;
    _companyCode = dic[@"code"];
    _packetId = packageModel.out_sid;
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
- (void)endRefresh {
    if (_isPullDown) {
        _isPullDown = NO;
        [self.tableView.mj_header endRefreshing];
    }
}
#pragma mark ==== 网络请求 ====
- (void)loadDataSource {
    [MBProgressHUD showLoading:@""];
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/wuliu/get_wuliu_by_packetid?packetid=%@&company_code=%@", Root_URL, _packetId, _companyCode];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject)return;
        [self.dataSource removeAllObjects];
        [self dataAnalysis:responseObject];
        [self endRefresh];
        [MBProgressHUD hideHUD];
    } WithFail:^(NSError *error) {
        [self endRefresh];
        [MBProgressHUD hideHUD];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"查询失败,您的订单暂未查询到物流信息，可能快递公司数据还未更新，请稍候查询或到快递公司网站查询" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    } Progress:^(float progress) {
        
    }];
}
- (void)dataAnalysis:(NSDictionary *)data {
    NSArray *results = data[@"data"];
    
    if (results.count == 0) {
        results = @[@{@"content":@"暂未查询到物流信息",
                      @"time":[NSString jm_deleteTimeWithT:self.packageModel.pay_time]},
                    @{@"content":@"订单创建成功",
                      @"time":[NSString jm_deleteTimeWithT:self.packageModel.pay_time]},
                    ];
        self.logNameLabel.text = @"铺子推荐";
        self.logNumLabel.text = [NSString isStringEmpty:_packetId] ? @"未揽件" : _packetId;
    }else {
        self.logNameLabel.text = [data objectForKey:@"name"];
        self.logNumLabel.text = [data objectForKey:@"order"];
        if (![NSString isStringEmpty:self.logNumLabel.text]) {
            self.logNumLabel.userInteractionEnabled = YES;
        }
    }
    for (NSDictionary *account in results) {
        JMTimeInfoModel *accountM = [JMTimeInfoModel mj_objectWithKeyValues:account];
        [self.dataSource addObject:accountM];
    }
    [self.tableView reloadData];
}



#pragma mark ==== 自定义UI ====
- (void)createcustomizeUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.backgroundColor = [UIColor countLabelColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[JMBaseGoodsCell class] forCellReuseIdentifier:JMBaseGoodsCellIdentifier];
    [tableView registerClass:[JMTimeListCell class] forCellReuseIdentifier:JMTimeListCellIdentifier];
    self.tableView = tableView;
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 115)];
    self.tableView.tableHeaderView = headerView;
    
    UIView *sectionView1 = [UIView new];
    sectionView1.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:sectionView1];
    
    UILabel *logNameL = [UILabel new];
    [sectionView1 addSubview:logNameL];
    logNameL.text = @"物流配送";
    logNameL.font = [UIFont systemFontOfSize:13.];
    
    UILabel *logNameLabel = [UILabel new];
    [sectionView1 addSubview:logNameLabel];
    logNameLabel.font = [UIFont systemFontOfSize:14.];
    self.logNameLabel = logNameLabel;
    
    UIView *sectionView2 = [UIView new];
    sectionView2.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:sectionView2];
    
    UILabel *logNumL = [UILabel new];
    [sectionView2 addSubview:logNumL];
    logNumL.text = @"快递单号";
    logNumL.font = [UIFont systemFontOfSize:13.];
    
    UILabel *logNumLabel = [UILabel new];
    [sectionView2 addSubview:logNumLabel];
    self.logNumLabel = logNumLabel;
    logNumLabel.font = [UIFont systemFontOfSize:14.];
    self.logNumLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(copyLogistID)];
    [self.logNumLabel addGestureRecognizer:tap];
    self.logNumLabel.userInteractionEnabled = NO;
    
    [sectionView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView);
        make.width.mas_equalTo(SCREENWIDTH);
        make.centerX.equalTo(headerView.mas_centerX);
        make.height.mas_equalTo(50);
    }];
    [logNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectionView1).offset(15);
        make.centerY.equalTo(sectionView1.mas_centerY);
    }];
    [logNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sectionView1).offset(-10);
        make.centerY.equalTo(sectionView1.mas_centerY);
    }];
    
    [sectionView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sectionView1.mas_bottom).offset(1);
        make.width.mas_equalTo(SCREENWIDTH);
        make.centerX.equalTo(headerView.mas_centerX);
        make.height.mas_equalTo(50);
    }];
    [logNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectionView2).offset(15);
        make.centerY.equalTo(sectionView2.mas_centerY);
    }];
    [logNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sectionView2).offset(-10);
        make.centerY.equalTo(sectionView2.mas_centerY);
    }];
    
    NSDictionary *dic = self.packageModel.logistics_company;
    self.logNameLabel.text = [NSString isStringEmpty:dic[@"name"]] ? @"铺子推荐" : dic[@"name"];
    self.logNumLabel.text = [NSString isStringEmpty:self.packageModel.out_sid] ? @"未揽件" : self.packageModel.out_sid;
    
}


#pragma mark ==== 代理事件 ====
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.orderDataSource.count;
    }else {
        return self.dataSource.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JMBaseGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:JMBaseGoodsCellIdentifier];
        if (!cell) {
            cell = [[JMBaseGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JMBaseGoodsCellIdentifier];
        }
        [cell configWithAllOrder:self.orderDataSource[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        JMTimeListCell *cell = [tableView dequeueReusableCellWithIdentifier:JMTimeListCellIdentifier];
        if (!cell) {
            cell = [[JMTimeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JMTimeListCellIdentifier];
        }
        [cell config:self.dataSource[indexPath.row] Index:indexPath.row Count:self.dataSource.count];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }else {
        return 15.;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }else {
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 15)];
        sectionView.backgroundColor = [UIColor countLabelColor];
        return sectionView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 110;
    }else {
        JMTimeInfoModel *model = self.dataSource[indexPath.row];
        return model.cellHeight;
    }
}

#pragma mark ==== 自定义点击事件 ====
- (void)copyLogistID {
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    [pab setString:self.logNumLabel.text];
    if (pab != nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"铺子小贴士" message:@"亲爱的铺子用户,现在运单号已经复制成功了哦~可以粘贴啦。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else {
        [MBProgressHUD showWarning:@"复制失败!"];
    }
}
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}



@end

























































































































