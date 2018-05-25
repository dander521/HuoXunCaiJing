//
//  HXCommentTableViewCell.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/25.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXCommentModel.h"

@class HXCommentTableViewCell;

@protocol HXCommentTableViewCellDelegate <NSObject>

- (void)selectCommentPraiseButtonWithModel:(HXCommentModel *)model cell:(HXCommentTableViewCell *)cell;

@end

@interface HXCommentTableViewCell : UITableViewCell

@property (nonatomic, weak) id <HXCommentTableViewCellDelegate> delegate;
@property (nonatomic, strong) HXCommentModel *model;
@property (weak, nonatomic) IBOutlet UILabel *praiseLabel;
@property (weak, nonatomic) IBOutlet UIImageView *praiseImageView;
+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
