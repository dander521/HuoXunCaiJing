//
//  HXJoinViewController.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/6.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXJoinViewController.h"
#import "HXJoinTableViewCell.h"
#import "TXShowWebViewController.h"
#import "HXJoinModel.h"
#import "TXBlankView.h"

@interface HXJoinViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <HXJoinModel *>*newsArray;
/** 分页数 */
@property (nonatomic, assign) NSInteger page;
/** 分页请求条数 */
@property (nonatomic, assign) NSInteger page_size;
/** 返回数据条数 */
@property (nonatomic, assign) NSInteger dataCount;
@property (nonatomic, strong) TXBlankView *blankView;
@end

@implementation HXJoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"火讯聚合";
    
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
}

#pragma mark - Request

- (void)loadData {
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getJuHe]
                             headParams:[RCHttpHelper accessHeader]
                             bodyParams:@{@"page" : [NSString stringWithFormat:@"%zd", self.page], @"page_size" : [NSString stringWithFormat:@"%zd", self.page_size]}
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"code"] integerValue] == 200) {
            _page += 1;
            HXJoinCollectionModel *colloectionModel = [HXJoinCollectionModel mj_objectWithKeyValues:responseObject];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.newsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HXJoinTableViewCell *cell = [HXJoinTableViewCell cellWithTableView:tableView];
    cell.cellLineType = TXCellSeperateLinePositionType_Single;
    cell.cellLineRightMargin = TXCellRightMarginType0;
    if (self.newsArray.count > indexPath.row) {
        cell.joinModel = self.newsArray[indexPath.row];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HXJoinModel *model = self.newsArray[indexPath.row];
    TXShowWebViewController *vwcWeb = [TXShowWebViewController new];
    vwcWeb.webViewUrl = model.url;
    vwcWeb.naviTitle = model.title;
    [self.navigationController pushViewController:vwcWeb animated:true];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
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
