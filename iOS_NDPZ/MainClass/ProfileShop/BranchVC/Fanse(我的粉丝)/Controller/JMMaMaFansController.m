//
//  JMMaMaFansController.m
//  XLMM
//
//  Created by zhang on 17/4/1.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "JMMaMaFansController.h"
#import "UIImage+UIImageExt.h"
#import "JMNowFansController.h"
#import "JMAboutFansController.h"
#import "HMSegmentedControl.h"

@interface JMMaMaFansController () <UIScrollViewDelegate> {
    NSArray *_itemArr;
    NSArray *_itemIndexArr;
}
@property (nonatomic, strong) HMSegmentedControl *segmentControl;
@property (nonatomic, strong) UIScrollView *baseScrollView;

@end

@implementation JMMaMaFansController
#pragma mark 懒加载
- (HMSegmentedControl *)segmentControl {
    if (!_segmentControl) {
        _segmentControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 45)];
        _segmentControl.backgroundColor = [UIColor whiteColor];
        self.segmentControl.sectionTitles = _itemArr;
        _segmentControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentControl.selectionIndicatorHeight = 2.f;
        _segmentControl.selectionIndicatorColor = [UIColor buttonEnabledBackgroundColor];
        _segmentControl.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14.],
                                                NSForegroundColorAttributeName : [UIColor blackColor]};
        _segmentControl.selectedTitleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:15.],
                                                        NSForegroundColorAttributeName : [UIColor buttonEnabledBackgroundColor]};
        [_segmentControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentControl;
}
- (UIScrollView *)baseScrollView {
    if (!_baseScrollView) {
        _baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentControl.frame), SCREENWIDTH, SCREENHEIGHT - CGRectGetMaxY(self.segmentControl.frame))];
        _baseScrollView.showsHorizontalScrollIndicator = NO;
        _baseScrollView.showsVerticalScrollIndicator = NO;
        _baseScrollView.pagingEnabled = YES;
        _baseScrollView.delegate = self;
    }
    return _baseScrollView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"今日粉丝" selecotr:@selector(backClick)];
    _itemArr = @[@"正式粉丝",@"转正粉丝",@"试用粉丝",@"冻结粉丝"];
    _itemIndexArr = @[@"2",@"3",@"1",@"4"];
    [self.view addSubview:self.segmentControl];
    _segmentControl.selectedSegmentIndex = 0;
    [self.view addSubview:self.baseScrollView];
    [self addChildController];
    [self removeToPage:0];

}
- (void)addChildController {
    for (int i = 0 ; i < _itemArr.count; i++) {
        JMNowFansController *nowFansVC = [[JMNowFansController alloc] init];
        nowFansVC.urlString = [NSString stringWithFormat:@"%@/rest/v1/pmt/xlmm/get_today_referal_mama?type=%@",Root_URL,_itemIndexArr[i]];
        [self addChildViewController:nowFansVC];
    }
    self.baseScrollView.contentSize = CGSizeMake(SCREENWIDTH * _itemArr.count, self.baseScrollView.frame.size.height);
}
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    NSInteger page = segmentedControl.selectedSegmentIndex;
    [self removeToPage:page];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    //    _lastSelectedIndex = (int)page;
    [self.segmentControl setSelectedSegmentIndex:page animated:YES];
    [self removeToPage:page];
    
}
- (void)removeToPage:(NSInteger)index {
    self.baseScrollView.contentOffset = CGPointMake(SCREENWIDTH * index, 0);
    JMNowFansController *nowFansVC = self.childViewControllers[index];
    nowFansVC.view.frame = self.baseScrollView.bounds;
    [self.baseScrollView addSubview:nowFansVC.view];
    [nowFansVC didMoveToParentViewController:self];
}


- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}


@end






















