//
//  JMChildViewController.h
//  XLMM
//
//  Created by zhang on 17/4/8.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMChildViewController : UIViewController


@property (nonatomic, copy) NSString *categoryCid;
@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) NSString *categoryUrlString;
- (NSArray *)setSegmentArr;
- (NSArray *)setUrlData;





@end
