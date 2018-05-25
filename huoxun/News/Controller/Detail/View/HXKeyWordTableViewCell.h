//
//  HXKeyWordTableViewCell.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/5.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXNewsDetailModel.h"

@protocol HXKeyWordTableViewCellDelegate <NSObject>

- (void)selectPraiseButtonWithModel:(HXNewsDetailModel *)model;

@end

@interface HXKeyWordTableViewCell : TXSeperateLineCell

@property (nonatomic, strong) HXNewsDetailModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *praiseImageView;
@property (weak, nonatomic) IBOutlet UILabel *praiseLabel;
@property (nonatomic, weak) id <HXKeyWordTableViewCellDelegate> delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
