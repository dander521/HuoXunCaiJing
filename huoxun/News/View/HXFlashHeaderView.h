//
//  HXFlashHeaderView.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/24.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HXFlashHeaderViewDelegate <NSObject>

- (void)touchMoreButton;

@end

@interface HXFlashHeaderView : UIView

@property (nonatomic, weak) id <HXFlashHeaderViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@end
