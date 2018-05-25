//
//  HXResetSecretViewController.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/6.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXResetSecretViewController.h"

@interface HXResetSecretViewController ()
@property (weak, nonatomic) IBOutlet UITextField *firstTF;
@property (weak, nonatomic) IBOutlet UITextField *repeatTF;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@end

@implementation HXResetSecretViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"重置密码";
    self.topLayout.constant = 30 + kTopHeight;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textFieldDidChange:(NSNotification *)noti {
    if (self.firstTF.text.length != 0 &&
        self.repeatTF.text.length != 0) {
        self.doneBtn.enabled = true;
        [self.doneBtn setBackgroundColor:RGB(184, 11, 34)];
    } else {
        self.doneBtn.enabled = false;
        [self.doneBtn setBackgroundColor:RGB(153, 153, 153)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)touchFirstButton:(id)sender {
    self.firstTF.secureTextEntry = self.firstTF.isSecureTextEntry ? false : true;
}

- (IBAction)touchSecondButton:(id)sender {
    self.repeatTF.secureTextEntry = self.repeatTF.isSecureTextEntry ? false : true;
}

- (IBAction)touchDoneButton:(id)sender {
    if (![NSString isPhoneNumCorrectPhoneNum:self.phone]) {
        [ShowMessage showMessage:@"请输入正确的手机号"];
        return;
    }
    
    if (self.pincode.length == 0) {
        [ShowMessage showMessage:@"请输入4位正确验证码"];
        return;
    }
    
    if (self.firstTF.text.length < 6 || self.firstTF.text.length > 20) {
        [ShowMessage showMessage:@"请输入6-20位数字和字母组成的密码"];
        return;
    }
    
    if (self.repeatTF.text.length < 6 || self.repeatTF.text.length > 20) {
        [ShowMessage showMessage:@"请输入6-20位数字和字母组成的密码"];
        return;
    }
    
    if (![self.firstTF.text isEqualToString:self.repeatTF.text]) {
        [ShowMessage showMessage:@"两次输入密码不一致"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:postFindPwd]
                              headParams:[RCHttpHelper accessHeader]
                              bodyParams:@{@"mobile" : self.phone,@"password" : self.firstTF.text, @"smscode" : self.pincode}
                                 success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        [ShowMessage showMessage:responseObject[@"message"]];
        if ([responseObject[@"code"] integerValue] == 200) {
            [self.navigationController popToRootViewControllerAnimated:true];
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        // [ShowMessage showMessage:error.description];
        [MBProgressHUD hideHUDForView:self.view];
    } isLogin:^{
        [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
    }];
}

@end
