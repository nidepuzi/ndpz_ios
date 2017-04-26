//
//  CSMineMsgCell.m
//  NDPZ
//
//  Created by zhang on 17/4/22.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSMineMsgCell.h"

@interface CSMineMsgCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descTitleLabel;
@property (nonatomic, strong) UILabel *timeLabel;


@end

@implementation CSMineMsgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
- (void)createUI {
    self.iconImageView = [UIImageView new];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.titleLabel = [UILabel new];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = CS_UIFontSize(16.);
    
    self.timeLabel = [UILabel new];
    self.timeLabel.textColor = [UIColor dingfanxiangqingColor];
    self.timeLabel.font = CS_UIFontSize(12.);
    
    self.descTitleLabel = [UILabel new];
    self.descTitleLabel.textColor = [UIColor colorWithHex:0xff5000];
    self.descTitleLabel.font = CS_UIFontSize(14.);
    
    UILabel *lineView = [UILabel new];
    lineView.backgroundColor = [UIColor lineGrayColor];
    
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.descTitleLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:lineView];
    
    kWeakSelf
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.left.equalTo(weakSelf.contentView).offset(15);
        make.width.height.mas_equalTo(@(20));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(15);
        make.top.equalTo(weakSelf.contentView).offset(15);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).offset(-10);
        make.centerY.equalTo(weakSelf.titleLabel.mas_centerY);
    }];
    [self.descTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.contentView).offset(-15);
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(15);
        make.right.equalTo(weakSelf.contentView);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(15);
        make.right.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(@(1));
    }];
    
    
}

- (void)setCellDic:(NSDictionary *)cellDic {
    _cellDic = cellDic;
    self.iconImageView.image = CS_UIImageName(cellDic[@"iconImage"]);
    self.titleLabel.text = cellDic[@"title"];
    self.timeLabel.text = cellDic[@"createTime"];
    self.descTitleLabel.text = cellDic[@"descTitle"];
}

@end


































































