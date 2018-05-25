//
//  HXShowTopView.m
//  huoxun
//
//  Created by 倩倩 on 2018/3/18.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXShowTopView.h"

@implementation HXShowTopView

- (void)show {
    [UIView beginAnimations:@"show" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.3];
    self.frame = CGRectMake(0, kTopHeight, [UIScreen mainScreen].bounds.size.width, 30);
    [UIView commitAnimations];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self hide];
    });
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
