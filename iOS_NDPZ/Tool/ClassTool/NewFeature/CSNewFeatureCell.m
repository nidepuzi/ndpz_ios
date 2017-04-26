//
//  CSNewFeatureCell.m
//  iOS_NDPZ
//
//  Created by zhang on 17/4/26.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSNewFeatureCell.h"

@interface CSNewFeatureCell ()

@property (nonatomic,weak) UIImageView *imageView;

@property (nonatomic, weak) UIButton *shareButton;

@property (nonatomic, weak) UIButton *startButton;

@end

@implementation CSNewFeatureCell

//- (UIButton *)shareButton {
//    if (_shareButton == nil) {
//        
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setTitle:@"分享给大家" forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateSelected];
//        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [btn sizeToFit];
//        
//        [self.contentView addSubview:btn];
//        
//        _shareButton = btn;
//        
//    }
//    return _shareButton;
//}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.bounds];
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        imageV.clipsToBounds = YES;
        [self.contentView addSubview:imageV];
        self.imageView = imageV;
        
        UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        startBtn.backgroundColor = [UIColor buttonEnabledBackgroundColor];
        [startBtn setTitle:@"开始体验" forState:UIControlStateNormal];
        [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
        [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
        [startBtn sizeToFit];
        [startBtn addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
        startBtn.titleLabel.font = CS_UIFontSize(14.);
        startBtn.layer.cornerRadius = 20.;
        startBtn.layer.masksToBounds = YES;
        [self addSubview:startBtn];
        self.startButton = startBtn;
        
        kWeakSelf
        
        [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.contentView.mas_centerX);
            make.bottom.equalTo(weakSelf.contentView).offset(-80);
            make.width.mas_equalTo(@(80));
            make.height.mas_equalTo(@(40));
        }];
        
        
        
    }
    return self;
}
//
////布局子控件的frame
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    
//    self.imageView.frame = self.contentView.bounds;
//    
//    // 分享按钮
////    self.shareButton.center = CGPointMake(self.cs_w * 0.5, self.cs_h * 0.8);
//    // 开始按钮
//    self.startButton.center = CGPointMake(self.cs_w * 0.5, self.cs_h * 0.8);
//    self.startButton.cs_size = CGSizeMake(80, 40);
//    
//    
//}
- (void)setImage:(UIImage *)image {
    _image = image;
    
    self.imageView.image = image;
}
// 判断当前cell是否是最后一页
- (void)setIndexPath:(NSIndexPath *)indexPath count:(NSInteger)count {
    if (indexPath.row == count - 1) { // 最后一页,显示分享和开始按钮
//        self.shareButton.hidden = NO;
        self.startButton.hidden = NO;
        
        
    }else{ // 非最后一页，隐藏分享和开始按钮
//        self.shareButton.hidden = YES;
        self.startButton.hidden = YES;
    }
}
- (void)start:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(composeNewFeatureStartClick:)]) {
        [_delegate composeNewFeatureStartClick:button];
    }
}



@end















































































