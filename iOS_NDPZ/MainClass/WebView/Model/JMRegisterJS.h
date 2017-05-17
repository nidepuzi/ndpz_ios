//
//  JMRegisterJS.h
//  XLMM
//
//  Created by zhang on 17/4/3.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IMYWebView;
@interface JMRegisterJS : NSObject

+ (instancetype)defaultRegister;
- (void)registerJSBridgeBeforeIOSSeven:(UIViewController *)webVC WebView:(IMYWebView *)baseWebView;


@end
