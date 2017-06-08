//
//  JMGoodsLoopRollCell.m
//  XLMM
//
//  Created by zhang on 17/4/22.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "JMGoodsLoopRollCell.h"
#import "CSGoodsDetailModel.h"


@interface JMGoodsLoopRollCell ()

@property (nonatomic, strong) UIImageView *imageView;


@end

@implementation JMGoodsLoopRollCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setUpInit];
    }
    return self;
}

- (void)setUpInit {
    self.imageView = [UIImageView new];
    [self addSubview:self.imageView];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    kWeakSelf
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(weakSelf);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(SCREENWIDTH);
    }];
}
- (void)refreshScrollViewWithModel:(CSGoodsDetailContentModel *)model Index:(NSInteger)index {
    NSString *imageString = model.head_imgs[index];
    imageString = [NSString isStringEmpty:model.watermark_op] ? [imageString imageNormalCompression] : [NSString stringWithFormat:@"%@|%@",[imageString imageNormalCompression],model.watermark_op];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[imageString JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"icon_placeholderEmpty"] options:SDWebImageProgressiveDownload];
}

@end

















