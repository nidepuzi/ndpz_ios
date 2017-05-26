//
//  JMFineCounpContentController.m
//  XLMM
//
//  Created by zhang on 17/4/2.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "JMFineCounpContentController.h"
#import "CSFineCounpContentCell.h"
#import "JMGoodsDetailController.h"
#import "JMReloadEmptyDataView.h"
#import "JMFineCouponModel.h"
#import "JMEmptyView.h"
#import "JMRootGoodsModel.h"
#import "CSShareManager.h"

@interface JMFineCounpContentController () <CSFineCounpContentCellDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,CSTableViewPlaceHolderDelegate> {
    NSString *_nextPageUrlString;
    NSMutableArray *_numArray;
}


@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) JMReloadEmptyDataView *reload;
@property (nonatomic, strong) JMEmptyView *empty;
//下拉的标志
@property (nonatomic) BOOL isPullDown;
//上拉的标志
@property (nonatomic) BOOL isLoadMore;
@property (nonatomic,strong) UIButton *topButton;
@property (nonatomic, strong) JMShareModel *shareModel;
@property (nonatomic, strong) CSSharePopController *sharPopVC;


@end

static NSString * JMFineCounpContentControllerIdentifier = @"JMFineCounpContentControllerIdentifier";

@implementation JMFineCounpContentController

#pragma mark 懒加载
- (CSSharePopController *)sharPopVC {
    if (!_sharPopVC) {
        _sharPopVC = [[CSSharePopController alloc] init];
    }
    return _sharPopVC;
}
- (JMShareModel *)shareModel {
    if (!_shareModel) {
        _shareModel = [[JMShareModel alloc] init];
    }
    return _shareModel;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
#pragma mark 生命周期函数
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createNavigationBarWithTitle:@"精品汇" selecotr:nil];
    [self createCollectionView];
    [self createTopButton];
    [self emptyView];
    [self createPullHeaderRefresh];
    [self createPullFooterRefresh];
    [self.collectionView.mj_header beginRefreshing];

}
- (void)refresh {
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mrak 刷新界面
- (void)createPullHeaderRefresh {
    kWeakSelf
    self.collectionView.mj_header = [MJAnimationHeader headerWithRefreshingBlock:^{
        _isPullDown = YES;
        [self.collectionView.mj_footer resetNoMoreData];
        [weakSelf loadDataSource];
    }];
}
- (void)createPullFooterRefresh {
    kWeakSelf
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _isLoadMore = YES;
        [weakSelf loadMore];
    }];
}
- (void)endRefresh {
    if (_isPullDown) {
        _isPullDown = NO;
        [self.collectionView.mj_header endRefreshing];
    }
    if (_isLoadMore) {
        _isLoadMore = NO;
        [self.collectionView.mj_footer endRefreshing];
    }
}


#pragma mark 网络请求,数据处理
- (void)loadShareData:(NSString *)urlString {
    [MBProgressHUD showLoading:@"正在分享..."];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:[urlString JMUrlEncodedString] WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        self.shareModel = [JMShareModel mj_objectWithKeyValues:responseObject];
        self.shareModel.share_type = @"link";
        self.sharPopVC.popViewHeight = kAppShareEarningViewHeight;
        self.sharPopVC.model = self.shareModel;
        [MBProgressHUD hideHUD];
        [self popShareView:kAppShareEarningViewHeight];
    } WithFail:^(NSError *error) {
        [MBProgressHUD showError:@"分享失败"];
    } Progress:^(float progress) {
    }];
}

- (void)loadSharDataWithHour:(NSString *)urlString {
    [MBProgressHUD showLoading:@"正在分享..."];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        NSDictionary *shopInfo = responseObject[@"shop_info"];
        self.shareModel.share_type = @"link";
        self.shareModel.share_img = [shopInfo objectForKey:@"thumbnail"]; //图片
        self.shareModel.desc = [shopInfo objectForKey:@"desc"]; // 文字详情
        self.shareModel.title = [shopInfo objectForKey:@"name"]; //标题
        self.shareModel.share_link = [shopInfo objectForKey:@"shop_link"];
        self.sharPopVC.popViewHeight = kAppShareViewHeight;
        self.sharPopVC.model = self.shareModel;
        [MBProgressHUD hideHUD];
        [self popShareView:kAppShareViewHeight];
    } WithFail:^(NSError *error) {
        [MBProgressHUD showError:@"分享失败"];
    } Progress:^(float progress) {
        
    }];
}
#pragma mark 弹出视图 (弹出分享界面)
- (void)popShareView:(CGFloat)popHeeight {
    [[CSShareManager manager] showSharepopViewController:self.sharPopVC withRootViewController:self WithBlock:^(BOOL dismiss) {
        
    }];
    
}
- (void)loadDataSource {
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:self.urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject)return ;
//        NSLog(@"%@",responseObject);
        self.empty.hidden = YES;
        [self.dataSource removeAllObjects];
        [self fatchClassifyListData:responseObject];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        self.empty.hidden = NO;
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
    
}
- (void)loadMore {
    if ([NSString isStringEmpty:_nextPageUrlString]) {
        [self endRefresh];
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:_nextPageUrlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return;
        [self fatchClassifyListMoreData:responseObject];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}

- (void)fatchClassifyListData:(NSDictionary *)itemDic {
    _nextPageUrlString = itemDic[@"next"];
    NSArray *resultsArr = itemDic[@"results"];
    if (resultsArr.count != 0) {
        for (NSDictionary *dic in resultsArr) {
            JMFineCouponModel *model = [JMFineCouponModel mj_objectWithKeyValues:dic];
            [self.dataSource addObject:model];
        }
    }
    [self.collectionView cs_reloadData];
}
- (void)fatchClassifyListMoreData:(NSDictionary *)itemDic {
    _nextPageUrlString = itemDic[@"next"];
    NSArray *resultsArr = itemDic[@"results"];
    if (resultsArr.count != 0) {
        _numArray = [NSMutableArray array];
        
        for (NSDictionary *dic in resultsArr) {
            NSIndexPath *index ;
            index = [NSIndexPath indexPathForRow:self.dataSource.count inSection:0];
            JMFineCouponModel *model = [JMFineCouponModel mj_objectWithKeyValues:dic];
            [self.dataSource addObject:model];
            [_numArray addObject:index];
        }
        if((_numArray != nil) && (_numArray.count > 0)){
            @try{
                [self.collectionView insertItemsAtIndexPaths:_numArray];
                [_numArray removeAllObjects];
                _numArray = nil;
            }
            @catch(NSException *except)
            {
                NSLog(@"DEBUG: failure to batch update.  %@", except.description);
            }
        }
    }
    [self.collectionView cs_reloadData];
}
- (void)createCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64 - 45 - kAppTabBarHeight) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[CSFineCounpContentCell class] forCellWithReuseIdentifier:JMFineCounpContentControllerIdentifier];
    
}
- (void)emptyView {
    kWeakSelf
    self.empty = [[JMEmptyView alloc] initWithFrame:CGRectMake(0, (SCREENHEIGHT - 300) / 2 - 45, SCREENWIDTH, 300) Title:@"~~(>_<)~~" DescTitle:@"网络加载失败~!" BackImage:@"netWaring" InfoStr:@"重新加载"];
    [self.view addSubview:self.empty];
    self.empty.hidden = YES;
    self.empty.block = ^(NSInteger index) {
        if (index == 100) {
            weakSelf.empty.hidden = YES;
            [weakSelf refresh];
        }
    };
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CSFineCounpContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JMFineCounpContentControllerIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    JMFineCouponModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake((SCREENWIDTH - 15) * 0.5, (SCREENWIDTH - 15) * 0.5 * 8/6 + 60);
    return CGSizeMake(SCREENWIDTH, 175);
}


// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JMFineCouponModel *model = self.dataSource[indexPath.row];
    NSString *goodsID = model.fineCouponModelID;
    
    JMGoodsDetailController *detailVC = [[JMGoodsDetailController alloc] init];
    detailVC.goodsID = goodsID;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

#pragma mark CSFineCounpContentCellDelegate 点击事件
- (void)composeHourCell:(CSFineCounpContentCell *)cell Model:(JMFineCouponModel *)model ButtonClick:(UIButton *)button {
    NSInteger mobClickIndex = button.tag - 100;
    NSArray *itemArr = @[@"分享素材",@"单品分享",@"店铺分享"];
    NSDictionary *tempDict = @{@"code" : [NSString stringWithFormat:@"%@",itemArr[mobClickIndex]]};
    [MobClick event:@"JMHomeHourCell_ButtonClickIndex" attributes:tempDict];
    
    if (button.tag == 100) {
        JMGoodsDetailController *detailVC = [[JMGoodsDetailController alloc] init];
        detailVC.goodsID = model.fineCouponModelID;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else if (button.tag == 101) {
        NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/share/model?model_id=%@",Root_URL,model.fineCouponModelID];
        [self loadShareData:urlString];
    }else {
        NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/pmt/cushop/customer_shop", Root_URL];
        [self loadSharDataWithHour:urlString];
    }
}









- (UIView *)createPlaceHolderView {
    return self.reload;
}
- (JMReloadEmptyDataView *)reload {
    if (!_reload) {
        __block JMReloadEmptyDataView *reload = [[JMReloadEmptyDataView alloc] initWithFrame:CGRectMake(0, 100, 0, 0) Title:@"暂时没有商品哦~" DescTitle:@"" ButtonTitle:@"" Image:@"data_empty" ReloadBlcok:^{
//            [self.navigationController popViewControllerAnimated:YES];
        }];
        _reload = reload;
    }
    return _reload;
}

//- (void)emptyView {
//    kWeakSelf
//    JMEmptyView *empty = [[JMEmptyView alloc] initWithFrame:CGRectMake(0, 120, SCREENWIDTH, SCREENHEIGHT - 120) Title:@"暂时没有商品哦~" DescTitle:@"" BackImage:@"emptyGoods" InfoStr:@"查看其它分类"];
//    [self.view addSubview:empty];
//    empty.block = ^(NSInteger index) {
//        if (index == 100) {
//            [weakSelf.navigationController popViewControllerAnimated:YES];
//        }
//    };
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.topButton.hidden = scrollView.contentOffset.y > SCREENHEIGHT * 2 ? NO : YES;
}
#pragma mark -- 添加返回顶部按钮
- (void)createTopButton {
    UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:topButton];
    self.topButton = topButton;
    [self.topButton addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view).offset(-70);
        make.width.height.mas_equalTo(@50);
    }];
    //    self.topButton.frame = CGRectMake(SCREENWIDTH - 70, SCREENHEIGHT - 70, 50, 50);
    [self.topButton setImage:[UIImage imageNamed:@"backTop"] forState:UIControlStateNormal];
    self.topButton.hidden = YES;
    [self.topButton bringSubviewToFront:self.view];
    
}
- (void)topButtonClick:(UIButton *)btn {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    self.topButton.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[JMGlobal global] clearAllSDCache];
}

//- (void)emptyView {
//    JMEmptyGoodsView *empty = [[JMEmptyGoodsView alloc] initWithFrame:CGRectMake(0, 99, SCREENWIDTH, SCREENHEIGHT - 99)];
//    [self.view addSubview:empty];
//    empty.block = ^(NSInteger index) {
//        if (index == 100) {
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }
//    };
//
//}









@end
