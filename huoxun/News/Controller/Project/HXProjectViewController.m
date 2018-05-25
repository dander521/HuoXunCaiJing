//
//  HXProjectViewController.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/5.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXProjectViewController.h"
#import "HXProjectHeaderTableViewCell.h"
#import "HXProjectTotalTableViewCell.h"
#import "HXProjectListTableViewCell.h"
#import "HXProjectDetailViewController.h"
#import "HXProjectModel.h"
#import "TXShowWebViewController.h"

@interface HXProjectViewController () <UITableViewDelegate, UITableViewDataSource, HXProjectListTableViewCellDelegate, HXProjectHeaderTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <HXProjectModel *>*projectsArray;

/** 分页数 */
@property (nonatomic, assign) NSInteger page;
/** 分页请求条数 */
@property (nonatomic, assign) NSInteger page_size;
/** 返回数据条数 */
@property (nonatomic, assign) NSInteger dataCount;

@property (nonatomic, strong) HXProjectCollectionModel *totalModel;

@end

@implementation HXProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"项目";
    
    // tableView 设置
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.automaticallyHidden = true;
    
    self.projectsArray = [NSMutableArray new];
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
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getProjectList]
                             headParams:[RCHttpHelper accessHeader]
                             bodyParams:@{@"page" : [NSString stringWithFormat:@"%zd", self.page], @"page_size" : [NSString stringWithFormat:@"%zd", self.page_size]}
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"code"] integerValue] == 200) {
            _page += 1;
            self.totalModel = [HXProjectCollectionModel mj_objectWithKeyValues:responseObject[@"data"]];
            _dataCount = self.totalModel.list.count;
            if (_dataCount > 0) {
                [self.projectsArray addObjectsFromArray:self.totalModel.list];
            }
            if (self.projectsArray.count == 0) {
                
            } else {
                if (_dataCount < _page_size) {
                    [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                }
            }
            [self.tableView reloadData];
        } else {
            [ShowMessage showMessage:responseObject[@"message"]];            
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
    [self.projectsArray removeAllObjects];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 2;
    return self.projectsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *defaultCell = nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            HXProjectHeaderTableViewCell *cell = [HXProjectHeaderTableViewCell cellWithTableView:tableView];
            cell.delegate = self;
            if (self.projectsArray.count > 0) {
                cell.dataSource = self.projectsArray;
            }
            defaultCell = cell;
        } else {
            HXProjectTotalTableViewCell *cell = [HXProjectTotalTableViewCell cellWithTableView:tableView];
            cell.cellLineRightMargin = TXCellRightMarginType16;
            cell.cellLineType = TXCellSeperateLinePositionType_Single;
            cell.projectAmount.text = self.totalModel.total;
            defaultCell = cell;
        }
    } else {
        HXProjectListTableViewCell *cell = [HXProjectListTableViewCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.cellLineRightMargin = TXCellRightMarginType16;
        cell.cellLineType = TXCellSeperateLinePositionType_Single;
        if (self.projectsArray.count > indexPath.row) {
            cell.model = self.projectsArray[indexPath.row];
        }
        defaultCell = cell;
    }
    
    return defaultCell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 200;
        } else {
            return 50;
        }
    } else {
        return 168;
    }
}

#pragma mark - HXProjectListTableViewCellDelegate

- (void)touchCheckProjectWithModel:(HXProjectModel *)model {
    HXProjectDetailViewController *vwcDetail = [[HXProjectDetailViewController alloc] initWithNibName:NSStringFromClass([HXProjectDetailViewController class]) bundle:[NSBundle mainBundle]];
    vwcDetail.projectId = model.idField;
    [self.navigationController pushViewController:vwcDetail animated:true];
}

- (void)touchWhitePaperProjectWithModel:(HXProjectModel *)model {
    TXShowWebViewController *vwcWeb = [TXShowWebViewController new];
    vwcWeb.webViewUrl = model.ppt;
    vwcWeb.naviTitle = model.title;
    [self.navigationController pushViewController:vwcWeb animated:true];
}

#pragma mark - HXProjectHeaderTableViewCellDelegate

- (void)selectItemViewWithModel:(HXProjectModel *)model {
    HXProjectDetailViewController *vwcDetail = [[HXProjectDetailViewController alloc] initWithNibName:NSStringFromClass([HXProjectDetailViewController class]) bundle:[NSBundle mainBundle]];
    vwcDetail.projectId = model.idField;
    [self.navigationController pushViewController:vwcDetail animated:true];
}

@end
