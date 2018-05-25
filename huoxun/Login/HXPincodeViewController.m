//
//  HXPincodeViewController.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/4.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXPincodeViewController.h"
#import "HXLoginViewController.h"
#import "TXShowWebViewController.h"
#import "JPUSHService.h"

@interface HXPincodeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *pincodeTF;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@property (weak, nonatomic) IBOutlet UIButton *pincodeBtn;

@end

@implementation HXPincodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"注册帐号";
    self.topLayout.constant = 30 + kTopHeight;
    
    [[TXCountDownTime sharedTXCountDownTime] startWithTime:60 title:@"获取验证码" countDownTitle:@"重新获取" mainColor:RGB(246, 30, 46) countColor:[UIColor lightGrayColor] atBtn:self.pincodeBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)textFieldDidChange:(NSNotification *)noti {
    if (self.pincodeTF.text.length != 0) {
        self.doneBtn.enabled = true;
        [self.doneBtn setBackgroundColor:RGB(184, 11, 34)];
    } else {
        self.doneBtn.enabled = false;
        [self.doneBtn setBackgroundColor:RGB(153, 153, 153)];
    }
}

#pragma mark - Touch Method

- (IBAction)touchDoneButton:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:getRegister]
                              headParams:[RCHttpHelper accessHeader]
                              bodyParams:@{@"mobile" : self.phone ,@"password" : self.password, @"nickname" : self.nickname, @"smscode" : self.pincodeTF.text}
                                 success:^(AFHTTPSessionManager *operation, id responseObject) {
        [ShowMessage showMessage:responseObject[@"message"]];
        if ([responseObject[@"code"] integerValue] == 200) {
            // 通知个人中心页面处理数据
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRegisterSuccess object:nil];
            [self autoLogin];
        } else {
            [MBProgressHUD hideHUDForView:self.view];
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        // [ShowMessage showMessage:error.description];
        [MBProgressHUD hideHUDForView:self.view];
    } isLogin:^{
        [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
    }];
}

- (void)autoLogin {
    NSMutableDictionary *bodyParams = [NSMutableDictionary new];
    [bodyParams setValue:@"pwd" forKey:@"type"];
    [bodyParams setValue:self.phone forKey:@"mobile"];
    [bodyParams setValue:self.password forKey:@"password"];
    
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

- (IBAction)touchHXProtocolButton:(id)sender {
    TXShowWebViewController *vwcWeb = [TXShowWebViewController new];
    vwcWeb.webViewUrl = @"http://huoxun.com/m/protocol";
    vwcWeb.naviTitle = @"火讯财经使用协议";
    [self.navigationController pushViewController:vwcWeb animated:true];
}

- (IBAction)touchLoginButton:(id)sender {
    HXLoginViewController *vwcRegister = [[HXLoginViewController alloc] initWithNibName:NSStringFromClass([HXLoginViewController class]) bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vwcRegister animated:true];
}

- (IBAction)touchPincodeButton:(id)sender {
    
    [[TXCountDownTime sharedTXCountDownTime] startWithTime:60 title:@"获取验证码" countDownTitle:@"重新获取" mainColor:RGB(246, 30, 46) countColor:[UIColor lightGrayColor] atBtn:self.pincodeBtn];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:postPincode]
                              headParams:[RCHttpHelper accessHeader]
                              bodyParams:@{@"mobile" : self.phone, @"type" : @"reg"}
                                 success:^(AFHTTPSessionManager *operation, id responseObject) {
                                     [MBProgressHUD hideHUDForView:self.view];
                                     if ([responseObject[@"code"] integerValue] == 200) {
                                         
                                     }
                                     [ShowMessage showMessage:responseObject[@"message"]];
                                 } failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                     // [ShowMessage showMessage:error.description];
                                     [MBProgressHUD hideHUDForView:self.view];
                                 } isLogin:^{
                                     [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
                                 }];
}


@end
