//
//  CSShareManager.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/12.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSShareManager.h"
//#import "CSSharePopController.h"

@interface CSShareManager ()

@property (nonatomic, strong) STPopupController *popupController;

@end

@implementation CSShareManager

+ (CSShareManager *)manager {
    static CSShareManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CSShareManager alloc] init];
    });
    return manager;
}


- (void)showSharepopViewController:(CSSharePopController *)viewController withRootViewController:(UIViewController *)rootVC WithBlock:(void (^)(BOOL dismiss))ClickBlock {
    
//    if (self.popupController) {
//        NSLog(@"%@",self.popupController);
//        [self.popupController presentInViewController:rootVC];
//        return;
//    }
    
    self.popupController = [[STPopupController alloc] initWithRootViewController:viewController];
    self.popupController.navigationBarHidden = YES;
    self.popupController.isTouchBackgorundView = YES;
    self.popupController.style = STPopupStyleBottomSheet;
    [self.popupController presentInViewController:rootVC];
    self.popupController.popupBlock = ClickBlock;
    viewController.cancleBlock = ClickBlock;
    viewController.popVC = self.popupController;
    
    
}





@end
