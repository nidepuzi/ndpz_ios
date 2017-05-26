//
//  JMTimeListCell.m
//  XLMM
//
//  Created by 崔人帅 on 16/6/7.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "JMTimeListCell.h"
#import "JMTimeInfoModel.h"


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
    titleLabel.font = CS_UIFontSize(14.);
    titleLabel.textColor = [UIColor buttonTitleColor];
    self.titleLabel = titleLabel;
    titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    
    UILabel *timeLabel = [UILabel new];
    timeLabel.font = CS_UIFontSize(14.);
    timeLabel.textColor = [UIColor dingfanxiangqingColor];
    self.timeLabel = timeLabel;
    [self.contentView addSubview:self.timeLabel];
    
    self.iconImage = [UIImageView new];
//    self.iconImage.contentMode = UIViewContentModeScaleAspectFit;
//    self.iconImage.clipsToBounds = YES;
    self.iconImage.image = [UIImage imageNamed:@"cs_timeLine_history"];
    
    self.lineLabel1 = [UILabel new];
    self.lineLabel1.backgroundColor = [UIColor titleDarkGrayColor];
    
    self.lineLabel2 = [UILabel new];
    self.lineLabel2.backgroundColor = [UIColor titleDarkGrayColor];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor lineGrayColor];
    [self.contentView addSubview:lineView];
    
    [self.contentView addSubview:self.iconImage];
    [self.contentView addSubview:self.lineLabel1];
    [self.contentView addSubview:self.lineLabel2];
    
    kWeakSelf
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf.contentView).offset(20);
        make.width.height.mas_equalTo(@8);
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
        make.left.equalTo(weakSelf.iconImage.mas_right).offset(10);
        make.right.equalTo(weakSelf.contentView).offset(-10);
        make.top.equalTo(weakSelf.iconImage).offset(-5);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImage.mas_right).offset(10);
        make.right.equalTo(weakSelf.contentView).offset(-10);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(5);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel);
        make.right.equalTo(weakSelf.contentView);
        make.bottom.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(@1);
    }];
    
    
    
}

- (void)config:(JMTimeInfoModel *)model Index:(NSInteger)index Count:(NSInteger)count {
    self.titleLabel.text = model.content;
    self.timeLabel.text = model.time;
    if (index == 0) {
        self.iconImage.image = [UIImage imageNamed:@"cs_timeLine_current"];
        self.lineLabel1.hidden = YES;
        self.lineLabel2.hidden = NO;
        [self.iconImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(@14);
            make.left.equalTo(self.contentView).offset(17);
        }];
    }else if (index == count - 1) {
        self.iconImage.image = [UIImage imageNamed:@"cs_timeLine_history"];
        self.lineLabel2.hidden = YES;
        self.lineLabel1.hidden = NO;
        [self.iconImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(@8);
            make.left.equalTo(self.contentView).offset(20);
        }];
    }else {
        self.iconImage.image = [UIImage imageNamed:@"cs_timeLine_history"];
        self.lineLabel2.hidden = NO;
        self.lineLabel1.hidden = NO;
        [self.iconImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(@8);
            make.left.equalTo(self.contentView).offset(20);
        }];
    }

}






@end













































