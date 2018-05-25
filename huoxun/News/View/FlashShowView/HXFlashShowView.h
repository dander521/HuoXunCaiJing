//
//  HXFlashShowView.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/25.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXFlashModel.h"

@protocol HXFlashShowViewDelegate <NSObject>

- (void)touchShareButtonWithModel:(HXFlashModel *)model;

@end


@interface HXFlashShowView : UIView

@property (nonatomic, weak) id <HXFlashShowViewDelegate> delegate;

@property (nonatomic, strong) HXFlashModel *model;

+ (instancetype)shareInstanceManager;

- (void)show;

- (void)hide;

@end
