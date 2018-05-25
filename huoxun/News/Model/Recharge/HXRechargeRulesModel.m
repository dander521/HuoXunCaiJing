//
//  HXRechargeRulesModel.m
//  huoxun
//
//  Created by 倩倩 on 2018/3/12.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXRechargeRulesModel.h"

@implementation HXRechargeRulesModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idField" : @"id"};
}

@end

@implementation HXRechargeRulesCollectionModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"data" : [HXRechargeRulesModel class]};
}

@end

