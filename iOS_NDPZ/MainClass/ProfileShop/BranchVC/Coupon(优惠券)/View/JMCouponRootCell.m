//
//  JMCouponRootCell.m
//  XLMM
//
//  Created by zhang on 17/4/12.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "JMCouponRootCell.h"
#import "JMCouponModel.h"
#import "JMRichTextTool.h"


@interface JMCouponRootCell ()

/**
 *  优惠券金额
 */
@property (nonatomic, strong) UILabel *couponValueLabel;
/**
 *  使用条件
 */
@property (nonatomic, strong) UILabel *couponUsefeeLabel;
/**
 *  使用场景
 */
@property (nonatomic, strong) UILabel *couponProsdescLabel;
@property (nonatomic, strong) UILabel *couponTypeLabel;
/**
 *  开始时间
 */
@property (nonatomic, strong) UILabel *couponCreatedTimeLabel;
/**
 *  结束时间
 */
@property (nonatomic, strong) UILabel *couponDeadLineLabel;

@property (nonatomic, strong) UIImageView *rightImage;

@property (nonatomic, strong) UIImageView *statusImageV;
@property (nonatomic, strong) UILabel *youhuiquan;

@end

@implementation JMCouponRootCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    UIImageView *couponBackImage = [UIImageView new];
    [self.contentView addSubview:couponBackImage];
    self.couponBackImage = couponBackImage;
    couponBackImage.image = [UIImage imageNamed:@"cs_couponBack_enable"];
    
    UILabel *youhuiquan = [UILabel new];
    youhuiquan.font = CS_UIFontBoldSize(16.);
    youhuiquan.textColor = [UIColor whiteColor];
    youhuiquan.text = @"满减券";
    youhuiquan.numberOfLines = 0;
    youhuiquan.textAlignment = NSTextAlignmentCenter;
    self.youhuiquan = youhuiquan;
    
    UILabel *valueLabel = [UILabel new];
    valueLabel.font = CS_UIFontBoldSize(32);
    valueLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    self.couponValueLabel = valueLabel;
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = CS_UIFontSize(14.);
    titleLabel.textColor = [UIColor dingfanxiangqingColor];
    titleLabel.text = @"新掌柜专属券";
    self.couponTypeLabel = titleLabel;
    
    UILabel *tiaojianLabel = [UILabel new];
    tiaojianLabel.font = CS_UIFontSize(14.);
    tiaojianLabel.textColor = [UIColor dingfanxiangqingColor];
    tiaojianLabel.text = @"无门槛使用";
    self.couponProsdescLabel = tiaojianLabel;
    
    UILabel *timeLabel = [UILabel new];
    timeLabel.font = CS_UIFontSize(14.);
    timeLabel.textColor = [UIColor dingfanxiangqingColor];
    timeLabel.text = @"有效期至: 2017 - 10 - 01";
    self.couponDeadLineLabel = timeLabel;
    
    UIImageView *statusImageV = [UIImageView new];
    statusImageV.image = [UIImage imageNamed:@"cs_coupon_enable"];
    self.statusImageV = statusImageV;
    
    
    [self.contentView addSubview:youhuiquan];
    [self.contentView addSubview:valueLabel];
    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:tiaojianLabel];
    [self.contentView addSubview:timeLabel];
    [self.contentView addSubview:statusImageV];
    
    CGFloat spaceLeft = HomeCategoryRatio * 5;
    if (SCREENWIDTH > 320 && SCREENWIDTH <= 375) {
        spaceLeft = HomeCategoryRatio * 6;
        valueLabel.font = CS_UIFontBoldSize(28);
    }else if (SCREENWIDTH > 375) {
        spaceLeft = HomeCategoryRatio * 8;
        valueLabel.font = CS_UIFontBoldSize(32);
    }else {
        valueLabel.font = CS_UIFontBoldSize(24);
    }
    
    CGFloat titleW = SCREENWIDTH - 70 - HomeCategoryRatio * 110;
    
    kWeakSelf
    [self.couponBackImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(10);
        make.top.equalTo(weakSelf.contentView).offset(10);
        make.width.mas_equalTo(SCREENWIDTH - 20);
        make.height.mas_equalTo(@100);
    }];
    [youhuiquan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.couponBackImage.mas_centerY);
        make.width.mas_equalTo(@20);
        make.left.equalTo(weakSelf.couponBackImage).offset(spaceLeft);
    }];
    [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.couponBackImage.mas_centerY);
        make.left.equalTo(weakSelf.couponBackImage).offset(HomeCategoryRatio * 32);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.couponBackImage).offset(HomeCategoryRatio * 110);
        make.centerY.equalTo(weakSelf.couponBackImage.mas_centerY).offset(-25);
        make.width.mas_equalTo(@(titleW));
    }];
    [tiaojianLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.centerY.equalTo(weakSelf.couponBackImage.mas_centerY);
        make.width.mas_equalTo(@(titleW));
    }];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.centerY.equalTo(weakSelf.couponBackImage.mas_centerY).offset(25);
        make.width.mas_equalTo(@(titleW));
    }];
    [statusImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.couponBackImage).offset(15);
        make.right.equalTo(weakSelf.couponBackImage).offset(-10);
    }];
    
    
    /*
     (lldb) po [UIScreen mainScreen].bounds
     (origin = (x = 0, y = 0), size = (width = 375, height = 667))
     
     
     (origin = (x = 0, y = 0), size = (width = 414, height = 736))
     
     */
}



