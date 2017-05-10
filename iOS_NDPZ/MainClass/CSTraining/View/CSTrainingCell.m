//
//  CSTrainingCell.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/9.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSTrainingCell.h"
#import "CSTrainingModel.h"

@interface CSTrainingCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descTitleLabel;
@property (nonatomic, strong) UIImageView *itemImageView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *canrurenshuLabel;

@end

@implementation CSTrainingCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
- (void)createUI {
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = CS_UIFontSize(16.);
    titleLabel.textColor = [UIColor buttonTitleColor];
    titleLabel.numberOfLines = 1;
    
    UILabel *descTitleLabel = [UILabel new];
    descTitleLabel.font = CS_UIFontSize(15.);
    descTitleLabel.textColor = [UIColor dingfanxiangqingColor];
    descTitleLabel.numberOfLines = 0;
    
    UIImageView *itemImageView = [UIImageView new];
    itemImageView.contentMode = UIViewContentModeScaleAspectFit;
    itemImageView.clipsToBounds = YES;
    
    UILabel *timeLabel = [UILabel new];
    timeLabel.font = CS_UIFontSize(13.);
    timeLabel.textColor = [UIColor dingfanxiangqingColor];
    timeLabel.numberOfLines = 1;
    
    UILabel *canrurenshuLabel = [UILabel new];
    canrurenshuLabel.font = CS_UIFontSize(13.);
    canrurenshuLabel.textColor = [UIColor dingfanxiangqingColor];
    canrurenshuLabel.numberOfLines = 1;
    
    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:descTitleLabel];
    [self.contentView addSubview:itemImageView];
    [self.contentView addSubview:timeLabel];
    [self.contentView addSubview:canrurenshuLabel];
    
    self.titleLabel = titleLabel;
    self.descTitleLabel = descTitleLabel;
    self.itemImageView = itemImageView;
    self.timeLabel = timeLabel;
    self.canrurenshuLabel = canrurenshuLabel;
    
    UIView *lineView = [UIView new];
    [self.contentView addSubview:lineView];
    lineView.backgroundColor = [UIColor lineGrayColor];
    
    kWeakSelf
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(15);
        make.left.equalTo(weakSelf.contentView).offset(10);
        make.right.equalTo(weakSelf.contentView).offset(-10);
    }];
    [descTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.left.equalTo(titleLabel);
        make.right.equalTo(weakSelf.contentView).offset(-10);
    }];
    [itemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descTitleLabel.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf.contentView);
        make.width.mas_equalTo(@(SCREENWIDTH - 20));
        make.height.mas_equalTo(@(SCREENWIDTH / 2));
    }];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(itemImageView.mas_bottom).offset(10);
        make.left.equalTo(titleLabel);
    }];
    [canrurenshuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(itemImageView.mas_bottom).offset(10);
        make.right.equalTo(weakSelf.contentView).offset(-10);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(@1);
    }];
    
    
    
}
- (void)config:(CSTrainingModel *)model {
    self.titleLabel.text = model.title;
    self.descTitleLabel.text = model.descriptionTitle;
    [self.itemImageView sd_setImageWithURL:[NSURL URLWithString:[[model.cover_image JMUrlEncodedString] imageNormalCompression]] placeholderImage:[UIImage imageNamed:@"icon_placeholderEmpty"]];
    self.timeLabel.text = @"";
    self.canrurenshuLabel.text = [NSString stringWithFormat:@"参与人数%@",model.num_attender];
    
    
}




@end































































