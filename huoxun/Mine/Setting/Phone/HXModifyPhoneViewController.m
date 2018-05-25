//
//  HXModifyPhoneViewController.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/6.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXModifyPhoneViewController.h"
#import "HXLoginViewController.h"

@interface HXModifyPhoneViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@property (weak, nonatomic) IBOutlet UITextField *pincodeTF;
@property (weak, nonatomic) IBOutlet UIButton *pinBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@end

@implementation HXModifyPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"更改手机号";
    self.topLayout.constant = 30 + kTopHeight;
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn setTitleColor:RGB(178, 0, 0) forState:UIControlStateNormal];
    self.rightBtn.titleLabel.font = FONT(14);
    UIBarButtonItem *attention = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    self.rightBtn.enabled = false;
    self.navigationItem.rightBarButtonItems = @[attention];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidChange:(NSNotification *)noti {
    if (self.phoneTF.text.length != 0 &&
        self.pincodeTF.text.length != 0) {
        self.rightBtn.enabled = true;
        [self.rightBtn setTitleColor:RGB(184, 11, 34) forState:UIControlStateNormal];
    } else {
        self.rightBtn.enabled = false;
        [self.rightBtn setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
    }
}

#pragma mark - Custom

- (void)save {
    if (self.pincodeTF.text.length != 4) {
        [ShowMessage showMessage:@"请输入正确的短信验证码"];
        return;
    }

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:postModifyPhone]
                              headParams:[RCHttpHelper accessHeader]
                              bodyParams:@{@"new_mobile" : self.phoneTF.text, @"smscode" : self.pincodeTF.text}
                                 success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"code"] integerValue] == 200) {
            [TXModelAchivar updateUserModelWithKey:@"mobile" value:self.phoneTF.text];
            [[TXUserModel defaultUser] resetModelData];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoginOutSuccess object:nil userInfo:nil];
            HXLoginViewController *vwcRegister = [[HXLoginViewController alloc] initWithNibName:NSStringFromClass([HXLoginViewController class]) bundle:[NSBundle mainBundle]];
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

- (IBAction)touchPinButton:(id)sender {
    if (![NSString isPhoneNumCorrectPhoneNum:self.phoneTF.text]) {
        [ShowMessage showMessage:@"请输入正确的手机号"];
        return;
    }
    
    [[TXCountDownTime sharedTXCountDownTime] startWithTime:60 title:@"获取验证码" countDownTitle:@"重新获取" mainColor:RGB(246, 30, 46) countColor:[UIColor lightGrayColor] atBtn:self.pinBtn];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:postPincode]
                              headParams:[RCHttpHelper accessHeader]
                              bodyParams:@{@"mobile" : [TXModelAchivar getUserModel].mobile, @"type" : @"login"}
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
