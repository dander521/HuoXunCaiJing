//
//  HXNewsViewController.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/4.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXNewsViewController.h"
#import "HXHeaderTableViewCell.h"
#import "HXFlashTableViewCell.h"
#import "HXNewsTableViewCell.h"
#import "TXDiscoverTopView.h"
#import "TXSearchResultViewController.h"
#import "HXNewsDetailViewController.h"
#import "HXNoViewController.h"
#import "HXProjectViewController.h"
#import "HXFlashViewController.h"
#import "HXJoinViewController.h"
#import "HXBannerModel.h"
#import "HXCategroyModel.h"
#import "HXFlashModel.h"
#import "HXNewsModel.h"
#import "TXShowWebViewController.h"
#import "HXFlashHeaderView.h"
#import "HXFlashShowView.h"
#import "HXFlashShareViewController.h"
#import "HXLongShareViewController.h"
#import "HXMyNewsTableViewController.h"
#import "HXCandyTableViewController.h"
#import "HXShowTopView.h"

@interface HXNewsViewController ()<UITableViewDelegate, UITableViewDataSource, TXDiscoverTopViewDelegate, HXFlashHeaderViewDelegate, HXHeaderTableViewCellDelegate, HXFlashTableViewCellDelegate, HXFlashShowViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *searchView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLayout;

@property (nonatomic, strong) TXDiscoverTopView *sectionView;
@property (nonatomic, strong) HXFlashHeaderView *flashHeaderView;
@property (nonatomic, strong) HXFlashShowView *showView;
@property (nonatomic, strong) HXShowTopView *showTopView;

@property (nonatomic, strong) NSMutableArray <HXBannerModel *>*bannerArray;
@property (nonatomic, strong) NSMutableArray <HXCategroyModel *>*categoryArray;
@property (nonatomic, strong) HXCategroyModel *currentCategoryModel;
@property (nonatomic, strong) NSMutableArray <HXFlashModel *>*flashArray;
@property (nonatomic, strong) HXFlashModel *flashModel;
@property (nonatomic, strong) NSMutableArray <HXNewsModel *>*newsArray;
/** 分页数 */
@property (nonatomic, assign) NSInteger page;
/** 分页请求条数 */
@property (nonatomic, assign) NSInteger page_size;
/** 返回数据条数 */
@property (nonatomic, assign) NSInteger dataCount;

@property (weak, nonatomic) IBOutlet UILabel *newsCountLabel;


@end

@implementation HXNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.heightLayout.constant = kTopHeight;
    
    self.searchView.layer.cornerRadius = 5;
    self.searchView.layer.masksToBounds = true;
    
    self.newsCountLabel.layer.cornerRadius = 8;
    self.newsCountLabel.layer.masksToBounds = true;
    
    // tableView 设置
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.automaticallyHidden = true;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calculatorNotice) name:kNotificationCalculatorNotice object:nil];
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;

    self.bannerArray = [NSMutableArray new];
    self.newsArray = [NSMutableArray new];
    self.categoryArray = [NSMutableArray new];
    self.flashArray = [NSMutableArray new];
    _page = 1;
    _page_size = 10;
    _dataCount = 0;
    
    [self getAccess];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(Timered) userInfo:nil repeats:YES];
}

- (void)Timered {
    [self getAttentionCount];
    [self getNotifyCount];
    [self getNewsCount];
}

- (void)showAnimationWithText:(NSString *)text {
    self.showTopView.topTextLabel.text = text;
    [self.view insertSubview:self.showTopView belowSubview:self.topView];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = true;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)calculatorNotice {
    NSInteger count = [[TXModelAchivar getUserModel].attentionCount integerValue] + [[TXModelAchivar getUserModel].notifyCount integerValue] -  [[TXModelAchivar getUserModel].notifyLocalCount integerValue] -  [[TXModelAchivar getUserModel].attentionLocalCount integerValue];
    self.newsCountLabel.hidden = count > 0 ? false : true;
    self.newsCountLabel.text = [NSString stringWithFormat:@"%ld", count];
}

#pragma mark - Request

- (NSInteger)notifyNum {
    return [[TXModelAchivar getUserModel].attentionCount integerValue] + [[TXModelAchivar getUserModel].notifyCount integerValue] -  [[TXModelAchivar getUserModel].notifyLocalCount integerValue] -  [[TXModelAchivar getUserModel].attentionLocalCount integerValue];
}

