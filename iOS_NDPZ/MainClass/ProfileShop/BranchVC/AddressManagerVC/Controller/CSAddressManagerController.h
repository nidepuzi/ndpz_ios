//
//  CSAddressManagerController.h
//  iOS_NDPZ
//
//  Created by zhang on 17/5/5.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSAddressManagerController,JMAddressModel;
@protocol CSAddressManagerControllerDelegate <NSObject>

@required

- (void)addressView:(CSAddressManagerController *)addressVC model:(JMAddressModel *)model;

@end

@interface CSAddressManagerController : UIViewController

@property (nonatomic, assign) id <CSAddressManagerControllerDelegate>delegate;
@property (nonatomic, assign) NSInteger cartsPayInfoLevel;
@property (nonatomic, assign) BOOL isSelected;

@end
