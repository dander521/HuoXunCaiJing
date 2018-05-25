//
//  HXNewsModel.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/7.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXAuthorModel.h"

@interface HXNewsModel : NSObject

@property (nonatomic, strong) NSString *idField;
@property (nonatomic, strong) NSString *cid;
@property (nonatomic, strong) NSString *model;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *shorttitle;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *flag;
@property (nonatomic, strong) NSString *view;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *good;
@property (nonatomic, strong) NSString *bad;
@property (nonatomic, strong) NSString *mark;
@property (nonatomic, strong) NSString *create_time_format;
@property (nonatomic, strong) NSString *update_time;
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *trash;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *aid;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *des;
@property (nonatomic, strong) HXAuthorModel *user;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *actionType;
@property (nonatomic, strong) NSString *jump;

@end

@interface HXNewsCollectionModel : NSObject

@property (nonatomic, strong) NSArray *data;

@end
