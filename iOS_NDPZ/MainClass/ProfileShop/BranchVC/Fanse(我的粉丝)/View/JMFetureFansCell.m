//
//  JMFetureFansCell.m
//  XLMM
//
//  Created by zhang on 17/4/27.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "JMFetureFansCell.h"
#import "JMFetureFansModel.h"
#import "JMVisitorModel.h"
#import "CSFansModel.h"
#import "JMRichTextTool.h"


@interface JMFetureFansCell ()

@property (nonatomic, strong) UIImageView *iconImage;

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *phoneLabel;

@end

@implementation JMFetureFansCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
        [self layoutUI];
    }
    return self;
}

- (void)initUI {
    UIImageView *iconImage = [UIImageView new];
    [self.contentView addSubview:iconImage];
    self.iconImage = iconImage;
    self.iconImage.layer.cornerRadius = 30;
    self.iconImage.layer.borderWidth = 0.5;
    self.iconImage.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;
    self.iconImage.layer.masksToBounds = YES;
    
    UILabel *descLabel = [UILabel new];
    [self.contentView addSubview:descLabel];
    self.descLabel = descLabel;
    self.descLabel.font = [UIFont systemFontOfSize:12.];
    self.descLabel.textColor = [UIColor dingfanxiangqingColor];
    self.descLabel.numberOfLines = 0;
    
    UILabel *phoneLabel = [UILabel new];
    [self.contentView addSubview:phoneLabel];
    self.phoneLabel = phoneLabel;
    self.phoneLabel.font = [UIFont systemFontOfSize:12.];
    self.phoneLabel.textColor = [UIColor dingfanxiangqingColor];
    self.phoneLabel.numberOfLines = 0;
    
    UILabel *nameLabel = [UILabel new];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    self.nameLabel.font = [UIFont systemFontOfSize:14.];
    
    UILabel *timeLabel = [UILabel new];
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    self.timeLabel.font = [UIFont systemFontOfSize:13.];
    self.timeLabel.textColor = [UIColor timeLabelColor];
    
    
    kWeakSelf
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf.contentView).offset(10);
        make.width.height.mas_equalTo(@60);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImage.mas_right).offset(10);
        make.width.mas_equalTo(SCREENWIDTH - 160);
        make.top.equalTo(weakSelf.iconImage).offset(5);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImage.mas_right).offset(10);
        make.width.mas_equalTo(SCREENWIDTH - 160);
        make.top.equalTo(weakSelf.nameLabel.mas_bottom).offset(5);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabel);
        make.right.equalTo(weakSelf.contentView).offset(-20);
        make.top.equalTo(weakSelf.phoneLabel.mas_bottom).offset(5);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).offset(-10);
        make.centerY.equalTo(weakSelf.nameLabel.mas_centerY);
    }];
    
}
- (void)layoutUI {
    
    
    
}

- (void)fillData:(JMFetureFansModel *)model {
    kWeakSelf
    if (model.headimgurl.length == 0) {
        self.iconImage.image = [UIImage imageNamed:@"icon_placeholderEmpty"];
    }else {
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[model.headimgurl JMUrlEncodedString]]];
    }
    
    if ([model.nick isEqualToString:@""]) {
        self.nameLabel.text = @"匿名用户";
    }else {
        self.nameLabel.text = model.nick;
    }
    self.timeLabel.text = [NSString jm_cutOutYearWihtSec:model.modified];
    self.descLabel.text = model.note;
    
    if (model.mobile == nil) {
        [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.nameLabel);
            make.right.equalTo(weakSelf.contentView).offset(-20);
            make.top.equalTo(weakSelf.nameLabel.mas_bottom).offset(15);
        }];
    }else {
        self.phoneLabel.text = [NSString stringWithFormat:@"TEL:%@",model.mobile];
    }
    
}

- (void)fillVisitorData:(JMVisitorModel *)model {
    if (model.visitor_img.length == 0) {
        self.iconImage.image = [UIImage imageNamed:@"icon_placeholderEmpty"];
    }else {
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[model.visitor_img JMUrlEncodedString]]];
    }
    self.nameLabel.text = model.visitor_nick;
    self.descLabel.text = model.visitor_description;
    self.timeLabel.text = [NSString jm_cutOutYearWihtSec:model.created];
    
    
    
}
- (void)configNowFnas:(CSFansModel *)model {
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[model.thumbnail JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"icon_placeholderEmpty"]];
    self.nameLabel.text = model.nick;
//    self.timeLabel.text = [NSString jm_cutOutYearWihtSec:model.charge_time];
    NSString *timeString = [NSString yearDeal:model.charge_time];
    
    if ([model.referal_type isEqual:@"15"]) {
        self.descLabel.text = [NSString stringWithFormat:@"试用时间: %@",timeString];
    }else {
        self.descLabel.text = [NSString stringWithFormat:@"注册时间: %@",timeString];
    }
    
    
    
}




@end































