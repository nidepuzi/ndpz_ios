//
//  CSAccountSecurityCell.m
//  iOS_NDPZ
//
//  Created by zhang on 17/4/27.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSAccountSecurityCell.h"


@interface CSAccountSecurityCell ()

@property (nonatomic, strong) UILabel *settingTitleLabel;
@property (nonatomic, strong) UILabel *settingDescTitleLabel;
@property (nonatomic, strong) UIImageView *cellImageView;

@end

@implementation CSAccountSecurityCell

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
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor countLabelColor];
        [self.contentView addSubview:lineView];
        
        kWeakSelf
        [self.settingTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).offset(15);
            make.centerY.equalTo(weakSelf.contentView);
        }];
        [self.settingDescTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.cellImageView.mas_left).offset(-10);
            make.centerY.equalTo(weakSelf.contentView);
        }];
        
        [self.cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.contentView).offset(-15);
            make.centerY.equalTo(weakSelf.contentView);
            make.width.mas_equalTo(@(8));
            make.height.mas_equalTo(@(15));
        }];
        
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
    self.settingTitleLabel.text = itemDic[@"title"];
    self.settingDescTitleLabel.text = itemDic[@"descTitle"];
    self.cellImageView.image = [UIImage imageNamed:itemDic[@"cellImage"]];
    
    
}




@end




































