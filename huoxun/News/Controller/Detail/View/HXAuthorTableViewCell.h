//
//  HXAuthorTableViewCell.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/5.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXAuthorModel.h"

@protocol HXAuthorTableViewCellDelegate <NSObject>

- (void)selectAttentionWithModel:(HXAuthorModel *)model;

@end

@interface HXAuthorTableViewCell : TXSeperateLineCell

@property (nonatomic, weak) id <HXAuthorTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (nonatomic, strong) HXAuthorModel *modle;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
