//
//  HXVerifyTypeModel.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/9.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXVerifyTypeModel.h"

@implementation HXVerifyTypeModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idField" : @"id"};
}

@end


@implementation HXVerifyTypeCollectionModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"data" : [HXVerifyTypeModel class]};
}

@end
