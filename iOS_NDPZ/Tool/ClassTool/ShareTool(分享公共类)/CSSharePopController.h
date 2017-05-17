//
//  CSSharePopController.h
//  iOS_NDPZ
//
//  Created by zhang on 17/5/12.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^touchShareCancleBlock)(BOOL dismiss);

@class STPopupController,JMShareModel;
@interface CSSharePopController : UIViewController

@property (nonatomic, strong) UIButton *cancleButton;
@property (nonatomic, strong) STPopupController *popVC;
@property (nonatomic, strong) JMShareModel *model;
@property (nonatomic, copy) touchShareCancleBlock cancleBlock;

@property (nonatomic, assign) CGFloat popViewHeight;
//- (instancetype)initWithFrame:(CGRect)frame;


@end
