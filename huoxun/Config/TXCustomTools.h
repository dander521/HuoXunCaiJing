//
//  TXCustomTools.h
//  TailorX
//
//  Created by 程荣刚 on 2017/7/27.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXCustomTools : NSObject


/**
 调起系统拨打电话

 @param phoneNo 电话号码
 */
+ (void)callStoreWithPhoneNo:(NSString *)phoneNo target:(UIViewController *)target;

/**
 设置alert按钮颜色

 @param color
 @param action
 */
+ (void)setActionTitleTextColor:(UIColor *)color action:(UIAlertAction *)action;

// 设置图片尺寸
+ (UIImage*)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

//获取当前时间戳
+ (NSString *)currentTimeStr;

+ (NSString *)md5:(NSString *)str;

+ (CGSize)heightForString:(NSString *)value fontSize:(UIFont*)fontSize andWidth:(CGFloat)width;

/**
 *  设置行间距和字间距
 *
 *  @param lineSpace 行间距
 *  @param kern      字间距
 *
 *  @return 富文本
 */
+ (NSMutableAttributedString *)getAttributedStringWithLineSpace:(NSString *) text lineSpace:(CGFloat)lineSpace kern:(CGFloat)kern;

/**
 * 计算带有行间距的文字宽高
 */
+ (CGSize)heightForString:(NSString *)value Spacing:(CGFloat)spacing fontSize:(UIFont*)fontSize andWidth:(CGFloat)width;
@end
