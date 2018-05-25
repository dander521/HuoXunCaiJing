//
//  HXMyNoticeTableViewController.m
//  huoxun
//
//  Created by 倩倩 on 2018/3/9.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXMyNoticeTableViewController.h"
#import "HXMyNoticeTableViewCell.h"
#import "HXNotifyModel.h"

@interface HXMyNoticeTableViewController ()

@property (nonatomic, strong) NSMutableArray <HXNotifyModel *>*notifyArray;
/** 分页数 */
@property (nonatomic, assign) NSInteger page;
/** 分页请求条数 */
@property (nonatomic, assign) NSInteger page_size;
/** 返回数据条数 */
@property (nonatomic, assign) NSInteger dataCount;

@property (nonatomic, strong) TXBlankView *blankView;

@end

@implementation HXMyNoticeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"公告";
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 90;
    
    [TXModelAchivar updateUserModelWithKey:@"notifyLocalCount" value:[TXModelAchivar getUserModel].notifyCount];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCalculatorNotice object:nil userInfo:nil];
    
    // tableView 设置
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.automaticallyHidden = true;
    
    self.notifyArray = [NSMutableArray new];
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
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getPlacard]
                             headParams:[RCHttpHelper accessAndLoginTokenHeader]
                             bodyParams:@{@"page" : [NSString stringWithFormat:@"%zd", self.page], @"page_size" : [NSString stringWithFormat:@"%zd", self.page_size]}
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
                                    [MBProgressHUD hideHUDForView:self.view];
                                    if ([responseObject[@"code"] integerValue] == 200) {
                                        _page += 1;
                                        HXNotifyCollectionModel *colloectionModel = [HXNotifyCollectionModel mj_objectWithKeyValues:responseObject[@"data"]];
                                        _dataCount = colloectionModel.list.count;
                                        if (_dataCount > 0) {
                                            [self.notifyArray addObjectsFromArray:colloectionModel.list];
                                        }
                                        if (self.notifyArray.count == 0) {
                                            
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
    [self.notifyArray removeAllObjects];
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
    return self.notifyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HXMyNoticeTableViewCell *cell = [HXMyNoticeTableViewCell cellWithTableView:tableView];
    if (self.notifyArray.count > indexPath.row) {
        HXNotifyModel *model = self.notifyArray[indexPath.row];
        cell.model = model;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
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
