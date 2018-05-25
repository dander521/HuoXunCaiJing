//
//  HXAttentionsModel.h
//  huoxun
//
//  Created by 倩倩 on 2018/3/12.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXRechargedModel.h"

@interface HXAttentionsModel : NSObject

@property (nonatomic, strong) NSString *idField;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *model;

@property (nonatomic, strong) NSString *ip;
@property (nonatomic, strong) NSString *record_id;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *update_time;
@property (nonatomic, strong) NSString *des;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *type; // 通知类型，1：充值状态，2：获得糖果，3：被点赞，4：被评论
@property (nonatomic, strong) HXRechargedModel *recharge;

@end

@interface HXAttentionsCollectionModel : NSObject

@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) NSString *total;

@end
