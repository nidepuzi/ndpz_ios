//
//  CSProfileShopHeaderView.m
//  NDPZ
//
//  Created by zhang on 17/4/24.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSProfileShopHeaderView.h"
#import "UIImage+UIImageExt.h"
#import "NSArray+Reverse.h"
#import "JMMaMaCenterModel.h"
#import "CSUserProfileModel.h"


@interface CSProfileShopHeaderView ()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *userShopDescLabel;
@property (nonatomic, strong) UIImageView *yaoqinghaoyouImageV;

@end

@implementation CSProfileShopHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
        
    }
    return self;
}
- (void)createUI {
    CAGradientLayer *layer = [CAGradientLayer new];
    //colors存放渐变的颜色的数组
    layer.colors=@[(__bridge id)[UIColor colorWithR:10 G:169 B:188 alpha:1].CGColor,(__bridge id)[UIColor colorWithR:130 G:215 B:215 alpha:1].CGColor];
    /**
     * 起点和终点表示的坐标系位置，(0,0)表示左上角，(1,1)表示右下角
     */
    layer.startPoint = CGPointMake(0.5, 0);
    layer.endPoint = CGPointMake(0.5, 1.0);
    layer.frame = self.bounds;
    [self.layer addSublayer:layer];
    
    UIButton *headerIconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:headerIconButton];
    headerIconButton.tag = 100;
    [headerIconButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.iconImage = [UIImageView new];
    self.iconImage.backgroundColor = [UIColor whiteColor];
    self.iconImage.layer.cornerRadius = 30;
    self.iconImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.layer.borderWidth = 1;
    [headerIconButton addSubview:self.iconImage];
    
    UIImageView *xiugaiImageView = [UIImageView new];
    [self addSubview:xiugaiImageView];
    xiugaiImageView.image = [UIImage imageNamed:@"cs_profileShop_xiugai"];
    
    UIImageView *yaoqinghaoyouImageV = [UIImageView new];
    [self addSubview:yaoqinghaoyouImageV];
    yaoqinghaoyouImageV.image = [UIImage imageNamed:@"cs_yaoqinghaoyou"];
    yaoqinghaoyouImageV.contentMode = UIViewContentModeScaleAspectFill;
    yaoqinghaoyouImageV.clipsToBounds = YES;
    yaoqinghaoyouImageV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(yaoqinghaoyouImageVTap)];
    [yaoqinghaoyouImageV addGestureRecognizer:tap];
    
    self.userNameLabel = [UILabel new];
    self.userNameLabel.font = CS_UIFontSize(14.);
    self.userNameLabel.textColor = [UIColor whiteColor];
    self.userNameLabel.text = @"掌柜: 你的铺子";
    [self addSubview:self.userNameLabel];
    
    self.userShopDescLabel = [UILabel new];
    self.userShopDescLabel.font = CS_UIFontSize(11.);
    self.userShopDescLabel.textColor = [UIColor whiteColor];
    self.userShopDescLabel.text = @"店铺名 :我的铺子 / 店铺序号 : 1234567";
    [self addSubview:self.userShopDescLabel];
    
    kWeakSelf
    [headerIconButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(70);
        make.width.height.mas_equalTo(@(60));
        make.centerX.equalTo(weakSelf.mas_centerX);
    }];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@(60));
        make.center.equalTo(headerIconButton);
    }];
    [xiugaiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImage.mas_right).offset(-8);
        make.bottom.equalTo(weakSelf.iconImage.mas_bottom).offset(-6);
        make.width.mas_equalTo(@(12));
        make.height.mas_equalTo(@(13));
    }];
    [yaoqinghaoyouImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf.iconImage.mas_centerY);
        make.width.mas_equalTo(@110);
        make.height.mas_equalTo(@30);
    }];
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerIconButton.mas_centerX);
        make.top.equalTo(headerIconButton.mas_bottom).offset(5);
    }];
    [self.userShopDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerIconButton.mas_centerX);
        make.top.equalTo(weakSelf.userNameLabel.mas_bottom).offset(5);
    }];
    self.iconImage.image = [UIImage imageWithColor:[UIColor lineGrayColor] Frame:CGRectMake(0, 0, 60, 60)];
    
    
    NSArray *title1 = @[@"0",@"0.00",@"0",@"0"];
    NSArray *title2 = @[@"今日订单",@"今日收益",@"今日访客",@"今日掌柜"];
    CGFloat itemSizeWidth = SCREENWIDTH / 4;
    for (int i = 0; i < title1.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:button];
        button.tag = 101 + i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).offset(itemSizeWidth * (i % 4));
            make.bottom.equalTo(weakSelf);
            make.width.mas_equalTo(@(itemSizeWidth));
            make.height.mas_equalTo(@(50));
        }];
        
        UILabel *titleLabel = [UILabel new];
        [button addSubview:titleLabel];
        titleLabel.text = title1[i];
        titleLabel.tag = 10 + i;
        titleLabel.font = [UIFont systemFontOfSize:14.];
        titleLabel.textColor = [UIColor whiteColor];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(button.mas_centerX);
            make.centerY.equalTo(button.mas_centerY).offset(-10);
        }];
        UILabel *oederNumLabel = [UILabel new];
        [button addSubview:oederNumLabel];
        oederNumLabel.text = title2[i];
        oederNumLabel.textColor = [UIColor whiteColor];
        oederNumLabel.textAlignment = NSTextAlignmentCenter;
        oederNumLabel.font = CS_UIFontBoldSize(12.);
        [oederNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(button.mas_centerX);
            make.centerY.equalTo(button.mas_centerY).offset(10);
        }];
    }
}
- (void)setMamaCenterModel:(JMMaMaCenterModel *)mamaCenterModel {
    _mamaCenterModel = mamaCenterModel;
    
}
- (void)setMamaResults:(NSArray *)mamaResults {
    _mamaResults = mamaResults;
    NSArray *data = [NSArray reverse:mamaResults];
    NSDictionary *dic = data[0];
    UILabel *jinridingdanLabel = (UILabel *)[self viewWithTag:10];
    UILabel *leijixiaoliangLabel = (UILabel *)[self viewWithTag:11];
    UILabel *fangwenLabel = (UILabel *)[self viewWithTag:12];
    UILabel *fensiLabel = (UILabel *)[self viewWithTag:13];
    
    fangwenLabel.text = [dic[@"visitor_num"] stringValue];                                      // 访客
    jinridingdanLabel.text = [dic[@"order_num"] stringValue];                                   // 订单
    leijixiaoliangLabel.text = [NSString stringWithFormat:@"%.2f",[dic[@"carry"] floatValue]];  // 今日收益
    fensiLabel.text = [NSString stringWithFormat:@"%@",dic[@"today_referal_num"]];              // 今日粉丝
    
    
    
    
}
- (void)setUserModel:(CSUserProfileModel *)userModel {
    _userModel = userModel;
    self.userNameLabel.text = userModel.nick;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:userModel.thumbnail] placeholderImage:[UIImage imageNamed:@"icon_placeholder"]];
     self.userShopDescLabel.text = [NSString stringWithFormat:@"店铺序号 : %@",userModel.xiaolumm.UserVipID];
    
    
}

- (void)yaoqinghaoyouImageVTap {
    if (_delegate && [_delegate respondsToSelector:@selector(composeProfileShopHeaderTap:)]) {
        [_delegate composeProfileShopHeaderTap:self];
    }
}
- (void)buttonClick:(UIButton *)button {
    NSLog(@"%ld",button.tag);
    button.enabled = NO;
    [self performSelector:@selector(buttonEnable:) withObject:button afterDelay:0.5];
    if (_delegate && [_delegate respondsToSelector:@selector(composeProfileShopHeader:ButtonActionClick:)]) {
        [_delegate composeProfileShopHeader:self ButtonActionClick:button];
    }
    
    
}
- (void)buttonEnable:(UIButton *)button {
    button.enabled = YES;
}



@end






































