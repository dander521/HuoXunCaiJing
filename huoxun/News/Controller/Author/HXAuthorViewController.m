//
//  HXAuthorViewController.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/6.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXAuthorViewController.h"
#import "HXAuthorHeaderTableViewCell.h"
#import "HXNewsTableViewCell.h"
#import "HXNewsDetailViewController.h"
#import "HXNewsModel.h"

@interface HXAuthorViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <HXNewsModel *>*newsArray;
@property (nonatomic, strong) UIButton *rightBtn;
/** 分页数 */
@property (nonatomic, assign) NSInteger page;
/** 分页请求条数 */
@property (nonatomic, assign) NSInteger page_size;
/** 返回数据条数 */
@property (nonatomic, assign) NSInteger dataCount;
@end

@implementation HXAuthorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"作者";
    
    // tableView 设置
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.automaticallyHidden = true;
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *attStr = [self.model.isatt isEqualToString:@"0"] ? @"关注" : @"取消关注";
    [self.rightBtn setTitle:attStr forState:UIControlStateNormal];
    self.rightBtn.frame = CGRectMake(0, 0, 60, 40);
    self.rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.rightBtn addTarget:self action:@selector(payAttentionToAuthor) forControlEvents:UIControlEventTouchUpInside];
    if ([self.model.isatt isEqualToString:@"0"]) {
        [self.rightBtn setTitleColor:RGB(230, 33, 42) forState:UIControlStateNormal];
    } else {
        [self.rightBtn setTitleColor:RGB(136, 136, 136) forState:UIControlStateNormal];
    }
    self.rightBtn.titleLabel.font = FONT(14);
    UIBarButtonItem *attention = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    
    self.navigationItem.rightBarButtonItems = @[attention];
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

#pragma mark - events

- (void)payAttentionToAuthor {
    NSString *attStr = [self.model.isatt isEqualToString:@"0"] ? @"add" : @"del";
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:postAttention]
                              headParams:[RCHttpHelper accessAndLoginTokenHeader]
                              bodyParams:@{@"to_id" : self.uid, @"type" : attStr}
                                 success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"code"] integerValue] == 200) {
            self.model.isatt = [self.model.isatt isEqualToString:@"0"] ? @"1" : @"0";
            self.model.fans_num = [self.model.isatt isEqualToString:@"0"] ? [NSString stringWithFormat:@"%ld", [self.model.fans_num integerValue]-1] : [NSString stringWithFormat:@"%ld", [self.model.fans_num integerValue]+1];
            NSString *btnTitle = [self.model.isatt isEqualToString:@"0"] ? @"关注" : @"取消关注";
            [self.rightBtn setTitle:btnTitle forState:UIControlStateNormal];
            if ([self.model.isatt isEqualToString:@"0"]) {
                [self.rightBtn setTitleColor:RGB(230, 33, 42) forState:UIControlStateNormal];
            } else {
                [self.rightBtn setTitleColor:RGB(136, 136, 136) forState:UIControlStateNormal];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPayAttentionSuccess object:nil userInfo:@{@"att" : @"self.model.isatt"}];
            [self.tableView reloadData];
        }
        [ShowMessage showMessage:responseObject[@"message"]];
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        // [ShowMessage showMessage:error.description];
    } isLogin:^{
        [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
    }];
}

#pragma mark - Request

- (void)loadData {
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getNewsOrHXNoList]
                             headParams:[RCHttpHelper accessHeader]
                             bodyParams:@{@"uid" : self.uid, @"page" : [NSString stringWithFormat:@"%zd", self.page], @"page_size" : [NSString stringWithFormat:@"%zd", self.page_size]}
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return self.newsArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HXAuthorHeaderTableViewCell *cell = [HXAuthorHeaderTableViewCell cellWithTableView:tableView];
        cell.model = self.model;
        return cell;
    } else {
        HXNewsTableViewCell *cell = [HXNewsTableViewCell cellWithTableView:tableView];
        cell.cellLineType = TXCellSeperateLinePositionType_Single;
        cell.cellLineRightMargin = TXCellRightMarginType0;
        if (self.newsArray.count > indexPath.row) {
            cell.model = self.newsArray[indexPath.row];
        }
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        HXNewsModel *model = self.newsArray[indexPath.row];
        HXNewsDetailViewController *vwcDetail = [[HXNewsDetailViewController alloc] initWithNibName:NSStringFromClass([HXNewsDetailViewController class]) bundle:[NSBundle mainBundle]];
        vwcDetail.articleId = model.idField;
        [self.navigationController pushViewController:vwcDetail animated:true];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 300;
    } else {
        return 110;
    }
}


@end
