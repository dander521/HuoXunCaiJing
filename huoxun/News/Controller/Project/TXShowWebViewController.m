//
//  TXShowWebViewController.m
//  TailorX
//
//  Created by RogerChen on 2017/4/13.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXShowWebViewController.h"
#import "HXThirdlibShareView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface TXShowWebViewController () <HXThirdlibShareViewDelegate>

@property (nonatomic, strong) HXThirdlibShareView *shareView;

@end

@implementation TXShowWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    weakSelf(self);
    self.navigationItem.title = self.naviTitle;
    
    self.webView = [[TXWebView alloc] initWithFrame:self.view.bounds];
    self.webView.requestUrl = self.webViewUrl;
    
    self.webView.didFinish = ^(WKNavigation *navi, NSString *title) {
        if (weakSelf.isShowShare) {
            [weakSelf.view addSubview:weakSelf.shareView];
            
            [weakSelf.shareView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(weakSelf.view.mas_left);
                make.right.mas_equalTo(weakSelf.view.mas_right);
                make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
                make.height.mas_equalTo(@55);
            }];
        }
    };
    
    [self.view addSubview:self.webView];
    
    
    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_nav_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
//    backItem.tintColor = RGB(138, 138, 138);
//    self.navigationItem.leftBarButtonItems = @[backItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isShowShare) {
        self.navigationController.navigationBarHidden = true;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isShowShare) {
        self.navigationController.navigationBarHidden = false;
    }
}

#pragma mark - events

//- (void)back {
//    [self.navigationController popViewControllerAnimated:YES];
//}

#pragma mark - HXThirdlibShareViewDelegate

- (void)selectItemWithIndex:(NSInteger)index {
    NSLog(@"index = %ld", index);
    switch (index) {
        case 1: {
            [self.navigationController popViewControllerAnimated:true];
        }
            break;
        case 2: {
            [self startSharePlatform: SSDKPlatformSubTypeWechatSession];
        }
            break;
        case 3: {
            [self startSharePlatform: SSDKPlatformSubTypeWechatTimeline];
        }
            break;
        case 4: {
            //    [self startSharePlatform: SSDKPlatformSubTypeQQFriend];
            [ShowMessage showMessage:@"此功能暂未开通"];
        }
            break;
        case 5: {
            //    [self startSharePlatform: SSDKPlatformSubTypeQZone];
            [ShowMessage showMessage:@"此功能暂未开通"];
        }
            break;
            
        default:
            break;
    }
}

- (HXThirdlibShareView *)shareView {
    if (!_shareView) {
        _shareView  =  [[[NSBundle mainBundle] loadNibNamed:@"HXThirdlibShareView" owner:nil options:nil] lastObject];
        _shareView.delegate = self;
    }
    return _shareView;
}

//开始分享
- (void)startSharePlatform:(SSDKPlatformType)platform {
    
    NSArray* imageArray = [NSArray new];
    imageArray = @[[self createImageWithView:self.webView]];
    if (imageArray.count == 0) {
        [ShowMessage showMessage:@"分享失败"];
        return;
    }
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:@"火讯财经"
                                     images:imageArray
                                        url:nil
                                      title:self.title
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

- (UIImage *)createImageWithView:(UIView *)view
{
    CGSize s = view.bounds.size;
    //第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，设置为[UIScreen mainScreen].scale可以保证转成的图片不失真。
    UIGraphicsBeginImageContextWithOptions(s, NO,[UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
//    UIImage* image = nil;
//    UIGraphicsBeginImageContextWithOptions(self.webView.webView.scrollView.contentSize, YES, 0.0);
//
//    //保存collectionView当前的偏移量
//    CGPoint savedContentOffset = self.webView.webView.scrollView.contentOffset;
//    CGRect saveFrame = self.webView.frame;
//
//    //将collectionView的偏移量设置为(0,0)
//    self.webView.webView.scrollView.contentOffset = CGPointZero;
//    self.webView.webView.scrollView.frame = CGRectMake(0, 0, self.webView.webView.scrollView.contentSize.width, self.webView.webView.scrollView.contentSize.height);
//
//    //在当前上下文中渲染出collectionView
//    [self.webView.layer renderInContext: UIGraphicsGetCurrentContext()];
//    //截取当前上下文生成Image
//    image = UIGraphicsGetImageFromCurrentImageContext();
//
//    //恢复collectionView的偏移量
//    self.webView.webView.scrollView.contentOffset = savedContentOffset;
//    self.webView.frame = saveFrame;
//
//    UIGraphicsEndImageContext();
//
//    if (image != nil) {
//        return image;
//    }else {
//        return nil;
//    }
}


@end
