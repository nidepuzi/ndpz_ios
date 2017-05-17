//
//  JMShareButtonView.h
//  XLMM
//
//  Created by 崔人帅 on 16/5/30.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef NS_ENUM(NSInteger, shareButtonType) {
//    shareButtonType1,
//    shareButtonType2,
//};

@class JMShareButtonView;
@protocol JMShareButtonViewDelegate <NSObject>

@optional
- (void)composeShareBtn:(JMShareButtonView *)shareBtn didClickBtn:(NSInteger)index;

@end

@interface JMShareButtonView : UIView

- (instancetype)initWithFrame:(CGRect)frame;
//@property (nonatomic, assign) shareButtonType buttonType;
@property (nonatomic,weak) id<JMShareButtonViewDelegate> delegate;


@end
