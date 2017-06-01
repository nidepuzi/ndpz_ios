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
@property (nonatomic, strong) UIView *sectionView2;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation CSProfileShopFooterView

- (instancetype)initWithFrame:(CGRect)frame Type:(profileStatus)type {
    if (self = [super initWithFrame:frame]) {
        self.statusType = type;
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
    
    UIButton *yueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sectionView1 addSubview:yueButton];
    yueButton.tag = 99;
    [yueButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *ableBlanceValueLabel = [UILabel new];
    ableBlanceValueLabel.textColor = [UIColor colorWithHex:0xff5000];
    ableBlanceValueLabel.font = CS_UIFontSize(14.);
    [yueButton addSubview:ableBlanceValueLabel];
    ableBlanceValueLabel.text = @"0.00";
    self.ableBlanceValueLabel = ableBlanceValueLabel;
    
    UILabel *ableBlanceLabel = [UILabel new];
    ableBlanceLabel.textColor = [UIColor dingfanxiangqingColor];
    ableBlanceLabel.font = CS_UIFontSize(12.);
    [yueButton addSubview:ableBlanceLabel];
    ableBlanceLabel.text = @"可用余额";
    
    UIButton *outBlancePushInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sectionView1 addSubview:outBlancePushInButton];
    //    [outBlancePushInButton setImage:[UIImage imageNamed:@"cs_pushInImage"] forState:UIControlStateNormal];
    outBlancePushInButton.tag = 100;
    [outBlancePushInButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *outBlanceLabel = [UILabel new];
    outBlanceLabel.textColor = [UIColor buttonTitleColor];
    outBlanceLabel.font = CS_UIFontSize(14.);
    [outBlancePushInButton addSubview:outBlanceLabel];
    outBlanceLabel.text = @"提现";
    
    UIImageView *csPushImage1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cs_pushInImage"]];
    [outBlancePushInButton addSubview:csPushImage1];
    
    
    
    [yueButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectionView1).offset(10);
        make.top.bottom.equalTo(sectionView1);
        make.width.mas_equalTo(@80);
    }];
    [ableBlanceValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yueButton).offset(5);
