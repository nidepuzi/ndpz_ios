//
//  CSShareManager.h
//  iOS_NDPZ
//
//  Created by zhang on 17/5/12.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <STPopup/STPopup.h>
#import "CSSharePopController.h"
#import "JMShareModel.h"

//@class CSSharePopController;
@interface CSShareManager : NSObject

+ (CSShareManager *)manager;

// withBlock:(void (^)(UIViewController *popViewController))clickBlock;
- (void)showSharepopViewController:(CSSharePopController *)viewController withRootViewController:(UIViewController *)rootVC WithBlock:(void (^)(BOOL dismiss))ClickBlock;



@end
