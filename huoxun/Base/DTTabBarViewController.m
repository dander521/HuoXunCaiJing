//
//  DTTabBarViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/12.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTTabBarViewController.h"
#import "DTNavigationViewController.h"
#import "HXNewsViewController.h"
#import "HXFlashViewController.h"
#import "HXMarketViewController.h"
#import "HXMineViewController.h"
#import "ScrollTabBarDelegate.h"

@interface DTTabBarViewController ()

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) NSInteger subViewControllerCount;
@property (nonatomic, strong) ScrollTabBarDelegate *tabBarDelegate;

@end

@implementation DTTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *dictTitle = [NSDictionary dictionaryWithObject:RGB(246, 30, 46) forKey:NSForegroundColorAttributeName];
    
    // 新闻
    HXNewsViewController *vwcNews = [[HXNewsViewController alloc] init];
    vwcNews.title = @"新闻";
    DTNavigationViewController *vwcNavNews = [[DTNavigationViewController alloc] initWithRootViewController:vwcNews];
    vwcNavNews.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"新闻"
                                                           image:[UIImage imageNamed:@"xinwen"]
                                                   selectedImage:[UIImage imageNamed:@"xinwen_cur"]];
    [vwcNavNews.tabBarItem setTitleTextAttributes:dictTitle forState:UIControlStateSelected];
    
    // 快讯
    HXFlashViewController *vwcFlash = [[HXFlashViewController alloc] init];
    vwcFlash.title = @"快讯";
    DTNavigationViewController *vwcNavFlash = [[DTNavigationViewController alloc] initWithRootViewController:vwcFlash];
    vwcNavFlash.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"快讯"
                                                          image:[UIImage imageNamed:@"kuaixun"]
                                                  selectedImage:[UIImage imageNamed:@"kuaixun_cur"]];
    [vwcNavFlash.tabBarItem setTitleTextAttributes:dictTitle forState:UIControlStateSelected];

    // 行情
    HXMarketViewController *vwcMarket = [[HXMarketViewController alloc] init];
    vwcMarket.title = @"行情";
    DTNavigationViewController *vwcNavMarket = [[DTNavigationViewController alloc] initWithRootViewController:vwcMarket];
    vwcNavMarket.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"行情"
                                                          image:[UIImage imageNamed:@"hangqing"]
                                                  selectedImage:[UIImage imageNamed:@"hangqing_cur"]];
    [vwcNavMarket.tabBarItem setTitleTextAttributes:dictTitle forState:UIControlStateSelected];

    // 我的
    HXMineViewController *vwcMine = [[HXMineViewController alloc] init];
    vwcMine.title = @"我的";
    DTNavigationViewController *vwcNavMine = [[DTNavigationViewController alloc] initWithRootViewController:vwcMine];
    vwcNavMine.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的"
                                                          image:[UIImage imageNamed:@"my"]
                                                  selectedImage:[UIImage imageNamed:@"my_cur"]];
   [vwcNavMine.tabBarItem setTitleTextAttributes:dictTitle forState:UIControlStateSelected];


    self.viewControllers = @[vwcNavNews, vwcNavFlash, vwcNavMarket, vwcNavMine];
//    [self addScrollTabBar];
}

/**
 添加滑动逻辑
 */
- (void)addScrollTabBar {
    // 正确的给予 count
    self.subViewControllerCount = self.viewControllers ? self.viewControllers.count : 0;
    // 代理
    self.tabBarDelegate = [[ScrollTabBarDelegate alloc] init];
    self.delegate = self.tabBarDelegate;
    // 增加滑动手势
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandle:)];
    [self.view addGestureRecognizer:self.panGesture];
}

- (void)panHandle:(UIPanGestureRecognizer *)panGesture {
    // 获取滑动点
    CGFloat translationX = [panGesture translationInView:self.view].x;
    CGFloat progress = fabs(translationX)/self.view.frame.size.width;
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.tabBarDelegate.interactive = YES;
            CGFloat velocityX = [panGesture velocityInView:self.view].x;
            if (velocityX < 0) {
                if (self.selectedIndex < self.subViewControllerCount - 1) {
                    self.selectedIndex += 1;
                }
            }
            else {
                if (self.selectedIndex > 0) {
                    self.selectedIndex -= 1;
                }
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self.tabBarDelegate.interactionController updateInteractiveTransition:progress];
        }
            
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        {
            if (progress > 0.3) {
                self.tabBarDelegate.interactionController.completionSpeed = 0.99;
                [self.tabBarDelegate.interactionController finishInteractiveTransition];
            }else{
                //转场取消后，UITabBarController 自动恢复了 selectedIndex 的值，不需要我们手动恢复。
                self.tabBarDelegate.interactionController.completionSpeed = 0.99;
                [self.tabBarDelegate.interactionController cancelInteractiveTransition];
            }
            self.tabBarDelegate.interactive = NO;
        }
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
