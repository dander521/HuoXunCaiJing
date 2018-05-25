//
//  HXVerifyTypeModel.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/9.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXVerifyTypeModel : NSObject

@property (nonatomic, strong) NSString *idField;
@property (nonatomic, strong) NSString *name;

@end

@interface HXVerifyTypeCollectionModel : NSObject

@property (nonatomic, strong) NSArray *data;

@end
