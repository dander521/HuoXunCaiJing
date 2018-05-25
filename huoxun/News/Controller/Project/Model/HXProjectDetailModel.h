//
//  HXProjectDetailModel.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/7.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXCoinModel.h"

@interface HXProjectDetailModel : NSObject

@property (nonatomic, strong) NSString *idField;
@property (nonatomic, strong) NSString *cid;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *model;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *update_time;
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *view;
@property (nonatomic, strong) NSString *trash;
@property (nonatomic, strong) NSString *symbol;
@property (nonatomic, strong) NSString *des;
// 总币
@property (nonatomic, strong) NSString *total;
// 发行
@property (nonatomic, strong) NSString *circulate;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *tags;
@property (nonatomic, strong) NSString *website;
@property (nonatomic, strong) NSString *cn_name;
@property (nonatomic, strong) NSString *ppt;
@property (nonatomic, strong) NSString *links;
@property (nonatomic, strong) NSString *only_id;
@property (nonatomic, strong) NSString *flag;
@property (nonatomic, strong) HXCoinModel *price;


@end
