//
//  HXNotifyModel.h
//  huoxun
//
//  Created by 倩倩 on 2018/3/12.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXNotifyModel : NSObject

@property (nonatomic, strong) NSString *idField;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *des;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *update_time;
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, strong) NSString *status;

@end

@interface HXNotifyCollectionModel : NSObject

@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) NSString *total;

@end
