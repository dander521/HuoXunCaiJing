//
//  HXInfoViewController.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/6.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXInfoViewController.h"
#import "HXInfoAvatarTableViewCell.h"
#import "HXInfoTitleTableViewCell.h"
#import "HXInfoDesTableViewCell.h"
#import "HXAuthenticationTableViewCell.h"
#import "HXAuthenticationViewController.h"
#import "TXCitySelector.h"
#import "PGDatePicker.h"

@interface HXInfoViewController () <UITableViewDataSource, UITableViewDelegate, TXCitySelectorDelegate, PGDatePickerDelegate, HXInfoAvatarTableViewCellDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) PGDatePicker *datePicker;
@property (nonatomic, strong) TXUserModel *userModel;
@property (nonatomic, strong) UIImage *imageAvatar;
@property (nonatomic, strong) UITextView *desTV;

@end

@implementation HXInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人资料";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authenticating) name:kNSNotificationAuthenticating object:nil];
    
    self.tableView.estimatedRowHeight = 0.0;
    self.tableView.estimatedSectionFooterHeight = 0.0;
    self.tableView.estimatedSectionHeaderHeight = 0.0;
    
    self.userModel = [TXUserModel defaultUser];

    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(saveInfo) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:RGB(178, 0, 0) forState:UIControlStateNormal];
    rightBtn.titleLabel.font = FONT(14);
    UIBarButtonItem *attention = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItems = @[attention];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Authenticating

- (void)authenticating {
    [self.tableView reloadData];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    self.userModel.des = self.desTV.text;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *defaultCell = nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            HXInfoAvatarTableViewCell *cell = [HXInfoAvatarTableViewCell cellWithTableView:tableView];
            cell.delegate = self;
            cell.cellLineRightMargin = TXCellRightMarginType0;
            cell.cellLineType = TXCellSeperateLinePositionType_Single;
            
            if (self.imageAvatar) {
                cell.avatarImg.image = self.imageAvatar;
            } else {
                [cell.avatarImg sd_setImageWithURL:[NSURL URLWithString:self.userModel.avatar] placeholderImage:[UIImage imageNamed:@"none_av"]];
            }
            
            NSString *buttonTitle = nil;
            
            if (self.imageAvatar || ![NSString isTextEmpty:self.userModel.avatar]) {
                buttonTitle = @"更改头像";
            } else {
                buttonTitle = @"上传头像";
            }
            [cell.uploadBtn setTitle:buttonTitle forState:UIControlStateNormal];
            
            defaultCell = cell;
        } else if (indexPath.row == 4) {
            HXInfoDesTableViewCell *cell = [HXInfoDesTableViewCell cellWithTableView:tableView];
            [cell.contentTV addPlaceholderWithText:@"输入个人介绍" textColor:RGB(153, 153, 153) font:FONT(13)];
            cell.contentTV.text = self.userModel.des;
            self.desTV = cell.contentTV;
            self.desTV.delegate = self;
            
            defaultCell = cell;
        } else {
            HXInfoTitleTableViewCell *cell = [HXInfoTitleTableViewCell cellWithTableView:tableView];
            cell.cellLineRightMargin = TXCellRightMarginType0;
            cell.cellLineType = TXCellSeperateLinePositionType_Single;
            if (indexPath.row == 1) {
                cell.nameLabel.text = @"昵称";
                cell.contentLabel.text = [NSString isTextEmpty:self.userModel.nickname] ? @"请输入" : self.userModel.nickname;
            } else if (indexPath.row == 2) {
                cell.nameLabel.text = @"地区";
                cell.contentLabel.text = [NSString isTextEmpty:self.userModel.address] ? @"请选择" : self.userModel.address;
            } else {
                cell.nameLabel.text = @"生日";
                cell.contentLabel.text = [NSString isTextEmpty:self.userModel.birthday] ? @"0000-00-00" : self.userModel.birthday;
            }
            defaultCell = cell;
        }
    } else {
        HXAuthenticationTableViewCell *cell = [HXAuthenticationTableViewCell cellWithTableView:tableView];
        if ([[TXModelAchivar getUserModel].verified_status isEqualToString:@"0"] || [[TXModelAchivar getUserModel].verified_status isEqualToString:@"3"]) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.verifyNameLabel.text = @"提交认证";
            cell.auImg.hidden = true;
        } else if ([[TXModelAchivar getUserModel].verified_status isEqualToString:@"1"]) {
            // 审核中
            cell.verifyNameLabel.text = @"审核中";
            cell.auImg.hidden = true;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            // 通过
            if ([self.userModel.verified isEqualToString:@"1"]) {
                cell.auImg.image = [UIImage imageNamed:@"verified_1"];
                cell.verifyNameLabel.textColor = RGB(251, 9, 32);
                cell.verifyNameLabel.text = @"自媒体";
            } else if ([self.userModel.verified isEqualToString:@"2"]) {
                cell.auImg.image = [UIImage imageNamed:@"verified_2"];
                cell.verifyNameLabel.textColor = RGB(54, 124, 255);
                cell.verifyNameLabel.text = @"媒体";
            } else if ([self.userModel.verified isEqualToString:@"3"]) {
                cell.auImg.image = [UIImage imageNamed:@"verified_3"];
                cell.verifyNameLabel.textColor = RGB(50, 177, 47);
                cell.verifyNameLabel.text = @"机构";
            } else if ([self.userModel.verified isEqualToString:@"4"]) {
                cell.auImg.image = [UIImage imageNamed:@"verified_4"];
                cell.verifyNameLabel.textColor = RGB(252, 104, 8);
                cell.verifyNameLabel.text = @"企业";
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
 
        defaultCell = cell;
    }
    
    return defaultCell;
}

