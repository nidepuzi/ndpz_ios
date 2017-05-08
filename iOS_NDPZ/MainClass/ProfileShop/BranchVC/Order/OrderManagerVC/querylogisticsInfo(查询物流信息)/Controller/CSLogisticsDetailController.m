//
//  CSLogisticsDetailController.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/6.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSLogisticsDetailController.h"
#import "JMGoodsListCell.h"
#import "JMTimeListCell.h"
#import "JMOrderGoodsModel.h"


@interface CSLogisticsDetailController () <UITableViewDelegate, UITableViewDataSource> {
    NSString *_outSidID;
    NSString *_companyCode;
    NSMutableArray *logisData;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CSLogisticsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"物流详情" selecotr:@selector(backClick)];
    
    
    logisData = [NSMutableArray array];
    [self createUI];
    
    NSString *currentTime = [NSString getCurrentTime];
    NSArray *arr = @[@{
                         @"title":@"订单创建成功",
                         @"time":currentTime
                         },
                    @{
                         @"title":@"暂时没有物流信息",
                         @"time":currentTime
                         }];
    logisData = [arr mutableCopy];
    
    [self.tableView reloadData];
    
}
- (void)loadData {
    [MBProgressHUD showLoading:@""];
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/wuliu/get_wuliu_by_packetid?packetid=%@&company_code=%@", Root_URL, _outSidID, _companyCode];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:[urlString JMUrlEncodedString] WithParaments:nil WithSuccess:^(id responseObject) {
        [MBProgressHUD hideHUD];
        if(responseObject == nil) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的订单暂未查询到物流信息，可能快递公司数据还未更新，请稍候查询或到快递公司网站查询" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            return;
        }
        NSDictionary *info = responseObject;
        [self fetchedWuliuData:info];
    } WithFail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSLog(@"wuliu info get failed.");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"查询失败,您的订单暂未查询到物流信息，可能快递公司数据还未更新，请稍候查询或到快递公司网站查询" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    } Progress:^(float progress) {
        
    }];
}
- (void)fetchedWuliuData:(NSDictionary *)responseData {
    // NSLog(@"%@",responseData);
    if (responseData == nil) {
        return;
    }
    NSArray *infoArr = responseData[@"data"];
    if (infoArr.count == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的订单暂未查询到物流信息，可能快递公司数据还未更新，请稍候查询或到快递公司网站查询" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }else {
        
        [self.tableView reloadData]; // 可以单独刷新第二组数据 (时间线数据)
    }
    
//    NSDictionary *dicJson = responseData;
//    NSLog(@"json = %@", dicJson);
//    self.infoArray = [dicJson objectForKey:@"data"];
//    NSInteger length = self.infoArray.count;
//    if (length == 0) {
    
//        self.logNameLabel.text = self.logName;
//        self.logNumLabel.text = self.packetId;
//    }else {
//        self.logNameLabel.text = [dicJson objectForKey:@"name"];
//        self.logNumLabel.text = [dicJson objectForKey:@"order"];
//        if (![NSString isStringEmpty:self.logNumLabel.text]) {
//            self.logNumLabel.userInteractionEnabled = YES;
//        }
//        [self createTimeListView];
//    }
}
- (void)createUI {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[JMGoodsListCell class] forCellReuseIdentifier:JMGoodsListCellIdentifier];
    [self.tableView registerClass:[JMTimeListCell class] forCellReuseIdentifier:JMTimeListCellIdentifier];
    [self.view addSubview:self.tableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.goodsSource.count;
    }else if (section == 1) {
        return 2;
    }else {
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 110;
    }else if (indexPath.section == 1) {
        return 90;
    }else {
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JMGoodsListCell *listCell = [tableView dequeueReusableCellWithIdentifier:JMGoodsListCellIdentifier];
        [listCell configData:self.goodsSource[indexPath.row]];
        listCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return listCell;
    }else if (indexPath.section == 1) {
        JMTimeListCell *timeCell = [tableView dequeueReusableCellWithIdentifier:JMTimeListCellIdentifier];
        [timeCell config:logisData[indexPath.row] Index:indexPath.row];
        timeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return timeCell;
    }else {
        return nil;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }else {
        return 50;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }else {
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
        UILabel *wuliugenzong = [UILabel new];
        wuliugenzong.font = CS_UIFontSize(16.);
        wuliugenzong.textColor = [UIColor dingfanxiangqingColor];
        wuliugenzong.text = @"物流跟踪";
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor lineGrayColor];
        
        [sectionView addSubview:wuliugenzong];
        [sectionView addSubview:lineView];
        
        [wuliugenzong mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(sectionView).offset(15);
            make.centerY.equalTo(sectionView.mas_centerY);
        }];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(sectionView).offset(15);
            make.right.equalTo(sectionView).offset(-15);
            make.bottom.equalTo(sectionView);
            make.height.mas_equalTo(@1);
        }];
        
        return sectionView;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 140;
    }else {
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 140)];
//        sectionView.backgroundColor = [UIColor whiteColor];
        
        UILabel *fahuishijian = [UILabel new];
        fahuishijian.font = CS_UIFontSize(14.);
        fahuishijian.textColor = [UIColor buttonTitleColor];
        fahuishijian.text = @"发货时间:";
        
        UILabel *wuliugongsi = [UILabel new];
        wuliugongsi.font = CS_UIFontSize(14.);
        wuliugongsi.textColor = [UIColor buttonTitleColor];
        wuliugongsi.text = @"物流公司:";
        
        UILabel *lianxidianhua = [UILabel new];
        lianxidianhua.font = CS_UIFontSize(14.);
        lianxidianhua.textColor = [UIColor buttonTitleColor];
        lianxidianhua.text = @"联系电话:";
        
        UILabel *wuliudanhao = [UILabel new];
        wuliudanhao.font = CS_UIFontSize(14.);
        wuliudanhao.textColor = [UIColor buttonTitleColor];
        wuliudanhao.text = @"物流单号:";
        
        UILabel *fahuishijianValue = [UILabel new];
        fahuishijianValue.font = CS_UIFontSize(14.);
        fahuishijianValue.textColor = [UIColor buttonTitleColor];
        fahuishijianValue.text = @"";
        
        UILabel *wuliugongsiValue = [UILabel new];
        wuliugongsiValue.font = CS_UIFontSize(14.);
        wuliugongsiValue.textColor = [UIColor buttonTitleColor];
        wuliugongsiValue.text = @"";
        
        UILabel *lianxidianhuaValue = [UILabel new];
        lianxidianhuaValue.font = CS_UIFontSize(14.);
        lianxidianhuaValue.textColor = [UIColor buttonTitleColor];
        lianxidianhuaValue.text = @"";
        
        UILabel *wuliudanhaoValue = [UILabel new];
        wuliudanhaoValue.font = CS_UIFontSize(14.);
        wuliudanhaoValue.textColor = [UIColor buttonTitleColor];
        wuliudanhaoValue.text = @"";
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor lineGrayColor];
        
        [sectionView addSubview:fahuishijian];
        [sectionView addSubview:wuliugongsi];
        [sectionView addSubview:lianxidianhua];
        [sectionView addSubview:wuliudanhao];
        [sectionView addSubview:fahuishijianValue];
        [sectionView addSubview:wuliugongsiValue];
        [sectionView addSubview:lianxidianhuaValue];
        [sectionView addSubview:wuliudanhaoValue];
        [sectionView addSubview:lineView];
        
        [fahuishijian mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(sectionView).offset(15);
        }];
        [wuliugongsi mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(fahuishijian);
            make.top.equalTo(fahuishijian.mas_bottom).offset(10);
        }];
        [lianxidianhua mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(fahuishijian);
            make.top.equalTo(wuliugongsi.mas_bottom).offset(10);
        }];
        [wuliudanhao mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(fahuishijian);
            make.top.equalTo(lianxidianhua.mas_bottom).offset(10);
        }];
        [fahuishijianValue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(fahuishijian.mas_right).offset(15);
            make.centerY.equalTo(fahuishijian.mas_centerY);
        }];
        [wuliugongsiValue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wuliugongsi.mas_right).offset(15);
            make.centerY.equalTo(wuliugongsi.mas_centerY);
        }];
        [lianxidianhuaValue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lianxidianhua.mas_right).offset(15);
            make.centerY.equalTo(lianxidianhua.mas_centerY);
        }];
        [wuliudanhaoValue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wuliudanhao.mas_right).offset(15);
            make.centerY.equalTo(wuliudanhao.mas_centerY);
        }];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(sectionView);
            make.height.mas_equalTo(@15);
        }];
        return sectionView;
    }else {
        
        return nil;
        
        
    }
}



- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}




@end











































































