//
//  HXAuthenticationViewController.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/6.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXAuthenticationViewController.h"
#import "HXInfoAvatarTableViewCell.h"
#import "HXApplyInputTableViewCell.h"
#import "HXApplyCategoryTableViewCell.h"
#import "HXInfoDesTableViewCell.h"
#import "HXVerifyTypeModel.h"
#import "HXVerifyModel.h"
#import "HXPaperIDModel.h"

@interface HXAuthenticationViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate, HXInfoAvatarTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <HXVerifyTypeModel *>*typesArray;
@property (nonatomic, strong) HXVerifyTypeModel *verifyTypeModel;
@property (nonatomic, strong) HXVerifyModel *verifyModel;

@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *emailTF;
@property (nonatomic, strong) UITextField *companyTF;
@property (nonatomic, strong) UITextView *desTV;

@property (nonatomic, strong) UIImage *imageAvatar;


@end

@implementation HXAuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"申请认证";
    
    self.tableView.estimatedRowHeight = 0.0;
    self.tableView.estimatedSectionFooterHeight = 0.0;
    self.tableView.estimatedSectionHeaderHeight = 0.0;
    
    self.typesArray = [NSMutableArray new];
    self.verifyModel = [HXVerifyModel new];
    
    if (self.isVerified) {
        self.nameTF.enabled = false;
        self.phoneTF.enabled = false;
        self.emailTF.enabled = false;
        self.companyTF.enabled = false;
        self.desTV.editable = false;
        self.desTV.selectable = false;
    } else {
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setTitle:@"提交申请" forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(commitApply) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn setTitleColor:RGB(178, 0, 0) forState:UIControlStateNormal];
        rightBtn.titleLabel.font = FONT(14);
        UIBarButtonItem *attention = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        
        self.navigationItem.rightBarButtonItems = @[attention];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getVerifyType];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]) {
        return YES;
    }

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.nameTF) {
        self.verifyModel.name = textField.text;
    } else if (textField == self.phoneTF) {
        self.verifyModel.tel = textField.text;
    } else if (textField == self.emailTF) {
        self.verifyModel.email = textField.text;
    } else if (textField == self.companyTF) {
        self.verifyModel.title = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([@"\n" isEqualToString:text] == YES) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.verifyModel.des = textView.text;
}

#pragma mark - UIResponder

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
}

- (void)touchUploadUserAvatarButton {
    if (self.isVerified) {
        return;
    }
    UIAlertController *avatarAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak __typeof(&*avatarAlert)weakAvatarAlert = avatarAlert;
    weakSelf(self);
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[CMImagePickerManager sharedCMImagePickerManager] showCameraWithViewController:weakSelf handler:^(UIImage *image) {
            if (!image) {
                [ShowMessage showMessage:@"图片异常"];
                return;
            }
            // 上传图片
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [[RCHttpHelper sharedHelper] uploadPicWithPostUrl:[httpHost stringByAppendingPathComponent:postVerifyFile]
                                                   headParams:[RCHttpHelper accessHeader]
                                                   bodyParams:nil imageKeys:@[@"file"]
                                                       images:@[imageData]
                                                     progress:nil
                                                      success:^(AFHTTPSessionManager *operation, id responseObject) {
                                                          [MBProgressHUD hideHUDForView:self.view];
                                                          self.imageAvatar = image;
                                                          
                                                          HXPaperIDModel *model = [HXPaperIDModel mj_objectWithKeyValues:responseObject[@"data"]];
                                                          self.verifyModel.paperwork = model.idField;
                                                          
                                                          [self.tableView reloadData];
                                                          
                                                          [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUploadAvatarSuccess object:nil userInfo:nil];
                                                      }
                                                      failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                                          // [ShowMessage showMessage:error.description];
                                                          [MBProgressHUD hideHUDForView:self.view];
                                                      }
                                                      isLogin:^{
                                                          [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
                                                      }];
        }];
    }];
    
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[CMImagePickerManager sharedCMImagePickerManager] showPhotoLibraryWithViewController:weakSelf handler:^(UIImage *image) {
            if (!image) {
                [ShowMessage showMessage:@"图片异常"];
                return;
            }
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [[RCHttpHelper sharedHelper] uploadPicWithPostUrl:[httpHost stringByAppendingPathComponent:postVerifyFile]
                                                   headParams:[RCHttpHelper accessHeader]
                                                   bodyParams:nil
                                                    imageKeys:@[@"file"]
                                                       images:@[imageData]
                                                     progress:nil
                                                      success:^(AFHTTPSessionManager *operation, id responseObject) {
                                                          [MBProgressHUD hideHUDForView:self.view];
                                                          self.imageAvatar = image;
                                                          
                                                          HXPaperIDModel *model = [HXPaperIDModel mj_objectWithKeyValues:responseObject[@"data"]];
                                                          self.verifyModel.paperwork = model.idField;
                                                          
                                                          [self.tableView reloadData];
                                                          
                                                          [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUploadAvatarSuccess object:nil userInfo:nil];
                                                      }
                                                      failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                                          // [ShowMessage showMessage:error.description];
                                                          [MBProgressHUD hideHUDForView:self.view];
                                                      }
                                                      isLogin:^{
                                                          [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
                                                      }];
        }];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakAvatarAlert dismissViewControllerAnimated:true completion:nil];
    }];

    [TXCustomTools setActionTitleTextColor:RGB(46, 46, 46) action:cameraAction];
    [TXCustomTools setActionTitleTextColor:RGB(46, 46, 46) action:albumAction];
    [TXCustomTools setActionTitleTextColor:RGB(0, 122, 255) action:cancelAction];
    
    [avatarAlert addAction:cameraAction];
    [avatarAlert addAction:albumAction];
    [avatarAlert addAction:cancelAction];
    
    [self presentViewController:avatarAlert animated:true completion:nil];
}

