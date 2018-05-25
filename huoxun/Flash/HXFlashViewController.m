//
//  HXFlashViewController.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/4.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXFlashViewController.h"
#import "HXTopView.h"
#import "HXFlashListTableViewCell.h"
#import "HXCategroyModel.h"
#import "HXFlashModel.h"
#import "HXFlashShareViewController.h"
#import "HXLongShareViewController.h"
#import "HXShowTopView.h"

@interface HXFlashViewController () <UITableViewDelegate, UITableViewDataSource, HXTopViewDelegate, HXFlashListTableViewCellDelegate>

@property (nonatomic, strong) HXShowTopView *showTopView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) HXTopView *sectionView;
@property (nonatomic, strong) NSMutableArray <HXCategroyModel *>*categoryArray;
@property (nonatomic, strong) HXCategroyModel *currentCategoryModel;
@property (nonatomic, strong) NSMutableArray <HXFlashModel *>*flashArray;
/** 分页数 */
@property (nonatomic, assign) NSInteger page;
/** 分页请求条数 */
@property (nonatomic, assign) NSInteger page_size;
/** 返回数据条数 */
@property (nonatomic, assign) NSInteger dataCount;

@end

@implementation HXFlashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.isTabBar ? @"7X24H快讯" : @"快讯";
    
    // tableView 设置
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.automaticallyHidden = true;
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.categoryArray = [NSMutableArray new];
    self.flashArray = [NSMutableArray new];
    _page = 1;
    _page_size = 10;
    _dataCount = 0;
    
    HXCategroyModel *model = [HXCategroyModel new];
    model.isSelected = true;
    model.title = @"快讯";
    model.type = @"fast";
    self.currentCategoryModel = model;
    
    HXCategroyModel *model1 = [HXCategroyModel new];
    model1.isSelected = false;
    model1.title = @"Twitter";
    model1.type = @"twitter";
    
    HXCategroyModel *model2 = [HXCategroyModel new];
    model2.isSelected = false;
    model2.title = @"微博";
    model2.type = @"weibo";
    
    [self.categoryArray addObject:model];
    [self.categoryArray addObject:model1];
    [self.categoryArray addObject:model2];
    
    if (!self.isTabBar) {
        // 定义全局leftBarButtonItem
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@""]
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:nil];
    }
    
    [self loadData];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(Timered) userInfo:nil repeats:YES];
}

- (void)Timered {
    [self getFlashsCount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)showAnimationWithText:(NSString *)text {
    self.showTopView.topTextLabel.text = text;
    [self.view addSubview:self.showTopView];
    [self show];
}

- (void)show {
    [UIView animateWithDuration:0.3 animations:^{
        self.showTopView.frame = CGRectMake(0, kTopHeight, SCREEN_WIDTH, 30);
    } completion:^(BOOL finished) {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self hide];
        });
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.showTopView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - Request

- (void)getFlashsCount {
    if (![[TXUserModel defaultUser] userLoginStatus]) {
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:@"fast" forKey:@"model"];
    [param setValue:self.currentCategoryModel.type forKey:@"type"];
    
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getLatestNewsOrFlash]
                             headParams:[RCHttpHelper accessAndLoginTokenHeader]
                             bodyParams:param
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
                                    if ([responseObject[@"code"] integerValue] == 200) {
                                        [TXModelAchivar updateUserModelWithKey:@"flashCount" value:responseObject[@"data"]];
                                        if ([responseObject[@"data"] integerValue] > [[TXModelAchivar getUserModel].flashLocalCount integerValue]) {
//                                            [self loadNewData];
                                            
                                            if ([self.currentCategoryModel.type isEqualToString:@"fast"]) {
                                                [self showAnimationWithText:[NSString stringWithFormat:@"更新了%ld条快讯", [responseObject[@"data"] integerValue] - [[TXModelAchivar getUserModel].flashLocalCount integerValue]]];
                                            } else if ([self.currentCategoryModel.type isEqualToString:@"twitter"]) {
                                                [self showAnimationWithText:[NSString stringWithFormat:@"更新了%ld条Twitter", [responseObject[@"data"] integerValue] - [[TXModelAchivar getUserModel].flashLocalCount integerValue]]];
                                            } else {
                                                [self showAnimationWithText:[NSString stringWithFormat:@"更新了%ld条微博", [responseObject[@"data"] integerValue] - [[TXModelAchivar getUserModel].flashLocalCount integerValue]]];
                                            }
                                            if (self.page == 2) {
                                                [TXModelAchivar updateUserModelWithKey:@"flashLocalCount" value:responseObject[@"data"]];
                                            }
                                        }
                                    } else {
                                        [ShowMessage showMessage:responseObject[@"message"]];
                                    }
                                } failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                    
                                } isLogin:^{
                                    [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
                                }];
}

