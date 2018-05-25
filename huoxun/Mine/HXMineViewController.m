//
//  HXMineViewController.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/4.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXMineViewController.h"
#import "HXAuthorHeaderTableViewCell.h"
#import "HXMineTableViewCell.h"
#import "HXSettingViewController.h"
#import "HXCollectionViewController.h"
#import "TXUserModel.h"
#import "HXHistoryViewController.h"
#import "TXShowWebViewController.h"
#import "HXAttentionOrFansViewController.h"
#import "HXCandyTableViewController.h"


@interface HXMineViewController () <UITableViewDelegate, UITableViewDataSource, HXAuthorHeaderTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *candyNum;

@end

@implementation HXMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginInSuccess) name:kNotificationLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOutSuccess) name:kNotificationLoginOutSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOutSuccess) name:kNotificationUploadAvatarSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:kNSNotificationRemoveAttention object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:kNotificationPayAttentionSuccess object:nil];
    
    // 定义全局leftBarButtonItem
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@""]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];
    
    // 定义全局leftBarButtonItem
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shezhi"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(touchSettingBtn)];
    
    self.tableView.estimatedRowHeight = 0.0;
    self.tableView.estimatedSectionFooterHeight = 0.0;
    self.tableView.estimatedSectionHeaderHeight = 0.0;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Notification

- (void)loginInSuccess {
    [self loadData];
}

- (void)loginOutSuccess {
    [self.tableView reloadData];
}

#pragma mark - Request

- (void)getCandyNumber {
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getMySugar]
                             headParams:[RCHttpHelper accessAndLoginTokenHeader]
                             bodyParams:nil
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
                                    if ([responseObject[@"code"] integerValue] == 200) {
                                        self.candyNum = [NSString stringWithFormat:@"%@", responseObject[@"data"]];
                                        [self.tableView reloadData];
                                    } else {
                                        [ShowMessage showMessage:responseObject[@"message"]];
                                    }
                                } failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                } isLogin:^{
                                    [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
                                }];
}

- (void)loadData {
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getMyInfo]
                             headParams:[RCHttpHelper accessAndLoginTokenHeader]
                             bodyParams:nil
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
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
            [TXModelAchivar updateUserModelWithKey:@"bound_wechat" value:model.bound_wechat];
            
            [self.tableView reloadData];
            [self getCandyNumber];
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

#pragma mark - Custom

