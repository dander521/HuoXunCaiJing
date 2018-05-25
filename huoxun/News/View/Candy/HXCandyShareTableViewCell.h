//
//  HXCandyShareTableViewCell.h
//  huoxun
//
//  Created by 倩倩 on 2018/3/10.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HXCandyShareTableViewCellDelegate <NSObject>

- (void)selectShareWithTitle:(NSString *)title;

@end

@interface HXCandyShareTableViewCell : UITableViewCell

@property (nonatomic, weak) id <HXCandyShareTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *titleImageVuew;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