#pragma mark - Request

- (void)getVerifyInfo {
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getMyVerifyInfo]
                             headParams:[RCHttpHelper accessAndLoginTokenHeader]
                             bodyParams:nil
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"code"] integerValue] == 200) {
            self.verifyModel = [HXVerifyModel mj_objectWithKeyValues:responseObject[@"data"]];
            for (HXVerifyTypeModel *model in self.typesArray) {
                if ([self.verifyModel.type isEqualToString:model.idField]) {
                     self.verifyTypeModel = model;
                    break;
                }
            }
            [self.tableView reloadData];
        } else {
            [ShowMessage showMessage:responseObject[@"message"]];
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        // [ShowMessage showMessage:error.description];
    } isLogin:^{
        [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
    }];
}

- (void)getVerifyType {
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getVerifyType]
                             headParams:[RCHttpHelper accessHeader]
                             bodyParams:nil
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            HXVerifyTypeCollectionModel *collectionModel = [HXVerifyTypeCollectionModel mj_objectWithKeyValues:responseObject];
            [self.typesArray addObjectsFromArray:collectionModel.data];
            [self getVerifyInfo];
        } else {
            [MBProgressHUD hideHUDForView:self.view];
            [ShowMessage showMessage:responseObject[@"message"]];
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        // [ShowMessage showMessage:error.description];
    } isLogin:^{
        [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
    }];
}

