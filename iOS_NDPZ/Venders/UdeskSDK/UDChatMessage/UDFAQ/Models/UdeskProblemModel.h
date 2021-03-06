//
//  UdeskProblemModel.h
//  UdeskSDK
//
//  Created by xuchen on 15/11/26.
//  Copyright (c) 2015年 xuchen. All rights reserved.
//

#import "UdeskBaseModel.h"

@interface UdeskProblemModel : UdeskBaseModel
/**
 *  文章id
 */
@property (nonatomic, copy) NSString *articleId;
/**
 *  文章标题
 */
@property (nonatomic, copy) NSString *subject;

@end
