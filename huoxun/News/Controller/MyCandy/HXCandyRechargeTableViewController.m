//
//  HXCandyRechargeTableViewController.m
//  huoxun
//
//  Created by 倩倩 on 2018/3/10.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXCandyRechargeTableViewController.h"
#import "HXRechargeHistoryTableViewController.h"
#import "HXCandyRechargeHeaderTableViewCell.h"
#import "HXCandyRechargeTableViewCell.h"
#import "HXCandyRechargeBottomTableViewCell.h"
#import "HXRechargeSuccessTableViewController.h"
#import "HXRechargeRulesModel.h"

@interface HXCandyRechargeTableViewController () <UITextFieldDelegate, HXCandyRechargeTableViewCellDelegate>

@property (nonatomic, strong) HXRechargeRulesModel *currentModel;
@property (nonatomic, strong) UITextField *numTF;
@property (nonatomic, strong) NSString *countNum;

@property (nonatomic, strong) NSMutableArray *rulesModelArray;
@end

@implementation HXCandyRechargeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"充值积分";
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"充值记录" forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 60, 40);
    rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [rightBtn addTarget:self action:@selector(rechargeHistory) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:RGB(230, 33, 42) forState:UIControlStateNormal];
    rightBtn.titleLabel.font = FONT(14);
    UIBarButtonItem *attention = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.navigationItem.rightBarButtonItems = @[attention];
    
    self.tableView.estimatedRowHeight = 130;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.tableFooterView = [self tableFooterView];
    
    self.currentModel = [HXRechargeRulesModel new];
    self.rulesModelArray = [NSMutableArray new];
    
    [self getRechargeRules];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.countNum = textField.text;
    [self.tableView reloadData];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:true];
    self.countNum = textField.text;
    return true;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
    self.countNum = self.numTF.text;
    [self.tableView reloadData];
}

#pragma mark - Request

- (void)getRechargeRules {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getRechargeRule]
                             headParams:[RCHttpHelper accessAndLoginTokenHeader]
                             bodyParams:nil
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
                                    [MBProgressHUD hideHUDForView:self.view];
                                    if ([responseObject[@"code"] integerValue] == 200) {
                                        
                                        HXRechargeRulesCollectionModel *collection = [HXRechargeRulesCollectionModel mj_objectWithKeyValues:responseObject];
                                        [self.rulesModelArray addObjectsFromArray:collection.data];
                                        HXRechargeRulesModel *model = self.rulesModelArray.firstObject;
                                        model.isSelected = @"1";
                                        self.currentModel = model;
                                        [self.tableView reloadData];
                                    } else {
                                        [ShowMessage showMessage:responseObject[@"message"]];
                                    }
                                } failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                    [MBProgressHUD hideHUDForView:self.view];
                                } isLogin:^{
                                    [MBProgressHUD hideHUDForView:self.view];
                                    [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
                                }];
}

#pragma mark - Custom Method

- (void)rechargeHistory {
    HXRechargeHistoryTableViewController *vwcHistory = [[HXRechargeHistoryTableViewController alloc] initWithNibName:NSStringFromClass([HXRechargeHistoryTableViewController class]) bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vwcHistory animated:true];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.rulesModelArray.count + 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            HXCandyRechargeHeaderTableViewCell *cell = [HXCandyRechargeHeaderTableViewCell cellWithTableView:tableView];
            self.numTF = cell.inputTF;
            self.numTF.delegate = self;
            self.numTF.text = self.countNum;
            return cell;
        } else {
            HXCandyRechargeTableViewCell *cell = [HXCandyRechargeTableViewCell cellWithTableView:tableView];
            if (self.rulesModelArray.count >= indexPath.row - 1) {
                HXRechargeRulesModel *model = self.rulesModelArray[indexPath.row - 1];
                cell.model = model;
            }
            cell.delegate = self;
            return cell;
        }
    } else {
        HXCandyRechargeBottomTableViewCell *cell = [HXCandyRechargeBottomTableViewCell cellWithTableView:tableView];
        cell.typeLabel.text = self.currentModel.name;
        if ([self.currentModel.sugar_num floatValue] > 0) {
            cell.countLabel.text = [NSString stringWithFormat:@"%.6f", [self.countNum floatValue] / [self.currentModel.sugar_num floatValue]];
        }
        cell.addressLabel.text = self.currentModel.wallet;
        [cell.addressButton addTarget:self action:@selector(addressButtonAction) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 140.0;
        }
        return 36.0;
    } else {
        return UITableViewAutomaticDimension;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - HXCandyRechargeTableViewCellDelegate

- (void)selectedItemWithModel:(HXRechargeRulesModel *)model {
    self.currentModel = model;
    
    for (HXRechargeRulesModel *rulesModel in self.rulesModelArray) {
        if ([model.idField isEqualToString:rulesModel.idField]) {
            rulesModel.isSelected = @"1";
        } else {
            rulesModel.isSelected = @"0";
        }
    }
    [self.tableView reloadData];
}

#pragma mark - Custom Method

- (void)addressButtonAction {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.currentModel.wallet;
    [ShowMessage showMessage:@"复制成功"];
}

- (UIView *)tableFooterView {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    footer.backgroundColor = [UIColor clearColor];
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = CGRectMake(15, 62, SCREEN_WIDTH - 30, 49);
    commitButton.titleLabel.font = FONT(18);
    [commitButton setTitle:@"完成" forState:UIControlStateNormal];
    commitButton.backgroundColor = RGB(246, 30, 46);
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitButton.layer.cornerRadius = 5;
    commitButton.layer.masksToBounds = true;
    [commitButton addTarget:self action:@selector(touchCommitBtn) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:commitButton];
    return footer;
}

// 完成
- (void)touchCommitBtn {
    
    if ([NSString isTextEmpty:self.countNum]) {
        [ShowMessage showMessage:@"请输入充值数量"];
        return;
    }
    
    if ([NSString isTextEmpty:self.currentModel.idField]) {
        [ShowMessage showMessage:@"请选择充值类型"];
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:self.countNum forKey:@"num"];
    [param setValue:self.currentModel.idField forKey:@"pay_type"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:postRechargeAdd]
                             headParams:[RCHttpHelper accessAndLoginTokenHeader]
                             bodyParams:param
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
                                    [MBProgressHUD hideHUDForView:self.view];
                                    if ([responseObject[@"code"] integerValue] == 200) {
                                        HXRechargeSuccessTableViewController *vwcHistory = [[HXRechargeSuccessTableViewController alloc] initWithNibName:NSStringFromClass([HXRechargeSuccessTableViewController class]) bundle:[NSBundle mainBundle]];
                                        [self.navigationController pushViewController:vwcHistory animated:true];
                                    } else {
                                        [ShowMessage showMessage:responseObject[@"message"]];
                                    }
                                } failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                    [MBProgressHUD hideHUDForView:self.view];
                                } isLogin:^{
                                    [MBProgressHUD hideHUDForView:self.view];
                                    [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
                                }];
}

@end