#pragma mark  - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
//        if (([[TXModelAchivar getUserModel].verified_status isEqualToString:@"0"] || [[TXModelAchivar getUserModel].verified_status isEqualToString:@"3"])) {
//            HXAuthenticationViewController *vwcSet = [[HXAuthenticationViewController alloc] initWithNibName:NSStringFromClass([HXAuthenticationViewController class]) bundle:[NSBundle mainBundle]];
//            [self.navigationController pushViewController:vwcSet animated:true];
//        } else if ([[TXModelAchivar getUserModel].verified_status isEqualToString:@"1"]) {
//            // 审核中
//            [ShowMessage showMessage:@"审核中，请耐心等待"];
//        }
        if ([[TXModelAchivar getUserModel].verified_status isEqualToString:@"1"]) {
            // 审核中
            [ShowMessage showMessage:@"审核中，请耐心等待"];
        } else if (([[TXModelAchivar getUserModel].verified_status isEqualToString:@"0"] || [[TXModelAchivar getUserModel].verified_status isEqualToString:@"3"])) {
            HXAuthenticationViewController *vwcSet = [[HXAuthenticationViewController alloc] initWithNibName:NSStringFromClass([HXAuthenticationViewController class]) bundle:[NSBundle mainBundle]];
            vwcSet.isVerified = false;
            [self.navigationController pushViewController:vwcSet animated:true];
        } else if ([[TXModelAchivar getUserModel].verified_status isEqualToString:@"2"]) {
                HXAuthenticationViewController *vwcSet = [[HXAuthenticationViewController alloc] initWithNibName:NSStringFromClass([HXAuthenticationViewController class]) bundle:[NSBundle mainBundle]];
                vwcSet.isVerified = true;
                [self.navigationController pushViewController:vwcSet animated:true];
        }
    } else if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            [self touchChangeNicknameCell];
        } else if (indexPath.row == 2) {
            [self showCitySelectorView];
        } else if (indexPath.row == 3) {
            [self showDatePicker];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 4) {
        return 100;
    } else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - Custom

- (void)showCitySelectorView {
    TXCitySelector *citySelector = [TXCitySelector shareManager];
    citySelector.delegate = self;
    [citySelector showCitySelector];
}

- (void)showDatePicker {
    PGDatePicker *datePicker = [[PGDatePicker alloc]init];
    datePicker.delegate = self;
    datePicker.datePickerMode = PGDatePickerModeDate;
    [datePicker show];
}

#pragma mark - TXCitySelectorDelegate

- (void)touchCitySelectorButtonWithDictionary:(NSDictionary *)param {
    NSLog(@"%@-%@-%@", param[@"province"], param[@"city"], param[@"zone"])
    self.userModel.address = [NSString stringWithFormat:@"%@-%@-%@", param[@"province"], param[@"city"], param[@"zone"]];
    [self.tableView reloadData];
}