- (void)getNewsCount {
    
    if (![[TXUserModel defaultUser] userLoginStatus]) {
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:@"hot" forKey:@"model"];
    [param setValue:self.currentCategoryModel.column forKey:@"cid"];
    
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getLatestNewsOrFlash]
                             headParams:[RCHttpHelper accessAndLoginTokenHeader]
                             bodyParams:param
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
                                    if ([responseObject[@"code"] integerValue] == 200) {
                                        [TXModelAchivar updateUserModelWithKey:@"newsCount" value:responseObject[@"data"]];
                                        if ([responseObject[@"data"] integerValue] > [[TXModelAchivar getUserModel].newsLocalCount integerValue]) {
//                                            [self loadNewData];
                                            [self showAnimationWithText:[NSString stringWithFormat:@"更新了%ld条新闻", [responseObject[@"data"] integerValue] - [[TXModelAchivar getUserModel].newsLocalCount integerValue]]];
                                            if (self.page == 2) {
                                                [TXModelAchivar updateUserModelWithKey:@"newsLocalCount" value:responseObject[@"data"]];
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

- (void)getAttentionCount {
    if (![[TXUserModel defaultUser] userLoginStatus]) {
        return;
    }
    
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getSugarNotify]
                             headParams:[RCHttpHelper accessAndLoginTokenHeader]
                             bodyParams:nil
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
                                    if ([responseObject[@"code"] integerValue] == 200) {
                                        [TXModelAchivar updateUserModelWithKey:@"attentionCount" value:responseObject[@"data"][@"total"]];
                                        NSLog(@"attentionCount = %@", responseObject[@"data"][@"total"]);
                                        self.newsCountLabel.hidden = [self notifyNum] == 0 ? true : false;
                                        self.newsCountLabel.text = [self notifyNum] == 0 ? @"" : [NSString stringWithFormat:@"%ld", [self notifyNum]];
                                    } else {
                                        [ShowMessage showMessage:responseObject[@"message"]];
                                    }
                                } failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                    
                                } isLogin:^{
                                    [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
                                }];
}

- (void)getNotifyCount {
    if (![[TXUserModel defaultUser] userLoginStatus]) {
        return;
    }
    
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getPlacard]
                             headParams:[RCHttpHelper accessHeader]
                             bodyParams:nil
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
                                    if ([responseObject[@"code"] integerValue] == 200) {
                                        [TXModelAchivar updateUserModelWithKey:@"notifyCount" value:responseObject[@"data"][@"total"]];
                                        NSLog(@"notifyCount = %@", responseObject[@"data"][@"total"]);
                                        self.newsCountLabel.hidden = [self notifyNum] == 0 ? true : false;
                                        self.newsCountLabel.text = [self notifyNum] == 0 ? @"" : [NSString stringWithFormat:@"%ld", [self notifyNum]];
                                    } else {
                                        [ShowMessage showMessage:responseObject[@"message"]];
                                    }
                                } failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                    
                                } isLogin:^{
                                    [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
                                }];
}

- (void)getAccess {
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setValue:appId forKey:@"appid"];
    [params setValue:@"sdger234a" forKey:@"key"];
    [params setValue:[TXCustomTools currentTimeStr] forKey:@"timestamp"];
    NSString *sign = [NSString stringWithFormat:@"%@%@%@%@", appId, appSecret, @"sdger234a", [TXCustomTools currentTimeStr]];
    [params setValue:[TXCustomTools md5:sign] forKey:@"sign"];
    
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getAccess] headParams:nil bodyParams:params success:^(AFHTTPSessionManager *operation, id responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            NSLog(@"获取access成功");
            [TXModelAchivar updateUserModelWithKey:@"access" value:responseObject[@"data"][@"access"]];
            [self getBannerData];
            [self getNewsCategoryItem];
            [self getFirstFlash];
        } else {
            [self getAccess];
            NSLog(@"获取access失败");
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [self getAccess];
        NSLog(@"failure:获取access失败");
    } isLogin:^{
        
    }];
}

