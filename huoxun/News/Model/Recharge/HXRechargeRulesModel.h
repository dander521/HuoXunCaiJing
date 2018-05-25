//
//  HXRechargeRulesModel.h
//  huoxun
//
//  Created by 倩倩 on 2018/3/12.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXRechargeRulesModel : NSObject

@property (nonatomic, strong) NSString *idField;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *divisor;
@property (nonatomic, strong) NSString *sugar_num;
@property (nonatomic, strong) NSString *wallet;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *update_time;
@property (nonatomic, strong) NSString *isSelected;

@end

@interface HXRechargeRulesCollectionModel : NSObject

@property (nonatomic, strong) NSArray *data;

@end
