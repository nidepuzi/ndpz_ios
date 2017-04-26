//
//  CSProfileShopFooterView.m
//  NDPZ
//
//  Created by zhang on 17/4/24.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSProfileShopFooterView.h"

@interface CSProfileShopFooterView ()

@property (nonatomic, strong) UILabel *ableBlanceValueLabel;

@end

@implementation CSProfileShopFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}
- (void)createUI {
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 15)];
    lineView1.backgroundColor = [UIColor lineGrayColor];
    [self addSubview:lineView1];
    
    UIView *sectionView1 = [[UIView alloc] initWithFrame:CGRectMake(0, lineView1.cs_max_Y, SCREENWIDTH, 50)];
    sectionView1.backgroundColor = [UIColor whiteColor];
    [self addSubview:sectionView1];
    
    UILabel *ableBlanceValueLabel = [UILabel new];
    ableBlanceValueLabel.textColor = [UIColor colorWithHex:0xff5000];
    ableBlanceValueLabel.font = CS_UIFontSize(14.);
    [sectionView1 addSubview:ableBlanceValueLabel];
    ableBlanceValueLabel.text = @"0.00";
    self.ableBlanceValueLabel = ableBlanceValueLabel;
    
    UILabel *ableBlanceLabel = [UILabel new];
    ableBlanceLabel.textColor = [UIColor dingfanxiangqingColor];
    ableBlanceLabel.font = CS_UIFontSize(12.);
    [sectionView1 addSubview:ableBlanceLabel];
    ableBlanceLabel.text = @"可用余额";
    
    UILabel *outBlanceLabel = [UILabel new];
    outBlanceLabel.textColor = [UIColor buttonTitleColor];
    outBlanceLabel.font = CS_UIFontSize(14.);
    [sectionView1 addSubview:outBlanceLabel];
    outBlanceLabel.text = @"提现";
    
    UIButton *outBlancePushInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sectionView1 addSubview:outBlancePushInButton];
    [outBlancePushInButton setImage:[UIImage imageNamed:@"cs_pushInImage"] forState:UIControlStateNormal];
    outBlancePushInButton.tag = 100;
    [outBlancePushInButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

    [ableBlanceValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectionView1).offset(15);
        make.centerY.equalTo(sectionView1.mas_centerY).offset(-10);
    }];
    [ableBlanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ableBlanceValueLabel.mas_centerX);
        make.centerY.equalTo(sectionView1.mas_centerY).offset(10);
    }];
    [outBlanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sectionView1.mas_centerY);
        make.right.equalTo(outBlancePushInButton.mas_left);
    }];
    [outBlancePushInButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sectionView1);
        make.centerY.equalTo(sectionView1.mas_centerY);
        make.width.mas_equalTo(@(30));
        make.height.mas_equalTo(@(50));
    }];
    
    
    
    NSArray *section1Title = @[@"代收收益",@"累计收益",@"优惠券",@"客户管理",@"业绩管理",@"销售管理",@"收货地址"];
    NSArray *section1Image = @[@"cs_profileShop_daishoushouyi",@"cs_profileShop_leijishouyi",@"cs_profileShop_coupon",@"cs_profileShop_kehuguanli",@"cs_profileShop_yeji",@"cs_profileShop_xiaoshou",@"cs_profileShop_address"];
    CGFloat spaceLine = SCREENWIDTH / 3;
    CGFloat itemHeight = 80.;
    for (int i = 0; i < section1Title.count; i++) {
        if (i % 3 == 0) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(5, sectionView1.cs_max_Y + (i / 3) * itemHeight, SCREENWIDTH - 10, 1)];
            lineView.backgroundColor = [UIColor lineGrayColor];
            [self addSubview:lineView];
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor whiteColor];
        [self addSubview:button];
        button.tag = 101 + i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(spaceLine * (i % 3), sectionView1.cs_max_Y + (i / 3) * itemHeight + 1, spaceLine, itemHeight);
        
        if ((i % 3 == 0) || (i % 3 == 1)) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(spaceLine - 1, 10, 1, itemHeight - 20)];
            lineView.backgroundColor = [UIColor lineGrayColor];
            [button addSubview:lineView];
        }

        
        
        UIImageView *iconImage = [UIImageView new];
        [button addSubview:iconImage];
        iconImage.image = [UIImage imageNamed:section1Image[i]];
        [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(button.mas_centerX);
            make.centerY.equalTo(button.mas_centerY).offset(-10);
            make.width.height.mas_equalTo(@20);
        }];
        UILabel *titleLabel = [UILabel new];
        [button addSubview:titleLabel];
        titleLabel.text = section1Title[i];
        titleLabel.font = [UIFont systemFontOfSize:12.];
        titleLabel.textColor = [UIColor buttonTitleColor];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(button).offset(-15);
            make.centerX.equalTo(iconImage.mas_centerX);
        }];
        
        
        
        
    }
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, sectionView1.cs_max_Y + itemHeight * (section1Title.count / 3 + 1), SCREENWIDTH, 15)];
    lineView2.backgroundColor = [UIColor lineGrayColor];
    [self addSubview:lineView2];
    
    UIView *sectionView2 = [[UIView alloc] initWithFrame:CGRectMake(0, lineView2.cs_max_Y, SCREENWIDTH, 50)];
    sectionView2.backgroundColor = [UIColor whiteColor];
    [self addSubview:sectionView2];
    
    UILabel *orderGuanliLabel = [UILabel new];
    orderGuanliLabel.textColor = [UIColor buttonTitleColor];
    orderGuanliLabel.font = CS_UIFontSize(14.);
    [sectionView2 addSubview:orderGuanliLabel];
    orderGuanliLabel.text = @"订单管理";
    
    UILabel *allOrderLabel = [UILabel new];
    allOrderLabel.textColor = [UIColor buttonTitleColor];
    allOrderLabel.font = CS_UIFontSize(14.);
    [sectionView2 addSubview:allOrderLabel];
    allOrderLabel.text = @"全部订单";
    
    UIButton *orderPushInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sectionView2 addSubview:orderPushInButton];
    orderPushInButton.tag = 108;
    [orderPushInButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [orderPushInButton setImage:[UIImage imageNamed:@"cs_pushInImage"] forState:UIControlStateNormal];
    
    [orderGuanliLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectionView2).offset(15);
        make.centerY.equalTo(sectionView2.mas_centerY);
    }];
    [allOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sectionView2.mas_centerY);
        make.right.equalTo(orderPushInButton.mas_left);
    }];
    [orderPushInButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sectionView2);
        make.centerY.equalTo(sectionView2.mas_centerY);
        make.width.mas_equalTo(@(30));
        make.height.mas_equalTo(@(50));
    }];
    NSArray *section2Title = @[@"待付款",@"待发货",@"已完成"];
    NSArray *section2Image = @[@"cs_profileShop_orderWaitPay",@"cs_profileShop_orderWaitFahuo",@"cs_profileShop_orderWancheng"];
    for (int i = 0; i < section2Title.count; i++) {
        if (i % 3 == 0) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(5, sectionView2.cs_max_Y + (i / 3) * itemHeight, SCREENWIDTH - 10, 1)];
            lineView.backgroundColor = [UIColor lineGrayColor];
            [self addSubview:lineView];
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor whiteColor];
        [self addSubview:button];
        button.tag = 109 + i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(spaceLine * (i % 3), sectionView2.cs_max_Y + (i / 3) * itemHeight + 1, spaceLine, itemHeight);
        
        if ((i % 3 == 0) || (i % 3 == 1)) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(spaceLine - 1, 10, 1, itemHeight - 20)];
            lineView.backgroundColor = [UIColor lineGrayColor];
            [button addSubview:lineView];
        }        
        
        UIImageView *iconImage = [UIImageView new];
        [button addSubview:iconImage];
        iconImage.image = [UIImage imageNamed:section2Image[i]];
        [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(button.mas_centerX);
            make.centerY.equalTo(button.mas_centerY).offset(-10);
            make.width.height.mas_equalTo(@20);
        }];
        UILabel *titleLabel = [UILabel new];
        [button addSubview:titleLabel];
        titleLabel.text = section2Title[i];
        titleLabel.font = [UIFont systemFontOfSize:12.];
        titleLabel.textColor = [UIColor buttonTitleColor];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(button).offset(-15);
            make.centerX.equalTo(iconImage.mas_centerX);
        }];
        
        
        
        
    }
    

}
- (void)setAccountMoney:(NSNumber *)accountMoney {
    _accountMoney = accountMoney;
    self.ableBlanceValueLabel.text = [NSString stringWithFormat:@"%.2f",[accountMoney floatValue]];
}
- (void)buttonClick:(UIButton *)button {
    NSLog(@"%ld",button.tag);
    button.enabled = NO;
    [self performSelector:@selector(buttonEnable:) withObject:button afterDelay:0.5];
    if (_delegate && [_delegate respondsToSelector:@selector(composeProfileShopFooter:ButtonActionClick:)]) {
        [_delegate composeProfileShopFooter:self ButtonActionClick:button];
    }
    
    
}
- (void)buttonEnable:(UIButton *)button {
    button.enabled = YES;
}





@end













































