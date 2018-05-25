//
//  HXLoginViewController.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/4.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXLoginViewController.h"
#import "HXRegisterViewController.h"
#import "HXRetreiveViewController.h"
#import "JPUSHService.h"
#import "WXApi.h"
#import "HXBindPhoneViewController.h"

@interface HXLoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *pwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;

@end

@implementation HXLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"手机帐号登录";
    self.topLayout.constant = 30 + kTopHeight;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatGetuserInfo) name:kNSNotificationWeChatGetUserInfo object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidChange:(NSNotification *)noti {
    if (self.accountTF.text.length != 0 &&
        self.passwordTF.text.length != 0) {
        self.loginBtn.enabled = true;
        [self.loginBtn setBackgroundColor:RGB(184, 11, 34)];
    } else {
        self.loginBtn.enabled = false;
        [self.loginBtn setBackgroundColor:RGB(153, 153, 153)];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:true];
    return true;
}

#pragma mark - Touch Method

- (IBAction)touchPwdButton:(id)sender {
    self.passwordTF.secureTextEntry = self.passwordTF.isSecureTextEntry ? false : true;
}

- (IBAction)touchRetreiveButton:(id)sender {
    HXRetreiveViewController *vwcRegister = [[HXRetreiveViewController alloc] initWithNibName:NSStringFromClass([HXRetreiveViewController class]) bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vwcRegister animated:true];
}

- (IBAction)touchLoginButton:(id)sender {
    if (![NSString isPhoneNumCorrectPhoneNum:self.accountTF.text]) {
        [ShowMessage showMessage:@"请输入正确的手机号"];
        return;
    }
    
    if (self.passwordTF.text.length < 6 || self.passwordTF.text.length > 20) {
        [ShowMessage showMessage:@"请输入6-20位数字和字母组成的密码"];
        return;
    }

    NSMutableDictionary *bodyParams = [NSMutableDictionary new];
    [bodyParams setValue:@"pwd" forKey:@"type"];
    [bodyParams setValue:self.accountTF.text forKey:@"mobile"];
    [bodyParams setValue:self.passwordTF.text forKey:@"password"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:postLogin]
                             headParams:[RCHttpHelper accessHeader]
                             bodyParams:bodyParams
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
                                    [MBProgressHUD hideHUDForView:self.view];
                                    [ShowMessage showMessage:responseObject[@"message"]];
                                    if ([responseObject[@"code"] integerValue] == 200) {
                                        
                                        TXUserModel *model = [TXUserModel new];
                                        model = [TXUserModel mj_objectWithKeyValues:responseObject[@"data"]];
                                        
                                        [TXModelAchivar updateUserModelWithKey:@"idField" value:model.idField];
                                        [TXModelAchivar updateUserModelWithKey:@"username" value:model.username];
                                        [TXModelAchivar updateUserModelWithKey:@"nickname" value:model.nickname];
                                        [TXModelAchivar updateUserModelWithKey:@"avatar" value:model.avatar];
                                        [TXModelAchivar updateUserModelWithKey:@"mobile" value:model.mobile];
                                        [TXModelAchivar updateUserModelWithKey:@"des" value:model.des];
                                        [TXModelAchivar updateUserModelWithKey:@"article_num" value:model.count.article_num];
                                        [TXModelAchivar updateUserModelWithKey:@"att_num" value:model.count.att_num];
                                        [TXModelAchivar updateUserModelWithKey:@"fans_num" value:model.count.fans_num];
                                        [TXModelAchivar updateUserModelWithKey:@"address" value:model.address];
                                        [TXModelAchivar updateUserModelWithKey:@"six" value:model.six];
                                        [TXModelAchivar updateUserModelWithKey:@"birthday" value:model.birthday];
                                        [TXModelAchivar updateUserModelWithKey:@"verified" value:model.verified];
                                        [TXModelAchivar updateUserModelWithKey:@"verified_status" value:model.verified_status];
                                        [TXModelAchivar updateUserModelWithKey:@"logintoken" value:model.logintoken];
                                        
                                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoginSuccess object:nil userInfo:nil];
                                        
                                        [JPUSHService setAlias:model.mobile completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                                            NSLog(@"iAlias = %@,  iResCode = %ld seq = %ld", iAlias, iResCode, seq);
                                        } seq:1];
                                        
                                        [self.navigationController popToRootViewControllerAnimated:true];
                                        
                                    }
                                }
                                failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                    // [ShowMessage showMessage:error.description];
                                    [MBProgressHUD hideHUDForView:self.view];
                                } isLogin:^{
                                    [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
                                }];
}

