//
//  HXBindPhoneViewController.m
//  huoxun
//
//  Created by 倩倩 on 2018/3/11.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXBindPhoneViewController.h"
#import "JPUSHService.h"

@interface HXBindPhoneViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *pincodeTF;
@property (weak, nonatomic) IBOutlet UITextField *secretTF;
@property (weak, nonatomic) IBOutlet UITextField *repeatTF;
@property (weak, nonatomic) IBOutlet UIButton *pincodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *bindBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;

@property (weak, nonatomic) IBOutlet UIImageView *secretImageView;
@property (weak, nonatomic) IBOutlet UIImageView *repeatImageView;
@property (weak, nonatomic) IBOutlet UILabel *secretLineLabel;
@property (weak, nonatomic) IBOutlet UILabel *repeatLineLabel;

@property (nonatomic, assign) BOOL isFirst;


@end

@implementation HXBindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    adjustsScrollViewInsets_NO(<#scrollView#>, <#vc#>)
    self.topLayout.constant = 30 + kTopHeight;
    self.navigationItem.title = @"绑定手机号";
    
    self.isFirst = false;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidChange:(NSNotification *)noti {
    if (self.phoneTF.text.length != 0 &&
        self.pincodeTF.text.length != 0 &&
        self.secretTF.text.length != 0 &&
        self.repeatTF.text.length != 0) {
        self.bindBtn.enabled = true;
        [self.bindBtn setBackgroundColor:RGB(184, 11, 34)];
    } else {
        self.bindBtn.enabled = false;
        [self.bindBtn setBackgroundColor:RGB(153, 153, 153)];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.phoneTF && !self.isFirst) {
        [self judgePhoneNo];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:true];
    if (textField == self.phoneTF && !self.isFirst) {
        [self judgePhoneNo];
    }
    return true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)judgePhoneNo {
    if ([NSString isTextEmpty:self.phoneTF.text]) {
        [ShowMessage showMessage:@"请输入正确的手机号码"];
        return;
    }
    
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getIsReg]
                             headParams:[RCHttpHelper accessHeader]
                             bodyParams:@{@"mobile" : self.phoneTF.text}
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
                                    [MBProgressHUD hideHUDForView:self.view];
                                    if ([responseObject[@"code"] integerValue] == 200) {
                                        self.isFirst = true;
                                        if ([responseObject[@"data"] integerValue] == 1) {
                                            self.secretTF.text = @"";
                                            self.secretTF.hidden = true;
                                            self.secretImageView.hidden = true;
                                            self.secretLineLabel.hidden = true;
                                            self.repeatTF.hidden = true;
                                            self.repeatImageView.hidden = true;
                                            self.repeatLineLabel.hidden = true;
                                        } else if ([responseObject[@"data"] integerValue] == 0) {
                                            self.secretTF.hidden = false;
                                            self.secretImageView.hidden = false;
                                            self.secretLineLabel.hidden = false;
                                            self.repeatTF.hidden = false;
                                            self.repeatImageView.hidden = false;
                                            self.repeatLineLabel.hidden = false;
                                        }
                                    }
                                    [ShowMessage showMessage:responseObject[@"message"]];
                                } failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                    [MBProgressHUD hideHUDForView:self.view];
                                } isLogin:^{
                                    [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
                                }];
}

- (IBAction)touchGetPincodeBtn:(id)sender {
    
    if ([NSString isTextEmpty:self.phoneTF.text]) {
        [ShowMessage showMessage:@"请输入正确的手机号码"];
        return;
    }
    
    [[TXCountDownTime sharedTXCountDownTime] startWithTime:60 title:@"获取验证码" countDownTitle:@"重新获取" mainColor:RGB(246, 30, 46) countColor:[UIColor lightGrayColor] atBtn:self.pincodeBtn];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:postPincode]
                              headParams:[RCHttpHelper accessHeader]
                              bodyParams:@{@"mobile" : self.phoneTF.text, @"type" : @"bound"}
                                 success:^(AFHTTPSessionManager *operation, id responseObject) {
                                     [MBProgressHUD hideHUDForView:self.view];
                                     if ([responseObject[@"code"] integerValue] == 200) {
                                         
                                     }
                                     [ShowMessage showMessage:responseObject[@"message"]];
                                 } failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                     [MBProgressHUD hideHUDForView:self.view];
                                 } isLogin:^{
                                     [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
                                 }];
}

- (IBAction)touchBindPhoneBtn:(id)sender {
    if ([NSString isTextEmpty:self.phoneTF.text]) {
        [ShowMessage showMessage:@"请输入正确的手机号码"];
        return;
    }
    
    if ([NSString isTextEmpty:self.pincodeTF.text]) {
        [ShowMessage showMessage:@"请输入正确的验证码"];
        return;
    }
    
    if ([NSString isTextEmpty:self.secretTF.text]) {
        [ShowMessage showMessage:@"请输入手机密码"];
        return;
    }
    
    if ([NSString isTextEmpty:self.repeatTF.text]) {
        [ShowMessage showMessage:@"请重复输入手机密码"];
        return;
    }
    
    if (![self.secretTF.text isEqualToString:self.repeatTF.text]) {
        [ShowMessage showMessage:@"输入密码不一致"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.phoneTF.text forKey:@"mobile"];
    [params setValue:self.pincodeTF.text forKey:@"smscode"];
    [params setValue:self.secretTF.text forKey:@"password"];
    [params setValue:self.nickName forKey:@"nickname"];
    [params setValue:self.openId forKey:@"openid"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:postBindPhone] headParams:nil bodyParams:@{@"mobile" : self.phoneTF.text, @"smscode" : self.pincodeTF.text, @"password" : self.secretTF.text, @"nickname" : self.nickName, @"openid" : self.openId} success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
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
        [ShowMessage showMessage:responseObject[@"message"]];
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
    } isLogin:^{
        
    }];
}


@end
