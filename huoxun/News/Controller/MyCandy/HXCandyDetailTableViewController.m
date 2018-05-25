//
//  HXCandyDetailTableViewController.m
//  huoxun
//
//  Created by 倩倩 on 2018/3/10.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXCandyDetailTableViewController.h"
#import "HXCandyDetailTableViewCell.h"
#import "HXTopView.h"
#import "HXCategroyModel.h"
#import "HXCandyDetailModel.h"

@interface HXCandyDetailTableViewController ()<HXTopViewDelegate>

@property (nonatomic, strong) HXTopView *sectionView;
@property (nonatomic, strong) NSMutableArray <HXCategroyModel *>*categoryArray;
@property (nonatomic, strong) HXCategroyModel *currentCategoryModel;

@property (nonatomic, strong) NSMutableArray <HXCandyDetailModel *>*detailArray;
/** 分页数 */
@property (nonatomic, assign) NSInteger page;
/** 分页请求条数 */
@property (nonatomic, assign) NSInteger page_size;
/** 返回数据条数 */
@property (nonatomic, assign) NSInteger dataCount;

@property (nonatomic, strong) TXBlankView *blankView;

@end

@implementation HXCandyDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"积分明细";
    
    self.categoryArray = [NSMutableArray new];
    HXCategroyModel *model = [HXCategroyModel new];
    model.isSelected = true;
    model.title = @"全部";
    model.type = @"all";
    self.currentCategoryModel = model;
    
    HXCategroyModel *model1 = [HXCategroyModel new];
    model1.isSelected = false;
    model1.title = @"收入";
    model1.type = @"income";
    
    HXCategroyModel *model2 = [HXCategroyModel new];
    model2.isSelected = false;
    model2.title = @"支出";
    model2.type = @"expend";
    
    [self.categoryArray addObject:model];
    [self.categoryArray addObject:model1];
    [self.categoryArray addObject:model2];
    
    // tableView 设置
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.automaticallyHidden = true;
    
    self.detailArray = [NSMutableArray new];
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
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:[NSString stringWithFormat:@"%zd", self.page] forKey:@"page"];
    [params setValue:[NSString stringWithFormat:@"%zd", self.page_size] forKey:@"page_size"];
    
    NSString *sign = nil;
    if ([self.currentCategoryModel.type isEqualToString:@"income"]) {
        sign = @"1";
        [params setValue:sign forKey:@"sign"];
    } else if ([self.currentCategoryModel.type isEqualToString:@"expand"]) {
        sign = @"0";
        [params setValue:sign forKey:@"sign"];
    } else {
//        sign = @"";
    }
    
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getSugarNotes]
                             headParams:[RCHttpHelper accessAndLoginTokenHeader]
                             bodyParams:params
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
                                    [MBProgressHUD hideHUDForView:self.view];
                                    if ([responseObject[@"code"] integerValue] == 200) {
                                        _page += 1;
                                        HXCandyDetailCollectionModel *colloectionModel = [HXCandyDetailCollectionModel mj_objectWithKeyValues:responseObject];
                                        _dataCount = colloectionModel.data.count;
                                        if (_dataCount > 0) {
                                            [self.detailArray addObjectsFromArray:colloectionModel.data];
                                        }
                                        if (self.detailArray.count == 0) {
                                            
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
    [self.detailArray removeAllObjects];
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
    return self.detailArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HXCandyDetailTableViewCell *cell = [HXCandyDetailTableViewCell cellWithTableView:tableView];
    
    if (self.detailArray.count > indexPath.row) {
        HXCandyDetailModel *model = self.detailArray[indexPath.row];
        cell.model = model;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 62;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 62)];
    headerView.backgroundColor = RGB(247, 247, 247);
    self.sectionView.dataSource = self.categoryArray;
    self.sectionView.center = headerView.center;
    [headerView addSubview:self.sectionView];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
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
        _sectionView.frame = CGRectMake(0, 0, (SCREEN_WIDTH/4-10)*3+25, 62);
        _sectionView.delegate = self;
        _sectionView.myView.hidden = true;
    }
    return _sectionView;
}

- (void)showBlankView {
    [self.view addSubview:self.blankView];
}

- (TXBlankView *)blankView {
    if (nil == _blankView) {
        _blankView = [[TXBlankView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight)];
        [_blankView createBlankViewWithImage:@"empty" title:@"暂无数据"];
    }
    return _blankView;
}

@end
