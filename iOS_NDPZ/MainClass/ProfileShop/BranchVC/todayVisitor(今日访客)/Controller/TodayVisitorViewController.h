//
//  TodayVisitorViewController.h
//  XLMM
//
//  Created by apple on 16/3/22.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayVisitorViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)NSNumber *visitorDate;
@end