- (void)wechatLoginDirectly {
    NSString *openID = [[NSUserDefaults standardUserDefaults] objectForKey:WX_OPEN_ID];
    NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:WX_NICKNAME];
    NSMutableDictionary *bodyParams = [NSMutableDictionary new];
    [bodyParams setValue:@"wechat" forKey:@"type"];
    [bodyParams setValue:openID forKey:@"openid"];
    [bodyParams setValue:nickName forKey:@"nickname"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:postLogin]
                              headParams:[RCHttpHelper accessHeader]
                              bodyParams:bodyParams
                                 success:^(AFHTTPSessionManager *operation, id responseObject) {
                                     [MBProgressHUD hideHUDForView:self.view];
                                     [ShowMessage showMessage:responseObject[@"message"]];
                                     if ([responseObject[@"code"] integerValue] == 200) {
                                         
                                         TXUserModel *model = [TXUserModel new];
                                         model = [TXUserModel mj_objectWithKeyValues:responseObject[@"data"]];
                                         
                                         [TXModelAchivar updateUserModelWithKey:@"idField" value:model.idField];
                                         [TXModelAchivar updateUserModelWithKey:@"username" value:model.username];
                                         [TXModelAchivar updateUserModelWithKey:@"nickname" value:model.nickname];
                                         [TXModelAchivar updateUserModelWithKey:@"avatar" value:model.avatar];
                                         [TXModelAchivar updateUserModelWithKey:@"mobile" value:model.mobile];
                                         [TXModelAchivar updateUserModelWithKey:@"des" value:model.des];
                                         [TXModelAchivar updateUserModelWithKey:@"article_num" value:model.count.article_num];
                                         [TXModelAchivar updateUserModelWithKey:@"att_num" value:model.count.att_num];
                                         [TXModelAchivar updateUserModelWithKey:@"fans_num" value:model.count.fans_num];
                                         [TXModelAchivar updateUserModelWithKey:@"address" value:model.address];
                                         [TXModelAchivar updateUserModelWithKey:@"six" value:model.six];
                                         [TXModelAchivar updateUserModelWithKey:@"birthday" value:model.birthday];
                                         [TXModelAchivar updateUserModelWithKey:@"verified" value:model.verified];
                                         [TXModelAchivar updateUserModelWithKey:@"verified_status" value:model.verified_status];
                                         [TXModelAchivar updateUserModelWithKey:@"logintoken" value:model.logintoken];
                                         
                                         [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoginSuccess object:nil userInfo:nil];
                                         
                                         [JPUSHService setAlias:model.mobile completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                                             NSLog(@"iAlias = %@,  iResCode = %ld seq = %ld", iAlias, iResCode, seq);
                                         } seq:1];
                                         
                                         [self.navigationController popToRootViewControllerAnimated:true];
                                         
                                     }
                                 }
                                 failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                     // [ShowMessage showMessage:error.description];
                                     [MBProgressHUD hideHUDForView:self.view];
                                 } isLogin:^{
                                     [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
                                 }];
}

- (IBAction)touchRegisterButton:(id)sender {
    HXRegisterViewController *vwcRegister = [[HXRegisterViewController alloc] initWithNibName:NSStringFromClass([HXRegisterViewController class]) bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vwcRegister animated:true];
}

