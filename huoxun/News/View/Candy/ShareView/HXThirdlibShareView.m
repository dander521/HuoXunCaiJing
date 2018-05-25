//
//  HXThirdlibShareView.m
//  huoxun
//
//  Created by 倩倩 on 2018/3/12.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXThirdlibShareView.h"

@implementation HXThirdlibShareView

- (IBAction)touchActionButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(selectItemWithIndex:)]) {
        [self.delegate selectItemWithIndex:sender.tag];
    }
}

@end
