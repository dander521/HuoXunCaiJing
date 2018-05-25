//
//  HXThirdlibShareView.h
//  huoxun
//
//  Created by 倩倩 on 2018/3/12.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HXThirdlibShareViewDelegate <NSObject>

- (void)selectItemWithIndex:(NSInteger)index;

@end

@interface HXThirdlibShareView : UIView

@property (nonatomic, weak) id <HXThirdlibShareViewDelegate> delegate;

@end
