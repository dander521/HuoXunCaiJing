//
//  HXFlashShowView.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/25.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXFlashShowView.h"

@interface HXFlashShowView ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UITextView *contentTV;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation HXFlashShowView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.cornerRadius = 10;
    self.bgView.layer.masksToBounds = true;
    self.contentTV.editable = false;
    self.contentTV.selectable = false;
}

+ (instancetype)shareInstanceManager {
    HXFlashShowView *instance = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    return instance;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        //代码
        self.frame = CGRectMake(0, 322, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        //        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestrueMethod:)];
        //        tapGesture.delegate = self;
        //        tapGesture.numberOfTapsRequired = 1;
        //        [self addGestureRecognizer:tapGesture];
    }
    
    return self;
}

// 点击背景
- (void)tapGestrueMethod:(UITapGestureRecognizer *)gesture {
    [self hide];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view.tag == 100) {
        return false;
    }
    return true;
}

- (void)show {
    [self showInView:[UIApplication sharedApplication].keyWindow];
}

// 添加弹出移除的动画效果
- (void)showInView:(UIView *)view {
    // 浮现
    [UIView animateWithDuration:0.25 animations:^{
        //        self.backgroundColor = RGBA(0, 0, 0, 0.0);
        CGPoint point = self.center;
        point.y -= 322;
        self.center = point;
    } completion:^(BOOL finished) {
        //        self.backgroundColor = RGBA(0, 0, 0, 0.3);
    }];
    [view addSubview:self];
}

- (void)hide {
    //    self.backgroundColor = RGBA(0, 0, 0, 0.0);
    [UIView animateWithDuration:0.25 animations:^{
        CGPoint point = self.center;
        self.alpha = 0;
        point.y += 322;
        self.center = point;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)setModel:(HXFlashModel *)model {
    _model = model;
    
    self.timeLabel.text = model.create_time_format;
    self.contentTV.attributedText = [TXCustomTools getAttributedStringWithLineSpace:model.des lineSpace:8 kern:1];
}

- (IBAction)touchCloseButton:(id)sender {
    [self hide];
}
- (IBAction)touchShareButton:(id)sender {
    [self.delegate touchShareButtonWithModel:self.model];
}

@end
