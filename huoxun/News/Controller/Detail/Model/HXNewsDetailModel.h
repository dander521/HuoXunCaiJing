//
//  HXNewsDetailModel.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/7.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXAuthorModel.h"

@interface HXNewsDetailModel : NSObject

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
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *des;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *original;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) HXAuthorModel *user;
@property (nonatomic, strong) NSString *is_collect; // 是否收藏  1：是，0：否
@property (nonatomic, strong) NSString *praise_num;
@property (nonatomic, strong) NSString *is_praise; // 是否点赞  1：是，0：否


@end
