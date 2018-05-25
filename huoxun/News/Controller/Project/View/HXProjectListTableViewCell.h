//
//  HXProjectListTableViewCell.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/5.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXProjectModel.h"

@protocol HXProjectListTableViewCellDelegate <NSObject>

- (void)touchCheckProjectWithModel:(HXProjectModel *)model;

- (void)touchWhitePaperProjectWithModel:(HXProjectModel *)model;

@end

@interface HXProjectListTableViewCell : TXSeperateLineCell

@property (nonatomic, weak) id <HXProjectListTableViewCellDelegate> delegate;
@property (nonatomic, strong) HXProjectModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
