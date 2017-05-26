//
//  CSPersonalInfoCell.m
//  iOS_NDPZ
//
//  Created by zhang on 17/4/27.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSPersonalInfoCell.h"

NSString *const CSPersonalInfoCellIdentifier = @"CSPersonalInfoCellIdentifier";

@interface CSPersonalInfoCell ()

@property (nonatomic, strong) UILabel *settingTitleLabel;
@property (nonatomic, strong) UILabel *settingDescTitleLabel;
@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, strong) UIImageView *iconImageView;



@end

@implementation CSPersonalInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.cellImageView = [UIImageView new];
        [self.contentView addSubview:self.cellImageView];
        
        self.settingTitleLabel = [UILabel new];
        self.settingTitleLabel.textColor = [UIColor buttonTitleColor];
        self.settingTitleLabel.font = CS_UIFontSize(14.);
        [self.contentView addSubview:self.settingTitleLabel];
        
        self.settingDescTitleLabel = [UILabel new];
        self.settingDescTitleLabel.textColor = [UIColor dingfanxiangqingColor];
        self.settingDescTitleLabel.font = CS_UIFontSize(13.);
        [self.contentView addSubview:self.settingDescTitleLabel];
        
        self.iconImageView = [UIImageView new];
        [self.contentView addSubview:self.iconImageView];
        self.iconImageView.hidden = YES;
        
//        UIView *lineView = [UIView new];
//        lineView.backgroundColor = [UIColor countLabelColor];
//        [self.contentView addSubview:lineView];
        
        kWeakSelf

        [self.settingTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).offset(15);
            make.centerY.equalTo(weakSelf.contentView);
        }];
        [self.settingDescTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.cellImageView.mas_left).offset(-10);
            make.centerY.equalTo(weakSelf.contentView);
        }];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.cellImageView.mas_left).offset(-10);
            make.centerY.equalTo(weakSelf.contentView);
            make.width.height.mas_equalTo(@(40));
        }];
        [self.cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.contentView).offset(-15);
            make.centerY.equalTo(weakSelf.contentView);
            make.width.mas_equalTo(@(8));
            make.height.mas_equalTo(@(15));
        }];
//        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(weakSelf.contentView).offset(15);
//            make.right.equalTo(weakSelf.contentView).offset(-15);
//            make.bottom.equalTo(weakSelf.contentView);
//            make.height.mas_equalTo(@1);
//        }];
        
        
        
        
        
    }
    return self;
}

- (void)configWithItem:(NSDictionary *)itemDic Section:(NSInteger)section Row:(NSInteger)row {
    self.iconImageView.layer.cornerRadius = 1.;
    if (section == 0) {
        if (row == 2) {
            self.iconImageView.layer.cornerRadius = 20.;
            self.iconImageView.layer.masksToBounds = YES;
            self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
            self.iconImageView.clipsToBounds = YES;
            self.iconImageView.hidden = NO;
        }else if (row == 3) {
            self.iconImageView.hidden = NO;
            
        }else {
            
        }
    }else {
    }
    self.settingTitleLabel.text = itemDic[@"title"];
    self.settingDescTitleLabel.text = itemDic[@"descTitle"];
    self.cellImageView.image = [UIImage imageNamed:itemDic[@"cellImage"]];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:itemDic[@"iconImage"]] placeholderImage:[UIImage imageNamed:@"icon_placeholder"]];
    
}

- (void)setItemDic:(NSDictionary *)itemDic {
    _itemDic = itemDic;
    self.settingTitleLabel.text = itemDic[@"title"];
    self.settingDescTitleLabel.text = itemDic[@"descTitle"];
    self.cellImageView.image = [UIImage imageNamed:itemDic[@"cellImage"]];
    self.iconImageView.image = [UIImage imageNamed:itemDic[@"iconImage"]];
    
}
- (void)configWithItemForBankWithdraw:(NSDictionary *)itemDic {
    self.iconImageView.hidden = NO;
    
    kWeakSelf
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.width.mas_equalTo(@30);
        make.height.mas_equalTo(@23);
    }];
    [self.settingTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
    [self.settingDescTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.settingTitleLabel.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
    self.settingTitleLabel.text = itemDic[@"title"];
    self.settingDescTitleLabel.text = itemDic[@"descTitle"];
    self.cellImageView.image = [UIImage imageNamed:itemDic[@"cellImage"]];
    self.iconImageView.image = [UIImage imageNamed:itemDic[@"iconImage"]];
    
}
- (void)configWithItemForBankChoise:(NSDictionary *)itemDic {
    self.cellImageView.hidden = YES;
    self.iconImageView.hidden = NO;
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconImageView.clipsToBounds = YES;
    
    kWeakSelf
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:itemDic[@"bank_img"]] placeholderImage:[UIImage imageNamed:@"icon_placeholderEmpty"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        CGFloat imageWidth = (image.size.width / image.size.height) * 30;
        
        [weakSelf.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).offset(10);
            make.centerY.equalTo(weakSelf.contentView.mas_centerY);
            make.width.mas_equalTo(imageWidth);
            make.height.mas_equalTo(@30);
        }];
        
        
        
    }];
    

    
    
}






@end












































































