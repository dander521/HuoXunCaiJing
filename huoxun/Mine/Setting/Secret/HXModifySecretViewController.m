//
//  HXModifySecretViewController.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/6.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXModifySecretViewController.h"

@interface HXModifySecretViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldTF;
@property (weak, nonatomic) IBOutlet UITextField *curTF;
@property (weak, nonatomic) IBOutlet UITextField *repeatTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation HXModifySecretViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改密码";
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
    if (self.oldTF.text.length != 0 &&
        self.curTF.text.length != 0 &&
        self.repeatTF.text.length != 0) {
        self.rightBtn.enabled = true;
        [self.rightBtn setTitleColor:RGB(184, 11, 34) forState:UIControlStateNormal];
    } else {
        self.rightBtn.enabled = false;
        [self.rightBtn setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
    }
}

#pragma mark - Custom

- (void)save {
    if (self.oldTF.text.length < 6 || self.oldTF.text.length > 20) {
        [ShowMessage showMessage:@"请输入6-20位数字和字母组成的旧密码"];
        return;
    }
    
    if (self.curTF.text.length < 6 || self.curTF.text.length > 20) {
        [ShowMessage showMessage:@"请输入6-20位数字和字母组成的密码"];
        return;
    }
    
    if (self.repeatTF.text.length < 6 || self.repeatTF.text.length > 20) {
        [ShowMessage showMessage:@"请输入6-20位数字和字母组成的密码"];
        return;
    }
    
    if (![self.curTF.text isEqualToString:self.repeatTF.text]) {
        [ShowMessage showMessage:@"两次输入新密码不一致"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:postModifySecret]
                              headParams:[RCHttpHelper accessAndLoginTokenHeader]
                              bodyParams:@{@"old_password" : self.oldTF.text, @"password" : self.curTF.text} success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [self.navigationController popViewControllerAnimated:true];
        }
        [ShowMessage showMessage:responseObject[@"message"]];
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        // [ShowMessage showMessage:error.description];
    } isLogin:^{
        [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
    }];
}

@end
