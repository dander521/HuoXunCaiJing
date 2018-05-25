//
//  HXProjectModel.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/7.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXProjectModel.h"

@implementation HXProjectModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idField" : @"id"};
}

@end

@implementation HXProjectCollectionModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : [HXProjectModel class]};
}

@end
