//
//  JMTimeListCell.m
//  XLMM
//
//  Created by 崔人帅 on 16/6/7.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "JMTimeListCell.h"

NSString *const JMTimeListCellIdentifier = @"JMTimeListCellIdentifier";

@interface JMTimeListCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *lineLabel1;
@property (nonatomic, strong) UILabel *lineLabel2;

@end

@implementation JMTimeListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initUI];
    }
    return self;
    
}
- (void)initUI {
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = CS_UIFontSize(16.);
    titleLabel.textColor = [UIColor buttonTitleColor];
    self.titleLabel = titleLabel;
    [self.contentView addSubview:self.titleLabel];
    
    UILabel *timeLabel = [UILabel new];
    timeLabel.font = CS_UIFontSize(16.);
    timeLabel.textColor = [UIColor buttonTitleColor];
    self.timeLabel = timeLabel;
    [self.contentView addSubview:self.timeLabel];
    
    self.iconImage = [UIImageView new];
    self.iconImage.image = [UIImage imageNamed:@"cs_timeLine_history"];
    
    self.lineLabel1 = [UILabel new];
    self.lineLabel1.backgroundColor = [UIColor titleDarkGrayColor];
    
    self.lineLabel2 = [UILabel new];
    self.lineLabel2.backgroundColor = [UIColor titleDarkGrayColor];
    
    [self.contentView addSubview:self.iconImage];
    [self.contentView addSubview:self.lineLabel1];
    [self.contentView addSubview:self.lineLabel2];
    
    kWeakSelf
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(40);
        make.top.equalTo(weakSelf.contentView).offset(20);
        make.width.height.mas_equalTo(@18);
    }];
    [self.lineLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.iconImage.mas_centerX);
        make.top.equalTo(weakSelf.contentView);
        make.bottom.equalTo(weakSelf.iconImage.mas_top);
        make.width.mas_equalTo(@1);
    }];
    [self.lineLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.iconImage.mas_centerX);
        make.top.equalTo(weakSelf.iconImage.mas_bottom);
        make.bottom.equalTo(weakSelf.contentView);
        make.width.mas_equalTo(@1);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImage.mas_right).offset(20);
        make.right.equalTo(weakSelf.contentView).offset(-10);
        make.centerY.equalTo(weakSelf.iconImage.mas_centerY);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.titleLabel);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(10);
    }];
    
    
    
}

- (void)config:(NSDictionary *)itemDic Index:(NSInteger)index {
    self.titleLabel.text = itemDic[@"title"];
    self.timeLabel.text = itemDic[@"time"];
    if (index == 0) {
        self.iconImage.image = [UIImage imageNamed:@"cs_timeLine_current"];
        self.lineLabel1.hidden = YES;
    }else {
        self.iconImage.image = [UIImage imageNamed:@"cs_timeLine_history"];
        self.lineLabel1.hidden = NO;
    }

}






@end













































