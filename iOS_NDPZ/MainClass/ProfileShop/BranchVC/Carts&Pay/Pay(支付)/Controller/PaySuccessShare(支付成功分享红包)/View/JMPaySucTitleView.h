//
//  JMPaySucTitleView.h
//  XLMM
//
//  Created by zhang on 17/4/21.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>


@class JMPaySucTitleView;
@protocol JMPaySucTitleViewDelegate <NSObject>

- (void)composeGetRedpackBtn:(JMPaySucTitleView *)renPack didClick:(UIButton *)button;

@end


@interface JMPaySucTitleView : UIView

+ (instancetype)enterHeaderView;

@property (nonatomic, weak) id<JMPaySucTitleViewDelegate> delegate;


@end
