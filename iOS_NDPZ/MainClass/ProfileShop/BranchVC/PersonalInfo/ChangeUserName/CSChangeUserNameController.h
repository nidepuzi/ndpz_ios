//
//  CSChangeUserNameController.h
//  iOS_NDPZ
//
//  Created by zhang on 17/6/1.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^changeNameBlock)(NSString *userName);

@interface CSChangeUserNameController : UIViewController

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) changeNameBlock block;


@end
