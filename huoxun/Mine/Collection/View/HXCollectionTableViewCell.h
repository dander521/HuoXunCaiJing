//
//  HXCollectionTableViewCell.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/6.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXNewsModel.h"

@protocol HXCollectionTableViewCellDelegate <NSObject>

- (void)selectCancelButtonWithModel:(HXNewsModel *)model;

@end

@interface HXCollectionTableViewCell : TXSeperateLineCell

@property (weak, nonatomic) id <HXCollectionTableViewCellDelegate>delegate;
@property (nonatomic, strong) HXNewsModel *model;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
