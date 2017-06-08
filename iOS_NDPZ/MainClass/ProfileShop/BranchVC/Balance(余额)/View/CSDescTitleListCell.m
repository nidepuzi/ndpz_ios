//
//  CSDescTitleListCell.m
//  iOS_NDPZ
//
//  Created by zhang on 17/6/5.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSDescTitleListCell.h"
#import "CSPopDescModel.h"

@interface CSDescTitleListCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation CSDescTitleListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.font = CS_UIFontSize(12.);
        self.titleLabel.textColor = [UIColor dingfanxiangqingColor];
        self.titleLabel.numberOfLines = 0;
        [self.contentView addSubview:self.titleLabel];
        
        kWeakSelf
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).offset(10);
            make.right.equalTo(weakSelf.contentView).offset(-10);
            make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        }];
        
    }
    return self;
}
- (void)setDescModel:(CSPopDescModel *)descModel {
    _descModel = descModel;
    self.titleLabel.text = descModel.rowTitle;
    
}



@end
