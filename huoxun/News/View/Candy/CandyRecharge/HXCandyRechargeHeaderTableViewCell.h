//
//  HXCandyRechargeHeaderTableViewCell.h
//  huoxun
//
//  Created by 倩倩 on 2018/3/11.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXCandyRechargeHeaderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *inputTF;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
