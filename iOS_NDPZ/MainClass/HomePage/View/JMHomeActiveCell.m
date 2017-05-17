//
//  JMHomeActiveCell.m
//  XLMM
//
//  Created by zhang on 17/4/19.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "JMHomeActiveCell.h"

NSString *const JMHomeActiveCellIdentifier = @"JMHomeActiveCellIdentifier";

@interface JMHomeActiveCell ()

@property (nonatomic, strong) UIImageView *iconImage;

@end

@implementation JMHomeActiveCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    self.iconImage = [UIImageView new];
    [self.contentView addSubview:self.iconImage];
    self.iconImage.contentMode = UIViewContentModeScaleAspectFill;
    
    kWeakSelf
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(5);
        make.left.equalTo(weakSelf.contentView);
        make.width.mas_equalTo(@(SCREENWIDTH));
        make.height.mas_equalTo(@(SCREENWIDTH / 2));
    }];
    
}
- (void)setActiveDic:(NSDictionary *)activeDic {
    _activeDic = activeDic;
    NSString *imageString = activeDic[@"act_img"];
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[[imageString JMUrlEncodedString] imageNormalCompression]] placeholderImage:[UIImage imageNamed:@"icon_placeholderEmpty"]];
}

- (void)setModel:(JMHomeActiveModel *)model {
    _model = model;
    NSString *urlString = [[model.act_img JMUrlEncodedString] imageNormalCompression];
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:nil];
    
}




@end
























































































