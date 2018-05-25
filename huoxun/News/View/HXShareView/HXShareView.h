//
//  HXShareView.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/24.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HXShareViewType) {
    HXShareViewTypeWechat = 1,
    HXShareViewTypeFriend,
    HXShareViewTypeQQ,
    HXShareViewTypeQQZone,
    HXShareViewTypeCopy,
    HXShareViewTypeSafari,
    HXShareViewTypeCancel,
    HXShareViewTypeMail
};

typedef NS_ENUM(NSInteger, HXShareViewInterfaceType) {
    HXShareViewInterfaceTypeNews,
    HXShareViewInterfaceTypeFlash
};

@protocol HXShareViewDelegate <NSObject>

- (void)touchShareButtonWithType:(HXShareViewType)type;

@end

@interface HXShareView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, assign) HXShareViewInterfaceType interfaceType;
@property (nonatomic, weak) id <HXShareViewDelegate> delegate;

+ (instancetype)shareInstanceManager;

- (void)show;

- (void)hide;

@end
