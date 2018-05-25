//
//  HXBannerModel.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/7.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXBannerModel.h"

@implementation HXBannerModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idField" : @"id"};
}

@end

@implementation HXBannerCollectionModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"data" : [HXBannerModel class]};
}

@end
