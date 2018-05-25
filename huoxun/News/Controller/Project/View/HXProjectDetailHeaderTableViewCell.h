//
//  HXProjectDetailHeaderTableViewCell.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/5.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXProjectDetailModel.h"

@protocol HXProjectDetailHeaderTableViewCellDelegate <NSObject>

- (void)touchProjectDetailWhitePaperWithPPTUrl:(NSString *)ppturl;

@end

@interface HXProjectDetailHeaderTableViewCell : UITableViewCell

@property (nonatomic, strong) HXProjectDetailModel *model;
@property (nonatomic, weak) id <HXProjectDetailHeaderTableViewCellDelegate> delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
