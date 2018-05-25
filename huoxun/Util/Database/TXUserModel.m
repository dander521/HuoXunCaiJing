//
//  TXUserModel.m
//  TailorX
//
//  Created by Qian Shen on 24/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXUserModel.h"
#import "TXModelAchivar.h"
#import <objc/runtime.h>

@implementation TXUserModel

+ (TXUserModel *)defaultUser {
    static TXUserModel *model;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [TXModelAchivar unachiveUserModel];
        if (!model) {
            model = [[TXUserModel alloc]init];
        }
    });
    return model;
}

MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idField" : @"id",
             @"des" : @"description"};
}

/**
 * 字典转模型
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    [[TXUserModel defaultUser] setValuesForKeysWithDictionary:dictionary];
    return [TXUserModel defaultUser];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

/**
 * 清楚用户数据
 */
- (void)resetModelData {
    self.logintoken = nil;
    self.email = nil;
    self.idField = nil;
    self.username = nil;
    self.nickname = nil;
    self.avatar = nil;
    self.mobile = nil;
    self.des = nil;
    self.verified_status = nil;
    self.count = nil;
    self.article_num = nil;
    self.att_num = nil;
    self.fans_num = nil;
    
    [TXModelAchivar updateUserModelWithKey:@"idField" value:@""];
    [TXModelAchivar updateUserModelWithKey:@"email" value:@""];
    [TXModelAchivar updateUserModelWithKey:@"logintoken" value:@""];
    [TXModelAchivar updateUserModelWithKey:@"username" value:@""];
    [TXModelAchivar updateUserModelWithKey:@"nickname" value:@""];
    [TXModelAchivar updateUserModelWithKey:@"avatar" value:@""];
    [TXModelAchivar updateUserModelWithKey:@"mobile" value:@""];
    [TXModelAchivar updateUserModelWithKey:@"legalize" value:@""];
    [TXModelAchivar updateUserModelWithKey:@"des" value:@""];
    [TXModelAchivar updateUserModelWithKey:@"article_num" value:@""];
    [TXModelAchivar updateUserModelWithKey:@"att_num" value:@""];
    [TXModelAchivar updateUserModelWithKey:@"fans_num" value:@""];
    [TXModelAchivar updateUserModelWithKey:@"verified_status" value:@""];
    [TXModelAchivar updateUserModelWithKey:@"bound_wechat" value:@""];
    [TXModelAchivar updateUserModelWithKey:@"attentionCount" value:@""];
    [TXModelAchivar updateUserModelWithKey:@"notifyCount" value:@""];
    [TXModelAchivar updateUserModelWithKey:@"attentionLocalCount" value:@""];
    [TXModelAchivar updateUserModelWithKey:@"notifyLocalCount" value:@""];
    [TXModelAchivar updateUserModelWithKey:@"newsCount" value:@""];
    [TXModelAchivar updateUserModelWithKey:@"flashCount" value:@""];
    [TXModelAchivar updateUserModelWithKey:@"newsLocalCount" value:@""];
    [TXModelAchivar updateUserModelWithKey:@"flashLocalCount" value:@""];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:WX_NICKNAME];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:WX_OPEN_ID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:WX_ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:WX_REFRESH_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 判断用户登录状态
 
 @return true：登录 false：未登录
 */
- (BOOL)userLoginStatus {
    NSLog(@"logintoken = %@", [TXModelAchivar getUserModel].logintoken);
    if ([NSString isTextEmpty:[TXModelAchivar getUserModel].logintoken]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoginOutSuccess object:nil userInfo:nil];
    }
    return ![NSString isTextEmpty:[TXModelAchivar getUserModel].logintoken];
}

@end
