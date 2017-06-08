//
//  JMGoodsExplainCell.m
//  XLMM
//
//  Created by zhang on 17/4/8.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "JMGoodsExplainCell.h"
#import "JMCountDownView.h"
#import "JMRichTextTool.h"
#import "CSGoodsDetailModel.h"


NSString *const JMGoodsExplainCellIdentifier = @"JMGoodsExplainCellIdentifier";

/// <JMCountDownViewDelegate>

@interface JMGoodsExplainCell ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UILabel *nameTitle;
@property (nonatomic, strong) UILabel *PriceLabel;
@property (nonatomic, strong) UILabel *oldPriceLabel;
@property (nonatomic, strong) UIButton *itemMask;

@property (nonatomic, strong) UILabel *timerLabel;

@property (nonatomic, strong) UIButton *storeUpButton;

@property (nonatomic, strong) JMCountDownView *countDownView;
@property (nonatomic, strong) UIButton *fineGoodsView;
/// 地址信息提示
@property (nonatomic, strong) UIView *promptView;
@property (nonatomic, strong) UILabel *promptLabel;

@property (nonatomic, strong) UIView *limitHeaderView;           // 特卖商品内容视图

@property (nonatomic, strong) UILabel *hourLabel;   // 时间 -> 时
@property (nonatomic, strong) UILabel *minuteLabel; // 时间 -> 分
@property (nonatomic, strong) UILabel *secLabel;    // 时间 -> 秒

@property (nonatomic, strong) UILabel *limitPriceLabel;  // 特卖商品 价格
@property (nonatomic, strong) UILabel *limitProfitLabel; // 特卖商品 赚
@property (nonatomic, strong) UILabel *saleNumAndstockLabel;     // 在售人数..
@property (nonatomic, strong) UILabel *curreLabel;               // '/'


@end

@implementation JMGoodsExplainCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}
- (void)setDetailModel:(CSGoodsDetailModel *)detailModel {
    _detailModel = detailModel;
    CSGoodsDetailContentModel *detailContentModel = detailModel.detail_content;
    NSDictionary *profitDic = detailModel.profit;
    
    if (detailModel.is_flashsale) {
        [self.nameTitle mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(75);
        }];
        self.limitHeaderView.hidden = NO;
        self.PriceLabel.hidden = YES;
        self.curreLabel.hidden = YES;
        self.oldPriceLabel.hidden = YES;
        
        self.limitPriceLabel.attributedText = [JMRichTextTool cs_changeFontAndColorWithSubFont:[UIFont systemFontOfSize:18] AllString:[NSString stringWithFormat:@"¥%.2f",[detailContentModel.lowest_agent_price floatValue]] SubStringArray:@[@"¥"]];
        self.limitProfitLabel.text = [NSString stringWithFormat:@"赚:%.1f",[profitDic[@"min"] floatValue]];
    }else {
        self.limitHeaderView.hidden = YES;
        self.PriceLabel.attributedText = [JMRichTextTool cs_changeFontAndColorWithSubFont:[UIFont systemFontOfSize:18] AllString:[NSString stringWithFormat:@"¥%.2f",[detailContentModel.lowest_agent_price floatValue]] SubStringArray:@[@"¥"]];
        self.oldPriceLabel.text = [NSString stringWithFormat:@"赚:%.1f",[profitDic[@"min"] floatValue]];
    }
    self.nameTitle.text = detailContentModel.name;
    
    NSInteger kucunNum = [detailModel.stock integerValue];
    if (kucunNum < 0) {
        kucunNum = 0;
    }
    NSInteger zaishouNum = [detailModel.selling_num integerValue];
    self.saleNumAndstockLabel.text = [NSString stringWithFormat:@"在售人数%ld        库存%ld",zaishouNum,kucunNum];
    //    self.timerLabel.text = detailContentDic[@"offshelf_time"];
    
    NSArray *itemMask = detailContentModel.item_marks;
    NSString *itemString = @"包邮";
    if (itemMask.count == 0) {
        return ;
    }else {
        itemString = itemMask[0];
        
    }
    [self.itemMask setTitle:itemString forState:UIControlStateNormal];
    //    self.itemMask.text = [NSString stringWithFormat:@"%@",itemString];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont boldSystemFontOfSize:14] forKey:NSFontAttributeName];
    CGSize size = [itemString sizeWithAttributes:dic];
    [self.itemMask mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(size.width + 10));
    }];
    //    self.itemMask.textAlignment = NSTextAlignmentCenter;
    
    
    
    
    
    // === 处理结束时间 === //
    
    NSString *endTime = @"";
    NSString *timeString = detailContentModel.offshelf_time;
    if ([NSString isStringEmpty:timeString]) {
        //        self.timerLabel.text = @"即将上架";
    }else {
        endTime = [NSString jm_deleteTimeWithT:timeString];
        int endSecond = [[JMGlobal global] secondOfCurrentTimeInEndTime:endTime];
        [JMCountDownView countDownWithCurrentTime:endSecond];
        kWeakSelf
        [JMCountDownView shareCountDown].timeBlock = ^(int second) {
            kStrongSelf
            //            weakSelf.timerLabel.text = second == -1 ? @"商品已下架" : [NSString TimeformatDHMSFromSeconds:second];
            if (second == -1) {
                second = 0;
            }
            strongSelf.hourLabel.text = [NSString stringWithFormat:@"%02d",(second/(3600))%24];
            strongSelf.minuteLabel.text = [NSString stringWithFormat:@"%02d",(second%3600)/60];
            strongSelf.secLabel.text = [NSString stringWithFormat:@"%02d",second%60];
        };
    }
    
    
    
    
    
}


