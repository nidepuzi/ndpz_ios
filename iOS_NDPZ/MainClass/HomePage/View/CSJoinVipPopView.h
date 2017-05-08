//
//  CSJoinVipPopView.h
//  iOS_NDPZ
//
//  Created by zhang on 17/5/6.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class CSJoinVipPopView;
//
//@protocol CSJoinVipPopViewDelegate <NSObject>
//
//@optional
//
//- (void)composeJoinVipPopButton:(CSJoinVipPopView *)updataButton didClick:(NSInteger)index;
//
//@end
@interface CSJoinVipPopView : UIView

//@property (nonatomic, weak) id<CSJoinVipPopViewDelegate> delegate;

+ (instancetype)defaultJoinVipPopView;
@property (nonatomic, weak) UIViewController *parentVC;


@end
