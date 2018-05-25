//
//  HXHistoryViewController.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/10.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXHistoryViewController.h"
#import "HXNewsModel.h"
#import "HXNewsTableViewCell.h"
#import "HXNewsDetailViewController.h"
#import "TXBlankView.h"
#import "TXShowWebViewController.h"

@interface HXHistoryViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray <HXNewsModel *>*newsArray;
/** 分页数 */
@property (nonatomic, assign) NSInteger page;
/** 分页请求条数 */
@property (nonatomic, assign) NSInteger page_size;
/** 返回数据条数 */
@property (nonatomic, assign) NSInteger dataCount;

@property (nonatomic, strong) TXBlankView *blankView;

@end

@implementation HXHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.isUser ? @"我的文章" : @"历史足迹";
    // tableView 设置
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.automaticallyHidden = true;
    
    self.newsArray = [NSMutableArray new];
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

- (void)loadData {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:[NSString stringWithFormat:@"%zd", self.page] forKey:@"page"];
    [params setValue:[NSString stringWithFormat:@"%zd", self.page_size] forKey:@"page_size"];
    
    if (self.isUser) {
        [params setValue:[TXModelAchivar getUserModel].idField forKey:@"uid"];
    } else {
        [params setValue:@"1" forKey:@"history"];
    }
    
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getNewsOrHXNoList]
                             headParams:[RCHttpHelper accessAndLoginTokenHeader]
                             bodyParams:params
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"code"] integerValue] == 200) {
            _page += 1;
            HXNewsCollectionModel *colloectionModel = [HXNewsCollectionModel mj_objectWithKeyValues:responseObject];
            _dataCount = colloectionModel.data.count;
            if (_dataCount > 0) {
                [self.newsArray addObjectsFromArray:colloectionModel.data];
            }
            if (self.newsArray.count == 0) {
                
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
    [self.newsArray removeAllObjects];
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.newsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HXNewsTableViewCell *cell = [HXNewsTableViewCell cellWithTableView:tableView];
    cell.cellLineType = TXCellSeperateLinePositionType_Single;
    cell.cellLineRightMargin = TXCellRightMarginType0;
    if (self.newsArray.count > indexPath.row) {
        cell.model = self.newsArray[indexPath.row];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HXNewsModel *model = self.newsArray[indexPath.row];
    if ([NSString isTextEmpty:model.jump]) {
        HXNewsDetailViewController *vwcDetail = [[HXNewsDetailViewController alloc] initWithNibName:NSStringFromClass([HXNewsDetailViewController class]) bundle:[NSBundle mainBundle]];
        vwcDetail.articleId = model.idField;
        [self.navigationController pushViewController:vwcDetail animated:true];
    } else {
        TXShowWebViewController *vwcWeb = [TXShowWebViewController new];
        vwcWeb.webViewUrl = model.jump;
        vwcWeb.naviTitle = model.title;
        [self.navigationController pushViewController:vwcWeb animated:true];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110.0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isUser) {
        HXNewsModel *model = self.newsArray[indexPath.row];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[RCHttpHelper sharedHelper]  getUrl:[httpHost stringByAppendingPathComponent:getDeleteReadHistory]
                                  headParams:[RCHttpHelper accessAndLoginTokenHeader]
                                  bodyParams:@{@"id" : model.idField}
                                     success:^(AFHTTPSessionManager *operation, id responseObject) {
                                         [MBProgressHUD hideHUDForView:self.view];
                                         if ([responseObject[@"code"] integerValue] == 200) {
                                             // 删除模型
                                             [self.newsArray removeObjectAtIndex:indexPath.row];
                                             [self.tableView reloadData];
                                             if (self.newsArray.count == 0) {
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
    
}

/**
 *  修改Delete按钮文字为“删除”
 */
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除历史记录";
}


- (void)showBlankView {
    [self.view addSubview:self.blankView];
}

- (TXBlankView *)blankView {
    if (nil == _blankView) {
        _blankView = [[TXBlankView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight)];
        [_blankView createBlankViewWithImage:@"empty" title:@"暂无数据"];
    }
    
    return _blankView;
}

@end