- (void)initUI {
    
    UIView *headerView = [UIView new];
    [self.contentView addSubview:headerView];
    self.limitHeaderView = headerView;
    
    UIImageView *leftImageView = [UIImageView new];
    [headerView addSubview:leftImageView];
    leftImageView.image = [UIImage imageNamed:@"limitTimeSaleImage_left"];
    leftImageView.contentMode = UIViewContentModeScaleAspectFill;
    leftImageView.clipsToBounds = YES;
    
    UIImageView *rightImageView = [UIImageView new];
    [headerView addSubview:rightImageView];
    rightImageView.image = [UIImage imageNamed:@"limitTimeSaleImage_right"];
    rightImageView.contentMode = UIViewContentModeScaleAspectFill;
    rightImageView.clipsToBounds = YES;
    
    UIImageView *limitImage = [UIImageView new];
    [leftImageView addSubview:limitImage];
    limitImage.image = [UIImage imageNamed:@"limitTimeSaleImage_remind"];
    limitImage.contentMode = UIViewContentModeScaleAspectFill;
    limitImage.clipsToBounds = YES;
    
    UILabel *limitPriceLabel = [UILabel new];
    limitPriceLabel.textColor = [UIColor whiteColor];
    limitPriceLabel.font = CS_UIFontBoldSize(24);
    [leftImageView addSubview:limitPriceLabel];
    limitPriceLabel.text = @"¥0.00";
    
    UILabel *fengexianL = [UILabel new];
    [leftImageView addSubview:fengexianL];
    fengexianL.textColor = [UIColor whiteColor];
    fengexianL.text = @"/";
    fengexianL.font = CS_UIFontSize(20);
    
    UILabel *profitLabel = [UILabel new];
    [leftImageView addSubview:profitLabel];
    profitLabel.font = [UIFont systemFontOfSize:20.];
    profitLabel.textColor = [UIColor whiteColor];
    profitLabel.text = @"赚0.00";
    
    
    UILabel *timeLabel = [UILabel new];
    timeLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    timeLabel.font = CS_UIFontSize(14.);
    [rightImageView addSubview:timeLabel];
    timeLabel.text = @"距结束还剩 :";
    
    UILabel *hourLabel = [UILabel new];
    hourLabel.textColor = [UIColor whiteColor];
    hourLabel.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    hourLabel.font = CS_UIFontSize(12.);
    hourLabel.textAlignment = NSTextAlignmentCenter;
    [rightImageView addSubview:hourLabel];
    hourLabel.text = @"99";
    hourLabel.layer.cornerRadius = 5;
    hourLabel.layer.masksToBounds = YES;
    
    UILabel *minuteLabel = [UILabel new];
    minuteLabel.textColor = [UIColor whiteColor];
    minuteLabel.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    minuteLabel.font = CS_UIFontSize(12.);
    minuteLabel.textAlignment = NSTextAlignmentCenter;
    [rightImageView addSubview:minuteLabel];
    minuteLabel.text = @"99";
    minuteLabel.layer.cornerRadius = 5;
    minuteLabel.layer.masksToBounds = YES;
    
    UILabel *secLabel = [UILabel new];
    secLabel.textColor = [UIColor whiteColor];
    secLabel.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    secLabel.font = CS_UIFontSize(12.);
    secLabel.textAlignment = NSTextAlignmentCenter;
    [rightImageView addSubview:secLabel];
    secLabel.text = @"99";
    secLabel.layer.cornerRadius = 5;
    secLabel.layer.masksToBounds = YES;
    
    UILabel *maohao1 = [UILabel new];
    maohao1.textColor = [UIColor buttonEnabledBackgroundColor];
    maohao1.font = CS_UIFontSize(14.);
    [rightImageView addSubview:maohao1];
    maohao1.text = @" : ";
    
    UILabel *maohao2 = [UILabel new];
    maohao2.textColor = [UIColor buttonEnabledBackgroundColor];
    maohao2.font = CS_UIFontSize(14.);
    [rightImageView addSubview:maohao2];
    maohao2.text = @" : ";
    
    self.hourLabel = hourLabel;
    self.minuteLabel = minuteLabel;
    self.secLabel = secLabel;
    self.limitPriceLabel = limitPriceLabel;
    self.limitProfitLabel = profitLabel;
    
    kWeakSelf
    
    CGFloat timeSpace = 1.;
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(0);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(60);
    }];
    [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(headerView);
        make.width.mas_equalTo(SCREENWIDTH * 0.65);
        make.height.equalTo(headerView.mas_height);
    }];
    [limitImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftImageView).offset(15);
        make.top.equalTo(leftImageView).offset(5);
        make.width.mas_equalTo(72);
        make.height.mas_equalTo(16);
    }];
    [limitPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(limitImage);
        make.top.equalTo(limitImage.mas_bottom).offset(5);
    }];
    [fengexianL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(limitPriceLabel.mas_centerY).offset(-2);
        make.left.equalTo(limitPriceLabel.mas_right).offset(2);
    }];
    [profitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fengexianL.mas_right).offset(2);
        make.centerY.equalTo(limitPriceLabel.mas_centerY);
        
    }];
    
    
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(headerView);
        make.width.mas_equalTo(SCREENWIDTH * 0.35);
        make.height.equalTo(headerView.mas_height);
    }];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightImageView.mas_centerX);
        make.top.equalTo(rightImageView).offset(10);
    }];
    [minuteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightImageView.mas_centerX);
        make.width.height.mas_equalTo(20);
        make.top.equalTo(timeLabel.mas_bottom).offset(5);
    }];
    [maohao1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(minuteLabel.mas_left).offset(-timeSpace);
        make.centerY.equalTo(minuteLabel.mas_centerY);
    }];
    [maohao2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(minuteLabel.mas_right).offset(timeSpace);
        make.centerY.equalTo(minuteLabel.mas_centerY);
    }];
    [hourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(maohao1.mas_left).offset(-timeSpace);
        make.centerY.equalTo(minuteLabel.mas_centerY);
        make.width.height.mas_equalTo(20);
    }];
    [secLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(maohao2.mas_right).offset(timeSpace);
        make.centerY.equalTo(minuteLabel.mas_centerY);
        make.width.height.mas_equalTo(20);
    }];
    
    
    UILabel *nameTitle = [UILabel new];
    [self.contentView addSubview:nameTitle];
    nameTitle.font = [UIFont systemFontOfSize:16.];
    nameTitle.numberOfLines = 2;
    nameTitle.textColor = [UIColor buttonTitleColor];
    self.nameTitle = nameTitle;
    
    UILabel *PriceLabel = [UILabel new];
    [self.contentView addSubview:PriceLabel];
    PriceLabel.font = [UIFont systemFontOfSize:24.];
    PriceLabel.textColor = [UIColor buttonTitleColor];
    self.PriceLabel = PriceLabel;
    
    UILabel *curreLabel = [UILabel new];
    [self.contentView addSubview:curreLabel];
    curreLabel.text = @"/";
    curreLabel.textColor = [UIColor dingfanxiangqingColor];
    curreLabel.font = CS_UIFontSize(20);
    self.curreLabel = curreLabel;
    
    UILabel *oldPriceLabel = [UILabel new];
    [self.contentView addSubview:oldPriceLabel];
    oldPriceLabel.font = [UIFont systemFontOfSize:20.];
    oldPriceLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    self.oldPriceLabel = oldPriceLabel;
    
    UILabel *saleNumAndstockLabel = [UILabel new];
    [self.contentView addSubview:saleNumAndstockLabel];
    saleNumAndstockLabel.font = [UIFont systemFontOfSize:13.];
    saleNumAndstockLabel.textColor = [UIColor dingfanxiangqingColor];
    self.saleNumAndstockLabel = saleNumAndstockLabel;
    
    
    UIButton *lookWirter = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:lookWirter];
    [lookWirter setTitle:@"分享素材" forState:UIControlStateNormal];
    [lookWirter setTitleColor:[UIColor timeLabelColor] forState:UIControlStateNormal];
    lookWirter.titleLabel.font = [UIFont systemFontOfSize:14.];
    lookWirter.layer.masksToBounds = YES;
    lookWirter.layer.borderWidth = 0.5f;
    lookWirter.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;
    lookWirter.layer.cornerRadius = 5.f;
    lookWirter.tag = 100;
    [self.contentView addSubview:lookWirter];
    self.storeUpButton = lookWirter;
    [self.storeUpButton addTarget:self action:@selector(storeUpClick:) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *baoyouBUtton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:baoyouBUtton];
    [baoyouBUtton setTitle:@"包邮" forState:UIControlStateNormal];
    [baoyouBUtton setTitleColor:[UIColor timeLabelColor] forState:UIControlStateNormal];
    baoyouBUtton.titleLabel.font = [UIFont systemFontOfSize:14.];
