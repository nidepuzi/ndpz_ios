//
//  CSWithdrawDetailController.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/22.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSWithdrawDetailController.h"
#import "CSWithdrawDetailCell.h"
#import "CSWithdrawRecordingModel.h"


@interface CSWithdrawDetailController () <UITableViewDelegate, UITableViewDataSource> {
    BOOL _isPullDown;       // 下拉刷新的标志
    
    UILabel *_timeLabel1;
    UILabel *_timeLabel2;
    UILabel *_timeLabel3;
    
    UILabel *_statusLabel1;
    UILabel *_statusLabel2;
    UILabel *_statusLabel3;
    
    UIImageView *_iconImageView1;
    UIImageView *_iconImageView2;
    UIImageView *_iconImageView3;
    
    UIView *_lineView2;
    
    UILabel *_withdrawValueLabel;
    
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation CSWithdrawDetailController

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
    [self.tableView.mj_header beginRefreshing];
    
    [[JMGlobal global] showWaitLoadingInView:self.view];
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
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:self.recordingUrl WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject)return;
        [self.dataSource removeAllObjects];
        [self dataAnalysis:responseObject];
        [self endRefresh];
        [[JMGlobal global] hideWaitLoading];
    } WithFail:^(NSError *error) {
        [self endRefresh];
        [[JMGlobal global] hideWaitLoading];
    } Progress:^(float progress) {
        
    }];
}
- (void)dataAnalysis:(NSDictionary *)data {
    CSWithdrawRecordingModel *recordingModel = [CSWithdrawRecordingModel mj_objectWithKeyValues:data];
    NSString *shenqingTime = recordingModel.created;
    NSString *chuliTime = recordingModel.send_time;
    NSString *successTime = recordingModel.success_time;
    
    if ([NSString isStringEmpty:chuliTime]) {
        chuliTime = shenqingTime;
    }
    if ([NSString isStringEmpty:successTime]) {
        successTime = [NSString getTime:shenqingTime BeforeOrAfterDay:3];
    }
    
    _timeLabel1.text = [NSString yearDeal:shenqingTime];
    _timeLabel2.text = [NSString yearDeal:chuliTime];
    _timeLabel3.text = [NSString yearDeal:successTime];
    
    if ([recordingModel.state isEqual:@"success"]) {
        _lineView2.backgroundColor = [UIColor buttonEnabledBackgroundColor];
        _iconImageView3.image = [UIImage imageNamed:@"success_Image"];
        _timeLabel3.textColor = [UIColor buttonTitleColor];
        _statusLabel3.textColor = [UIColor buttonTitleColor];
    }else if ([recordingModel.state isEqual:@"apply"]) {
        
    }else if ([recordingModel.state isEqual:@"pending"]) {
        
    }else if ([recordingModel.state isEqual:@"fail"]) {
        _statusLabel3.text = @"提现失败";
    }else { }
    
    NSString *money = [NSString stringWithFormat:@"%.2f",[recordingModel.amount floatValue]];
    _withdrawValueLabel.text = money;
    
    if (recordingModel.bank_card == nil) {
        NSArray *arr = @[@{@"title":@"提现方式:",
                           @"desTitle":@"微信提现"},
                         @{@"title":@"手续费(元):",
                           @"desTitle":money},
                         @{@"title":@"创建时间:",
                           @"desTitle":[NSString yearDeal:shenqingTime]},
                         ];
        self.dataSource = [arr mutableCopy];
    }else {
        NSString *bankCardAccountNo = recordingModel.bank_card.account_no;
        NSMutableString *bankCardAccountNoMus = [NSMutableString stringWithFormat:@"%@", bankCardAccountNo];
        NSInteger hideLenght = bankCardAccountNo.length - 9;
        NSMutableString *hideStr = [NSMutableString string];
        for (int i = 0; i < hideLenght; i++) {
            [hideStr appendFormat:@"*"];
        }
        NSRange range = {4, hideLenght};
        [bankCardAccountNoMus replaceCharactersInRange:range withString:hideStr];
        
        if ([NSString isStringEmpty:recordingModel.fail_msg]) {
            NSArray *arr = @[@{@"title":@"提现方式:",
                               @"desTitle":@"银行卡"},
                             @{@"title":@"手续费(元):",
                               @"desTitle":money},
                             @{@"title":@"创建时间:",
                               @"desTitle":[NSString yearDeal:shenqingTime]},
                             @{@"title":@"提现人姓名:",
                               @"desTitle":recordingModel.bank_card.account_name},
                             @{@"title":@"银行卡信息:",
                               @"desTitle":recordingModel.bank_card.bank_name},
                             @{@"title":@"银行卡:",
                               @"desTitle":bankCardAccountNoMus},
                             ];
            self.dataSource = [arr mutableCopy];
        }else {
            NSArray *arr = @[@{@"title":@"提现方式:",
                               @"desTitle":@"银行卡"},
                             @{@"title":@"手续费(元):",
                               @"desTitle":money},
                             @{@"title":@"创建时间:",
                               @"desTitle":[NSString yearDeal:shenqingTime]},
                             @{@"title":@"提现人姓名:",
                               @"desTitle":recordingModel.bank_card.account_name},
                             @{@"title":@"银行卡信息:",
                               @"desTitle":recordingModel.bank_card.bank_name},
                             @{@"title":@"银行卡:",
                               @"desTitle":bankCardAccountNoMus},
                             @{@"title":@"失败原因:",
                               @"desTitle":recordingModel.fail_msg},
                             ];
            self.dataSource = [arr mutableCopy];
        }
        
        
        
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
    [tableView registerClass:[CSWithdrawDetailCell class] forCellReuseIdentifier:@"CSWithdrawDetailCellIdentifier"];
    self.tableView = tableView;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 240)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 15)];
    sectionView.backgroundColor = [UIColor lineGrayColor];
    [headerView addSubview:sectionView];
    
    UILabel *withdrawLabel = [UILabel new];
    [headerView addSubview:withdrawLabel];
    withdrawLabel.textColor = [UIColor buttonTitleColor];
    withdrawLabel.font = CS_UIFontSize(14.);
    withdrawLabel.text = @"提现金额(元)";
    
    UILabel *withdrawValueLabel = [UILabel new];
    [headerView addSubview:withdrawValueLabel];
    withdrawValueLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    withdrawValueLabel.font = CS_UIFontBoldSize(36.);
    _withdrawValueLabel = withdrawValueLabel;
    
    [withdrawLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sectionView.mas_bottom).offset(15);
        make.centerX.equalTo(headerView.mas_centerX);
    }];
    [withdrawValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(withdrawLabel.mas_bottom).offset(10);
        make.centerX.equalTo(headerView.mas_centerX);
    }];
    
    CGFloat spaceLeft = 35 * HomeCategoryRatio;
    CGFloat lineWidth = (SCREENWIDTH - 2 * spaceLeft - 90) / 2;
    
    UIImageView *iconImageView1 = [UIImageView new];
    [headerView addSubview:iconImageView1];
    
    UILabel *timeLabel1 = [UILabel new];
    timeLabel1.textColor = [UIColor buttonTitleColor];
    timeLabel1.font = CS_UIFontSize(12.);
    [headerView addSubview:timeLabel1];
    
    UILabel *statusLabel1 = [UILabel new];
    statusLabel1.textColor = [UIColor buttonTitleColor];
    statusLabel1.font = CS_UIFontSize(12.);
    [headerView addSubview:statusLabel1];
    
    [iconImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(spaceLeft);
        make.bottom.equalTo(headerView).offset(-80);
        make.width.height.mas_equalTo(@30);
    }];
    [timeLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageView1.mas_bottom).offset(10);
        make.centerX.equalTo(iconImageView1.mas_centerX);
    }];
    [statusLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLabel1.mas_bottom).offset(10);
        make.centerX.equalTo(iconImageView1.mas_centerX);
    }];
    
    UIImageView *iconImageView2 = [UIImageView new];
    [headerView addSubview:iconImageView2];
    
    UILabel *timeLabel2 = [UILabel new];
    timeLabel2.textColor = [UIColor buttonTitleColor];
    timeLabel2.font = CS_UIFontSize(12.);
    [headerView addSubview:timeLabel2];
    
    UILabel *statusLabel2 = [UILabel new];
    statusLabel2.textColor = [UIColor buttonTitleColor];
    statusLabel2.font = CS_UIFontSize(12.);
    [headerView addSubview:statusLabel2];
    
    [iconImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView.mas_centerX);
        make.centerY.equalTo(iconImageView1.mas_centerY);
        make.width.height.mas_equalTo(@30);
    }];
    [timeLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageView2.mas_bottom).offset(10);
        make.centerX.equalTo(iconImageView2.mas_centerX);
    }];
    [statusLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLabel2.mas_bottom).offset(10);
        make.centerX.equalTo(iconImageView2.mas_centerX);
    }];
    
    UIImageView *iconImageView3 = [UIImageView new];
    [headerView addSubview:iconImageView3];
    
    UILabel *timeLabel3 = [UILabel new];
    timeLabel3.textColor = [UIColor dingfanxiangqingColor];
    timeLabel3.font = CS_UIFontSize(12.);
    [headerView addSubview:timeLabel3];
    
    UILabel *statusLabel3 = [UILabel new];
    statusLabel3.textColor = [UIColor dingfanxiangqingColor];
    statusLabel3.font = CS_UIFontSize(12.);
    [headerView addSubview:statusLabel3];
    
    [iconImageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView).offset(-spaceLeft);
        make.centerY.equalTo(iconImageView1.mas_centerY);
        make.width.height.mas_equalTo(@30);
    }];
    [timeLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageView3.mas_bottom).offset(10);
        make.centerX.equalTo(iconImageView3.mas_centerX);
    }];
    [statusLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLabel3.mas_bottom).offset(10);
        make.centerX.equalTo(iconImageView3.mas_centerX);
    }];
    
    UIView *lineView1 = [UIView new];
    lineView1.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    [headerView addSubview:lineView1];
    
    UIView *lineView2 = [UIView new];
    lineView2.backgroundColor = [UIColor buttonDisabledBorderColor];
    [headerView addSubview:lineView2];
    
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView1.mas_right);
        make.centerY.equalTo(iconImageView1.mas_centerY);
        make.width.mas_equalTo(lineWidth);
        make.height.mas_equalTo(2);
    }];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView2.mas_right);
        make.width.mas_equalTo(lineWidth);
        make.centerY.equalTo(iconImageView2.mas_centerY);
        make.height.mas_equalTo(2);
    }];
    
    _timeLabel1 = timeLabel1;
    _timeLabel2 = timeLabel2;
    _timeLabel3 = timeLabel3;
    
    _statusLabel1 = statusLabel1;
    _statusLabel2 = statusLabel2;
    _statusLabel3 = statusLabel3;
    
    _iconImageView1 = iconImageView1;
    _iconImageView2 = iconImageView2;
    _iconImageView3 = iconImageView3;
    
    _statusLabel1.text = @"提现申请";
    _statusLabel2.text = @"处理中";
    _statusLabel3.text = @"提现成功";
    
    _iconImageView1.image = [UIImage imageNamed:@"dispose_Image"];
    _iconImageView2.image = [UIImage imageNamed:@"ice_Image"];
    _iconImageView3.image = [UIImage imageNamed:@"success_Image_nomal"];
    
    _lineView2 = lineView2;
    
}





#pragma mark ==== 代理事件 ====
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CSWithdrawDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSWithdrawDetailCellIdentifier"];
    if (!cell) {
        cell = [[CSWithdrawDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSWithdrawDetailCellIdentifier"];
    }
    cell.itemDic = self.dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.;
}



#pragma mark ==== 自定义点击事件 ====
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}



@end










































































































