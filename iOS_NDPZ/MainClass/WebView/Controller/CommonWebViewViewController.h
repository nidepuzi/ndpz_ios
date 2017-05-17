//
//  CommonWebViewViewController.h
//  XLMM
//
//  Created by zhang on 17/4/12.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMYWebView.h"
#import <WebKit/WebKit.h>

@interface CommonWebViewViewController : UIViewController

@property (nonatomic, strong)NSString *loadLink;
@property (nonatomic, strong)NSString *titleName;
@property (nonatomic ,strong) IMYWebView *baseWebView;

- (instancetype)initWithUrl:(NSString *)url title:(NSString *)titleName;
@end
