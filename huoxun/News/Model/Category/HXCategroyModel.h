//
//  HXCategroyModel.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/7.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXCategroyModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *column;
@property (nonatomic, strong) NSString *rel;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) BOOL isSelected;

@end

@interface HXCategroyCollectionModel : NSObject

@property (nonatomic, strong) NSArray *data;

@end
