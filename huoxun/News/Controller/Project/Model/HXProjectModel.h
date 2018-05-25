//
//  HXProjectModel.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/7.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXProjectModel : NSObject

@property (nonatomic, strong) NSString *idField;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *symbol;
@property (nonatomic, strong) NSString *des;
@property (nonatomic, strong) NSString *ppt;
@property (nonatomic, strong) NSString *icon;

@end

@interface HXProjectCollectionModel : NSObject

@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) NSString *total;

@end
