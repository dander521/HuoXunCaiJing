//
//  HXMultiView.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/25.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HXMultiViewDelegate <NSObject>

- (void)selectInputButton;

- (void)selectCommentButton;

- (void)selectCollectionButton;

- (void)selectShareButton;

@end

@interface HXMultiView : UIView

@property (nonatomic, weak) id <HXMultiViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *inputTF;
@property (weak, nonatomic) IBOutlet UIButton *inputButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *collectionButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@end