//    [baoyouBUtton setImage:[UIImage imageNamed:@"baoyouImage"] forState:UIControlStateNormal];
    baoyouBUtton.layer.masksToBounds = YES;
    baoyouBUtton.layer.borderWidth = 0.5f;
    baoyouBUtton.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;
    baoyouBUtton.layer.cornerRadius = 5.f;
//    baoyouBUtton.tag = 100;
    [self.contentView addSubview:baoyouBUtton];
    self.itemMask = baoyouBUtton;
    
    [nameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(@(SCREENWIDTH - 30));
    }];
    
    [saleNumAndstockLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameTitle);
        make.centerY.equalTo(baoyouBUtton.mas_centerY);
    }];
    
    [PriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameTitle);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY).offset(5);
    }];
    [curreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(PriceLabel.mas_centerY).offset(-2);
        make.left.equalTo(PriceLabel.mas_right);
    }];
    [oldPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(curreLabel.mas_right).offset(2);
        make.centerY.equalTo(PriceLabel.mas_centerY);
    }];

    
    [lookWirter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(baoyouBUtton.mas_centerY);
        make.width.mas_equalTo(@75);
        make.height.mas_equalTo(@30);
        make.right.equalTo(baoyouBUtton.mas_left).offset(-5);
    }];
    
    [baoyouBUtton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).offset(-5);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.width.mas_equalTo(@60);
        make.height.mas_equalTo(@30);
    }];
}

- (void)storeUpClick:(UIButton *)button {
    if (self.block) {
        self.block(button);
    }
    
}

- (CGFloat)promptInfoStrHeight:(NSString *)string {
    CGFloat contentW = [UIScreen mainScreen].bounds.size.width - 10;
    CGFloat contentH = [string boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.]} context:nil].size.height;
    return contentH + 20;
}



@end






















































