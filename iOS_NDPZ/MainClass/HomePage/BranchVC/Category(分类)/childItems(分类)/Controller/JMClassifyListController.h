//
//  JMClassifyListController.h
//  XLMM
//
//  Created by zhang on 17/4/16.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMClassifyListController : UIViewController

@property (nonatomic, copy) NSString *titleString;

@property (nonatomic, copy) NSString *urlString;

@property (nonatomic, copy) NSString *emptyTitle;

- (void)refresh;

@end
