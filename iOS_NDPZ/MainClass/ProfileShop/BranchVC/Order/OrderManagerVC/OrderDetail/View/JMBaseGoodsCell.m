//
//  JMBaseGoodsCell.m
//  XLMM
//
//  Created by 崔人帅 on 16/6/24.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "JMBaseGoodsCell.h"
#import "JMSelecterButton.h"
#import "JMPackAgeModel.h"

NSString *const JMBaseGoodsCellIdentifier = @"JMBaseGoodsCellIdentifier";

@interface JMBaseGoodsCell ()

@property (nonatomic,strong) UIImageView *iconImage;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *PriceLabel;

@property (nonatomic, strong) UILabel *sizeLabel;

@property (nonatomic, strong) UILabel *numLabel;

@property (nonatomic, strong) JMSelecterButton *optionButton;

@property (nonatomic, strong) UILabel *refundLabel;

@property (nonatomic, strong) UIView *tapView;

@property (nonatomic, strong) JMOrderGoodsModel *orderModel;


@end

@implementation JMBaseGoodsCell {
    NSInteger _sectionCount;
    NSInteger _rowCount;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    UIImageView *iconImage = [UIImageView new];
    [self.contentView addSubview:iconImage];
    self.iconImage = iconImage;
    self.iconImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewClick:)];
    [self.iconImage addGestureRecognizer:tap];
    self.iconImage.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.layer.borderWidth = 0.5;
    self.iconImage.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;
    self.iconImage.layer.cornerRadius = 5;
    
    UILabel *titleLabel = [UILabel new];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    self.titleLabel.font = [UIFont systemFontOfSize:13.];
    self.titleLabel.numberOfLines = 2;
    
    UILabel *PriceLabel = [UILabel new];
    [self.contentView addSubview:PriceLabel];
    self.PriceLabel = PriceLabel;
    self.PriceLabel.font = [UIFont boldSystemFontOfSize:12.];
    self.PriceLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    
    UILabel *sizeLabel = [UILabel new];
    [self.contentView addSubview:sizeLabel];
    self.sizeLabel = sizeLabel;
    self.sizeLabel.font = [UIFont boldSystemFontOfSize:12.];
    self.sizeLabel.textColor = [UIColor dingfanxiangqingColor];
    
    UILabel *numLabel = [UILabel new];
    [self.contentView addSubview:numLabel];
    self.numLabel = numLabel;
    self.numLabel.font = [UIFont systemFontOfSize:12.];
    self.numLabel.textColor = [UIColor dingfanxiangqingColor];
    
    UILabel *zhuanLabel = [UILabel new];
    zhuanLabel.textColor = [UIColor whiteColor];
    zhuanLabel.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    zhuanLabel.font = CS_UIFontSize(11.);
    zhuanLabel.text = @"赚";
    zhuanLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:zhuanLabel];
    self.zhuanLabel = zhuanLabel;
    
    UILabel *zhuanValueLabel = [UILabel new];
    zhuanValueLabel.textColor = [UIColor buttonTitleColor];
    zhuanValueLabel.font = CS_UIFontSize(12.);
    zhuanValueLabel.text = @"0.00";
    self.zhuanValueLabel = zhuanValueLabel;
    [self.contentView addSubview:zhuanValueLabel];
    
    JMSelecterButton *optionButton = [[JMSelecterButton alloc] init];
    [self.contentView addSubview:optionButton];
    self.optionButton = optionButton;
    [self.optionButton addTarget:self action:@selector(optionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *refundLabel = [UILabel new];
    [self.contentView addSubview:refundLabel];
    self.refundLabel = refundLabel;
    self.refundLabel.numberOfLines = 0;
    self.refundLabel.font = [UIFont systemFontOfSize:12.];
    self.refundLabel.textAlignment = NSTextAlignmentRight;
    self.refundLabel.textColor = [UIColor dingfanxiangqingColor];
    
//    UIView *tapView = [UIView new];
//    [self.contentView addSubview:tapView];
//    self.tapView = tapView;
//    self.tapView.alpha = 0.0;
//    self.tapView.userInteractionEnabled = YES;
    
//    self.earningButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.contentView addSubview:self.earningButton];
//    [self.earningButton sizeToFit];
//    self.earningButton.titleLabel.font = CS_UIFontSize(13.);
//    [self.earningButton setTitleColor:[UIColor buttonEnabledBackgroundColor] forState:UIControlStateNormal];
//    self.earningButton.hidden = YES;
    
    kWeakSelf
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf.contentView).offset(10);
        make.width.height.mas_equalTo(@90);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImage).offset(5);
        make.left.equalTo(weakSelf.iconImage.mas_right).offset(10);
        make.right.equalTo(weakSelf.contentView).offset(-10);
    }];
    
    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.iconImage.mas_centerY);
        make.left.equalTo(weakSelf.titleLabel);
        make.right.equalTo(weakSelf.contentView).offset(-10);
        //        make.width.mas_equalTo(@(SCREENWIDTH - 180));
    }];
    
    [self.PriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.iconImage.mas_bottom).offset(-5);
        make.left.equalTo(weakSelf.titleLabel);
    }];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.PriceLabel);
        make.left.equalTo(weakSelf.PriceLabel.mas_right).offset(10);
    }];
    
    [zhuanValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).offset(-10);
        make.centerY.equalTo(weakSelf.numLabel.mas_centerY);
    }];
    [zhuanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(zhuanValueLabel.mas_left).offset(-2);
        make.centerY.equalTo(weakSelf.numLabel.mas_centerY);
        make.width.height.mas_equalTo(15);
    }];
    
    [self.optionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).offset(-10);
        //        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.top.equalTo(weakSelf.sizeLabel.mas_bottom).offset(5);
        make.width.mas_equalTo(@70);
        make.height.mas_equalTo(@25);
    }];
    
    [self.refundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).offset(-10);
        //        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.top.equalTo(weakSelf.sizeLabel.mas_bottom).offset(5);
        //        make.width.mas_equalTo(@80);
    }];
    
    //    [self.tapView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.top.bottom.equalTo(weakSelf.contentView);
    //        make.right.equalTo(weakSelf.refundLabel.mas_left).offset(-40);
    //    }];
