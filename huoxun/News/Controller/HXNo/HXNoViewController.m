//
//  HXNoViewController.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/5.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXNoViewController.h"
#import "HXNewsTableViewCell.h"
#import "HXNewsDetailViewController.h"
#import "HXTopView.h"
#import "HXCategroyModel.h"

@interface HXNoViewController () <UITableViewDataSource, UITableViewDelegate, HXTopViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) HXTopView *sectionView;

@property (nonatomic, strong) NSMutableArray <HXCategroyModel *>*categoryArray;
@property (nonatomic, strong) HXCategroyModel *currentCategoryModel;
@property (nonatomic, strong) NSMutableArray <HXNewsModel *>*newsArray;
/** 分页数 */
@property (nonatomic, assign) NSInteger page;
/** 分页请求条数 */
@property (nonatomic, assign) NSInteger page_size;
/** 返回数据条数 */
@property (nonatomic, assign) NSInteger dataCount;

@end

@implementation HXNoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"火讯号";
    // tableView 设置
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.automaticallyHidden = true;
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.newsArray = [NSMutableArray new];
    self.categoryArray = [NSMutableArray new];
    _page = 1;
    _page_size = 10;
    _dataCount = 0;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getNewsCategoryItem];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request

- (void)loadData {
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getNewsOrHXNoList]
                             headParams:[RCHttpHelper accessHeader]
                             bodyParams:@{@"rel" : self.currentCategoryModel.rel, @"page" : [NSString stringWithFormat:@"%zd", self.page], @"page_size" : [NSString stringWithFormat:@"%zd", self.page_size]}
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

- (void)getNewsCategoryItem {
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getHXNoOrNewsCategory]
                             headParams:[RCHttpHelper accessHeader]
                             bodyParams:nil
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            HXCategroyCollectionModel *colloectionModel = [HXCategroyCollectionModel mj_objectWithKeyValues:responseObject];
            HXCategroyModel *firstModel = colloectionModel.data.firstObject;
            firstModel.isSelected = true;
            self.categoryArray = [NSMutableArray arrayWithArray:colloectionModel.data];
            self.currentCategoryModel = self.categoryArray.firstObject;
            [self loadData];
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

#pragma mark - UITableViewDataSource

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
    HXNewsDetailViewController *vwcDetail = [[HXNewsDetailViewController alloc] initWithNibName:NSStringFromClass([HXNewsDetailViewController class]) bundle:[NSBundle mainBundle]];
    vwcDetail.articleId = model.idField;
    [self.navigationController pushViewController:vwcDetail animated:true];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 62;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.categoryArray.count > 0) {
        self.sectionView.dataSource = self.categoryArray;
    }
    return self.sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110.0;
}

#pragma mark - TXDiscoverTopViewDelegate

- (void)selectTopViewWithModel:(HXCategroyModel *)model {
    self.currentCategoryModel = model;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadNewData];
}

#pragma mark - Lazy

- (HXTopView *)sectionView {
    if (!_sectionView) {
        _sectionView  =  [[[NSBundle mainBundle] loadNibNamed:@"HXTopView" owner:nil options:nil] lastObject];
        _sectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 62);
        _sectionView.delegate = self;
    }
    return _sectionView;
}

@end