- (void)loadData {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:self.currentCategoryModel.type forKey:@"type"];
    [param setValue:[NSString stringWithFormat:@"%zd", self.page] forKey:@"page"];
    [param setValue:[NSString stringWithFormat:@"%zd", self.page_size] forKey:@"page_size"];
    
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getFlashList]
                             headParams:[RCHttpHelper accessHeader]
                             bodyParams:param
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"code"] integerValue] == 200) {
            _page += 1;
            HXFlashCollectionModel *colloectionModel = [HXFlashCollectionModel mj_objectWithKeyValues:responseObject];
            _dataCount = colloectionModel.data.count;
            if (_dataCount > 0) {
                [self.flashArray addObjectsFromArray:colloectionModel.data];
            }
            if (self.flashArray.count == 0) {
                
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
    [self.flashArray removeAllObjects];
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
    return self.flashArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HXFlashListTableViewCell *cell = [HXFlashListTableViewCell cellWithTableView:tableView];
    cell.delegate = self;
    if (self.flashArray.count > indexPath.row) {
        HXFlashModel *model = self.flashArray[indexPath.row];
        model.type = self.currentCategoryModel.type;
        cell.model = model;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.flashArray.count > indexPath.row) {
        CGFloat height = 0.0;
        HXFlashModel *model = self.flashArray[indexPath.row];
        NSString *str = model.des;
        
        if ([self.currentCategoryModel.type isEqualToString:@"fast"]) {
            height = [TXCustomTools heightForString:str Spacing:5 fontSize:FONT(14) andWidth:SCREEN_WIDTH-30].height;
        } else if ([self.currentCategoryModel.type isEqualToString:@"weibo"]) {
            height = [TXCustomTools heightForString:str Spacing:5 fontSize:FONT(14) andWidth:SCREEN_WIDTH-105].height;
            height = height > 63 ? height : 63;
        } else {
            height = [TXCustomTools heightForString:str Spacing:5 fontSize:FONT(14) andWidth:SCREEN_WIDTH-105].height;
            height = height > 63 ? height : 63;
        }

        return height + 63;
    } else {
        return 115;
    }
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

#pragma mark - TXDiscoverTopViewDelegate

- (void)selectTopViewWithModel:(HXCategroyModel *)model {
    self.currentCategoryModel = model;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadNewData];
}

#pragma mark - HXFlashListTableViewCellDelegate

- (void)touchShareContentButtonWithModel:(HXFlashModel *)model {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:getShare]
                              headParams:[RCHttpHelper accessAndLoginTokenHeader]
                              bodyParams:@{@"type" : @"fast", @"id" : model.idField}
                                 success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"code"] integerValue] == 200) {
            NSDictionary *dic = responseObject[@"data"];
            HXLongShareViewController *vwcShare = [[HXLongShareViewController alloc] initWithNibName:NSStringFromClass([HXLongShareViewController class]) bundle:[NSBundle mainBundle]];
            vwcShare.param = dic;
            vwcShare.time = model.create_time_format;
            NSString *str = nil;
            if ([self.currentCategoryModel.type isEqualToString:@"fast"]) {
                str = model.des;
            } else if ([self.currentCategoryModel.type isEqualToString:@"weibo"]) {
                str = model.text;
            } else {
                str = model.chinese_original;
            }
            vwcShare.content = str;
            [self.navigationController pushViewController:vwcShare animated:true];
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
    } isLogin:^{
        [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
    }];
}

#pragma mark - Lazy

- (HXShowTopView *)showTopView {
    if (!_showTopView) {
        _showTopView  =  [[[NSBundle mainBundle] loadNibNamed:@"HXShowTopView" owner:nil options:nil] lastObject];
        _showTopView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    }
    return _showTopView;
}

- (HXTopView *)sectionView {
    if (!_sectionView) {
        _sectionView  =  [[[NSBundle mainBundle] loadNibNamed:@"HXTopView" owner:nil options:nil] lastObject];
        _sectionView.frame = CGRectMake(0, 0, (SCREEN_WIDTH/4-10)*3+20, 62);
        _sectionView.delegate = self;
        _sectionView.myView.hidden = true;
    }
    return _sectionView;
}

@end
