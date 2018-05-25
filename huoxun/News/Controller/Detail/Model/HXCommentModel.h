//
//  HXCommentModel.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/25.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXAuthorModel.h"

@interface HXCommentModel : NSObject

@property (nonatomic, strong) NSString *idField;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *nid;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *add_time;
@property (nonatomic, strong) HXAuthorModel *user;
@property (nonatomic, strong) NSString *znum;
@property (nonatomic, strong) NSString *is_praise;

@end

@interface HXCommentCollectionModel : NSObject

@property (nonatomic, strong) NSArray *data;

@end
