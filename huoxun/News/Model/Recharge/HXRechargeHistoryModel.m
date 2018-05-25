//
//  HXRechargeHistoryModel.m
//  huoxun
//
//  Created by 倩倩 on 2018/3/12.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXRechargeHistoryModel.h"

@implementation HXRechargeHistoryModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idField" : @"id"};
}

- (HXRechargedModel *)converToRechargedModel {
    HXRechargedModel *model = [HXRechargedModel new];
    model.idField = self.idField;;
    model.uid = self.uid;;
    model.pay_type = self.pay_type;
    model.rate = self.rate;
    model.num = self.num;
    model.wallet = self.wallet;
    model.status = self.status;
    model.update_time = self.update_time;
    model.create_time = self.create_time;
    
    return model;
}

@end

@implementation HXRechargeHistoryCollectionModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"data" : [HXRechargeHistoryModel class]};
}

@end

