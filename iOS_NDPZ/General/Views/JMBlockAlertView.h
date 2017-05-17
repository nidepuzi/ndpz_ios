//
//  JMBlockAlertView.h
//  XLMM
//
//  Created by zhang on 17/4/9.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMBlockAlertView : UIAlertView <UIAlertViewDelegate>

+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
 cancelButtonWithTitle:(NSString *)cancelTitle
           cancelBlock:(void (^)())cancelblock
confirmButtonWithTitle:(NSString *)confirmTitle
          confirmBlock:(void (^)())confirmBlock;



@end
