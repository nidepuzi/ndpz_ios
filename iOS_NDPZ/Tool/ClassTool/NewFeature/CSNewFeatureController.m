//
//  CSNewFeatureController.m
//  iOS_NDPZ
//
//  Created by zhang on 17/4/26.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSNewFeatureController.h"
#import "CSNewFeatureCell.h"

@interface CSNewFeatureController () <CSNewFeatureCellDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate> {
    NSMutableArray *dataArr;
    NSInteger showIndex;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, weak) UIPageControl *control;

@end

@implementation CSNewFeatureController

static NSString * const reuseIdentifier = @"CSNewFeatureCellIdentifier";


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    dataArr = [NSMutableArray array];
    NSArray *imageStrArr = @[@"newFeature_01"];
    for (int i = 0; i < imageStrArr.count; i++) {
        UIImage *imagev = [UIImage imageNamed:imageStrArr[i]];
        [dataArr addObject:imagev];
    }
    showIndex = dataArr.count;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(SCREENWIDTH, SCREENHEIGHT);
    layout.minimumInteritemSpacing = 0.0f;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH , SCREENHEIGHT) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerClass:[CSNewFeatureCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.contentSize = CGSizeMake(SCREENWIDTH * showIndex, SCREENHEIGHT);
    self.collectionView.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:_collectionView];
    
   
    // 添加pageController
    [self setUpPageControl];
}

// 添加pageController
- (void)setUpPageControl
{
    // 添加pageController,只需要设置位置，不需要管理尺寸
    UIPageControl *control = [[UIPageControl alloc] init];
    
    control.numberOfPages = showIndex;
    control.pageIndicatorTintColor = [UIColor blackColor];
    control.currentPageIndicatorTintColor = [UIColor redColor];
    
    // 设置center
    control.center = CGPointMake(self.view.cs_w * 0.5, self.view.cs_h - 20);
    _control = control;
    [self.view addSubview:control];
    
    if (showIndex == 1) {
        control.hidden = YES;
    }
    
    
    
}

#pragma mark - UIScrollView代理
// 只要一滚动就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 获取当前的偏移量，计算当前第几页
    int page = scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5;
    
    // 设置页数
    _control.currentPage = page;
}


#pragma mark - UICollectionView代理和数据源
//返回 第section组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return dataArr.count;
}
//返回有多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}
//返回cell的样式
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //dequeueReusableCellWithReuseIdentifier 的底层会做哪些事情
    //首先从缓存池里面取出cell
    //看下当前是否有注册cell,如果注册了cell,就会帮你创建cell
    //没有注册就报错
    CSNewFeatureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    //给cell传值
    
    cell.delegate = self;
    //拼接图片名称
    // 拼接图片名称 3.5 320 480
//    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
//    NSString *imageName = [NSString stringWithFormat:@"new_feature_%ld",indexPath.row + 1];
//    if (screenH > 480) { // 5 , 6 , 6 plus
//        imageName = [NSString stringWithFormat:@"new_feature_%ld-568h",indexPath.row + 1];
//    }
    cell.image = dataArr[indexPath.row];
    
    
    [cell setIndexPath:indexPath count:showIndex];
    
    
    return cell;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREENWIDTH, SCREENHEIGHT);
}
//每一个分组的上左下右间距

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}
- (void)composeNewFeatureStartClick:(UIButton *)button {
    
    [self dismissViewControllerAnimated:NO completion:^{
        NSLog(@"隐藏了???????");
        [JMNotificationCenter postNotificationName:@"showNewFeatureView" object:nil];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end






















































