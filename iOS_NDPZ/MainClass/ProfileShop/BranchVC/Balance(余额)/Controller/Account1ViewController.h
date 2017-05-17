//
//  Account1ViewController.h
//  XLMM
//
//  Created by apple on 16/2/26.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface Account1ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)NSNumber *accountMoney;
@property (nonatomic, strong) NSDictionary *personCenterDict;


@end