//    [self.earningButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(weakSelf.PriceLabel.mas_centerY);
//        make.right.equalTo(weakSelf.contentView).offset(-10);
//    }];
    
    
}
- (void)setIsTeamBuy:(BOOL)isTeamBuy {
    _isTeamBuy = isTeamBuy;
}
- (void)setIsCanRefund:(bool)isCanRefund {
    _isCanRefund = isCanRefund;
    
}
- (void)configWithModel:(JMOrderGoodsModel *)goodsModel SectionCount:(NSInteger)sectionCount RowCount:(NSInteger)rowCount     {
    self.zhuanLabel.hidden = YES;
    self.zhuanValueLabel.hidden = YES;
    
    NSString *string = goodsModel.pic_path;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[[string imageGoodsOrderCompression] JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"icon_placeholderEmpty"]];
    self.titleLabel.text = goodsModel.title;
    self.sizeLabel.text = [NSString stringWithFormat:@"规格:%@",goodsModel.sku_name];
    CGFloat payment = [goodsModel.total_fee floatValue];
    NSInteger goodsNum = [goodsModel.num integerValue];
    self.PriceLabel.text = [NSString stringWithFormat:@"¥%.2f",payment / goodsNum];
    self.numLabel.text = [NSString stringWithFormat:@"x%@",goodsModel.num];
    
    NSInteger orderStatus = [goodsModel.status integerValue];
    NSInteger refundStatus = [goodsModel.refund_status integerValue];
    NSString *refundDisplay = goodsModel.refund_status_display;
