//
//  TXCustomTools.m
//  TailorX
//
//  Created by 程荣刚 on 2017/7/27.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXCustomTools.h"
#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation TXCustomTools

/**
 调起系统拨打电话
 
 @param phoneNo 电话号码
 */
+ (void)callStoreWithPhoneNo:(NSString *)phoneNo target:(UIViewController *)target {
    if ([NSString isTextEmpty:phoneNo]) {
        [ShowMessage showMessage:@"该门店没有留下电话哦！" withCenter:CGPointMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT/2.0)];
    }else {
        
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *callAction = [UIAlertAction actionWithTitle:@"联系平台" style:UIAlertActionStyleDefault handler:nil];
        [TXCustomTools setActionTitleTextColor:RGB(26, 26, 26) action:callAction];
        callAction.enabled = NO;
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:phoneNo style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt:%@", phoneNo];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertVc dismissViewControllerAnimated:true completion:nil];
        }];

        [alertVc addAction:callAction];
        [alertVc addAction:noAction];
        [alertVc addAction:cancelAction];
        
        [target presentViewController:alertVc animated:true completion:nil];
    }
}

/**
 设置alert按钮颜色
 
 @param color
 @param action
 */
+ (void)setActionTitleTextColor:(UIColor *)color action:(UIAlertAction *)action {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.3) {
        [action setValue:color forKey:@"titleTextColor"];
    }
}

+ (UIImage*)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//获取当前时间戳
+ (NSString *)currentTimeStr {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time = [date timeIntervalSince1970];// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

+ (NSString *)md5:(NSString *)string{
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X", digest[i]];
    }
    
    NSString *lower = [result lowercaseString];
    
    return lower;
}

/**
 * 计算文字的宽高
 */
+ (CGSize)heightForString:(NSString *)value fontSize:(UIFont*)fontSize andWidth:(CGFloat)width {
    UITextView *detailTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = fontSize;
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize;
}

/**
 *  设置行间距和字间距
 *
 *  @param lineSpace 行间距
 *  @param kern      字间距
 *
 *  @return 富文本
 */
+ (NSMutableAttributedString *)getAttributedStringWithLineSpace:(NSString *) text lineSpace:(CGFloat)lineSpace kern:(CGFloat)kern {
    NSMutableParagraphStyle * paragraphStyle = [NSMutableParagraphStyle new];
    //调整行间距
    paragraphStyle.lineSpacing= lineSpace;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = lineSpace; //设置行间距
    paragraphStyle.firstLineHeadIndent = 0.0;//设置第一行缩进
    UIFont *font = FONT(14);
    NSDictionary*attriDict =@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:@(kern)};
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attriDict];
    
    return attributedString;
}

/**
 *  富文本部分字体设置颜色
 *
 *  @param text 文本
 *  @param highlightText  设置颜色的文本
 *
 *  @return 富文本
 */
+ (NSMutableAttributedString *)setupAttributeString:(NSString *)text highlightText:(NSString *)highlightText {
    NSRange hightlightTextRange = [text rangeOfString:highlightText];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:text];
    if (hightlightTextRange.length > 0) {
        [attributeStr addAttribute:NSForegroundColorAttributeName
                             value:[UIColor redColor]
                             range:hightlightTextRange];
        [attributeStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15.0f] range:hightlightTextRange];
        return attributeStr;
    }else {
        return [highlightText copy];
    }
}

/**
 * 计算带有行间距的文字宽高
 */
+ (CGSize)heightForString:(NSString *)value Spacing:(CGFloat)spacing fontSize:(UIFont*)fontSize andWidth:(CGFloat)width {
    if ([NSString isTextEmpty:value]) {
        return CGSizeZero;
    }
    NSMutableAttributedString *coreText = [[NSMutableAttributedString alloc] initWithString:value];
    // 设置字体
    [coreText addAttribute:NSFontAttributeName value:fontSize range:NSMakeRange(0, coreText.length)];
    // 自动获取coreText所占CGSize 注意：获取前必须设置所有字体大小
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:spacing];
    [coreText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [coreText length])];
    CGSize labelSize = [coreText boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    return labelSize;
}

@end
