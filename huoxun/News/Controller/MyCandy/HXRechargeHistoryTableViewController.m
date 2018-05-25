//
//  HXRechargeHistoryTableViewController.m
//  huoxun
//
//  Created by 倩倩 on 2018/3/10.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXRechargeHistoryTableViewController.h"
#import "HXRechargeHistoryTableViewCell.h"
#import "HXRechargeHistoryModel.h"
#import "HXRechargeHistoryDetailTableViewController.h"

@interface HXRechargeHistoryTableViewController () <HXRechargeHistoryTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray <HXRechargeHistoryModel *>*historyArray;
/** 分页数 */
@property (nonatomic, assign) NSInteger page;
/** 分页请求条数 */
@property (nonatomic, assign) NSInteger page_size;
/** 返回数据条数 */
@property (nonatomic, assign) NSInteger dataCount;

@property (nonatomic, strong) TXBlankView *blankView;

@end

@implementation HXRechargeHistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"充值记录";
    self.tableView.estimatedRowHeight = 206;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 20.0;
    
    // tableView 设置
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.automaticallyHidden = true;
    
    self.historyArray = [NSMutableArray new];
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
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getSugarRechargeLog]
                             headParams:[RCHttpHelper accessAndLoginTokenHeader]
                             bodyParams:@{@"page" : [NSString stringWithFormat:@"%zd", self.page], @"page_size" : [NSString stringWithFormat:@"%zd", self.page_size]}
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
                                    [MBProgressHUD hideHUDForView:self.view];
                                    if ([responseObject[@"code"] integerValue] == 200) {
                                        _page += 1;
                                        HXRechargeHistoryCollectionModel *colloectionModel = [HXRechargeHistoryCollectionModel mj_objectWithKeyValues:responseObject];
                                        _dataCount = colloectionModel.data.count;
                                        if (_dataCount > 0) {
                                            [self.historyArray addObjectsFromArray:colloectionModel.data];
                                        }
                                        if (self.historyArray.count == 0) {
                                            
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
    [self.historyArray removeAllObjects];
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
    return self.historyArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HXRechargeHistoryTableViewCell *cell = [HXRechargeHistoryTableViewCell cellWithTableView:tableView];
    
    if (self.historyArray.count >= indexPath.section) {
        HXRechargeHistoryModel *model = self.historyArray[indexPath.section];
        cell.model = model;
    }
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HXRechargeHistoryModel *model = self.historyArray[indexPath.section];
    HXRechargeHistoryDetailTableViewController *vwcHistory = [[HXRechargeHistoryDetailTableViewController alloc] initWithNibName:NSStringFromClass([HXRechargeHistoryDetailTableViewController class]) bundle:[NSBundle mainBundle]];
    vwcHistory.model = [model converToRechargedModel];
    [self.navigationController pushViewController:vwcHistory animated:true];
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

#pragma mark - HXRechargeHistoryTableViewCellDelegate

- (void)selectAddressButtonWithModel:(HXRechargeHistoryModel *)model {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = model.wallet;
    [ShowMessage showMessage:@"复制成功"];
}


@end
