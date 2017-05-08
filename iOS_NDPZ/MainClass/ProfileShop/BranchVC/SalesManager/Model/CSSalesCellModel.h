//
//  CSSalesCellModel.h
//  iOS_NDPZ
//
//  Created by zhang on 17/4/28.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSSalesCellModel : NSObject

/** 用户ID */
@property (nonatomic, copy) NSString *ID;
/** 头像 */
@property (nonatomic, copy) NSString *headImg;
/** 姓名 */
@property (nonatomic, copy) NSString *name;
/** 描述 */
@property (nonatomic, copy) NSString *describe;
/** 活动时间(表示与该联系人的最后交流时间) */
@property (nonatomic, copy) NSString *activeTime;


@end
