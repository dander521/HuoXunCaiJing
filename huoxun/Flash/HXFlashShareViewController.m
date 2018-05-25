//
//  HXFlashShareViewController.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/15.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXFlashShareViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "SGQRCode.h"
#import "NSString+WGDate.h"

@interface HXFlashShareViewController ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qrImageView;

@end

@implementation HXFlashShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timeLabel.text = [NSString formatDateToSecond:[[NSString getTimeInterval] doubleValue]];
    self.contentLabel.attributedText = [TXCustomTools getAttributedStringWithLineSpace:self.content lineSpace:5 kern:0];
    NSString *str = [[TXUserModel defaultUser] userLoginStatus] == false ? @"http://huoxun.domain.cn.vc/m/lives" : [NSString stringWithFormat:@"http://huoxun.domain.cn.vc/m/lives?uid=%@", [TXModelAchivar getUserModel].idField];
    self.qrImageView.image = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:str imageViewWidth:80];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = true;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = false;
}

- (UIImage *)createImageWithView:(UIView *)view
{
    CGSize s = view.bounds.size;
    //第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，设置为[UIScreen mainScreen].scale可以保证转成的图片不失真。
    UIGraphicsBeginImageContextWithOptions(s, NO,[UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (IBAction)touchBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)touchWeChatButton:(id)sender {
    [self startSharePlatform: SSDKPlatformSubTypeWechatSession];
}

- (IBAction)touchFriendButton:(id)sender {
    [self startSharePlatform: SSDKPlatformSubTypeWechatTimeline];
}

- (IBAction)touchCollectionButton:(id)sender {
//    [self startSharePlatform: SSDKPlatformSubTypeQQFriend];
    [ShowMessage showMessage:@"此功能暂未开通"];
}
- (IBAction)touchQZoneButton:(id)sender {
//    [self startSharePlatform: SSDKPlatformSubTypeQZone];
    [ShowMessage showMessage:@"此功能暂未开通"];
}

//开始分享
- (void)startSharePlatform:(SSDKPlatformType)platform {
    
    NSArray* imageArray = [NSArray new];
    imageArray = @[[self createImageWithView:self.bgView]];
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:@"火讯财经快讯分享"
                                     images:imageArray
                                        url:nil
                                      title:self.param[@"title"]
                                       type:SSDKContentTypeImage];
    
    [ShareSDK share:platform parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
                break;
            }
            case SSDKResponseStateFail:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                break;
            }
            default:
                break;
        }
    }];
}


@end
