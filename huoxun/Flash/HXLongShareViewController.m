//
//  HXLongShareViewController.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/26.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXLongShareViewController.h"
#import "HXLongHeaderTableViewCell.h"
#import "HXLongMiddleTableViewCell.h"
#import "HXLongBottomTableViewCell.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "SGQRCode.h"
#import "NSString+WGDate.h"

@interface HXLongShareViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HXLongShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = true;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *defaultCell = nil;
    if (indexPath.row == 0) {
        HXLongHeaderTableViewCell *cell = [HXLongHeaderTableViewCell cellWithTableView:tableView];
        defaultCell = cell;
    } else if (indexPath.row == 1) {
        HXLongMiddleTableViewCell *cell = [HXLongMiddleTableViewCell cellWithTableView:tableView];
        cell.timeLabel.text = self.time;
        cell.contentLabel.attributedText = [TXCustomTools getAttributedStringWithLineSpace:self.content lineSpace:5 kern:0];
        defaultCell = cell;
    } else {
        HXLongBottomTableViewCell *cell = [HXLongBottomTableViewCell cellWithTableView:tableView];
        NSString *str = [[TXUserModel defaultUser] userLoginStatus] == false ? self.param[@"url"] : [NSString stringWithFormat:@"%@?uid=%@", self.param[@"url"] ,[TXModelAchivar getUserModel].idField];
        cell.qrImageView.image = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:str imageViewWidth:100];
        defaultCell = cell;
    }
    
    return defaultCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 0.52 * SCREEN_WIDTH;
    } else if (indexPath.row == 1) {
        return UITableViewAutomaticDimension;
    } else {
        return 300;
    }
}

- (UIImage *)createImageWithView:(UIView *)view
{
//    CGSize s = view.bounds.size;
//    //第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，设置为[UIScreen mainScreen].scale可以保证转成的图片不失真。
//    UIGraphicsBeginImageContextWithOptions(s, NO,[UIScreen mainScreen].scale);
//    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image;
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(self.tableView.contentSize, YES, 0.0);
    
    //保存collectionView当前的偏移量
    CGPoint savedContentOffset = self.tableView.contentOffset;
    CGRect saveFrame = self.tableView.frame;
    
    //将collectionView的偏移量设置为(0,0)
    self.tableView.contentOffset = CGPointZero;
    self.tableView.frame = CGRectMake(0, 0, self.tableView.contentSize.width, self.tableView.contentSize.height);
    
    //在当前上下文中渲染出collectionView
    [self.tableView.layer renderInContext: UIGraphicsGetCurrentContext()];
    //截取当前上下文生成Image
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    //恢复collectionView的偏移量
    self.tableView.contentOffset = savedContentOffset;
    self.tableView.frame = saveFrame;
    
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        return image;
    }else {
        return nil;
    }
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
    imageArray = @[[self createImageWithView:self.tableView]];
    if (imageArray.count == 0) {
        [ShowMessage showMessage:@"分享失败"];
        return;
    }
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
