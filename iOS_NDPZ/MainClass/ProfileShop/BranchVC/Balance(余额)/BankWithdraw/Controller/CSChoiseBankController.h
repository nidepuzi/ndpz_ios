//
//  CSChoiseBankController.h
//  iOS_NDPZ
//
//  Created by zhang on 17/5/19.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CSChoiseBankBlock)(NSDictionary *dic);

@interface CSChoiseBankController : UIViewController

@property (nonatomic, copy) CSChoiseBankBlock block;


@end