- (void)touchSettingBtn {
    HXSettingViewController *vwcSet = [[HXSettingViewController alloc] initWithNibName:NSStringFromClass([HXSettingViewController class]) bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vwcSet animated:true];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) return 2;
    if (section == 2) return 3;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *defaultCell = nil;
    if (indexPath.section == 0) {
        HXAuthorHeaderTableViewCell *cell = [HXAuthorHeaderTableViewCell cellWithTableView:tableView];
        cell.nameLabel.text = [TXModelAchivar getUserModel].nickname;
        cell.articleLabel.text = [TXModelAchivar getUserModel].article_num;
        cell.attentionLabel.text = [TXModelAchivar getUserModel].att_num;
        cell.funsLabel.text = [TXModelAchivar getUserModel].fans_num;
        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[TXModelAchivar getUserModel].avatar] placeholderImage:[UIImage imageNamed:@"none_av"]];
        cell.delegate = self;
        defaultCell = cell;
    } else {
        HXMineTableViewCell *cell = [HXMineTableViewCell cellWithTableView:tableView];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        NSString *icon = nil;
        NSString *name = nil;
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                icon = @"m_j";
                name = @"积分";
                cell.countLabel.hidden = false;
                cell.countLabel.text = self.candyNum;
            } else {
                icon = @"m_3";
                name = @"兑换";
            }
        } else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                icon = @"m_1";
                name = @"收藏";
            } else if (indexPath.row == 1) {
                icon = @"m_6";
                name = @"点赞";
            }  else if (indexPath.row == 2) {
                icon = @"m_5";
                name = @"分享";
            }
        } else if (indexPath.section == 3) {
            icon = @"m_4";
            name = @"历史足迹";
        } else {
            icon = @"logo";
            name = @"关于火讯财经";
        }
        cell.iconImg.image = [UIImage imageNamed:icon];
        cell.nameLabel.text = name;
        defaultCell = cell;
    }
    return defaultCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 4) {
        TXShowWebViewController *vwcWeb = [TXShowWebViewController new];
        vwcWeb.webViewUrl = @"http://huoxun.com/m/about?app=yes";
        vwcWeb.naviTitle = @"关于火讯财经";
        [self.navigationController pushViewController:vwcWeb animated:true];
    } else if (indexPath.section == 3) {
        // 历史足迹
        HXHistoryViewController *vwcSet = [[HXHistoryViewController alloc] initWithNibName:NSStringFromClass([HXHistoryViewController class]) bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:vwcSet animated:true];
    } else {
        if (![[TXUserModel defaultUser] userLoginStatus]) {
            [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
            return;
        }
        
        if (indexPath.section == 0) {
            
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                HXCandyTableViewController *vwcSet = [[HXCandyTableViewController alloc] initWithNibName:NSStringFromClass([HXCandyTableViewController class]) bundle:[NSBundle mainBundle]];
                [self.navigationController pushViewController:vwcSet animated:true];
            } else {
                TXShowWebViewController *vwcWeb = [TXShowWebViewController new];
                vwcWeb.webViewUrl = URL_CANDY_EXCHANGE;
                vwcWeb.naviTitle = @"积分兑换";
                vwcWeb.isShowShare = true;
                [self.navigationController pushViewController:vwcWeb animated:true];
            }
        } else  if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                HXCollectionViewController *vwcSet = [[HXCollectionViewController alloc] initWithNibName:NSStringFromClass([HXCollectionViewController class]) bundle:[NSBundle mainBundle]];
                vwcSet.typeString = @"collect";
                [self.navigationController pushViewController:vwcSet animated:true];
            } else if (indexPath.row == 1) {
                // 点赞
                HXCollectionViewController *vwcSet = [[HXCollectionViewController alloc] initWithNibName:NSStringFromClass([HXCollectionViewController class]) bundle:[NSBundle mainBundle]];
                vwcSet.typeString = @"praise";
                [self.navigationController pushViewController:vwcSet animated:true];
            } else if (indexPath.row == 2) {
                // 分享
                HXCollectionViewController *vwcSet = [[HXCollectionViewController alloc] initWithNibName:NSStringFromClass([HXCollectionViewController class]) bundle:[NSBundle mainBundle]];
                vwcSet.typeString = @"share";
                [self.navigationController pushViewController:vwcSet animated:true];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 270;
    } else {
        return 50;
    }
}

#pragma mark - HXAuthorHeaderTableViewCellDelegate

- (void)selectArticleButton {
    if (![[TXUserModel defaultUser] userLoginStatus]) {
        [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
        return;
    }
    HXHistoryViewController *vwcSet = [[HXHistoryViewController alloc] initWithNibName:NSStringFromClass([HXHistoryViewController class]) bundle:[NSBundle mainBundle]];
    vwcSet.isUser = true;
    [self.navigationController pushViewController:vwcSet animated:true];
}

- (void)selectAttentionButton {
    if (![[TXUserModel defaultUser] userLoginStatus]) {
        [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
        return;
    }
    HXAttentionOrFansViewController *vwcSet = [[HXAttentionOrFansViewController alloc] initWithNibName:NSStringFromClass([HXAttentionOrFansViewController class]) bundle:[NSBundle mainBundle]];
    vwcSet.isAttention = true;
    [self.navigationController pushViewController:vwcSet animated:true];
}

- (void)selectFansButton {
    if (![[TXUserModel defaultUser] userLoginStatus]) {
        [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
        return;
    }
    HXAttentionOrFansViewController *vwcSet = [[HXAttentionOrFansViewController alloc] initWithNibName:NSStringFromClass([HXAttentionOrFansViewController class]) bundle:[NSBundle mainBundle]];
    vwcSet.isAttention = false;
    [self.navigationController pushViewController:vwcSet animated:true];
}

@end
