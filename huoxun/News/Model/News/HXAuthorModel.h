//
//  HXAuthorModel.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/7.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXAuthorModel : NSObject

@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *article_num;
@property (nonatomic, strong) NSString *browse_num;
@property (nonatomic, strong) NSString *comment_num;
@property (nonatomic, strong) NSString *att_num;
@property (nonatomic, strong) NSString *fans_num;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *isatt; // 0：未关注，1：已关注

@end
