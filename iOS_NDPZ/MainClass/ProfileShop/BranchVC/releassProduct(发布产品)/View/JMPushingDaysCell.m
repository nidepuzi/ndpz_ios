//
//  JMPushingDaysCell.m
//  XLMM
//
//  Created by zhang on 17/4/10.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "JMPushingDaysCell.h"

@interface JMPushingDaysCell ()

@end

@implementation JMPushingDaysCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.cellImageView = [[UIImageView alloc] init];
        self.cellImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.cellImageView.clipsToBounds = YES;
        [self addSubview:self.cellImageView];
        
        kWeakSelf
        [self.cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(weakSelf);
        }];
        
    }
    return self;
}
- (void)createImageForCellImageView:(NSString *)imageUrl Index:(NSInteger)index RowIndex:(NSInteger)rowIndex {
    if (index == rowIndex) {
    }else {
        imageUrl = [imageUrl imageGoodsOrderCompression];
    }
    [self.cellImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"icon_placeholderEmpty"]];
}

@end
