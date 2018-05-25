//
//  HXMultiView.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/25.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXMultiView.h"

@implementation HXMultiView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.inputTF.layer.borderWidth = 1.f;
    self.inputTF.layer.cornerRadius = 7.f;
    self.inputTF.layer.borderColor = RGB(229, 229, 229).CGColor;
    self.inputTF.layer.masksToBounds = YES;
}

- (IBAction)touchInputButton:(id)sender {
    [self.delegate selectInputButton];
}

- (IBAction)touchCommentButton:(id)sender {
    [self.delegate selectCommentButton];
}

- (IBAction)touchCollectionButton:(id)sender {
    [self.delegate selectCollectionButton];
}

- (IBAction)touchShareButton:(id)sender {
    [self.delegate selectShareButton];
}

@end
