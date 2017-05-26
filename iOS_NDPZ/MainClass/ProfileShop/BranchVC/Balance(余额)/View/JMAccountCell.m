//
//  JMAccountCell.m
//  XLMM
//
//  Created by zhang on 17/4/28.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "JMAccountCell.h"
#import "AccountModel.h"

NSString *const JMAccountCellIdentifier = @"JMAccountCellIdentifier";

@interface JMAccountCell ()

@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *sourceLabel;
@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) UILabel *bottomLabel;

@end

@implementation JMAccountCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    
    self.typeLabel = [UILabel new];
    [self.contentView addSubview:self.typeLabel];
    self.typeLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    self.typeLabel.font = [UIFont systemFontOfSize:13.];
    
    self.statusLabel = [UILabel new];
    [self.contentView addSubview:self.statusLabel];
    self.statusLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    self.statusLabel.font = [UIFont systemFontOfSize:13.];
    
    self.timeLabel = [UILabel new];
    [self.contentView addSubview:self.timeLabel];
    self.timeLabel.textColor = [UIColor dingfanxiangqingColor];
    self.timeLabel.font = [UIFont systemFontOfSize:14.];
    
    self.sourceLabel = [UILabel new];
    [self.contentView addSubview:self.sourceLabel];
    self.sourceLabel.textColor = [UIColor buttonTitleColor];
    self.sourceLabel.numberOfLines = 0;
    self.sourceLabel.font = [UIFont systemFontOfSize:14.];
    
    self.moneyLabel = [UILabel new];
    [self.contentView addSubview:self.moneyLabel];
    self.moneyLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    self.moneyLabel.font = [UIFont systemFontOfSize:16.];
    self.moneyLabel.textAlignment = NSTextAlignmentRight;
    
//    self.bottomLabel = [UILabel new];
//    [self.contentView addSubview:self.bottomLabel];
//    self.bottomLabel.backgroundColor = [UIColor countLabelColor];
    
    kWeakSelf
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(weakSelf.contentView).offset(10);
    }];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.typeLabel.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.typeLabel.mas_centerY);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.typeLabel);
        make.top.equalTo(weakSelf.typeLabel.mas_bottom).offset(10);
    }];
    
    [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.typeLabel);
        make.top.equalTo(weakSelf.timeLabel.mas_bottom).offset(10);
        make.right.equalTo(weakSelf.contentView).offset(-10);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.timeLabel.mas_centerY);
        make.right.equalTo(weakSelf.contentView).offset(-10);
//        make.width.mas_equalTo(@120);
    }];
//    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.bottom.equalTo(weakSelf.contentView);
//        make.width.mas_equalTo(@(SCREENWIDTH));
//        make.height.mas_equalTo(@1);
//    }];
    
    
    
}


- (void)fillDataOfCell:(AccountModel *)accountM {
    self.typeLabel.text = accountM.budget_log_type_display;
    self.statusLabel.text = accountM.get_status_display;
    self.timeLabel.text = accountM.budget_date;
    self.sourceLabel.text = accountM.desc;
    
    if ([accountM.budget_type boolValue]) {
        self.moneyLabel.text = [NSString stringWithFormat:@"- %.2f元", [accountM.budeget_detail_cash floatValue]];
        self.moneyLabel.textColor = [UIColor textDarkGrayColor];
    }else {
        self.moneyLabel.text = [NSString stringWithFormat:@"+ %.2f元", [accountM.budeget_detail_cash floatValue]];
        self.moneyLabel.textColor = [UIColor orangeThemeColor];
    }
    
    
}






@end































