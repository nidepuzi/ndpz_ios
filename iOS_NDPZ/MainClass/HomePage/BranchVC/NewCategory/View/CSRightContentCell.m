//
//  CSRightContentCell.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/18.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSRightContentCell.h"
#import "JMFineCouponModel.h"

@interface CSRightContentCell ()

@property (nonatomic, strong) UIImageView *iconImage;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *PriceLabel;

@property (nonatomic, strong) UILabel *curreLabel;

@property (nonatomic, strong) UILabel *oldPriceLabel;

@property (nonatomic, strong) UILabel *deletLine;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UILabel *backLabel;

@property (nonatomic, strong) UILabel *zaishouL;
@property (nonatomic, strong) UILabel *kucunL;

@end

@implementation CSRightContentCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    UIImageView *iconImage = [UIImageView new];
    [self.contentView addSubview:iconImage];
    self.iconImage = iconImage;
    //    self.iconImage.userInteractionEnabled = YES;
    
    UIView *shoumaiView = [UIView new];
    [self.iconImage addSubview:shoumaiView];
    shoumaiView.backgroundColor = [UIColor blackColor];
    shoumaiView.alpha = 0.5;
    
    
    self.zaishouL = [UILabel new];
    self.zaishouL.font = [UIFont systemFontOfSize:10];
    self.zaishouL.textColor = [UIColor whiteColor];
    [shoumaiView addSubview:self.zaishouL];
    
    self.kucunL = [UILabel new];
    self.kucunL.font = [UIFont systemFontOfSize:10];
    self.kucunL.textColor = [UIColor whiteColor];
    [shoumaiView addSubview:self.kucunL];
    
    if (SCREENWIDTH > 320) {
        self.zaishouL.font = [UIFont systemFontOfSize:11];
        self.kucunL.font = [UIFont systemFontOfSize:11];
    }else if (SCREENWIDTH > 375) {
        self.zaishouL.font = [UIFont systemFontOfSize:12];
        self.kucunL.font = [UIFont systemFontOfSize:12];
    }
    
    UILabel *titleLabel = [UILabel new];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    self.titleLabel.font = [UIFont systemFontOfSize:12.];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *PriceLabel = [UILabel new];
    [self.contentView addSubview:PriceLabel];
    self.PriceLabel = PriceLabel;
    self.PriceLabel.font = [UIFont boldSystemFontOfSize:13.];
    self.PriceLabel.textColor = [UIColor buttonTitleColor];
    
    UILabel *curreLabel = [UILabel new];
    [self.contentView addSubview:curreLabel];
    self.curreLabel = curreLabel;
    self.curreLabel.text = @"/";
    self.curreLabel.textColor = [UIColor dingfanxiangqingColor];
    
    UILabel *oldPriceLabel = [UILabel new];
    [self.contentView addSubview:oldPriceLabel];
    self.oldPriceLabel = oldPriceLabel;
    self.oldPriceLabel.font = [UIFont systemFontOfSize:14];
    self.oldPriceLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    
//    UILabel *deletLine = [UILabel new];
//    [self.oldPriceLabel addSubview:deletLine];
//    self.deletLine = deletLine;
//    self.deletLine.backgroundColor = [UIColor titleDarkGrayColor];
    
    UIView *backView = [UIView new];
    [self.iconImage addSubview:backView];
    self.backView = backView;
    self.backView.backgroundColor = [UIColor blackColor];
    self.backView.alpha = 0.7;
    self.backView.layer.cornerRadius = 30.;
    
    UILabel *backLabel = [UILabel new];
    [self.backView addSubview:backLabel];
    self.backLabel = backLabel;
    self.backLabel.textColor = [UIColor whiteColor];
    self.backLabel.font = [UIFont systemFontOfSize:13.];

    kWeakSelf
    CGFloat imageW = (SCREENWIDTH * 0.75 - 15) / 2;
    //    CGFloat imageH = (SCREENWIDTH-15) * 2 / 3;
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf.contentView);
        make.width.mas_equalTo(imageW);
        make.height.mas_equalTo(imageW);
    }];
    
    [shoumaiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.iconImage.mas_centerX);
        make.width.mas_equalTo(imageW);
        make.height.mas_equalTo(20);
        make.bottom.equalTo(weakSelf.iconImage);
    }];
    [self.zaishouL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(shoumaiView.mas_centerY);
        make.left.equalTo(shoumaiView);
    }];
    [self.kucunL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(shoumaiView.mas_centerY);
        make.right.equalTo(shoumaiView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImage.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
        make.width.mas_equalTo(imageW);
    }];
    
    [self.curreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(5);
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
        make.height.mas_equalTo(@13);
    }];
    
    [self.PriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.curreLabel.mas_left).offset(-2);
        make.centerY.equalTo(weakSelf.curreLabel.mas_centerY);
    }];
    
    [self.oldPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.curreLabel.mas_right).offset(2);
        make.centerY.equalTo(weakSelf.curreLabel.mas_centerY);
    }];
    
