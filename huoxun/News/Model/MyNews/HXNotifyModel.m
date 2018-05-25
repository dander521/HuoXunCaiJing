//
//  HXNotifyModel.m
//  huoxun
//
//  Created by 倩倩 on 2018/3/12.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXNotifyModel.h"

@implementation HXNotifyModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idField" : @"id"};
}

@end

@implementation HXNotifyCollectionModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : [HXNotifyModel class]};
}

@end
