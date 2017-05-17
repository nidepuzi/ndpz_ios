//
//  JMUpdataAppPopView.h
//  XLMM
//
//  Created by zhang on 17/4/23.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>


//@class JMUpdataAppPopView;
//
//@protocol JMUpdataAppPopViewDelegate <NSObject>
//
//@optional
//
//- (void)composeUpdataAppButton:(JMUpdataAppPopView *)updataButton didClick:(NSInteger)index;
//
//@end

@interface JMUpdataAppPopView : UIView

//@property (nonatomic, weak) id<JMUpdataAppPopViewDelegate> delegate;

@property (nonatomic, copy) NSString *releaseNotes;
@property (nonatomic, copy) NSString *trailURL;
@property (nonatomic, weak) UIViewController *parentVC;
+ (instancetype)defaultUpdataPopView;

@end