- (void)commitApply {
    [self.view endEditing:true];
    
    if ([NSString isTextEmpty:self.verifyModel.paperwork]) {
        [ShowMessage showMessage:@"请上传营业执照或其他证明文件"];
        return;
    }
    
    if ([NSString isTextEmpty:self.verifyModel.name]) {
        [ShowMessage showMessage:@"请输入姓名"];
        return;
    }
    
    if ([NSString isTextEmpty:self.verifyModel.tel]) {
        [ShowMessage showMessage:@"请输入电话号码"];
        return;
    }
    
    if ([NSString isTextEmpty:self.verifyModel.email]) {
        [ShowMessage showMessage:@"请输入邮箱"];
        return;
    }
    
    if ([NSString isTextEmpty:self.verifyModel.title]) {
        [ShowMessage showMessage:@"请输入企业/机构/媒体名称"];
        return;
    }
    
    if ([NSString isTextEmpty:self.verifyModel.des]) {
        [ShowMessage showMessage:@"请输入简短介绍"];
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:self.verifyTypeModel.idField forKeyPath:@"type"];
    [param setValue:self.verifyModel.name forKeyPath:@"name"];
    [param setValue:self.verifyModel.tel forKeyPath:@"tel"];
    [param setValue:self.verifyModel.paperwork forKeyPath:@"paperwork"];
    [param setValue:self.verifyModel.title forKeyPath:@"title"];
    [param setValue:self.verifyModel.des forKeyPath:@"des"];
    [param setValue:self.verifyModel.email forKeyPath:@"email"];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:postVerifyInfo]
                              headParams:[RCHttpHelper accessAndLoginTokenHeader]
                              bodyParams:param
                                 success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"code"] integerValue] == 200) {
            [TXModelAchivar updateUserModelWithKey:@"status" value:@"1"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationAuthenticating object:nil userInfo:nil];
            [self.navigationController popToRootViewControllerAnimated:true];
        }
        [ShowMessage showMessage:responseObject[@"message"]];
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        // [ShowMessage showMessage:error.description];
    } isLogin:^{
        [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *defaultCell = nil;
    if (indexPath.section == 0) {
        HXApplyCategoryTableViewCell *cell = [HXApplyCategoryTableViewCell cellWithTableView:tableView];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.model = self.verifyTypeModel;
        
        defaultCell = cell;
    } else if (indexPath.section == 1) {
        HXApplyInputTableViewCell *cell = [HXApplyInputTableViewCell cellWithTableView:tableView];
        cell.cellLineRightMargin = TXCellRightMarginType0;
        cell.cellLineType = TXCellSeperateLinePositionType_Single;
        if (indexPath.row == 0) {
            cell.nameLabel.text = @"姓名";
            cell.inputTF.placeholder = @"输入姓名";
            cell.inputTF.text = self.verifyModel.name;
            self.nameTF = cell.inputTF;
            self.nameTF.delegate = self;
            self.nameTF.enabled = !self.isVerified;
        } else if (indexPath.row == 1) {
            cell.nameLabel.text = @"联系电话";
            cell.inputTF.placeholder = @"输入电话";
            cell.inputTF.text = self.verifyModel.tel;
            self.phoneTF = cell.inputTF;
            self.phoneTF.delegate = self;
            self.phoneTF.enabled = !self.isVerified;
        } else {
            cell.nameLabel.text = @"电子邮箱";
            cell.inputTF.placeholder = @"输入邮箱";
            cell.inputTF.text = self.verifyModel.email;
            self.emailTF = cell.inputTF;
            self.emailTF.delegate = self;
            self.emailTF.enabled = !self.isVerified;
        }
        defaultCell = cell;
    } else {
        if (indexPath.row == 0) {
            HXApplyInputTableViewCell *cell = [HXApplyInputTableViewCell cellWithTableView:tableView];
            cell.cellLineRightMargin = TXCellRightMarginType0;
            cell.cellLineType = TXCellSeperateLinePositionType_Single;
            cell.nameLabel.text = @"名称";
            cell.inputTF.placeholder = @"企业/机构/媒体名称";
            cell.inputTF.text = self.verifyModel.title;
            self.companyTF = cell.inputTF;
            self.companyTF.delegate = self;
            self.companyTF.enabled = !self.isVerified;
            defaultCell = cell;
        } else if (indexPath.row == 1) {
            HXInfoAvatarTableViewCell *cell = [HXInfoAvatarTableViewCell cellWithTableView:tableView];
            cell.nameLabel.text = @"证件上传";
            cell.cellLineRightMargin = TXCellRightMarginType0;
            cell.cellLineType = TXCellSeperateLinePositionType_Single;
            cell.delegate = self;
            if (self.imageAvatar) {
                cell.avatarImg.image = self.imageAvatar;
            } else {
                [cell.avatarImg sd_setImageWithURL:[NSURL URLWithString:self.verifyModel.paperwork_img] placeholderImage:[UIImage imageNamed:@"photo"]];
            }
            
            NSString *buttonTitle = nil;
            
            if (self.imageAvatar || ![NSString isTextEmpty:self.verifyModel.paperwork_img]) {
                buttonTitle = @"更改头像";
            } else {
                buttonTitle = @"上传头像";
            }
            [cell.uploadBtn setTitle:buttonTitle forState:UIControlStateNormal];
            
            cell.uploadBtn.hidden = self.isVerified;
            
            defaultCell = cell;
        } else {
            HXInfoDesTableViewCell *cell = [HXInfoDesTableViewCell cellWithTableView:tableView];
            cell.desLabel.text = @"简短介绍";
            [cell.contentTV addPlaceholderWithText:@"输入简短介绍" textColor:RGB(153, 153, 153) font:FONT(13)];
            cell.contentTV.text = self.verifyModel.des;
            self.desTV = cell.contentTV;
            self.desTV.delegate = self;
            self.desTV.editable = !self.isVerified;
            self.desTV.selectable = !self.isVerified;
            defaultCell = cell;
        }
    }
    
    return defaultCell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isVerified) {
        return;
    }
    
    if (indexPath.section == 0) {
        [self touchSelectTypeCell];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 && indexPath.row == 2) return 100;
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    UILabel *perLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 30)];
    perLabel.font = FONT(14);
    perLabel.textColor = RGB(102, 102, 102);
    if (section == 1) {
        perLabel.text = @"运营者信息";
        [header addSubview:perLabel];
        return header;
    } else if (section == 2) {
        perLabel.text = @"单位信息";
        [header addSubview:perLabel];
        return header;
    }
    
    return nil;
}

- (void)touchSelectTypeCell {
    UIAlertController *avatarAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    __weak __typeof(&*avatarAlert)weakAvatarAlert = avatarAlert;
    weakSelf(self);
    
    for (HXVerifyTypeModel *model in self.typesArray) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:model.name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakSelf.verifyTypeModel = model;
            [weakSelf.tableView reloadData];
        }];
        [TXCustomTools setActionTitleTextColor:RGB(46, 46, 46) action:action];
        [avatarAlert addAction:action];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakAvatarAlert dismissViewControllerAnimated:true completion:nil];
    }];
    
    [TXCustomTools setActionTitleTextColor:RGB(0, 122, 255) action:cancelAction];
    [avatarAlert addAction:cancelAction];
    
    [self presentViewController:avatarAlert animated:true completion:nil];
}


@end
