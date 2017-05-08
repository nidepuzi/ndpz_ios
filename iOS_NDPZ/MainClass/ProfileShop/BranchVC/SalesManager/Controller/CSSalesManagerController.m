//
//  CSSalesManagerController.m
//  iOS_NDPZ
//
//  Created by zhang on 17/4/28.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSSalesManagerController.h"
#import "CSSalesCellModel.h"
#import "CSSalesGroupModel.h"
#import "CSSalesManagerCell.h"
#import "CSSearchSalesHistoryController.h"


@interface CSSalesManagerController () <UITableViewDataSource, UITableViewDelegate> {
    NSIndexPath *_indexPath; // 保存当前选中的单元格
    NSMutableArray *switchArr; // 保存旋转状态(展开/折叠)
}

@property (nonatomic, strong) UITableView *tableView;
/** 保存分组数据模型 */
@property (nonatomic, strong) NSMutableArray *groupModelArr;
/** 保存联系人数据模型 (是一个二维数组, 便于遍历分区和行信息) */
@property (nonatomic, strong) NSMutableArray *contactsModelArr;

@end

@implementation CSSalesManagerController

#pragma mark- 懒加载视图
- (UITableView *)tableView {
    if(_tableView == nil) {
        // 原点位置是(0,0)
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        // 设置表格头视图
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}
- (NSMutableArray *)groupModelArr {
    if (!_groupModelArr) {
        _groupModelArr = [[NSMutableArray alloc] init];
    }
    return _groupModelArr;
}

- (NSMutableArray *)contactsModelArr {
    if (!_contactsModelArr) {
        _contactsModelArr = [[NSMutableArray alloc]init];
    }
    return _contactsModelArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor countLabelColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createNavigationBarWithTitle:@"销售统计" selecotr:@selector(backClick)];
    
    [self loadData];
    
    UIButton *serViceButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 80)];
    [serViceButton addTarget:self action:@selector(serViceButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [serViceButton setTitle:@"查询历史" forState:UIControlStateNormal];
    [serViceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    serViceButton.titleLabel.font = [UIFont systemFontOfSize:14.];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:serViceButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    
    
    

}
- (void)serViceButtonClick {
    CSSearchSalesHistoryController *searchSaleHisVC = [[CSSearchSalesHistoryController alloc] init];
    [self.navigationController pushViewController:searchSaleHisVC animated:YES];
    
}

- (void)loadData {
    // 读取本地JSON文件的内容
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"contacts" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"数据内容：%@", jsonObj);
    NSString *retCode = jsonObj[@"head"][@"ret_code"];
    NSArray *groupsArr = jsonObj[@"body"][@"groups"];
    if ([retCode isEqualToString:@"0"]) {
        for (NSDictionary *groupDic in groupsArr) {
            CSSalesGroupModel *groupModel = [[CSSalesGroupModel alloc]init];
            groupModel.groupID = groupDic[@"group_id"];
            groupModel.groupName = groupDic[@"group_name"];
            groupModel.groupType = [groupDic[@"group_type"] integerValue];
            groupModel.memberNum = [groupDic[@"member_num"] integerValue];
            [self.groupModelArr addObject:groupModel];
            // 获取分组项
            NSArray *contactsArr = groupDic[@"contacts"];
            NSMutableArray *tmpArr = [[NSMutableArray alloc]init];
            for (NSDictionary *contactsDic in contactsArr) {
                CSSalesCellModel *contactsModel = [[CSSalesCellModel alloc]init];
                contactsModel.ID = contactsDic[@"id"];
                contactsModel.headImg = contactsDic[@"head_img"];
                contactsModel.name = contactsDic[@"name"];
                contactsModel.describe = contactsDic[@"describe"];
                contactsModel.activeTime = contactsDic[@"active_time"];
                [tmpArr addObject:contactsModel];
            }
            [self.contactsModelArr addObject:tmpArr];
            if (switchArr == nil) {
                switchArr = [[NSMutableArray alloc]init];
            }
            [switchArr addObject:@YES];
        }
    }
    // 回到主线程更新界面
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
#pragma mark- UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.contactsModelArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([switchArr[section] boolValue] == YES) {
        return [_contactsModelArr[section] count];
    } else {
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CSSalesManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[CSSalesManagerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.model = _contactsModelArr[indexPath.section][indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取消选中后的高亮状态(默认是：选中单元格后一直处于高亮状态，直到下次重新选择)
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _indexPath = indexPath;
    // 获取当前患者对象,并传给详情页面
    CSSalesCellModel *model = _contactsModelArr[indexPath.section][indexPath.row];
    NSLog(@"点击了：%@", model.name);
}
// 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
// 分区头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}
// 分区尾的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10.0f;
    } else {
        return 1.0f;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
    view.backgroundColor = [UIColor whiteColor];
    // 边界线
    UIView *borderView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 0.5)];
    borderView.backgroundColor = [UIColor colorWithHex:0xC8C7CC];
    [view addSubview:borderView];
    // 展开箭头
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"section_pullDown"];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-15);
        make.centerY.equalTo(view.mas_centerY);
    }];
    
    UILabel *xiaoshoueLabel = [UILabel new];
    xiaoshoueLabel.textColor = [UIColor buttonTitleColor];
    xiaoshoueLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:xiaoshoueLabel];
    [xiaoshoueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imageView.mas_left).offset(-10);
        make.centerY.equalTo(view.mas_centerY);
    }];
    CGFloat totalf = 0.00;
    NSArray *arr = self.contactsModelArr[section];
    for (CSSalesCellModel *model in arr) {
        totalf += [model.activeTime floatValue];
    }
    xiaoshoueLabel.text = [NSString stringWithFormat:@"销售额 : %.2f",totalf];
    
    
    
    // 分组名Label
    UILabel *groupLable = [[UILabel alloc]initWithFrame:CGRectMake(15 / 375.0 * SCREENWIDTH, 0, SCREENWIDTH, 50 / 375.0 * SCREENWIDTH)];
    CSSalesGroupModel *model = _groupModelArr[section];
    groupLable.text = [NSString stringWithFormat:@"%@", model.groupName];
    groupLable.textColor = [UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.0];
    groupLable.font = [UIFont systemFontOfSize:16];
    [view addSubview:groupLable];
    
    view.userInteractionEnabled = YES;
    // 初始化一个手势
    UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openClick:)];
    // 给view添加手势
    [view addGestureRecognizer:myTap];
    view.tag = 1000 + section;
    
    CGFloat rota;
    if ([switchArr[section] boolValue] == NO) {
        rota = 0;
    } else {
        rota = M_PI; //π/2
    }
    imageView.transform = CGAffineTransformMakeRotation(rota);//箭头偏移π/2
    return view;
}
- (void)openClick:(UITapGestureRecognizer *)sender {
    NSInteger section = sender.view.tag - 1000;
    if ([switchArr[section] boolValue] == NO) {
        [switchArr replaceObjectAtIndex:section withObject:@YES];
    } else {
        [switchArr replaceObjectAtIndex:section withObject:@NO];
    }
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *clearView = [[UIView alloc]init];
    clearView.backgroundColor = [UIColor clearColor];
    return clearView;
}



- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}



@end



























































