#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"dateComponents = %@", dateComponents);
    self.userModel.birthday = [NSString stringWithFormat:@"%ld-%ld-%ld", (long)dateComponents.year, (long)dateComponents.month, (long)dateComponents.day];
    [self.tableView reloadData];
}

#pragma mark - HXInfoAvatarTableViewCellDelegate

- (void)touchUploadUserAvatarButton {
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
            [[RCHttpHelper sharedHelper] uploadPicWithPostUrl:[httpHost stringByAppendingPathComponent:postModifyAvatar]
                                                   headParams:[RCHttpHelper accessAndLoginTokenHeader]
                                                   bodyParams:nil
                                                    imageKeys:@[@"file"]
                                                       images:@[imageData]
                                                     progress:nil
                                                      success:^(AFHTTPSessionManager *operation, id responseObject) {
                                                          [MBProgressHUD hideHUDForView:self.view];
                                                          self.imageAvatar = image;
                                                          
                                                          [TXModelAchivar updateUserModelWithKey:@"avatar" value:responseObject[@"data"][@"path"]];
                                                          
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
            [[RCHttpHelper sharedHelper] uploadPicWithPostUrl:[httpHost stringByAppendingPathComponent:postModifyAvatar]
                                                   headParams:[RCHttpHelper accessAndLoginTokenHeader]
                                                   bodyParams:nil
                                                    imageKeys:@[@"file"]
                                                       images:@[imageData]
                                                     progress:nil
                                                      success:^(AFHTTPSessionManager *operation, id responseObject) {
                                                          [MBProgressHUD hideHUDForView:self.view];
                                                          self.imageAvatar = image;
                                                          
                                                          [TXModelAchivar updateUserModelWithKey:@"avatar" value:responseObject[@"data"][@"path"]];
                                                          
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

- (void)touchChangeNicknameCell {
    UIAlertController *avatarAlert = [UIAlertController alertControllerWithTitle:@"修改昵称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    __weak __typeof(&*avatarAlert)weakAvatarAlert = avatarAlert;
    [avatarAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        NSLog(@"textField.text... = %@", textField.text);
    }];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"textField.text = %@", avatarAlert.textFields.firstObject.text);
        if ([NSString isTextEmpty:avatarAlert.textFields.firstObject.text]) {
            [ShowMessage showMessage:@"昵称不能为空"];
            return;
        }
        self.userModel.nickname = avatarAlert.textFields.firstObject.text;
        [self.tableView reloadData];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakAvatarAlert dismissViewControllerAnimated:true completion:nil];
    }];
    
    [TXCustomTools setActionTitleTextColor:RGB(46, 46, 46) action:sureAction];
    [TXCustomTools setActionTitleTextColor:RGB(0, 122, 255) action:cancelAction];
    
    [avatarAlert addAction:sureAction];
    [avatarAlert addAction:cancelAction];
    
    [self presentViewController:avatarAlert animated:true completion:nil];
}

#pragma mark - Custom

- (void)saveInfo {
    
    if ([NSString isTextEmpty:self.userModel.birthday]) {
        [ShowMessage showMessage:@"请选择生日"];
        return;
    }
    
    if ([NSString isTextEmpty:self.userModel.address]) {
        [ShowMessage showMessage:@"请选择地址"];
        return;
    }
    
    if ([NSString isTextEmpty:self.userModel.des]) {
        [ShowMessage showMessage:@"请输入个人介绍"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.userModel.nickname forKey:@"nickname"];
    [params setValue:@"1" forKey:@"six"];
    [params setValue:self.userModel.birthday forKey:@"birthday"];
    [params setValue:self.userModel.address forKey:@"address"];
    [params setValue:self.userModel.des forKey:@"description"];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:postModifyInfo]
                              headParams:[RCHttpHelper accessAndLoginTokenHeader]
                              bodyParams:params success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"code"] integerValue] == 200) {

            [TXModelAchivar updateUserModelWithKey:@"nickname" value:self.userModel.nickname];
            [TXModelAchivar updateUserModelWithKey:@"six" value:@"1"];
            [TXModelAchivar updateUserModelWithKey:@"birthday" value:self.userModel.birthday];
            [TXModelAchivar updateUserModelWithKey:@"des" value:self.userModel.des];
            [TXModelAchivar updateUserModelWithKey:@"address" value:self.userModel.address];
            
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
