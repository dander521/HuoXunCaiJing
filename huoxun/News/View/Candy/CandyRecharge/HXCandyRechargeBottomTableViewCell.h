//
//  HXCandyRechargeBottomTableViewCell.h
//  huoxun
//
//  Created by 倩倩 on 2018/3/11.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXCandyRechargeBottomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *addressButton;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
