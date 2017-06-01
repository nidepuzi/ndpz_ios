//
//  JMHomeHourModel.h
//  XLMM
//
//  Created by zhang on 17/4/16.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMHomeHourModel : NSObject

@property (nonatomic, copy) NSString *hour;
@property (nonatomic, copy) NSString *model_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSDictionary *profit;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *activity_id;
@property (nonatomic, copy) NSString *selling_num;
@property (nonatomic, copy) NSString *stock;
@property (nonatomic, copy) NSString *watermark_op;


@end

/*
 {
 hour = 13;
 items =     (
 {
 "activity_id" = 825;
 hour = 13;
 "model_id" = 24847;
 name = "\U767e\U642d\U4fdd\U6696\U957f\U6b3e\U7f8a\U6bdb\U62ab\U80a9";
 pic = "http://img.xiaolumeimei.com/MG_1480582697321.jpg";
 price = 168;
 profit =             {
 max = 60;
 min = 20;
 };
 "selling_num" = 87;
 "start_time" = "2017-05-17T21:00:00";
 stock = 0;
 "watermark_op" = "watermark/1/image/aHR0cDovL29wMDR5eGV0ci5ia3QuY2xvdWRkbi5jb20vNjEucG5nP2ltYWdlTW9ncjIvc3RyaXAvZm9ybWF0L3BuZy9xdWFsaXR5LzkwL2ludGVybGFjZS8xL3RodW1ibmFpbC8yMDAv/dissovle/50/gravity/Center/dx/0/dy/0/ws/1";
 
 }
 );
 }

 
 
 */

