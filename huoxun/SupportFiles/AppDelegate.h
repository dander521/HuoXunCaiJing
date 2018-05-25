//
//  AppDelegate.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/4.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXLoginViewController.h"
#import "DTTabBarViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) DTTabBarViewController *tabBar;
+ (instancetype)sharedAppDelegate;

@end

