//
//  CSProfilerSettingCell.m
//  NDPZ
//
//  Created by zhang on 17/4/24.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSProfilerSettingCell.h"

@interface CSProfilerSettingCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *settingTitleLabel;
@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, strong) UISwitch *switchSetting;

@end

@implementation CSProfilerSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.iconImageView = [UIImageView new];
        [self.contentView addSubview:self.iconImageView];
        
        self.settingTitleLabel = [UILabel new];
        self.settingTitleLabel.textColor = [UIColor buttonTitleColor];
        self.settingTitleLabel.font = CS_UIFontSize(14.);
        [self.contentView addSubview:self.settingTitleLabel];
        
        self.settingDescTitleLabel = [UILabel new];
        self.settingDescTitleLabel.textColor = [UIColor dingfanxiangqingColor];
        self.settingDescTitleLabel.font = CS_UIFontSize(13.);
        [self.contentView addSubview:self.settingDescTitleLabel];
        
        if ([reuseIdentifier isEqualToString:@"cell0"]) {
            self.cellImageView = [UIImageView new];
            [self.contentView addSubview:self.cellImageView];
        }else {
            self.switchSetting = [UISwitch new];
            self.switchSetting.on = NO;
            [self.contentView addSubview:self.switchSetting];
            [self.switchSetting addTarget:self action:@selector(swChange:) forControlEvents:UIControlEventValueChanged];
        }
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor countLabelColor];
        [self.contentView addSubview:lineView];
        
        kWeakSelf
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).offset(15);
            make.centerY.equalTo(weakSelf.contentView);
            make.width.height.mas_equalTo(@(20));
        }];
        [self.settingTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.iconImageView.mas_right).offset(10);
            make.centerY.equalTo(weakSelf.contentView);
        }];
        [self.settingDescTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.contentView).offset(-30);
            make.centerY.equalTo(weakSelf.contentView);
        }];
        if ([reuseIdentifier isEqualToString:@"cell0"]) {
            [self.cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(weakSelf.contentView).offset(-15);
                make.centerY.equalTo(weakSelf.contentView);
                make.width.mas_equalTo(@(8));
                make.height.mas_equalTo(@(15));
            }];
        }else {
            [self.switchSetting mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(weakSelf.contentView).offset(-15);
                make.centerY.equalTo(weakSelf.contentView);
            }];
        }
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).offset(15);
            make.right.equalTo(weakSelf.contentView).offset(-15);
            make.bottom.equalTo(weakSelf.contentView);
            make.height.mas_equalTo(@1);
        }];
        
        
        
        
        
    }
    return self;
}
- (void)setItemDic:(NSDictionary *)itemDic {
    _itemDic = itemDic;
    self.iconImageView.image = [UIImage imageNamed:itemDic[@"iconImage"]];
    self.settingTitleLabel.text = itemDic[@"title"];
    self.settingDescTitleLabel.text = itemDic[@"descTitle"];
    self.cellImageView.image = [UIImage imageNamed:itemDic[@"cellImage"]];
    
    
}
- (void)swChange:(UISwitch *)sw {
    if(sw.on == YES){
        NSLog(@"开关被打开");
    }else{
        NSLog(@"开关被关闭");
    }
}







@end































