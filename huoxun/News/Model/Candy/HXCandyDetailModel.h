//
//  HXCandyDetailModel.h
//  huoxun
//
//  Created by 倩倩 on 2018/3/12.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXCandyDetailModel : NSObject

@property (nonatomic, strong) NSString *idField;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *account_type;
@property (nonatomic, strong) NSString *sign;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *from_type;
@property (nonatomic, strong) NSString *des;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *update_time;

@end

@interface HXCandyDetailCollectionModel : NSObject

@property (nonatomic, strong) NSArray *data;

@end
