//
//  CSChoiseBankController.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/19.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSChoiseBankController.h"
#import "CSPersonalInfoCell.h"

@interface CSChoiseBankController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;


@end

@implementation CSChoiseBankController

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"请选择开户银行" selecotr:@selector(backClick)];
    [self createTableView];
    [self loadData];
}
- (void)loadData {
    NSString *url = [NSString stringWithFormat:@"%@/rest/v2/bankcards/preferances", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:url WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject)return;
        [self dataAnalysis:responseObject];
    } WithFail:^(NSError *error) {
    } Progress:^(float progress) {
        
    }];
    
}
- (void)dataAnalysis:(NSDictionary *)responseDic {
    NSArray *banks = responseDic[@"banks"];
    for (NSDictionary *dic in banks) {
        [self.dataSource addObject:dic];
    }
    
    [self.tableView reloadData];
}

- (void)createTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.backgroundColor = [UIColor countLabelColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.showsVerticalScrollIndicator = NO;
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [UIView new];
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.layoutMargins = UIEdgeInsetsZero;
    
    [tableView registerClass:[CSPersonalInfoCell class] forCellReuseIdentifier:CSPersonalInfoCellIdentifier];
    self.tableView = tableView;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CSPersonalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CSPersonalInfoCellIdentifier];
    if (!cell) {
        cell = [[CSPersonalInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CSPersonalInfoCellIdentifier];
    }
    NSDictionary *dic = self.dataSource[indexPath.row];
    [cell configWithItemForBankChoise:dic];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layoutMargins = UIEdgeInsetsZero;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataSource[indexPath.row];
    if (self.block) {
        self.block(dic);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}




- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}





@end




/*
    
 设置tableView的分割线
 
 tableView.separatorColor = [UIColor redColor];
 
 tableView.separatorInset = UIEdgeInsetsMake(0,80, 0, 80);        // 设置端距，这里表示separator离左边和右边均80像素
 
 tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
 
 tableView.dataSource = self;
 
 */

















































