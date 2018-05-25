//
//  HXMyNoticeTableViewCell.h
//  huoxun
//
//  Created by 倩倩 on 2018/3/9.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXNotifyModel.h"

@interface HXMyNoticeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic, strong) HXNotifyModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