//        make.centerY.equalTo(sectionView1.mas_centerY).offset(-10);
//        make.centerX.equalTo(yueButton.mas_centerX);
        make.centerY.equalTo(yueButton.mas_centerY).offset(-10);
    }];
    [ableBlanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(ableBlanceValueLabel.mas_centerX);
//        make.centerY.equalTo(sectionView1.mas_centerY).offset(10);
        make.centerX.equalTo(ableBlanceValueLabel.mas_centerX);
        make.centerY.equalTo(yueButton.mas_centerY).offset(10);
    }];
    [outBlancePushInButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sectionView1);
        make.centerY.equalTo(sectionView1.mas_centerY);
        make.width.mas_equalTo(@(100));
        make.height.mas_equalTo(@(50));
    }];
    [outBlanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(outBlancePushInButton.mas_centerY);
        make.right.equalTo(csPushImage1.mas_left).offset(-10);
    }];
    [csPushImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(outBlancePushInButton).offset(-15);
        make.centerY.equalTo(outBlancePushInButton.mas_centerY);
        make.width.mas_equalTo(@8);
        make.height.mas_equalTo(@15);
    }];
    
    
    
    NSArray *section1Title = @[@"收益管理",@"业绩管理",@"优惠券",@"收货地址"];
    NSArray *section1Image = @[@"cs_profileShop_leijishouyi",@"cs_profileShop_yeji",@"cs_profileShop_coupon",@"cs_profileShop_address"];
    CGFloat spaceLine = SCREENWIDTH / 4;
    CGFloat itemHeight = 80.;
    for (int i = 0; i < section1Title.count; i++) {
        if (i % 4 == 0) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(5, sectionView1.cs_max_Y + (i / 4) * itemHeight, SCREENWIDTH - 10, 1)];
            lineView.backgroundColor = [UIColor lineGrayColor];
            [self addSubview:lineView];
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor whiteColor];
        [self addSubview:button];
        button.tag = 101 + i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(spaceLine * (i % 4), sectionView1.cs_max_Y + (i / 5) * itemHeight + 1, spaceLine, itemHeight);
        
        if ((i % 4 == 0) || (i % 4 == 1) || (i % 4 == 2)) {
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
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, sectionView1.cs_max_Y + itemHeight * (section1Title.count / 5 + 1), SCREENWIDTH, 15)];
    lineView2.backgroundColor = [UIColor lineGrayColor];
    [self addSubview:lineView2];
    
    UIView *sectionView2 = [[UIView alloc] initWithFrame:CGRectMake(0, lineView2.cs_max_Y, SCREENWIDTH, 50)];
    sectionView2.backgroundColor = [UIColor whiteColor];
    [self addSubview:sectionView2];
    self.sectionView2 = sectionView2;
    
    UILabel *orderGuanliLabel = [UILabel new];
    orderGuanliLabel.textColor = [UIColor buttonTitleColor];
    orderGuanliLabel.font = CS_UIFontSize(14.);
    [sectionView2 addSubview:orderGuanliLabel];
    orderGuanliLabel.text = @"订单管理";
    
    UIButton *orderPushInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sectionView2 addSubview:orderPushInButton];
    orderPushInButton.tag = 105;
    [orderPushInButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [orderPushInButton setImage:[UIImage imageNamed:@"cs_pushInImage"] forState:UIControlStateNormal];
    
    UILabel *allOrderLabel = [UILabel new];
    allOrderLabel.textColor = [UIColor buttonTitleColor];
    allOrderLabel.font = CS_UIFontSize(14.);
    [orderPushInButton addSubview:allOrderLabel];
    allOrderLabel.text = @"全部订单";
    
    UIImageView *csPushImage2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cs_pushInImage"]];
    [orderPushInButton addSubview:csPushImage2];
    
    
    [orderGuanliLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectionView2).offset(15);
        make.centerY.equalTo(sectionView2.mas_centerY);
    }];
    [orderPushInButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sectionView2);
        make.centerY.equalTo(sectionView2.mas_centerY);
        make.width.mas_equalTo(@(100));
        make.height.mas_equalTo(@(50));
    }];
    [allOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(orderPushInButton.mas_centerY);
        make.right.equalTo(csPushImage2.mas_left).offset(-10);
    }];
    [csPushImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(orderPushInButton).offset(-15);
        make.centerY.equalTo(orderPushInButton.mas_centerY);
        make.width.mas_equalTo(@8);
        make.height.mas_equalTo(@15);
    }];

    UIView *bottomView = [UIView new];
    [self addSubview:bottomView];
    bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView = bottomView;
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(sectionView2.mas_bottom);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(80);
    }];
    
    
    NSArray *section2Title = nil;
    NSArray *section2Image = nil;
    if (self.statusType == profileStatusShiyong) {
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(160);
        }];
        section2Title = @[@"待付款",@"待发货",@"退款退货",@"加入正式掌柜"];
        section2Image = @[@"cs_profileShop_orderWaitPay",@"cs_profileShop_orderWaitFahuo",@"cs_profileShop_orderWancheng",@"cs_profileShop_joinVip"];
        [self sectionViewBottom:sectionView2 TitleArr:section2Title ImageArr:section2Image ItemHeight:itemHeight];
    }else {
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(80);
        }];
        section2Title = @[@"待付款",@"待发货",@"退款退货"];
        section2Image = @[@"cs_profileShop_orderWaitPay",@"cs_profileShop_orderWaitFahuo",@"cs_profileShop_orderWancheng"];
        [self sectionViewBottom:sectionView2 TitleArr:section2Title ImageArr:section2Image ItemHeight:itemHeight];
    }
    
}
- (void)setStatusType:(profileStatus)statusType {
    _statusType = statusType;
    if (self.bottomView) {
        [self.bottomView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }else {
        return;
    }
    if (statusType == profileStatusShiyong) {
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(160);
        }];
        NSArray *section2Title = @[@"待付款",@"待发货",@"退款退货",@"加入正式掌柜"];
        NSArray *section2Image = @[@"cs_profileShop_orderWaitPay",@"cs_profileShop_orderWaitFahuo",@"cs_profileShop_orderWancheng",@"cs_profileShop_joinVip"];
        [self sectionViewBottom:self.sectionView2 TitleArr:section2Title ImageArr:section2Image ItemHeight:80];
    }else {
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(80);
        }];
        NSArray *section2Title = @[@"待付款",@"待发货",@"退款退货"];
        NSArray *section2Image = @[@"cs_profileShop_orderWaitPay",@"cs_profileShop_orderWaitFahuo",@"cs_profileShop_orderWancheng"];
        [self sectionViewBottom:self.sectionView2 TitleArr:section2Title ImageArr:section2Image ItemHeight:80];
    }
    
}


- (void)sectionViewBottom:(UIView *)view TitleArr:(NSArray *)titleArr ImageArr:(NSArray *)imageArr ItemHeight:(CGFloat)itemHeight {
    CGFloat spaceLine2 = SCREENWIDTH / 3;
    for (int i = 0; i < titleArr.count; i++) {
        if (i % 3 == 0) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(5,  (i / 3) * itemHeight, SCREENWIDTH - 10, 1)];
            lineView.backgroundColor = [UIColor lineGrayColor];
            [self.bottomView addSubview:lineView];
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor whiteColor];
        [self.bottomView addSubview:button];
        button.tag = 106 + i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(spaceLine2 * (i % 3), (i / 3) * itemHeight + 1, spaceLine2, itemHeight);
        
        if ((i % 3 == 0) || (i % 3 == 1)) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(spaceLine2 - 1, 10, 1, itemHeight - 20)];
            lineView.backgroundColor = [UIColor lineGrayColor];
            [button addSubview:lineView];
        }
        
        UIImageView *iconImage = [UIImageView new];
        [button addSubview:iconImage];
        iconImage.image = [UIImage imageNamed:imageArr[i]];
        [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(button.mas_centerX);
            make.centerY.equalTo(button.mas_centerY).offset(-10);
            make.width.height.mas_equalTo(@20);
        }];
        UILabel *titleLabel = [UILabel new];
        [button addSubview:titleLabel];
        titleLabel.text = titleArr[i];
        titleLabel.font = [UIFont systemFontOfSize:12.];
        titleLabel.textColor = [UIColor buttonTitleColor];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(button).offset(-15);
            make.centerX.equalTo(iconImage.mas_centerX);
        }];
        
    }
    UIView *lineV = [UIView new];
    [self.bottomView addSubview:lineV];
    lineV.backgroundColor = [UIColor lineGrayColor];
    kWeakSelf
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.bottomView);
        //            make.top.equalTo(sectionView2.mas_bottom).offset(80);
        make.bottom.equalTo(weakSelf.bottomView).offset(-1);
        make.height.mas_equalTo(@1);
    }];
    
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













































