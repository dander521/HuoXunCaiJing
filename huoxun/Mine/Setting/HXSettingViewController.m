//
//  HXSettingViewController.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/6.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXSettingViewController.h"
#import "HXCommonTableViewCell.h"
#import "HXModifyPhoneViewController.h"
#import "HXModifySecretViewController.h"
#import "HXInfoViewController.h"
#import "JPUSHService.h"
#import "WXApi.h"

@interface HXSettingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UISwitch *cusSwitch;

@end

@implementation HXSettingViewController

- (void)viewDidLoad { 
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    
    self.tableView.estimatedRowHeight = 0.0;
    self.tableView.estimatedSectionFooterHeight = 0.0;
    self.tableView.estimatedSectionHeaderHeight = 0.0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatGetuserInfo) name:kNSNotificationWeChatGetUserInfo object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HXCommonTableViewCell *cell = [HXCommonTableViewCell cellWithTableView:tableView];
    cell.cellLineRightMargin = TXCellRightMarginType0;
    cell.cellLineType = TXCellSeperateLinePositionType_Single;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.nameLabel.text = @"个人资料";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.row == 1) {
            cell.nameLabel.text = @"修改密码";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.row == 2) {
            cell.nameLabel.text = @"更改手机号";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.nameLabel.text = @"清除缓存";
            UILabel *cleanLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
            cleanLab.text = @"清理";
            cleanLab.font = FONT(14);
            cleanLab.textColor = RGB(178, 0, 0);
            cell.accessoryView = cleanLab;
        }
    } else if (indexPath.section == 1) {
        cell.nameLabel.text = @"微信";
        cell.accessoryView = self.cusSwitch;
    } else if (indexPath.section == 2) {
        cell.nameLabel.text = @"退出登录";
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (![[TXUserModel defaultUser] userLoginStatus]) {
                [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
                return;
            }
            HXInfoViewController *vwcSet = [[HXInfoViewController alloc] initWithNibName:NSStringFromClass([HXInfoViewController class]) bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:vwcSet animated:true];
        } else if (indexPath.row == 1) {
            if (![[TXUserModel defaultUser] userLoginStatus]) {
                [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
                return;
            }
            HXModifySecretViewController *vwcSet = [[HXModifySecretViewController alloc] initWithNibName:NSStringFromClass([HXModifySecretViewController class]) bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:vwcSet animated:true];
        } else if (indexPath.row == 2) {
            if (![[TXUserModel defaultUser] userLoginStatus]) {
                [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
                return;
            }
            HXModifyPhoneViewController *vwcSet = [[HXModifyPhoneViewController alloc] initWithNibName:NSStringFromClass([HXModifyPhoneViewController class]) bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:vwcSet animated:true];
        } else {
            [self cleanCache];
        }
    } else if (indexPath.section == 2) {
        [self logoutApp];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - Custom

- (void)cleanCache {
    
    NSString *homeDir = NSHomeDirectory();
    
    //图片缓存的路径
    NSString *cachePath = nil;
    cachePath = @"Library/Caches/default/com.hackemist.SDWebImageCache.default";
    //完整的路径
    //拼接路径
    NSString *fullPath = [homeDir stringByAppendingPathComponent:cachePath];
    //使用文件管家，删除路径下的缓存文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isSuccess = [fileManager removeItemAtPath:fullPath error:nil];
    
    if (isSuccess) {
        [[SDImageCache sharedImageCache] clearMemory];
        [ShowMessage showMessage:@"清理缓存成功！" withCenter:self.view.center];
    } else {
        [ShowMessage showMessage:@"清理缓存失败！" withCenter:self.view.center];
    }
}

- (void)logoutApp {
    UIAlertController *avatarAlert = [UIAlertController alertControllerWithTitle:@"退出" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    __weak __typeof(&*avatarAlert)weakAvatarAlert = avatarAlert;
    weakSelf(self);
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[TXUserModel defaultUser] resetModelData];
        
        [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            NSLog(@"iAlias = %@,  iResCode = %ld seq = %ld", iAlias, iResCode, seq);
        } seq:1];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoginOutSuccess object:nil userInfo:nil];
        [weakSelf.navigationController popToRootViewControllerAnimated:true];
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

- (UISwitch *)cusSwitch {
    if (!_cusSwitch) {
        _cusSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
        
        if([[TXModelAchivar getUserModel].bound_wechat integerValue] == 1) {
            [_cusSwitch setOn:true];
        } else {
            [_cusSwitch setOn:false];
        }
        [_cusSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _cusSwitch;
}

- (void)switchAction:(UISwitch *)sender {
    if (sender.isOn) {
        NSString *openID = [[NSUserDefaults standardUserDefaults] objectForKey:WX_OPEN_ID];
        if ([NSString isTextEmpty:openID]) {
            [self getOpenId];
        } else {
            // 绑定
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:postBindWeChat]
                                      headParams:[RCHttpHelper accessAndLoginTokenHeader]
                                      bodyParams:@{@"openid" : openID}
                                         success:^(AFHTTPSessionManager *operation, id responseObject) {
                                             [MBProgressHUD hideHUDForView:self.view];
                                             if ([responseObject[@"code"] integerValue] == 200) {
                                                 [TXModelAchivar updateUserModelWithKey:@"bound_wechat" value:@"1"];
                                                 [self.tableView reloadData];
                                             }
                                             [ShowMessage showMessage:responseObject[@"message"]];
                                         } failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                             [MBProgressHUD hideHUDForView:self.view];
                                         } isLogin:^{
                                             [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
                                         }];
        }
    } else {
        // 解绑
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getUnbindWeChat]
                                  headParams:[RCHttpHelper accessAndLoginTokenHeader]
                                  bodyParams:nil
                                     success:^(AFHTTPSessionManager *operation, id responseObject) {
                                         [MBProgressHUD hideHUDForView:self.view];
                                         if ([responseObject[@"code"] integerValue] == 200) {
                                             [TXModelAchivar updateUserModelWithKey:@"bound_wechat" value:@"0"];
                                             [[NSUserDefaults standardUserDefaults] removeObjectForKey:WX_NICKNAME];
                                             [[NSUserDefaults standardUserDefaults] removeObjectForKey:WX_OPEN_ID];
                                             [[NSUserDefaults standardUserDefaults] removeObjectForKey:WX_ACCESS_TOKEN];
                                             [[NSUserDefaults standardUserDefaults] removeObjectForKey:WX_REFRESH_TOKEN];
                                             [[NSUserDefaults standardUserDefaults] synchronize];
                                             
                                             [self.tableView reloadData];
                                         }
                                         [ShowMessage showMessage:responseObject[@"message"]];
                                     } failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                         // [ShowMessage showMessage:error.description];
                                         [MBProgressHUD hideHUDForView:self.view];
                                     } isLogin:^{
                                         [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
                                     }];
    }
}

- (void)getOpenId {
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

#pragma mark - 设置弹出提示语
- (void)setupAlertController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionConfirm];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)wechatGetuserInfo {
    
    if ([NSString isTextEmpty:[TXModelAchivar getUserModel].logintoken]) {
        return;
    }
    
    NSString *openID = [[NSUserDefaults standardUserDefaults] objectForKey:WX_OPEN_ID];
    // 绑定
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:postBindWeChat]
                              headParams:[RCHttpHelper accessAndLoginTokenHeader]
                              bodyParams:@{@"openid" : openID}
                                 success:^(AFHTTPSessionManager *operation, id responseObject) {
                                     [MBProgressHUD hideHUDForView:self.view];
                                     if ([responseObject[@"code"] integerValue] == 200) {
                                         [TXModelAchivar updateUserModelWithKey:@"bound_wechat" value:@"1"];
                                         [self.tableView reloadData];
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
