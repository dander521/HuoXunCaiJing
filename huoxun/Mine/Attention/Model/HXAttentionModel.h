//
//  HXAttentionModel.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/25.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXAttentionModel : NSObject

@property (nonatomic, strong) NSString *idField;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *add_time;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *verified;
@property (nonatomic, strong) NSString *uid;

@end

@interface HXAttentionCollectionModel : NSObject

@property (nonatomic, strong) NSArray *data;

@end
