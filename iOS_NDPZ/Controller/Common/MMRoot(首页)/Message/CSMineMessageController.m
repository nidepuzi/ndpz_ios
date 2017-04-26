//
//  CSMineMessageController.m
//  NDPZ
//
//  Created by zhang on 17/4/22.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSMineMessageController.h"
#import "CSMineMsgCell.h"

@interface CSMineMessageController () <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *cellDataArr;              // 自定义在cell上展示的类型
}

@property (nonatomic, strong) UITableView *tableView;


@end

@implementation CSMineMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBarWithTitle:@"消息盒子" selecotr:@selector(backCkick)];
    
    [self createTableView];
    [self loadData];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor countLabelColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 80.f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[CSMineMsgCell class] forCellReuseIdentifier:@"CSMineMsgCellIdentifier"];
    [self.view addSubview:self.tableView];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return cellDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CSMineMsgCellIdentifier = @"CSMineMsgCellIdentifier";
    CSMineMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:CSMineMsgCellIdentifier];
    if (cell == nil) {
        cell = [[CSMineMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CSMineMsgCellIdentifier];
    }
    NSDictionary *dict = cellDataArr[indexPath.row];
    cell.cellDic = dict;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



- (void)loadData {
    NSString *timeStr = [NSString getCurrentTime];
    NSArray *arr = @[@{
                         @"title":@"云集公告",
                         @"descTitle":@"亲爱的你的铺子用户:进入人工客服排队提交审核,请耐心等待哦~",
                         @"iconImage":@"Message_box_copy",
                         @"createTime":timeStr
                         },
                     @{
                         @"title":@"培训消息",
                         @"descTitle":@"亲爱的你的铺子用户:进入人工客服排队提交审核,请耐心等待哦~",
                         @"iconImage":@"Message_box_train",
                         @"createTime":timeStr
                         },
                     @{
                         @"title":@"订单助手",
                         @"descTitle":@"亲爱的你的铺子用户:进入人工客服排队提交审核,请耐心等待哦~",
                         @"iconImage":@"Message_box_order",
                         @"createTime":timeStr
                         },
                     @{
                         @"title":@"你的铺子助手",
                         @"descTitle":@"亲爱的你的铺子用户:进入人工客服排队提交审核,请耐心等待哦~",
                         @"iconImage":@"Message_box_helper",
                         @"createTime":timeStr
                         },
                     @{
                         @"title":@"活动消息",
                         @"descTitle":@"亲爱的你的铺子用户:进入人工客服排队提交审核,请耐心等待哦~",
                         @"iconImage":@"Message_box_notifi",
                         @"createTime":timeStr
                         }
                     ];
    cellDataArr = [arr mutableCopy];
    [self.tableView reloadData];
    
}

- (void)backCkick {
    [self.navigationController popViewControllerAnimated:YES];
}


@end








































































































