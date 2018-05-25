//
//  HXRechargeHistoryDetailTableViewController.h
//  huoxun
//
//  Created by 倩倩 on 2018/3/14.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXRechargedModel.h"

@interface HXRechargeHistoryDetailTableViewController : UITableViewController

@property (nonatomic, strong) HXRechargedModel *model;

@property (nonatomic, assign) BOOL isAttention;
@property (nonatomic, strong) NSString *create_time;
@end

