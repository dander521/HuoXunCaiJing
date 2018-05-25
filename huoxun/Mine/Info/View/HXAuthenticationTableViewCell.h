//
//  HXAuthenticationTableViewCell.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/6.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXAuthenticationTableViewCell : TXSeperateLineCell
@property (weak, nonatomic) IBOutlet UIImageView *auImg;
@property (weak, nonatomic) IBOutlet UILabel *verifyNameLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
