//
//  HXFlashListTableViewCell.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/6.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXFlashModel.h"

@protocol HXFlashListTableViewCellDelegate <NSObject>

- (void)touchShareContentButtonWithModel:(HXFlashModel *)model;

@end

@interface HXFlashListTableViewCell : UITableViewCell

@property (nonatomic, strong) HXFlashModel *model;
@property (nonatomic, weak) id <HXFlashListTableViewCellDelegate> delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
