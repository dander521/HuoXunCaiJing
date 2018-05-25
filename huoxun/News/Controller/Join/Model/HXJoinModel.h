//
//  HXJoinModel.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/10.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXJoinModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *des;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *face;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *view;
@property (nonatomic, strong) NSString *create_time_format;

@end

@interface HXJoinCollectionModel : NSObject

@property (nonatomic, strong) NSArray *data;

@end
