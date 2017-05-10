//
//  JMRootTabBarController.m
//  XLMM
//
//  Created by zhang on 16/11/25.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMRootTabBarController.h"
#import "RootNavigationController.h"
#import "JMLogInViewController.h"
#import "CSCustomeServiceController.h"
#import "CSTrainingController.h"
#import "CSProfileShopController.h"
#import "JMHomePageController.h"
#import "CSPopAnimationViewController.h"

#define kClassKey   @"rootVCClassString"
#define kTitleKey   @"title"
#define kImgKey     @"imageName"
#define kSelImgKey  @"selectedImageName"

@interface JMRootTabBarController () <UITabBarControllerDelegate,UITabBarDelegate>

@property (nonatomic, strong) NSMutableArray *vcArray;



@property (nonatomic, strong) UIButton *bageButton;

@end

@implementation JMRootTabBarController

- (NSMutableArray *)vcArray {
    if (!_vcArray) {
        _vcArray = [NSMutableArray array];
    }
    return _vcArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)dealloc {
    [JMNotificationCenter removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];

//    [JMNotificationCenter addObserver:self selector:@selector(setLabelNumber) name:@"logout" object:nil];
//    [JMNotificationCenter addObserver:self selector:@selector(requestCartNumber:) name:@"shoppingCartNumChange" object:nil];
    [JMNotificationCenter addObserver:self selector:@selector(shoppingCartkuaiquguangguang) name:@"kuaiquguangguangButtonClick" object:nil];
    [JMNotificationCenter addObserver:self selector:@selector(phoneNumberLogin) name:@"phoneNumberLogin" object:nil];
    [JMNotificationCenter addObserver:self selector:@selector(WeChatLoginNoti) name:@"WeChatLoginSuccess" object:nil];
    [JMNotificationCenter addObserver:self selector:@selector(notificationJump:) name:@"notificationJump" object:nil];
    
    
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isRefreshFine"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.delegate = self;
    NSArray *childItemsArray = @[
                                 @{kClassKey  : @"JMHomePageController",
                                   kTitleKey  : @"选品",
                                   kImgKey    : @"tabBar_homeRoot_xuanpin",
                                   kSelImgKey : @"tabBar_homeRoot_xuanpin_selected"},
                                 
                                 @{kClassKey  : @"CSTrainingController",
                                   kTitleKey  : @"培训",
                                   kImgKey    : @"tabBar_homeRoot_share",
                                   kSelImgKey : @"tabBar_homeRoot_share_selected"},
                                 
                                 @{kClassKey  : @"CSProfileShopController",
                                   kTitleKey  : @"店铺",
                                   kImgKey    : @"tabBar_homeRoot_shop",
                                   kSelImgKey : @"tabBar_homeRoot_shop_selected"},
                                 
                                 @{kClassKey  : @"CSCustomeServiceController",
                                   kTitleKey  : @"客服",
                                   kImgKey    : @"tabBar_homeRoot_kefu",
                                   kSelImgKey : @"tabBar_homeRoot_kefu_selected"} ];
    
    [childItemsArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        UIViewController *vc = [NSClassFromString(dict[kClassKey]) new];
        [self.vcArray addObject:vc];
        vc.title = dict[kTitleKey];
        RootNavigationController *nav = [[RootNavigationController alloc] initWithRootViewController:vc];
        UITabBarItem *item = vc.tabBarItem;
        item.tag = idx;
        item.title = dict[kTitleKey];
        item.image = [[UIImage imageNamed:dict[kImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = [[UIImage imageNamed:dict[kSelImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHex:0xff5000]} forState:UIControlStateSelected];
        [self addChildViewController:nav];
        
    }];
    self.selectedIndex = 0;
  
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if ([viewController.tabBarItem.title isEqualToString:@"选品"]) {
        
    }else if ([viewController.tabBarItem.title isEqualToString:@"培训"]) {
    }else if ([viewController.tabBarItem.title isEqualToString:@"客服"]) {
    }else if ([viewController.tabBarItem.title isEqualToString:@"店铺"]) {
        if ([JMUserDefaults boolForKey:kIsLogin]) {
        }else {
        }
    }else { }
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([viewController.tabBarItem.title isEqualToString:@"店铺"]) {
//        if ([JMUserDefaults boolForKey:kIsLogin]) {
//            if (![JMUserDefaults boolForKey:kISXLMM]) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"小鹿提醒" message:@"您暂时还不是小鹿妈妈哦~ 请关注 \"小鹿美美\" 公众号,获取更多信息 " delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alert show];
//                return NO;
//            }
//            [MobClick event:@"tabBarWithFine"];
            return YES;
//        }else {
//            [[JMGlobal global] showLoginViewController];
//            return NO;
//        }
    }else if ([viewController.tabBarItem.title isEqualToString:@"选品"]) {
        [MobClick event:@"tabBarWithHomeRoot"];
        return YES;
    }else if ([viewController.tabBarItem.title isEqualToString:@"培训"]) {
        [MobClick event:@"tabBarWithMineCategory"];
        return YES;
    }
    else if ([viewController.tabBarItem.title isEqualToString:@"客服"]) {
//        if ([JMUserDefaults boolForKey:kIsLogin]) {
//            [MobClick event:@"tabBarWithMine"];
            return YES;
//        }else {
//            [[JMGlobal global] showLoginViewController];
//            return NO;
//        }
    }else {
        return YES;
    }
  
}
- (void)shoppingCartkuaiquguangguang {
    self.selectedIndex = 0;
}
- (void)phoneNumberLogin {
    self.selectedIndex = 0;
}
- (void)WeChatLoginNoti {
    self.selectedIndex = 0;
}
- (void)notificationJump:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    self.selectedIndex = [dic[@"selectedIndex"] integerValue];
}
#pragma mark --- 购物车数量 ---
//- (void)setLabelNumber {
//    //    [self requestCartNumber];
////    self.cartVC.tabBarItem.badgeValue = nil;
//}
//
//- (void)requestCartNumber:(NSNotification *)dict {
//    NSString *typeS;
//    //    if (dict == nil) {
//    typeS = @"5";
//    //    }else {
//    //        typeS = dict.userInfo[@"type"];
//    //    }
//    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/carts/show_carts_num.json?type=%@",Root_URL,typeS];
//    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
//        if (!responseObject) return;
//        [self fetchData:responseObject];
//    } WithFail:^(NSError *error) {
//    } Progress:^(float progress) {
//        
//    }];
//    
//    
//}
//- (void)fetchData:(NSDictionary *)dict {
//    NSString *cartNum = dict[@"result"];
//    if ([cartNum integerValue] == 0) {
////        self.cartVC.tabBarItem.badgeValue = nil;
//    }else {
//        //        self.cartVC.tabBarItem.badgeColor = [UIColor buttonEnabledBackgroundColor];
////        self.cartVC.tabBarItem.badgeValue = CS_STRING(cartNum);
//    }
//}



@end


















































