//
//  CSRefundsTimeLineCell.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/17.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSRefundsTimeLineCell.h"

NSString *const CSRefundsTimeLineCellIdentifier = @"CSRefundsTimeLineCellIdentifier";

@interface CSRefundsTimeLineCell ()

@property (nonatomic, strong) UIImageView *iconImageV;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *yuandianLabel;
@property (nonatomic, strong) UILabel *line1;
@property (nonatomic, strong) UILabel *line2;

@end

@implementation CSRefundsTimeLineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
- (void)createUI {
    UIImageView *iconImageV = [UIImageView new];
    [self.contentView addSubview:iconImageV];
    iconImageV.image = [UIImage imageNamed:@"cs_duihao_selected"];
    
    UILabel *timeLabel = [UILabel new];
    timeLabel.font = CS_UIFontSize(13.);
    timeLabel.textColor = [UIColor dingfanxiangqingColor];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = CS_UIFontSize(13.);
    titleLabel.textColor = [UIColor dingfanxiangqingColor];
    
    UILabel *yuandianLabel  = [UILabel new];
    yuandianLabel.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    yuandianLabel.layer.cornerRadius = 5;
    yuandianLabel.layer.masksToBounds = YES;
    
    UILabel *line1 = [UILabel new];
    line1.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    
    UILabel *line2 = [UILabel new];
    line2.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    
    [self.contentView addSubview:iconImageV];
    [self.contentView addSubview:timeLabel];
    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:yuandianLabel];
    [self.contentView addSubview:line1];
    [self.contentView addSubview:line2];
    
    self.iconImageV = iconImageV;
    self.timeLabel = timeLabel;
    self.titleLabel = titleLabel;
    self.yuandianLabel = yuandianLabel;
    self.line1 = line1;
    self.line2 = line2;
    
    UILabel *fengexianL = [UILabel new];
    fengexianL.backgroundColor = [UIColor lineGrayColor];
    [self.contentView addSubview:fengexianL];
    
    kWeakSelf
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(20);
        make.top.equalTo(weakSelf.contentView);
        make.width.mas_equalTo(@1);
        make.height.mas_equalTo(@25);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(20);
        make.bottom.equalTo(weakSelf.contentView);
        make.width.mas_equalTo(@1);
        make.height.mas_equalTo(@25);
    }];
    
    [iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(line1.mas_centerX);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.width.height.mas_equalTo(@20);
    }];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView.mas_centerY).offset(-10);
        make.left.equalTo(iconImageV.mas_right).offset(15);
        make.right.equalTo(weakSelf.contentView).offset(-5);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView.mas_centerY).offset(10);
        make.left.equalTo(iconImageV.mas_right).offset(15);
        make.right.equalTo(weakSelf.contentView).offset(-5);
    }];
    [yuandianLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(line1.mas_centerX);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.width.height.mas_equalTo(@10);
    }];
    [fengexianL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.bottom.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView).offset(-5);
        make.height.mas_equalTo(@1);
    }];
    
    
    
    
    
    
    
}

- (void)configWithDic:(NSDictionary *)dic Index:(NSInteger)index AllCount:(NSInteger)count {
    if (count == 1) {
        self.line1.hidden = YES;
        self.line2.hidden = YES;
        self.yuandianLabel.hidden = YES;
        
    }else {
        if (index == 0) {
            self.line1.hidden = YES;
            self.iconImageV.hidden = NO;
            self.yuandianLabel.hidden = YES;
            [self.line2 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(@20);
            }];
            
        }else if (index == count - 1) {
            self.line2.hidden = YES;
            self.iconImageV.hidden = YES;
            self.yuandianLabel.hidden = NO;
            
        }else {
            self.iconImageV.hidden = YES;
            self.line1.hidden = NO;
            self.yuandianLabel.hidden = NO;
            [self.line1 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(@25);
            }];
            [self.line2 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(@25);
            }];
        }
    }
    
    self.timeLabel.text = [NSString jm_deleteTimeWithT:dic[@"time"]];
    self.titleLabel.text = dic[@"status_display"];
    
    
    
}




@end











































































