//
//  HXProjectDetailIntroductTableViewCell.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/5.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXProjectDetailIntroductTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString *htmlString;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end