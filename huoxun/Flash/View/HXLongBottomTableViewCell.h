//
//  HXLongBottomTableViewCell.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/26.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXLongBottomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *qrImageView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
