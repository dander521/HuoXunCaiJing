//
//  HXAuthorHeaderTableViewCell.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/6.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXAuthorModel.h"

@protocol HXAuthorHeaderTableViewCellDelegate <NSObject>

- (void)selectArticleButton;
- (void)selectAttentionButton;
- (void)selectFansButton;

@end

@interface HXAuthorHeaderTableViewCell : UITableViewCell

@property (nonatomic, strong) HXAuthorModel *model;
@property (nonatomic, weak) id <HXAuthorHeaderTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *articleLabel;
@property (weak, nonatomic) IBOutlet UILabel *attentionLabel;
@property (weak, nonatomic) IBOutlet UILabel *funsLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
