//
//  HXCandyDetailTableViewCell.h
//  huoxun
//
//  Created by 倩倩 on 2018/3/11.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXCandyDetailModel.h"

@interface HXCandyDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (nonatomic, strong) HXCandyDetailModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