- (IBAction)touchWeChatLoginBt:(id)sender {
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:WX_ACCESS_TOKEN];
    NSString *openID = [[NSUserDefaults standardUserDefaults] objectForKey:WX_OPEN_ID];
    // 如果已经请求过微信授权登录，那么考虑用已经得到的access_token
    if (accessToken && openID) {
        NSString *refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:WX_REFRESH_TOKEN];
        NSString *refreshUrlStr = [NSString stringWithFormat:@"%@/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@", WX_BASE_URL, WX_App_ID, refreshToken];
        [[RCHttpHelper sharedHelper] getUrl:refreshUrlStr headParams:nil bodyParams:nil success:^(AFHTTPSessionManager *operation, id responseObject) {
            NSDictionary *refreshDict = [NSDictionary dictionaryWithDictionary:responseObject];
            NSString *reAccessToken = [refreshDict objectForKey:WX_ACCESS_TOKEN];
            // 如果reAccessToken为空,说明reAccessToken也过期了,反之则没有过期
            if (reAccessToken) {
                // 更新access_token、refresh_token、open_id
                [[NSUserDefaults standardUserDefaults] setObject:reAccessToken forKey:WX_ACCESS_TOKEN];
                [[NSUserDefaults standardUserDefaults] setObject:[refreshDict objectForKey:WX_OPEN_ID] forKey:WX_OPEN_ID];
                [[NSUserDefaults standardUserDefaults] setObject:[refreshDict objectForKey:WX_REFRESH_TOKEN] forKey:WX_REFRESH_TOKEN];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self wechatLoginByRequestForUserInfo];
            } else {
                [self wechatLogin];
            }
        } failure:^(AFHTTPSessionManager *operation, NSError *error) {
            NSLog(@"用refresh_token来更新accessToken时出错 = %@", error);
        } isLogin:^{
            
        }];
    }
    else {
        [self wechatLogin];
    }
}

// 获取用户个人信息（UnionID机制）
- (void)wechatLoginByRequestForUserInfo {
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:WX_ACCESS_TOKEN];
    NSString *openID = [[NSUserDefaults standardUserDefaults] objectForKey:WX_OPEN_ID];
    NSString *userUrlStr = [NSString stringWithFormat:@"%@/userinfo?access_token=%@&openid=%@", WX_BASE_URL, accessToken, openID];
    // 请求用户数据
    [[RCHttpHelper sharedHelper] getUrl:userUrlStr headParams:nil bodyParams:nil success:^(AFHTTPSessionManager *operation, id responseObject) {
        
        NSDictionary *accessDict = [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *nickName = [accessDict objectForKey:WX_NICKNAME];
        
        [[NSUserDefaults standardUserDefaults] setObject:nickName forKey:WX_NICKNAME];
        [[NSUserDefaults standardUserDefaults] synchronize]; // 命令直接同步到文件里，来避免数据的丢失
        
        // 判断微信号是否绑定
        [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getBindWeChat] headParams:nil bodyParams:@{WX_OPEN_ID : openID} success:^(AFHTTPSessionManager *operation, id responseObject) {
            if ([responseObject[@"code"] integerValue] == 200) {
                BOOL isBind = [responseObject[@"data"][@"is_bound"] boolValue];
                if (isBind) {
                    [self wechatLoginDirectly];
                } else {
                    HXBindPhoneViewController *vwcPhone = [[HXBindPhoneViewController alloc] initWithNibName:NSStringFromClass([HXBindPhoneViewController class]) bundle:[NSBundle mainBundle]];
                    vwcPhone.nickName = nickName;
                    vwcPhone.openId = openID;
                    [self.navigationController pushViewController:vwcPhone animated:true];
                }
            }
        } failure:^(AFHTTPSessionManager *operation, NSError *error) {
            
        } isLogin:^{
            
        }];
        
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        NSLog(@"获取用户信息时出错 = %@", error);
    } isLogin:^{
        
    }];
}

- (void)wechatLogin {
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"huoxun";
        [WXApi sendReq:req];
    }
    else {
        [self setupAlertController];
    }
}

- (void)wechatGetuserInfo {
    [self wechatLoginByRequestForUserInfo];
}

#pragma mark - 设置弹出提示语
- (void)setupAlertController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionConfirm];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
