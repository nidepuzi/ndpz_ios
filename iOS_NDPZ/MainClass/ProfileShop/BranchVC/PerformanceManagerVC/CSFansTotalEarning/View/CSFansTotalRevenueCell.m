//
//  CSFansTotalRevenueCell.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/12.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSFansTotalRevenueCell.h"
#import "CSFansTotlaRevenueModel.h"


@interface CSFansTotalRevenueCell ()

@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;

@end

@implementation CSFansTotalRevenueCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
- (void)createUI {
    CGFloat labelW = SCREENWIDTH / 3;
    for (int i = 0; i < 3; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((i % 3) * labelW, 0, labelW, 45)];
        label.font = CS_UIFontSize(13.);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor buttonTitleColor];
        [self.contentView addSubview:label];
        label.tag = 10 + i;
    }
    
    
    self.label1 = (UILabel *)[self viewWithTag:10];
    self.label2 = (UILabel *)[self viewWithTag:11];
    self.label3 = (UILabel *)[self viewWithTag:12];
    
    
    
    
    
}

- (void)setModel:(CSFansTotlaRevenueModel *)model {
    _model = model;
    self.label1.text = model.title;
    self.label2.text = model.title;
    self.label3.text = model.title;
}





@end



















