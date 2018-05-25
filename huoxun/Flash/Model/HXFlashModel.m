//
//  HXFlashModel.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/7.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXFlashModel.h"

@implementation HXFlashModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idField" : @"id"};
}

@end

@implementation HXFlashCollectionModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"data" : [HXFlashModel class]};
}

@end

