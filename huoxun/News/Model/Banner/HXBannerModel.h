//
//  HXBannerModel.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/7.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXBannerModel : NSObject

@property (nonatomic, strong) NSString *idField;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *url;

@end

@interface HXBannerCollectionModel : NSObject

@property (nonatomic, strong) NSArray *data;

@end