- (void)loadData {
    if ([NSString isTextEmpty:[TXModelAchivar getUserModel].access]) {
        [self getAccess];
        return;
    }

    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:self.currentCategoryModel.column forKey:@"cid"];
    [param setValue:[NSString stringWithFormat:@"%zd", self.page] forKey:@"page"];
    [param setValue:[NSString stringWithFormat:@"%zd", self.page_size] forKey:@"page_size"];
    
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getNewsOrHXNoList]
                             headParams:[RCHttpHelper accessHeader]
                             bodyParams:param
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
            [UIView performWithoutAnimation:^{
                [self.tableView reloadData];
            }];
        } else {
            [ShowMessage showMessage:responseObject[@"message"]];
            [UIView performWithoutAnimation:^{
                [self.tableView reloadData];
            }];
        }
                                    
        if ([responseObject[@"code"] integerValue] == 402) {
            [self getAccess];
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

- (void)getBannerData {
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getBanner]
                             headParams:[RCHttpHelper accessHeader]
                             bodyParams:nil
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            HXBannerCollectionModel *colloectionModel = [HXBannerCollectionModel mj_objectWithKeyValues:responseObject];
            self.bannerArray = [NSMutableArray arrayWithArray:colloectionModel.data];
            [self.tableView reloadData];
        } else {
            [ShowMessage showMessage:responseObject[@"message"]];
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        // [ShowMessage showMessage:error.description];
    } isLogin:^{
        [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
    }];
}

- (void)getNewsCategoryItem {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getHXNoOrNewsCategory]
                             headParams:[RCHttpHelper accessHeader]
                             bodyParams:@{@"tag" : @"main_news"}
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

- (void)getFirstFlash {
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getFlashList]
                             headParams:[RCHttpHelper accessHeader]
                             bodyParams:@{@"type" : @"fast", @"page" : @"1", @"page_size" : @"5"}
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            HXFlashCollectionModel *colloectionModel = [HXFlashCollectionModel mj_objectWithKeyValues:responseObject];
            self.flashArray = [NSMutableArray arrayWithArray:colloectionModel.data];
            self.flashModel = colloectionModel.data.firstObject;
            [self.tableView reloadData];
        } else {
            [ShowMessage showMessage:responseObject[@"message"]];
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        // [ShowMessage showMessage:error.description];
    } isLogin:^{
        [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1) return 1;
    return self.newsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cellDefault = nil;
    
    if (indexPath.section == 0) {
        HXHeaderTableViewCell *cell = [HXHeaderTableViewCell cellWithTableView:tableView];
        cell.delegate = self;
        if (self.bannerArray.count > 0) {
            cell.cycleData = self.bannerArray;
        }
        cellDefault = cell;
    } else if (indexPath.section == 1) {
        HXFlashTableViewCell *cell = [HXFlashTableViewCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.flashArray = self.flashArray;
        cellDefault = cell;
    } else {
        HXNewsTableViewCell *cell = [HXNewsTableViewCell cellWithTableView:tableView];
        cell.cellLineType = TXCellSeperateLinePositionType_Single;
        cell.cellLineRightMargin = TXCellRightMarginType0;
        if (self.newsArray.count > indexPath.row) {
            cell.model = self.newsArray[indexPath.row];
        }
        cellDefault = cell;
    }
    return cellDefault;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 0.01;
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return self.flashHeaderView;
    } else if (section == 2) {
        if (self.categoryArray.count > 0) {
            self.sectionView.dataSource = self.categoryArray;
        }
        return self.sectionView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 310;
    } else if (indexPath.section == 1) {
        return 80;
    } else {
        return 110.0;
    }
}

#pragma mark - Touch Method

- (IBAction)touchSearchButton:(id)sender {
    TXSearchResultViewController *vwcSearch = [TXSearchResultViewController new];
    [self.navigationController pushViewController:vwcSearch animated:true];
}

- (IBAction)touchNewsButton:(id)sender {
    HXMyNewsTableViewController *vwcNews = [[HXMyNewsTableViewController alloc] initWithNibName:NSStringFromClass([HXMyNewsTableViewController class]) bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vwcNews animated:true];
}


#pragma mark - HXHeaderTableViewCellDelegate

