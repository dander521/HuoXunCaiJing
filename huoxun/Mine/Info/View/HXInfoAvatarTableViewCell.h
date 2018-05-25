//
//  HXInfoAvatarTableViewCell.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/6.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HXInfoAvatarTableViewCellDelegate <NSObject>

- (void)touchUploadUserAvatarButton;

@end

@interface HXInfoAvatarTableViewCell : TXSeperateLineCell
@property (weak, nonatomic) id <HXInfoAvatarTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
