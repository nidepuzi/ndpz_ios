//
//  JMOrderDetailHeaderView.m
//  XLMM
//
//  Created by zhang on 17/4/7.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "JMOrderDetailHeaderView.h"
#import "JMOrderGoodsModel.h"
#import "JMTimeLineView.h"

@interface JMOrderDetailHeaderView ()

/**
 *  订单编号
 */
@property (nonatomic, strong) UILabel *orderNumLabel;
/**
 *  订单付款时间
 */
@property (nonatomic, strong) UILabel *orderPayTime;
/**
 *  订单创建时间
 */
@property (nonatomic, strong) UILabel *orderCreateTime;
/**
 *  订单来源
 */
@property (nonatomic, strong) UILabel *orderSource;
/**
 *  付款类型
 */
@property (nonatomic, strong) UILabel *orderPayType;

/**
 *  地址_姓名
 */
@property (nonatomic, strong) UILabel *addressNameLabel;
/**
 *  地址_手机号
 */
@property (nonatomic, strong) UILabel *addressPhoneLabel;
/**
 *  地址_详细地址
 */
@property (nonatomic, strong) UILabel *addressDetailLabel;
/**
 *  物流选择
 */
//@property (nonatomic, strong) UILabel *logisticsLabel;


//@property (nonatomic, strong) UIScrollView *timeLineView;
@property (nonatomic, strong) UILabel *yunfeiLabel;
@property (nonatomic, strong) UILabel *orderPayLabel;
@property (nonatomic, strong) UILabel *couponLabel;
@property (nonatomic, strong) UILabel *yueLabel;
@property (nonatomic, strong) UILabel *totalPayLabel;


@end


@implementation JMOrderDetailHeaderView {
    NSDictionary *_timeLineDict;
    CGFloat _timeLineH;
}


//+ (instancetype)enterHeaderView {
//    JMOrderDetailHeaderView *headView = [[JMOrderDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 230)];
//    return headView;
//}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        if (frame.size.height == 290) {
//            self.isTimeLineView = YES;
//        }else {
//            self.isTimeLineView = NO;
//        }
        self.backgroundColor = [UIColor whiteColor];
        [self setUpTopUI];
    }
    return self;
}