//    NSString *orderDisplay = goodsModel.status_display;
    BOOL isOrderStatus = (orderStatus == ORDER_STATUS_CONFIRM_RECEIVE);
    if (orderStatus == ORDER_STATUS_PAYED) {
        if (refundStatus == 0) {
            if (_isTeamBuy) {
                if (_isCanRefund) {
                    [self.optionButton setSelecterBorderColor:[UIColor buttonEnabledBackgroundColor] TitleColor:[UIColor buttonEnabledBackgroundColor] Title:@"申请退款" TitleFont:12. CornerRadius:10];
                    self.optionButton.tag = 100;
                }else { }
            }else {
                if (goodsModel.kill_title) {
                    [self.optionButton setNomalBorderColor:[UIColor buttonDisabledBackgroundColor] TitleColor:[UIColor buttonDisabledBackgroundColor] Title:@"秒杀款不退不换" TitleFont:11. CornerRadius:10];
                    self.optionButton.tag = 103;
                    self.optionButton.enabled = NO;
                }else {
                    [self.optionButton setSelecterBorderColor:[UIColor buttonEnabledBackgroundColor] TitleColor:[UIColor buttonEnabledBackgroundColor] Title:@"申请退款" TitleFont:12. CornerRadius:10];
                    self.optionButton.tag = 100;
                }
            }
        }else {
            self.optionButton.hidden = YES;
            self.refundLabel.text = refundDisplay;
        }
    }else if (orderStatus == ORDER_STATUS_SENDED) {
        [self.optionButton setSelecterBorderColor:[UIColor buttonEnabledBackgroundColor] TitleColor:[UIColor buttonEnabledBackgroundColor] Title:@"确认收货" TitleFont:12. CornerRadius:10];
        self.optionButton.tag = 101;
    }else if (isOrderStatus && (refundStatus == REFUND_STATUS_NO_REFUND)) {
        if (refundStatus == 0) {
            [self.optionButton setSelecterBorderColor:[UIColor buttonEnabledBackgroundColor] TitleColor:[UIColor buttonEnabledBackgroundColor] Title:@"退货退款" TitleFont:12. CornerRadius:10];
            self.optionButton.tag = 102;
            if (goodsModel.kill_title) {
                [self.optionButton setNomalBorderColor:[UIColor buttonDisabledBackgroundColor] TitleColor:[UIColor buttonDisabledBackgroundColor] Title:@"秒杀款不退不换" TitleFont:11. CornerRadius:10];
                self.optionButton.tag = 103;
                self.optionButton.enabled = NO;
            }
        }else {
            self.optionButton.hidden = YES;
        }
    }else {
        self.optionButton.hidden = YES;
        if (refundStatus == REFUND_STATUS_NO_REFUND) {
            self.refundLabel.text = @"";
        }
    }
    _sectionCount = sectionCount;
    _rowCount = rowCount;
    
    self.orderModel = [[JMOrderGoodsModel alloc] init];
    self.orderModel = goodsModel;
    
    
    
}
- (void)configWithAllOrder:(JMOrderGoodsModel *)goodsModel {
    NSString *string = goodsModel.pic_path;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[[string imageGoodsOrderCompression] JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"icon_placeholderEmpty"]];
    self.titleLabel.text = goodsModel.title;
    self.sizeLabel.text = [NSString stringWithFormat:@"规格:%@",goodsModel.sku_name];
    CGFloat payment = [goodsModel.total_fee floatValue];
    NSInteger goodsNum = [goodsModel.num integerValue];
    self.PriceLabel.text = [NSString stringWithFormat:@"¥%.2f",payment / goodsNum];
    self.numLabel.text = [NSString stringWithFormat:@"x%@",goodsModel.num];
    self.zhuanValueLabel.text = [NSString stringWithFormat:@"%.2f",[goodsModel.extras.order_profit floatValue] / 100.00];
    
}

- (void)configWithLogistics:(JMOrderGoodsModel *)goodsModel {
    self.zhuanLabel.hidden = YES;
    self.zhuanValueLabel.hidden = YES;
    
    NSString *string = goodsModel.pic_path;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[[string imageGoodsOrderCompression] JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"icon_placeholderEmpty"]];
    self.titleLabel.text = goodsModel.title;
    self.sizeLabel.text = [NSString stringWithFormat:@"规格:%@",goodsModel.sku_name];
    CGFloat payment = [goodsModel.total_fee floatValue];
    NSInteger goodsNum = [goodsModel.num integerValue];
    self.PriceLabel.text = [NSString stringWithFormat:@"¥%.2f",payment / goodsNum];
    self.numLabel.text = [NSString stringWithFormat:@"x%@",goodsModel.num];
    self.zhuanValueLabel.text = [NSString stringWithFormat:@"%.2f",[goodsModel.extras.order_profit floatValue] / 100.00];
}


/**
 *  支付订单数据源赋值
 */
- (void)configPurchaseModel:(CartListModel *)cartModel {
    self.zhuanLabel.hidden = YES;
    self.zhuanValueLabel.hidden = YES;
    
    NSString *string = cartModel.pic_path;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[[string imageGoodsOrderCompression] JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"icon_placeholderEmpty"]];
    self.titleLabel.text = cartModel.title;
    self.sizeLabel.text = [NSString stringWithFormat:@"规格:%@",cartModel.sku_name];
    CGFloat payment = [cartModel.total_fee floatValue];
    NSInteger goodsNum = [cartModel.num integerValue];
    self.PriceLabel.text = [NSString stringWithFormat:@"单价: ¥%.2f",payment / goodsNum];
    self.numLabel.text = [NSString stringWithFormat:@"x%@",cartModel.num];
    
    
}

- (void)optionButtonClick:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(composeOptionClick:Button:Section:Row:)]) {
        [_delegate composeOptionClick:self Button:button Section:_sectionCount Row:_rowCount];
    }
}
- (void)tapViewClick:(UITapGestureRecognizer *)tap {
    if (_delegate && [_delegate respondsToSelector:@selector(composeOptionClick:Tap:Section:Row:)]) {
        [_delegate composeOptionClick:self Tap:tap Section:_sectionCount Row:_rowCount];
    }
}

@end



























































