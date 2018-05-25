//
//  HXMyAttentionTableViewCell.h
//  huoxun
//
//  Created by 倩倩 on 2018/3/9.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXAttentionsModel.h"

typedef NS_ENUM(NSInteger, HXMyAttentionTableViewCellType) {
    HXMyAttentionTableViewCellTypeRecharge = 1,
    HXMyAttentionTableViewCellTypeReceiveCandy,
    HXMyAttentionTableViewCellTypePraise,
    HXMyAttentionTableViewCellTypeComment
};

@interface HXMyAttentionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic, assign) HXMyAttentionTableViewCellType cellType;

@property (nonatomic, strong) HXAttentionsModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