//- (void)setLogisticsStr:(NSString *)logisticsStr {
//    _logisticsStr = logisticsStr;
//    self.logisticsLabel.text = logisticsStr;
//}
- (void)setOrderDetailModel:(JMOrderDetailModel *)orderDetailModel {
    _orderDetailModel = orderDetailModel;
//    self.orderStatusLabel.text = self.orderDetailModel.status_display;
    self.orderNumLabel.text = [NSString stringWithFormat:@"订单编号: %@",orderDetailModel.tid];
    self.orderCreateTime.text = [NSString stringWithFormat:@"下单时间: %@",[NSString jm_cutOutSec:orderDetailModel.created]];
    self.orderPayTime.text = [NSString stringWithFormat:@"付款时间: %@",[NSString jm_cutOutSec:orderDetailModel.created]];
    NSDictionary *addressDict = orderDetailModel.user_adress;
    self.addressNameLabel.text = addressDict[@"receiver_name"];
    self.addressPhoneLabel.text = addressDict[@"receiver_mobile"];
    NSString *addressStr = [NSString stringWithFormat:@"%@-%@-%@-%@",addressDict[@"receiver_state"],addressDict[@"receiver_city"],addressDict[@"receiver_district"],addressDict[@"receiver_address"]];
    self.addressDetailLabel.text = addressStr;
    
    if ([orderDetailModel.channel isEqual:@"wx"]) {
        self.orderPayType.text = [NSString stringWithFormat:@"支付类型: 微信支付"];
    }else if ([orderDetailModel.channel isEqual:@"alipay"]) {
        self.orderPayType.text = [NSString stringWithFormat:@"支付类型: 支付宝支付"];
    }else if ([orderDetailModel.channel isEqual:@"budget"]) {
        self.orderPayType.text = [NSString stringWithFormat:@"支付类型: 余额支付"];
    }else { }
    
    CGFloat actualPayMent = [orderDetailModel.payment floatValue] - [orderDetailModel.pay_cash floatValue];
    
    self.yunfeiLabel.text = [NSString stringWithFormat:@"¥%.2f",[orderDetailModel.post_fee floatValue]];
    self.orderPayLabel.text = [NSString stringWithFormat:@"¥%.2f",[orderDetailModel.total_fee floatValue]];
    self.couponLabel.text = [NSString stringWithFormat:@"¥%.2f",[orderDetailModel.discount_fee floatValue]];
    self.yueLabel.text = [NSString stringWithFormat:@"¥%.2f",[orderDetailModel.pay_cash floatValue]];
    self.totalPayLabel.text = [NSString stringWithFormat:@"¥%.2f",actualPayMent];
    
//    NSDictionary *logisticsDic = orderDetailModel.logistics_company;
//    if (logisticsDic.count == 0) {
//        self.logisticsStr = @"小鹿推荐";
//        self.logisticsLabel.text = @"小鹿推荐";
//    }else {
//        self.logisticsStr = logisticsDic[@"name"];
//        self.logisticsLabel.text = logisticsDic[@"name"];
//    }
//    NSDictionary *dic = [orderDetailModel.orders[0] mj_keyValues];
//    NSInteger countNum = [dic[@"status"] integerValue];
//    NSInteger refundNum = [dic[@"refund_status"] integerValue];
//    NSArray *desArr = [NSArray array];
//    NSInteger count = 0;
//    int i = 0;
//    BOOL isCountNum = !(countNum == ORDER_STATUS_REFUND_CLOSE || countNum == ORDER_STATUS_TRADE_CLOSE);
//    BOOL isRefundNum = (refundNum == REFUND_STATUS_NO_REFUND || refundNum == REFUND_STATUS_REFUND_CLOSE);
//    if (isCountNum && isRefundNum) {
//        desArr = @[@"订单创建",@"支付成功",@"产品发货",@"产品签收",@"交易完成"];
//        for ( i = 0 ; i < desArr.count; i++) {
//            if (countNum == i) {
//                if (countNum >= 1) {
//                    i --;
//                }
//                break;
//            }else {
//                continue;
//            }
//        }
//        count = i + 1;
//        JMTimeLineView *timeLineV = [[JMTimeLineView alloc] initWithTimeArray:nil andTimeDesArray:desArr andCurrentStatus:count andFrame:self.timeLineView.frame];
//        [self.timeLineView addSubview:timeLineV];
//        self.timeLineView.contentSize = CGSizeMake(70 * desArr.count, 60);
//        self.timeLineView.showsHorizontalScrollIndicator = NO;
//    }
    
}
- (void)setUpTopUI {
    UIView *threeView = [UIView new];
    [self addSubview:threeView];
    self.addressView = threeView;
    self.addressView.backgroundColor = [UIColor whiteColor];
    self.addressView.userInteractionEnabled = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self.addressView addGestureRecognizer:tap];
    UIView *threeTapView = [tap view];
    threeTapView.tag = 100;
    
    UIImageView *addressImage = [UIImageView new];
    [threeView addSubview:addressImage];
    addressImage.image = [UIImage imageNamed:@"order_address"];
    
    UILabel *addressNameLabel = [UILabel new];
    [threeView addSubview:addressNameLabel];
    self.addressNameLabel = addressNameLabel;
    self.addressNameLabel.font = [UIFont systemFontOfSize:13.];
    self.addressNameLabel.textColor = [UIColor buttonTitleColor];
    
    UILabel *addressPhoneLabel = [UILabel new];
    [threeView addSubview:addressPhoneLabel];
    self.addressPhoneLabel = addressPhoneLabel;
    self.addressPhoneLabel.font = [UIFont systemFontOfSize:12.];
    self.addressPhoneLabel.textColor = [UIColor dingfanxiangqingColor];
    
    UILabel *addressDetailLabel = [UILabel new];
    [threeView addSubview:addressDetailLabel];
    self.addressDetailLabel = addressDetailLabel;
    self.addressDetailLabel.font = [UIFont systemFontOfSize:12.];
    self.addressDetailLabel.textColor = [UIColor dingfanxiangqingColor];
    self.addressDetailLabel.numberOfLines = 0;
    
    UIView *lineView = [UIView new];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor lineGrayColor];
    
    self.orderNumLabel = [UILabel new];
    self.orderNumLabel.font = CS_UIFontSize(14.);
    self.orderNumLabel.textColor = [UIColor dingfanxiangqingColor];
    self.orderNumLabel.text = @"订单编号: ";
    
    self.orderCreateTime = [UILabel new];
    self.orderCreateTime.font = CS_UIFontSize(14.);
    self.orderCreateTime.textColor = [UIColor dingfanxiangqingColor];
    self.orderCreateTime.text = @"下单时间: ";
    
    self.orderPayTime = [UILabel new];
    self.orderPayTime.font = CS_UIFontSize(14.);
    self.orderPayTime.textColor = [UIColor dingfanxiangqingColor];
    self.orderPayTime.text = @"付款时间: ";
    
    self.orderPayType = [UILabel new];
    self.orderPayType.font = CS_UIFontSize(14.);
    self.orderPayType.textColor = [UIColor dingfanxiangqingColor];
    self.orderPayType.text = @"付款类型: ";
    
    self.orderSource = [UILabel new];
    self.orderSource.font = CS_UIFontSize(14.);
    self.orderSource.textColor = [UIColor dingfanxiangqingColor];
    self.orderSource.text = @"订单来源: ";
    
    UILabel *yunfei = [UILabel new];
    yunfei.font = CS_UIFontSize(14.);
    yunfei.textColor = [UIColor buttonTitleColor];
    yunfei.text = @"运费";
    
    UILabel *dingdanjine = [UILabel new];
    dingdanjine.font = CS_UIFontSize(14.);
    dingdanjine.textColor = [UIColor buttonTitleColor];
    dingdanjine.text = @"订单金额";
    
    UILabel *youhuiquandikou = [UILabel new];
    youhuiquandikou.font = CS_UIFontSize(14.);
    youhuiquandikou.textColor = [UIColor buttonTitleColor];
    youhuiquandikou.text = @"优惠券抵扣";
    
    UILabel *yuezhifu = [UILabel new];
    yuezhifu.font = CS_UIFontSize(14.);
    yuezhifu.textColor = [UIColor buttonTitleColor];
    yuezhifu.text = @"余额支付";
    
    UILabel *shifukuan = [UILabel new];
    shifukuan.font = CS_UIFontBoldSize(16.);
    shifukuan.textColor = [UIColor buttonTitleColor];
    shifukuan.text = @"实付款 (含运费)";
    
    UILabel *yunfeiValue = [UILabel new];
    yunfeiValue.font = CS_UIFontSize(14.);
    yunfeiValue.textColor = [UIColor buttonTitleColor];
    yunfeiValue.text = @"¥0.00";
    
    UILabel *dingdanjineValue = [UILabel new];
    dingdanjineValue.font = CS_UIFontSize(14.);
    dingdanjineValue.textColor = [UIColor buttonTitleColor];
    dingdanjineValue.text = @"¥100.00";
    
    UILabel *youhuiquandikouValue = [UILabel new];
    youhuiquandikouValue.font = CS_UIFontSize(14.);
    youhuiquandikouValue.textColor = [UIColor buttonTitleColor];
    youhuiquandikouValue.text = @"¥0.00";
    
    UILabel *yuezhifuValue = [UILabel new];
    yuezhifuValue.font = CS_UIFontSize(14.);
    yuezhifuValue.textColor = [UIColor buttonTitleColor];
    yuezhifuValue.text = @"¥0.00";
    
    UILabel *shifukuanValue = [UILabel new];
    shifukuanValue.font = CS_UIFontBoldSize(18.);
    shifukuanValue.textColor = [UIColor buttonEnabledBackgroundColor];
    shifukuanValue.text = @"¥100.00";
    
    [self addSubview:self.orderNumLabel];
    [self addSubview:self.orderCreateTime];
    [self addSubview:self.orderPayTime];
    [self addSubview:self.orderPayType];
    [self addSubview:self.orderSource];
    [self addSubview:yunfei];
    [self addSubview:yunfeiValue];
    [self addSubview:dingdanjine];
    [self addSubview:dingdanjineValue];
    [self addSubview:youhuiquandikou];
    [self addSubview:youhuiquandikouValue];
    [self addSubview:yuezhifu];
    [self addSubview:yuezhifuValue];
    [self addSubview:shifukuan];
    [self addSubview:shifukuanValue];
    
    self.yunfeiLabel = yunfeiValue;
    self.orderPayLabel = dingdanjineValue;
    self.couponLabel = youhuiquandikouValue;
    self.yueLabel = yuezhifuValue;
    self.totalPayLabel = shifukuanValue;
    
    kWeakSelf
    
    [threeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf);
        make.width.mas_equalTo(@(SCREENWIDTH));
        make.height.mas_equalTo(@90);
    }];
    [addressImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(threeView).offset(10);
        make.centerY.equalTo(threeView.mas_centerY);
        make.height.mas_equalTo(@30);
        make.width.mas_equalTo(@20);
    }];
    [self.addressNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressImage.mas_right).offset(10);
        make.centerY.equalTo(threeView.mas_centerY).offset(-20);
    }];
    [self.addressPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.addressNameLabel.mas_right).offset(20);
        make.centerY.equalTo(weakSelf.addressNameLabel.mas_centerY);
    }];
    [self.addressDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressImage.mas_right).offset(10);
        make.right.equalTo(threeView).offset(-10);
        make.centerY.equalTo(threeView.mas_centerY).offset(15);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(threeView.mas_bottom);
        make.left.right.equalTo(weakSelf);
        make.height.mas_equalTo(10);
    }];
    [self.orderNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(15);
        make.top.equalTo(lineView.mas_bottom).offset(20);
    }];
    [self.orderCreateTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.orderNumLabel);
        make.top.equalTo(weakSelf.orderNumLabel.mas_bottom).offset(10);
    }];
    [self.orderPayTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.orderNumLabel);
        make.top.equalTo(weakSelf.orderCreateTime.mas_bottom).offset(10);
    }];
    [self.orderPayType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.orderNumLabel);
        make.top.equalTo(weakSelf.orderPayTime.mas_bottom).offset(10);
    }];
    [yunfei mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.orderNumLabel);
        make.top.equalTo(weakSelf.orderPayType.mas_bottom).offset(20);
    }];
    [dingdanjine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.orderNumLabel);
        make.top.equalTo(yunfei.mas_bottom).offset(10);
    }];
    [youhuiquandikou mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.orderNumLabel);
        make.top.equalTo(dingdanjine.mas_bottom).offset(10);
    }];
    [yuezhifu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.orderNumLabel);
        make.top.equalTo(youhuiquandikou.mas_bottom).offset(10);
    }];
    [shifukuan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.orderNumLabel);
        make.top.equalTo(yuezhifu.mas_bottom).offset(20);
    }];
    [yunfeiValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).offset(-15);
        make.centerY.equalTo(yunfei.mas_centerY);
    }];
    [dingdanjineValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(yunfeiValue);
        make.centerY.equalTo(dingdanjine.mas_centerY);
    }];
    [youhuiquandikouValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(yunfeiValue);
        make.centerY.equalTo(youhuiquandikou.mas_centerY);
    }];
    [yuezhifuValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(yunfeiValue);
        make.centerY.equalTo(yuezhifu.mas_centerY);
    }];
    [shifukuanValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(yunfeiValue);
        make.centerY.equalTo(shifukuan.mas_centerY);
    }];
    
    
    
}
- (void)tapClick:(UITapGestureRecognizer *)tap {
    UIView *tapView = [tap view];
    NSInteger tag = tapView.tag;
    
    if (_delegate && [_delegate respondsToSelector:@selector(composeHeaderTapView:TapClick:)]) {
        [_delegate composeHeaderTapView:self TapClick:tag];
    }
}


@end




























































