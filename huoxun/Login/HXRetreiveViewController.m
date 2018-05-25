//
//  HXRetreiveViewController.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/6.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXRetreiveViewController.h"
#import "HXResetSecretViewController.h"
#import "TXCountDownTime.h"

@interface HXRetreiveViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *pincodeTF;
@property (weak, nonatomic) IBOutlet UIButton *pincodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@end

@implementation HXRetreiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"忘记密码";
    self.topLayout.constant = 30 + kTopHeight;
    self.phoneTF.text = [TXModelAchivar getUserModel].mobile;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textFieldDidChange:(NSNotification *)noti {
    if (self.phoneTF.text.length != 0 &&
        self.pincodeTF.text.length != 0) {
        self.nextBtn.enabled = true;
        [self.nextBtn setBackgroundColor:RGB(184, 11, 34)];
    } else {
        self.nextBtn.enabled = false;
        [self.nextBtn setBackgroundColor:RGB(153, 153, 153)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)touchGetPincodeButton:(id)sender {
    if (![NSString isPhoneNumCorrectPhoneNum:self.phoneTF.text]) {
        [ShowMessage showMessage:@"请输入正确的手机号"];
        return;
    }
    
    [[TXCountDownTime sharedTXCountDownTime] startWithTime:60 title:@"获取验证码" countDownTitle:@"重新获取" mainColor:RGB(246, 30, 46) countColor:[UIColor lightGrayColor] atBtn:self.pincodeBtn];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:postPincode]
                              headParams:[RCHttpHelper accessHeader]
                              bodyParams:@{@"mobile" : self.phoneTF.text, @"type" : @"login"}
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

- (IBAction)touchNextButton:(id)sender {
    HXResetSecretViewController *vwcRegister = [[HXResetSecretViewController alloc] initWithNibName:NSStringFromClass([HXResetSecretViewController class]) bundle:[NSBundle mainBundle]];
    vwcRegister.pincode = self.pincodeTF.text;
    vwcRegister.phone = self.phoneTF.text;
    [self.navigationController pushViewController:vwcRegister animated:true];
}


@end
