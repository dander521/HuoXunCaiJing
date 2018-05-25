//
//  HXCandyDetailModel.m
//  huoxun
//
//  Created by 倩倩 on 2018/3/12.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXCandyDetailModel.h"

@implementation HXCandyDetailModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idField" : @"id"};
}

@end

@implementation HXCandyDetailCollectionModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"data" : [HXCandyDetailModel class]};
}


@end
