//
//  HXAttentionsModel.m
//  huoxun
//
//  Created by 倩倩 on 2018/3/12.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXAttentionsModel.h"

@implementation HXAttentionsModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idField" : @"id"};
}

@end

@implementation HXAttentionsCollectionModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : [HXAttentionsModel class]};
}

@end
