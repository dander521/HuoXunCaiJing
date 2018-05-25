//
//  HXAttentionModel.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/25.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXAttentionModel.h"

@implementation HXAttentionModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idField" : @"id"};
}

@end

@implementation HXAttentionCollectionModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"data" : [HXAttentionModel class]};
}

@end