- (void)touchButtonItemWithType:(HXHeaderType)type {
    NSLog(@"%ld", type);
    switch (type) {
        case HXHeaderTypeHXNo:
        {
            HXNoViewController *vwcDetail = [[HXNoViewController alloc] initWithNibName:NSStringFromClass([HXNoViewController class]) bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:vwcDetail animated:true];
        }
            break;
            
        case HXHeaderTypeProject:
        {
            HXProjectViewController *vwcDetail = [[HXProjectViewController alloc] initWithNibName:NSStringFromClass([HXProjectViewController class]) bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:vwcDetail animated:true];
        }
            break;
            
        case HXHeaderTypeHXJoin:
        {
            HXJoinViewController *vwcDetail = [[HXJoinViewController alloc] initWithNibName:NSStringFromClass([HXJoinViewController class]) bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:vwcDetail animated:true];
        }
            break;
            
        case HXHeaderTypeCreditExchange:
        {
            if (![[TXUserModel defaultUser] userLoginStatus]) {
                [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
                return;
            }
            
            HXCandyTableViewController *vwcDetail = [[HXCandyTableViewController alloc] initWithNibName:NSStringFromClass([HXCandyTableViewController class]) bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:vwcDetail animated:true];
        }
            break;
            
        default:
            break;
    }
}

- (void)didSelectCycleScrollViewItemWithModel:(HXBannerModel *)model {
    NSLog(@"model = %@", model);
    if ([NSString isTextEmpty:model.url]) {
        return;
    }
    if ([model.url hasPrefix:@"http"]) {
        TXShowWebViewController *vwcWeb = [TXShowWebViewController new];
        vwcWeb.webViewUrl = model.url;
        vwcWeb.naviTitle = model.title;
        [self.navigationController pushViewController:vwcWeb animated:true];
    } else {
        HXNewsDetailViewController *vwcDetail = [[HXNewsDetailViewController alloc] initWithNibName:NSStringFromClass([HXNewsDetailViewController class]) bundle:[NSBundle mainBundle]];
        vwcDetail.articleId = model.url;
        [self.navigationController pushViewController:vwcDetail animated:true];
    }
}

#pragma mark - HXFlashHeaderViewDelegate

- (void)touchMoreButton {
    HXFlashViewController *vwcDetail = [[HXFlashViewController alloc] initWithNibName:NSStringFromClass([HXFlashViewController class]) bundle:[NSBundle mainBundle]];
    vwcDetail.isTabBar = true;
    [self.navigationController pushViewController:vwcDetail animated:true];
}

#pragma mark - TXDiscoverTopViewDelegate

- (void)selectItemWithModel:(HXCategroyModel *)model {
    self.currentCategoryModel = model;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadNewData];
}

#pragma mark - HXFlashTableViewCellDelegate

- (void)selectScrollViewWithModel:(HXFlashModel *)model {
    self.showView = [HXFlashShowView shareInstanceManager];
    self.showView.model = model;
    self.showView.delegate = self;
    [self.showView show];
}

#pragma mark - HXFlashShowViewDelegate

- (void)touchShareButtonWithModel:(HXFlashModel *)model {
    [self.showView hide];
    HXLongShareViewController *vwcShare = [[HXLongShareViewController alloc] initWithNibName:NSStringFromClass([HXLongShareViewController class]) bundle:[NSBundle mainBundle]];
    vwcShare.param = @{@"title" : model.title};
    NSString *str = model.des;
    vwcShare.content = str;
    vwcShare.time = model.create_time_format;
    [self.navigationController pushViewController:vwcShare animated:true];
}

#pragma mark - Lazy

- (HXShowTopView *)showTopView {
    if (!_showTopView) {
        _showTopView  =  [[[NSBundle mainBundle] loadNibNamed:@"HXShowTopView" owner:nil options:nil] lastObject];
        _showTopView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    }
    return _showTopView;
}

- (TXDiscoverTopView *)sectionView {
    if (!_sectionView) {
        _sectionView  =  [[[NSBundle mainBundle] loadNibNamed:@"TXDiscoverTopView" owner:nil options:nil] lastObject];
        _sectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        _sectionView.delegate = self;
    }
    return _sectionView;
}

- (HXFlashHeaderView *)flashHeaderView {
    if (!_flashHeaderView) {
        _flashHeaderView  =  [[[NSBundle mainBundle] loadNibNamed:@"HXFlashHeaderView" owner:nil options:nil] lastObject];
        _flashHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        _flashHeaderView.delegate = self;
    }
    return _flashHeaderView;
}

@end
