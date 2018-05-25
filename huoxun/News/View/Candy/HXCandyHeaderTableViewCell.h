//
//  HXCandyHeaderTableViewCell.h
//  huoxun
//
//  Created by 倩倩 on 2018/3/10.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HXCandyHeaderTableViewCellDelegate <NSObject>

- (void)selectDetailButton;
- (void)selectRechargeButton;
- (void)selectExchangeButton;

@end

@interface HXCandyHeaderTableViewCell : UITableViewCell

@property (nonatomic, weak) id <HXCandyHeaderTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *rechargeButton;
@property (weak, nonatomic) IBOutlet UIButton *exchangeButton;
@property (weak, nonatomic) IBOutlet UIView *detailBgView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
