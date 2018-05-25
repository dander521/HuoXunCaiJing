//
//  HXRegisterViewController.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/4.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXRegisterViewController.h"
#import "HXLoginViewController.h"
#import "HXPincodeViewController.h"

@interface HXRegisterViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nickNameTF;
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@end

@implementation HXRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"注册帐号";
    self.topLayout.constant = 30 + kTopHeight;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidChange:(NSNotification *)noti {
    if (self.accountTF.text.length != 0 &&
        self.passwordTF.text.length != 0 &&
        self.nickNameTF.text.length != 0) {
        self.nextBtn.enabled = true;
        [self.nextBtn setBackgroundColor:RGB(184, 11, 34)];
    } else {
        self.nextBtn.enabled = false;
        [self.nextBtn setBackgroundColor:RGB(153, 153, 153)];
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

- (IBAction)touchNextButton:(id)sender {
    
    if (![NSString isPhoneNumCorrectPhoneNum:self.accountTF.text]) {
        [ShowMessage showMessage:@"请输入正确的手机号"];
        return;
    }
    
    if (self.nickNameTF.text.length == 0) {
        [ShowMessage showMessage:@"请输入昵称"];
        return;
    }
    
    if (self.passwordTF.text.length < 6 || self.passwordTF.text.length > 20) {
        [ShowMessage showMessage:@"请输入6-20位数字和字母组成的密码"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:postPincode]
                              headParams:[RCHttpHelper accessHeader]
                              bodyParams:@{@"mobile" : self.accountTF.text, @"type" : @"reg"}
                                 success:^(AFHTTPSessionManager *operation, id responseObject) {
                                     [MBProgressHUD hideHUDForView:self.view];
                                     if ([responseObject[@"code"] integerValue] == 200 ||
                                         [responseObject[@"code"] integerValue] == 201) {
                                         HXPincodeViewController *vwcRegister = [[HXPincodeViewController alloc] initWithNibName:NSStringFromClass([HXPincodeViewController class]) bundle:[NSBundle mainBundle]];
                                         vwcRegister.phone = self.accountTF.text;
                                         vwcRegister.nickname = self.nickNameTF.text;
                                         vwcRegister.password = self.passwordTF.text;
                                         [self.navigationController pushViewController:vwcRegister animated:true];
                                     }
                                     [ShowMessage showMessage:responseObject[@"message"]];
                                 } failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                     // [ShowMessage showMessage:error.description];
                                     [MBProgressHUD hideHUDForView:self.view];
                                 } isLogin:^{
                                     [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
                                 }];
}

- (IBAction)touchLoginButton:(id)sender {
    HXLoginViewController *vwcRegister = [[HXLoginViewController alloc] initWithNibName:NSStringFromClass([HXLoginViewController class]) bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vwcRegister animated:true];
}

@end