//    [self.deletLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(weakSelf.oldPriceLabel.mas_centerY);
//        make.left.equalTo(weakSelf.oldPriceLabel).offset(-2);
//        make.right.equalTo(weakSelf.oldPriceLabel).offset(3);
//        make.height.mas_equalTo(@1.5);
//    }];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.iconImage.mas_centerX);
        make.centerY.equalTo(weakSelf.iconImage.mas_centerY);
        make.width.height.mas_equalTo(@60);
    }];
    
    [self.backLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.backView.mas_centerX);
        make.centerY.equalTo(weakSelf.backView.mas_centerY);
    }];


}
- (void)setModel:(JMFineCouponModel *)model {
    _model = model;
    
    NSString *picString = model.head_img;
    
    if ([NSString isStringEmpty:model.watermark_op]) {
        picString = [picString imageGoodsListCompression];
    } else{
        picString = [NSString stringWithFormat:@"%@|%@",[picString imageGoodsListCompression],model.watermark_op];
    }
    NSMutableString *newImageUrl = [NSMutableString stringWithString:picString];
    if ([picString hasPrefix:@"http:"] || [picString hasPrefix:@"https:"]) {
    }else {
        [newImageUrl insertString:@"http:" atIndex:0];
    }
    //    NSLog(@"name = %@ %@ %@ %@", model.name, model.isSaleopen, model.isSaleout , model.productModel);
    self.iconImage.alpha = 0.3;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[newImageUrl JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"placeHolderImage.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [UIView animateWithDuration:0.3f animations:^{
            self.iconImage.alpha = 1.0;
        }];
    }];
    
    self.titleLabel.text = model.name;
    
    if ([model.lowest_agent_price integerValue]!=[model.lowest_agent_price floatValue]) {
        self.PriceLabel.text = [NSString stringWithFormat:@"¥%.1f", [model.lowest_agent_price floatValue]];
    } else {
        self.PriceLabel.text = [NSString stringWithFormat:@"¥%.1f", [model.lowest_agent_price floatValue]];
    }
    
    NSDictionary *profitDic = model.profit;
    self.oldPriceLabel.text = [NSString stringWithFormat:@"赚:¥%.1f",[profitDic[@"min"] floatValue]];
    
    NSInteger kucunNum = [model.stock integerValue];
    if (kucunNum < 0) {
        kucunNum = 0;
    }
    NSInteger zaishouNum = [model.selling_num integerValue];
    self.zaishouL.text = [NSString stringWithFormat:@"在售人数%ld",zaishouNum];
    self.kucunL.text = [NSString stringWithFormat:@"库存%ld",kucunNum];
    
    

    
    if ([model.sale_state isEqual:@"on"]) {
        if ([model.is_saleout boolValue]) {
            self.backView.hidden = NO;
            self.backLabel.text = @"已抢光";
        }else {
            self.backView.hidden = YES;
        }
    }else if ([model.sale_state isEqual:@"off"]) {
        self.backView.hidden = NO;
        self.backLabel.text = @"已下架";
    }else if ([model.sale_state isEqual:@"will"]) {
        self.backView.hidden = NO;
        self.backLabel.text = @"即将开售";
    }else {
    }
    
    
}


@end






















































