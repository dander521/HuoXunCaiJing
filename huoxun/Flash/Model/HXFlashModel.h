//
//  HXFlashModel.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/7.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXFlashModel : NSObject

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
@property (nonatomic, strong) NSString *des;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *create_time_format;
@property (nonatomic, strong) NSString *profile_image_url;
@property (nonatomic, strong) NSString *screen_name;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *chinese_original;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *user_avatar;
@property (nonatomic, strong) NSString *user_name;


@end

@interface HXFlashCollectionModel : NSObject

@property (nonatomic, strong) NSArray *data;

@end
