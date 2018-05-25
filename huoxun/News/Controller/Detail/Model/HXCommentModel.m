//
//  HXCommentModel.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/25.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXCommentModel.h"

@implementation HXCommentModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idField" : @"id"};
}

@end

@implementation HXCommentCollectionModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"data" : [HXCommentModel class]};
}

@end
