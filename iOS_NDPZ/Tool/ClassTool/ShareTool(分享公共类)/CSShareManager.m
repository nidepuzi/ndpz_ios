//
//  CSShareManager.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/12.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSShareManager.h"
//#import "CSSharePopController.h"

@implementation CSShareManager

+ (CSShareManager *)manager {
    static CSShareManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CSShareManager alloc] init];
    });
    return manager;
}


- (void)showSharepopViewController:(CSSharePopController *)viewController withRootViewController:(UIViewController *)rootVC {
    
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:viewController];
    popupController.navigationBarHidden = YES;
    popupController.isTouchBackgorundView = YES;
    popupController.style = STPopupStyleBottomSheet;
    [popupController presentInViewController:rootVC];
    
    viewController.popVC = popupController;
    
}





@end
