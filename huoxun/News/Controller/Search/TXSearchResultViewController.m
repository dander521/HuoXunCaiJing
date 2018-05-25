//
//  TXSearchResultViewController.m
//  TailorX
//
//  Created by 程荣刚 on 2017/12/5.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXSearchResultViewController.h"
#import "TXSearchTopView.h"
#import "TXHotSearchView.h"
#import "HXNewsDetailViewController.h"
#import "HXNewsTableViewCell.h"
#import "HXNewsModel.h"

@interface TXSearchResultViewController ()<TXSearchTopViewDelegate, UITextFieldDelegate, TXHotSearchViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TXHotSearchView *hotView;
@property (nonatomic, strong) TXSearchTopView *topView;
@property (nonatomic, strong) UITextField *topSearchTF;

@property (nonatomic, strong) NSMutableArray <HXNewsModel *>*newsArray;
/** 分页数 */
@property (nonatomic, assign) NSInteger page;
/** 分页请求条数 */
@property (nonatomic, assign) NSInteger page_size;
/** 返回数据条数 */
@property (nonatomic, assign) NSInteger dataCount;

@property (nonatomic, strong) NSString *keyStr;

@end

@implementation TXSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged) name:UITextFieldTextDidChangeNotification object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.keyStr = @"";
    self.newsArray = [NSMutableArray new];
    _page = 1;
    _page_size = 10;
    _dataCount = 0;
    
    [self setUpContentTableView];
    [self.view addSubview:self.hotView];
    [self.view addSubview:self.topView];
    
    adjustsScrollViewInsets_NO(self.tableView, self);
    
    // tableView 设置
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.automaticallyHidden = true;
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

#pragma mark - Custom

- (void)setUpContentTableView {
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = false;
        tableView.backgroundView = nil;
        tableView.bounces = true;
        tableView.scrollEnabled = true;
        tableView.backgroundColor = [UIColor clearColor];
        
        tableView;
    });
    [self.view addSubview:self.tableView];
}

- (void)textFieldDidChanged {
    
}

#pragma mark - Request

- (void)loadDataWithKeyString:(NSString *)keyStr {
    self.keyStr = keyStr;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getNewsOrHXNoList]
                             headParams:[RCHttpHelper accessHeader]
                             bodyParams:@{@"keywords" : keyStr, @"page" : [NSString stringWithFormat:@"%zd", self.page], @"page_size" : [NSString stringWithFormat:@"%zd", self.page_size]}
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"code"] integerValue] == 200) {
            _page += 1;
            HXNewsCollectionModel *colloectionModel = [HXNewsCollectionModel mj_objectWithKeyValues:responseObject];
            _dataCount = colloectionModel.data.count;
            if (_dataCount > 0) {
                [self.newsArray addObjectsFromArray:colloectionModel.data];
                self.topView.resultLabel.text = [NSString stringWithFormat:@"搜索结果共%zd条", self.newsArray.count];
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
    [self loadDataWithKeyString:self.keyStr];
}

- (void)loadMoreData {
    if (_dataCount < _page_size) {
        [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
    } else {
        [self loadDataWithKeyString:self.keyStr];
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

#pragma mark - TXSearchTopViewDelegate

- (void)touchCancelButton {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([NSString isTextEmpty:textField.text]) {
        [ShowMessage showMessage:@"请输入搜索内容"];
        return false;
    }
    
    [self.topSearchTF resignFirstResponder];
    self.hotView.hidden = true;
    self.topView.viewType = TXSearchTopViewTypeSearch;
    self.topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kTopHeight + 50);
    self.tableView.frame = CGRectMake(0, kTopHeight + 50, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight - 50);
    [self.view insertSubview:self.tableView belowSubview:self.topView];
    [self.newsArray removeAllObjects];
    _page = 1;
    [self loadDataWithKeyString:textField.text];
    return true;
}

#pragma mark - TXHotSearchViewDelegate

- (void)didSelectItemWithString:(NSString *)searchString {
    self.hotView.hidden = true;
    self.topView.viewType = TXSearchTopViewTypeSearch;
    self.topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kTopHeight + 50);
    self.tableView.frame = CGRectMake(0, kTopHeight + 50, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight - 50);
    [self.view insertSubview:self.tableView belowSubview:self.topView];
    [self.newsArray removeAllObjects];
    _page = 1;
    [self loadDataWithKeyString:searchString];
}

#pragma mark - TXHeatViewDelegate

- (void)scrollHeatScrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {

}

- (void)scrollHeatScrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

- (void)touchHeatDesignerButtonWithDesignerId:(NSString *)designerId {
    
}

#pragma mark - Lazy

- (TXSearchTopView *)topView {
    if (!_topView) {
        _topView = [TXSearchTopView instanceView];
        _topView.delegate = self;
        _topView.viewType = TXSearchTopViewTypeOrigin;
        self.topSearchTF = _topView.searchTF;
        self.topSearchTF.returnKeyType = UIReturnKeySearch;
        self.topSearchTF.delegate = self;
        _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kTopHeight);
    }
    
    return _topView;
}

- (TXHotSearchView *)hotView {
    if (!_hotView) {
        _hotView = [TXHotSearchView instanceView];
        _hotView.dataSource = @[@"交易", @"区块链技术"];
        _hotView.delegate = self;
        _hotView.frame = CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight);
    }
    return _hotView;
}

@end
