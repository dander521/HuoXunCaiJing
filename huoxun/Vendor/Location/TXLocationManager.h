//
//  TXLocationManager.h
//  TailorX
//
//  Created by Qian Shen on 8/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(NSString *cityName, NSString *areaName);
typedef void(^FailureBlock)(NSError *error);

@interface TXLocationManager : NSObject

@property (nonatomic, copy) SuccessBlock successBlock;

@property (nonatomic, copy) FailureBlock failureBlock;

/**
 * 定位回调
 */
- (void)locationManagerWithsuccess:(SuccessBlock)success
                           failure:(FailureBlock)failure;

/**
 * 根据地名获取经纬度
 */
- (void)geocodeAddressToLocation:(NSString*)addressName;

@end
