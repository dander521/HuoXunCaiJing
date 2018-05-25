//
//  HXNewsModel.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/7.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXNewsModel.h"

@implementation HXNewsModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idField" : @"id"};
}

@end

@implementation HXNewsCollectionModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"data" : [HXNewsModel class]};
}

@end
