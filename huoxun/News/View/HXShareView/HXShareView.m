//
//  HXShareView.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/24.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXShareView.h"

@interface HXShareView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLayout;

@property (weak, nonatomic) IBOutlet UIView *newsView;

@end

@implementation HXShareView

+ (instancetype)shareInstanceManager {
    HXShareView *instance = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    return instance;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        //代码
        self.frame = CGRectMake(0, 322, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestrueMethod:)];
        tapGesture.delegate = self;
        tapGesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGesture];
    }
    
    return self;
}

// 点击背景
- (void)tapGestrueMethod:(UITapGestureRecognizer *)gesture {
    [self hide];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view.tag == 100 || touch.view.tag == 101 || touch.view.tag == 102) {
        return false;
    }
    return true;
}

- (void)setInterfaceType:(HXShareViewInterfaceType)interfaceType {
    _interfaceType = interfaceType;
    
    if (interfaceType == HXShareViewInterfaceTypeFlash) {
        [self.newsView removeFromSuperview];
        self.heightLayout.constant = 145.5;
    } else {
        self.heightLayout.constant = 251.0;
    }
}

- (void)show {
    [self showInView:[UIApplication sharedApplication].keyWindow];
}

// 添加弹出移除的动画效果
- (void)showInView:(UIView *)view {
    // 浮现
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0.0);
        CGPoint point = self.center;
        point.y -= 322;
        self.center = point;
    } completion:^(BOOL finished) {
        self.backgroundColor = RGBA(0, 0, 0, 0.3);
    }];
    [view addSubview:self];
}

- (void)hide {
    self.backgroundColor = RGBA(0, 0, 0, 0.0);
    [UIView animateWithDuration:0.25 animations:^{
        CGPoint point = self.center;
        self.alpha = 0;
        point.y += 322;
        self.center = point;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)touchActionButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(touchShareButtonWithType:)]) {
        [self.delegate touchShareButtonWithType:sender.tag];
    }
}

@end
