//
//  TXUserModel.h
//  TailorX
//
//  Created by Qian Shen on 24/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXCountModel.h"

@interface TXUserModel : NSObject

/*________________________________________________________________________*/

@property (nonatomic, strong) NSString *access;
@property (nonatomic, strong) NSString *logintoken;

@property (nonatomic, strong) NSString *idField;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *des;
@property (nonatomic, strong) HXCountModel *count;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *six; // 1：男，2：女
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *verified;
@property (nonatomic, strong) NSString *article_num;
@property (nonatomic, strong) NSString *att_num;
@property (nonatomic, strong) NSString *fans_num;
@property (nonatomic, strong) NSString *verified_status; //  状态 0 未提交认证 1 审核中 2已审核 3 认证失效
@property (nonatomic, strong) NSString *bound_wechat;

@property (nonatomic, strong) NSString *attentionLocalCount;
@property (nonatomic, strong) NSString *notifyLocalCount;
@property (nonatomic, strong) NSString *attentionCount;
@property (nonatomic, strong) NSString *notifyCount;

@property (nonatomic, strong) NSString *flashCount;
@property (nonatomic, strong) NSString *newsCount;
@property (nonatomic, strong) NSString *flashLocalCount;
@property (nonatomic, strong) NSString *newsLocalCount;

/*________________________________________________________________________*/

+ (TXUserModel *)defaultUser;

/**
 * 清楚用户数据
 */
- (void)resetModelData;

/**
 * 字典转模型
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

/**
 判断用户登录状态

 @return true：登录 false：未登录
 */
- (BOOL)userLoginStatus;

@end
