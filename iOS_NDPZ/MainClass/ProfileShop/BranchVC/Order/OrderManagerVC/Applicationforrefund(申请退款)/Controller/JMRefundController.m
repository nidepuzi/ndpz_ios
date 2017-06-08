//
//  JMRefundController.m
//  XLMM
//
//  Created by zhang on 17/4/15.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "JMRefundController.h"
#import "JMAppForRefundModel.h"
#import "JMSelecterButton.h"
#import "JMRefundCell.h"
#import "JMContinuePayModel.h"
#import "JMOrderDetailModel.h"

@interface JMRefundController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) JMSelecterButton *cancelButton;


@end

@implementation JMRefundController

//- (NSMutableArray *)dataSource {
//    if (_dataSource == nil) {
//        _dataSource = [NSMutableArray array];
//    }
//    return _dataSource;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self crateTableView];
}
- (void)setIsRefund:(BOOL)isRefund {
    _isRefund = isRefund;
}

//- (void)setRefundDic:(NSDictionary *)refundDic {
//    _refundDic = refundDic;
//    _isRefund = YES;
//    self.dataSource = [NSMutableArray array];
//    NSArray *refundArr = _refundDic[@"refund_choices"];
//    for (NSDictionary *dic in refundArr) {
//        JMAppForRefundModel *refundModel = [JMAppForRefundModel mj_objectWithKeyValues:dic];
//        [self.dataSource addObject:refundModel];
//    }
//}
//- (void)setContinuePayDic:(NSDictionary *)continuePayDic {
//    _continuePayDic = continuePayDic;
//    _isRefund = NO;
//    self.dataSource = [NSMutableArray array];
//    NSArray *channelsArr = _continuePayDic[@"channels"];
//    for (NSDictionary *dict in channelsArr) {
//        JMContinuePayModel *continueModel = [JMContinuePayModel mj_objectWithKeyValues:dict];
//        [self.dataSource addObject:continueModel];
//    }
//}
- (void)crateTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, SCREENWIDTH - 20, 200) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    
    JMSelecterButton *cancelButton = [[JMSelecterButton alloc] init];
    self.cancelButton = cancelButton;
    [self.cancelButton setSelecterBorderColor:[UIColor buttonEnabledBackgroundColor] TitleColor:[UIColor whiteColor] Title:@"取消" TitleFont:13. CornerRadius:15];
    self.cancelButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    [self.cancelButton addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.cancelButton.frame = CGRectMake(10, 210, SCREENWIDTH - 20, 40);
    [self.view addSubview:self.cancelButton];

    UIView *headView = [UIView new];
//    [self.view addSubview:headView];
    headView.frame = CGRectMake(10, 0, SCREENWIDTH - 20, 60);
    headView.userInteractionEnabled = YES;
    self.tableView.tableHeaderView = headView;
    UIImageView *leftImage = [[UIImageView alloc] init];
    [headView addSubview:leftImage];
    [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(15);
        make.centerY.equalTo(headView.mas_centerY);
        make.height.width.mas_equalTo(@22);
    }];
    leftImage.image = [UIImage imageNamed:@"leftArrowIcon"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack:)];
    [headView addGestureRecognizer:tap];
    
    
    UILabel *headLabel = [UILabel new];
    [headView addSubview:headLabel];
    headLabel.font = [UIFont systemFontOfSize:16.];
    headLabel.textColor = [UIColor buttonTitleColor];
    if (self.isRefund == YES) {
        headLabel.text = @"退款方式";
    }else {
        headLabel.text = @"支付方式";
    }
    
    [headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headView.mas_centerX);
        make.centerY.equalTo(headView.mas_centerY);
    }];
    
    
}
- (void)goBack:(UITapGestureRecognizer *)tap {
    [self cancelBtnClick];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.channelsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    JMRefundCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[JMRefundCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (self.isRefund == YES) {
        CSOrderDetailChannels *model = self.channelsArr[indexPath.row];
        [cell configWithModel:model Index:indexPath.row];
    }else {
        CSOrderDetailChannels *continueModel = self.channelsArr[indexPath.row];
        [cell configWithPayModel:continueModel Index:indexPath.row];
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone; //选中cell时无色
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isRefund == YES) {
        CSOrderDetailChannels *model = self.channelsArr[indexPath.row];
        [self cancelBtnClick];
        if (_delegate && [_delegate respondsToSelector:@selector(Clickrefund:OrderGoods:Refund:)]) {
            [_delegate Clickrefund:self OrderGoods:self.ordergoodsModel Refund:model];
        }
    }else {
        CSOrderDetailChannels *continueModel = self.channelsArr[indexPath.row];
        [self cancelBtnClick];
        if (_delegate && [_delegate respondsToSelector:@selector(Clickrefund:ContinuePay:)]) {
            [_delegate Clickrefund:self ContinuePay:[continueModel mj_keyValues]];
        }
    }
    
    
}



- (void)cancelBtnClick {
    [JMShareView hide];
    [JMPopView hide];
}


@end








