- (void)configData:(JMCouponModel *)couponModel Index:(NSInteger)index {
    NSString *imageStr = @"";
    NSString *statusString = @"";
    if (index == 0) {
        //未使用优惠券
        imageStr = @"cs_couponBack_enable";
        statusString = @"cs_coupon_enable";
        self.couponValueLabel.textColor = [UIColor redColor];
    }else if (index == 1) {
        //已使用
        imageStr = @"cs_couponBack_disenable";
        statusString = @"cs_coupon_yijingused";
        self.couponValueLabel.textColor = [UIColor timeLabelColor];
        self.youhuiquan.textColor = [UIColor buttonEnabledBackgroundColor];
    }else if (index == 2) {
        //不可使用
        imageStr = @"cs_couponBack_disenable";
        statusString = @"cs_coupon_disenable";
        self.couponValueLabel.textColor = [UIColor dingfanxiangqingColor];
        self.youhuiquan.textColor = [UIColor dingfanxiangqingColor];
    }else if (index == 3) {
        //已过期
        imageStr = @"cs_couponBack_disenable";
        statusString = @"cs_coupon_timeout";
        self.couponValueLabel.textColor = [UIColor timeLabelColor];
        self.youhuiquan.textColor = [UIColor buttonEnabledBackgroundColor];
    }else if (index == 8) {
        //未使用优惠券
        imageStr = @"cs_couponBack_enable";
        statusString = @"cs_coupon_enable";
        self.couponValueLabel.textColor = [UIColor redColor];
    }else {
        imageStr = @"cs_couponBack_disenable";
        statusString = @"cs_coupon_enable";
        self.couponValueLabel.textColor = [UIColor redColor];
        self.youhuiquan.textColor = [UIColor buttonEnabledBackgroundColor];
    }
    self.couponBackImage.image = [UIImage imageNamed:imageStr];
    self.statusImageV.image = [UIImage imageNamed:statusString];
    NSString *valueString = [NSString stringWithFormat:@"¥%.1f",[couponModel.coupon_value floatValue]];
    if (valueString.length > 5) {
        self.couponValueLabel.font = CS_UIFontSize(26.);
    }
    self.couponValueLabel.attributedText = [JMRichTextTool cs_changeFontAndColorWithSubFont:[UIFont boldSystemFontOfSize:20.] AllString:valueString SubStringArray:@[@"¥"]];
//    CGSize sizeToFit = [self.couponValueLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:32.]} context:nil].size;
//    CGFloat valueWidth = sizeToFit.width + 5;
//    [self.couponValueLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_offset(@(valueWidth));
//    }];
    
    self.couponProsdescLabel.text = couponModel.use_fee_des;
    self.couponTypeLabel.text = couponModel.title;
//    self.couponCreatedTimeLabel.text = [self composeString:couponModel.created];
    self.couponDeadLineLabel.text = [NSString stringWithFormat:@"有效期至: %@",[NSString yearDeal:couponModel.deadline]];
    
    
}
- (void)configUsableData:(JMCouponModel *)couponModel IsSelectedYHQ:(BOOL)isselectedYHQ SelectedID:(NSString *)selectedID Index:(NSInteger)index {
    NSString *imageStr = @"";
    NSString *statusString = @"";
    if (index == 0) {
        imageStr = @"cs_couponBack_enable";
        statusString = @"cs_coupon_enable";
        if (isselectedYHQ == YES) {
            NSArray *selectedIDArr = [selectedID componentsSeparatedByString:@"/"];
            NSString *selectedFirstID = selectedIDArr[0];
            if ([selectedFirstID isEqualToString:couponModel.couponID]) {
                imageStr = @"cs_couponBack_enable";
                statusString = @"cs_coupon_enable";
                self.couponValueLabel.textColor = [UIColor redColor];
            }else {
                imageStr = @"cs_couponBack_enable";
                statusString = @"cs_coupon_enable";
                self.couponValueLabel.textColor = [UIColor redColor];
            }
        }else {
            imageStr = @"cs_couponBack_enable";
            statusString = @"cs_coupon_enable";
            self.couponValueLabel.textColor = [UIColor redColor];
        }
    }else {
        imageStr = @"cs_couponBack_disenable";
        statusString = @"cs_coupon_enable";
    }
    
    self.couponBackImage.image = [UIImage imageNamed:imageStr];
    self.statusImageV.image = [UIImage imageNamed:statusString];
    NSString *valueString = [NSString stringWithFormat:@"¥%.1f",[couponModel.coupon_value floatValue]];
    self.couponValueLabel.attributedText = [JMRichTextTool cs_changeFontAndColorWithSubFont:[UIFont boldSystemFontOfSize:22.] AllString:valueString SubStringArray:@[@"¥"]];
//    CGSize sizeToFit = [self.couponValueLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:32.]} context:nil].size;
//    CGFloat valueWidth = sizeToFit.width + 5;
//    [self.couponValueLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_offset(@(valueWidth));
//    }];

    self.couponProsdescLabel.text = couponModel.use_fee_des;
    self.couponTypeLabel.text = couponModel.title;
    //    self.couponCreatedTimeLabel.text = [self composeString:couponModel.created];
    self.couponDeadLineLabel.text = [NSString stringWithFormat:@"有效期至: %@",[NSString yearDeal:couponModel.deadline]];
}

- (NSString *)composeString:(NSString *)str {
    NSArray *arr = [str componentsSeparatedByString:@"T"];
    NSString *string1 = [arr componentsJoinedByString:@" "];
    NSString *string2 = [string1 substringWithRange:NSMakeRange(0,16)];
    return string2;
}



@end

/**
 *  未使用 {
           |-->   noUsed_coupon@2x
    未选中--|-->   used_nomalcoupon@2x
    选中           used_selectedcoupon@2x
 }
    已过期 -- >   outDate_coupon@2x
 
    已使用 -- >   used_coupon@2x
 
    选择优惠券 -->
 */


















































