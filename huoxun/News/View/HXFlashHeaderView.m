//
//  HXFlashHeaderView.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/24.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXFlashHeaderView.h"

@implementation HXFlashHeaderView

- (IBAction)touchCheckMoreButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchMoreButton)]) {
        [self.delegate touchMoreButton];
    }
}

@end
