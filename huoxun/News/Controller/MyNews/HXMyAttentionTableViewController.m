//
//  HXMyAttentionTableViewController.m
//  huoxun
//
//  Created by 倩倩 on 2018/3/9.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXMyAttentionTableViewController.h"
#import "HXMyAttentionTableViewCell.h"
#import "HXAttentionsModel.h"
#import "HXNewsDetailViewController.h"
#import "HXCandyTableViewController.h"
#import "HXRechargeHistoryDetailTableViewController.h"

@interface HXMyAttentionTableViewController ()

@property (nonatomic, strong) NSMutableArray <HXAttentionsModel *>*attentionArray;
/** 分页数 */
@property (nonatomic, assign) NSInteger page;
/** 分页请求条数 */
@property (nonatomic, assign) NSInteger page_size;
/** 返回数据条数 */
@property (nonatomic, assign) NSInteger dataCount;

@property (nonatomic, strong) TXBlankView *blankView;

@end

@implementation HXMyAttentionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"提醒";
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 90;
    
    [TXModelAchivar updateUserModelWithKey:@"attentionLocalCount" value:[TXModelAchivar getUserModel].attentionCount];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCalculatorNotice object:nil userInfo:nil];
    
    // tableView 设置
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.automaticallyHidden = true;
    
    self.attentionArray = [NSMutableArray new];
    _page = 1;
    _page_size = 10;
    _dataCount = 0;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request

- (void)loadData {
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getSugarNotify]
                             headParams:[RCHttpHelper accessAndLoginTokenHeader]
                             bodyParams:@{@"page" : [NSString stringWithFormat:@"%zd", self.page], @"page_size" : [NSString stringWithFormat:@"%zd", self.page_size]}
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
                                    [MBProgressHUD hideHUDForView:self.view];
                                    if ([responseObject[@"code"] integerValue] == 200) {
                                        _page += 1;
                                        HXAttentionsCollectionModel *colloectionModel = [HXAttentionsCollectionModel mj_objectWithKeyValues:responseObject[@"data"]];
                                        _dataCount = colloectionModel.list.count;
                                        if (_dataCount > 0) {
                                            [self.attentionArray addObjectsFromArray:colloectionModel.list];
                                        }
                                        if (self.attentionArray.count == 0) {
                                            
                                        } else {
                                            [self.blankView removeFromSuperview];
                                            if (_dataCount < _page_size) {
                                                [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                                            }
                                        }
                                        [self.tableView reloadData];
                                    } else {
                                        [ShowMessage showMessage:responseObject[@"message"]];
                                    }
                                    
                                    if ([responseObject[@"code"] integerValue] == 205) {
                                        [self showBlankView];
                                    }
                                    [self.tableView.mj_header endRefreshing];
                                    [self.tableView.mj_footer endRefreshing];
                                } failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                    [MBProgressHUD hideHUDForView:self.view];
                                    // [ShowMessage showMessage:error.description];
                                    
                                    [self.tableView.mj_header endRefreshing];
                                    [self.tableView.mj_footer endRefreshing];
                                } isLogin:^{
                                    [self.tableView.mj_header endRefreshing];
                                    [self.tableView.mj_footer endRefreshing];
                                    [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
                                }];
}

- (void)loadNewData {
    [self.attentionArray removeAllObjects];
    _page = 1;
    [self loadData];
}

- (void)loadMoreData {
    if (_dataCount < _page_size) {
        [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
    } else {
        [self loadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.attentionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HXMyAttentionTableViewCell *cell = [HXMyAttentionTableViewCell cellWithTableView:tableView];
    if (self.attentionArray.count >= indexPath.row) {
        HXAttentionsModel *model = self.attentionArray[indexPath.row];
        cell.model = model;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HXAttentionsModel *model = self.attentionArray[indexPath.row];
    
    // 点赞
    if ([model.type integerValue] == 3) {
        
        HXNewsDetailViewController *vwcDetail = [[HXNewsDetailViewController alloc] initWithNibName:NSStringFromClass([HXNewsDetailViewController class]) bundle:[NSBundle mainBundle]];
        vwcDetail.articleId = model.recharge.idField;
        [self.navigationController pushViewController:vwcDetail animated:true];
    }
    
    // 评论
    if ([model.type integerValue] == 4) {
        HXNewsDetailViewController *vwcDetail = [[HXNewsDetailViewController alloc] initWithNibName:NSStringFromClass([HXNewsDetailViewController class]) bundle:[NSBundle mainBundle]];
        vwcDetail.articleId = model.recharge.nid;
        [self.navigationController pushViewController:vwcDetail animated:true];
    }
    
    // 充值
    if ([model.type integerValue] == 1) {
        HXAttentionsModel *attModel = self.attentionArray[indexPath.row];
        HXRechargedModel *model = attModel.recharge;
        HXRechargeHistoryDetailTableViewController *vwcHistory = [[HXRechargeHistoryDetailTableViewController alloc] initWithNibName:NSStringFromClass([HXRechargeHistoryDetailTableViewController class]) bundle:[NSBundle mainBundle]];
        vwcHistory.model = model;
        vwcHistory.isAttention = true;
        vwcHistory.create_time = attModel.create_time;
        [self.navigationController pushViewController:vwcHistory animated:true];
    }
    
    // 获得豆子
    if ([model.type integerValue] == 2) {
        HXCandyTableViewController *vwcDetail = [[HXCandyTableViewController alloc] initWithNibName:NSStringFromClass([HXCandyTableViewController class]) bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:vwcDetail animated:true];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXAttentionsModel *attModel = self.attentionArray[indexPath.row];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper]  getUrl:[httpHost stringByAppendingPathComponent:getDeleteAttention]
                              headParams:[RCHttpHelper accessAndLoginTokenHeader]
                              bodyParams:@{@"id" : attModel.idField}
                                 success:^(AFHTTPSessionManager *operation, id responseObject) {
                                     [MBProgressHUD hideHUDForView:self.view];
                                     if ([responseObject[@"code"] integerValue] == 200) {
                                         // 删除模型
                                         [self.attentionArray removeObjectAtIndex:indexPath.row];
                                         [self.tableView reloadData];
                                         if (self.attentionArray.count == 0) {
                                             [self showBlankView];
                                         }
                                     }
                                     [ShowMessage showMessage:responseObject[@"message"]];
                                 } failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                     [MBProgressHUD hideHUDForView:self.view];
                                 } isLogin:^{
                                     [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
                                 }];
}

/**
 *  修改Delete按钮文字为“删除”
 */
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除提醒";
}


- (void)showBlankView {
    [self.view addSubview:self.blankView];
}

- (TXBlankView *)blankView {
    if (nil == _blankView) {
        _blankView = [[TXBlankView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_blankView createBlankViewWithImage:@"empty" title:@"暂无数据"];
    }
    return _blankView;
}

@end
