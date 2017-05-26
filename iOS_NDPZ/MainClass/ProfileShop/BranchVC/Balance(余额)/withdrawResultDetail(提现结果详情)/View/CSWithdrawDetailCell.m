//
//  CSWithdrawDetailCell.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/22.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSWithdrawDetailCell.h"

@interface CSWithdrawDetailCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descTitleLabel;

@end

@implementation CSWithdrawDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
- (void)createUI {
    self.contentView.backgroundColor = [UIColor countLabelColor];
    
    self.titleLabel = [UILabel new];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor buttonTitleColor];
    self.titleLabel.font = CS_UIFontSize(14.);
    
    self.descTitleLabel = [UILabel new];
    [self.contentView addSubview:self.descTitleLabel];
    self.descTitleLabel.numberOfLines = 2;
    self.descTitleLabel.textColor = [UIColor buttonTitleColor];
    self.descTitleLabel.font = CS_UIFontSize(14.);
    
    
    kWeakSelf
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(10);
        make.width.mas_equalTo(@80);
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.descTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel.mas_right).offset(10);
        make.right.equalTo(weakSelf.contentView).offset(-10);
        make.centerY.equalTo(weakSelf.contentView);
    }];
    
    
    
    
}

- (void)setItemDic:(NSDictionary *)itemDic {
    _itemDic = itemDic;
    self.titleLabel.text = itemDic[@"title"];
    self.descTitleLabel.text = itemDic[@"desTitle"];
    
}







@end











































































