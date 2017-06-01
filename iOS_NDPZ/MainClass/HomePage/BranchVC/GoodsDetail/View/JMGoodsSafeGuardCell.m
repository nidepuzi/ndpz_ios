//
//  JMGoodsSafeGuardCell.m
//  XLMM
//
//  Created by zhang on 17/4/11.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "JMGoodsSafeGuardCell.h"


NSString *const JMGoodsSafeGuardCellIdentifier = @"JMGoodsSafeGuardCellIdentifier";


@implementation JMGoodsSafeGuardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor lineGrayColor];
        [self initUI];
    }
    return self;
}

- (void)initUI {

    UIView *guaranteeView = [UIView new];
    [self.contentView addSubview:guaranteeView];
    guaranteeView.backgroundColor = [UIColor whiteColor];
    kWeakSelf
    
    [guaranteeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.contentView).offset(10);
        make.width.mas_equalTo(@(SCREENWIDTH));
        make.height.mas_equalTo(@90);
//        make.bottom.equalTo(weakSelf.contentView).offset(-10);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:button];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(guaranteeView.mas_bottom).offset(1);
        make.width.mas_equalTo(@(SCREENWIDTH));
        make.height.mas_offset(@45);
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
    }];
    
    
    UIImageView *iconImage = [UIImageView new];
    [button addSubview:iconImage];
    iconImage.image = [UIImage imageNamed:@"cs_qitianwuliyou"];
    
    UILabel *titleLabel = [UILabel new];
    [button addSubview:titleLabel];
    titleLabel.textColor = [UIColor buttonTitleColor];
    titleLabel.font = CS_UIFontBoldSize(13.);
    titleLabel.text = @"七天退换货规则";
    
    UIImageView *rightImage = [UIImageView new];
    [button addSubview:rightImage];
    rightImage.image = [UIImage imageNamed:@"cs_pushInImage"];
    
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(button).offset(10);
        make.centerY.equalTo(button.mas_centerY);
        make.width.mas_equalTo(14);
        make.height.mas_equalTo(19);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImage.mas_right).offset(5);
        make.centerY.equalTo(button.mas_centerY);
    }];
    [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(button).offset(-10);
        make.centerY.equalTo(button.mas_centerY);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(15);
    }];
    
    
    
    CGFloat accountH = 90;
    NSArray *accountArr = @[@"天天上新",@"100%正品",@"全国包邮"];
    NSArray *imageArr = @[@"tiantian.png",@"zhengpin.png",@"quabguobaoyou.png"];
    for (int i = 0; i < accountArr.count; i++) {
        UIView *accountV = [UIView new];
        [guaranteeView addSubview:accountV];
        [accountV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@(SCREENWIDTH));
//            make.left.right.equalTo(guaranteeView);
            make.height.mas_equalTo(@(accountH));
            make.centerY.equalTo(guaranteeView.mas_centerY);
            make.centerX.equalTo(guaranteeView.mas_right).multipliedBy(((CGFloat)i + 0.5) / ((CGFloat)accountArr.count + 0));
        }];
        UIImageView *accountLabel = [UIImageView new];
        [accountV addSubview:accountLabel];
        accountLabel.image = [UIImage imageNamed:imageArr[i]];
        [accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(accountV.mas_centerY).offset(-10);
            make.width.height.mas_equalTo(@32);
            make.centerX.equalTo(accountV.mas_centerX);
        }];
        UILabel *accountValueLabel = [UILabel new];
        [accountV addSubview:accountValueLabel];
        accountValueLabel.font = [UIFont boldSystemFontOfSize:14.];
        accountValueLabel.textColor = [UIColor buttonTitleColor];
        accountValueLabel.text = [NSString stringWithFormat:@"%@",accountArr[i]];
        [accountValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(accountLabel.mas_bottom).offset(10);
            make.centerX.equalTo(accountV.mas_centerX);
        }];
        
    }
    
    
    
}
- (void)buttonClick:(UIButton *)button {
    if (self.block) {
        self.block(button);
    }
}


@end


























