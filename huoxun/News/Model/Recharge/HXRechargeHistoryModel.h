//
//  HXRechargeHistoryModel.h
//  huoxun
//
//  Created by 倩倩 on 2018/3/12.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXRechargedModel.h"

@interface HXRechargeHistoryModel : NSObject

@property (nonatomic, strong) NSString *idField;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *pay_type;
@property (nonatomic, strong) NSString *rate;
@property (nonatomic, strong) NSString *num;
@property (nonatomic, strong) NSString *wallet;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *update_time;
@property (nonatomic, strong) NSString *create_time;

- (HXRechargedModel *)converToRechargedModel;

@end

@interface HXRechargeHistoryCollectionModel : NSObject

@property (nonatomic, strong) NSArray *data;

@end
