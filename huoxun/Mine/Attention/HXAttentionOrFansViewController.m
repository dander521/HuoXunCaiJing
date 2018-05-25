//
//  HXAttentionOrFansViewController.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/25.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXAttentionOrFansViewController.h"
#import "HXAttentionModel.h"
#import "HXAttentionTableViewCell.h"
#import "HXAuthorViewController.h"
#import "HXAuthorModel.h"

@interface HXAttentionOrFansViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 无数据提示页面 */
@property (nonatomic, strong) TXBlankView *blankView;
/** 分页数 */
@property (nonatomic, assign) NSInteger page;
/** 分页请求条数 */
@property (nonatomic, assign) NSInteger pageSize;
/** 返回数据条数 */
@property (nonatomic, assign) NSInteger dataCount;
/** 数据源集合 */
@property (nonatomic, strong) NSMutableArray *sourceArray;
@end

@implementation HXAttentionOrFansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.isAttention ? @"关注" : @"粉丝";
    
    // tableView 设置
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.automaticallyHidden = true;
    
    // 初始化数据
    _page = 1;
    _pageSize = 10;
    _dataCount = 0;
    self.sourceArray = [NSMutableArray new];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data Request

- (void)loadData {
    NSMutableDictionary *paramsBody = [NSMutableDictionary new];
    [paramsBody setValue:[NSString stringWithFormat:@"%zd", self.page] forKey:@"page"];
    [paramsBody setValue:[NSString stringWithFormat:@"%zd", self.pageSize] forKey:@"page_size"];
    
    if (self.isAttention) {
        [paramsBody setValue:@"att" forKey:@"type"];
    } else {
        [paramsBody setValue:@"fans" forKey:@"type"];
    }
    
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:getAttentionList] headParams:[RCHttpHelper accessAndLoginTokenHeader] bodyParams:paramsBody success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"code"] integerValue] == 200) {
            _page += 1;
            HXAttentionCollectionModel *colloectionModel = [HXAttentionCollectionModel mj_objectWithKeyValues:responseObject];
            _dataCount = colloectionModel.data.count;
            if (_dataCount > 0) {
                [self.sourceArray addObjectsFromArray:colloectionModel.data];
            }
            if (self.sourceArray.count == 0) {
                
            } else {
                [self.blankView removeFromSuperview];
                if (_dataCount < _pageSize) {
                    [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                }
            }
            [self.tableView reloadData];
        } else {
            
        }
        
        if ([responseObject[@"code"] integerValue] == 205) {
            [self showBlankView];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view];
    } isLogin:^{
        [MBProgressHUD hideHUDForView:self.view];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
    }];
}

- (void)loadMoreData {
    if (_dataCount < _pageSize) {
        [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
    } else {
        [self loadData];
    }
}

- (void)loadNewData {
    [self.sourceArray removeAllObjects];
    _page = 1;
    [self loadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - Custom

- (void)showBlankView {
    [self.view addSubview:self.blankView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HXAttentionTableViewCell *cell = [HXAttentionTableViewCell cellWithTableView:tableView];
    cell.cellLineType = TXCellSeperateLinePositionType_Single;
    cell.cellLineRightMargin = TXCellRightMarginType0;
    if (self.sourceArray.count > indexPath.row) {
        cell.model = self.sourceArray[indexPath.row];        
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXAttentionModel *model = self.sourceArray[indexPath.row];
    NSString *url = self.isAttention ? postAttention : postRemoveFans;
    NSDictionary *param = self.isAttention ? @{@"to_id" : model.uid, @"type" : @"del"} : @{@"to_id" : model.uid};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:url]
                              headParams:[RCHttpHelper accessAndLoginTokenHeader]
                              bodyParams:param
                                 success:^(AFHTTPSessionManager *operation, id responseObject) {
                                     [MBProgressHUD hideHUDForView:self.view];
                                     if ([responseObject[@"code"] integerValue] == 200) {
                                         // 删除模型
                                         [self.sourceArray removeObjectAtIndex:indexPath.row];
                                         [self.tableView reloadData];
                                         if (self.sourceArray.count == 0) {
                                             [self showBlankView];
                                         }
                                         [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationRemoveAttention object:nil userInfo:nil];
                                     }
                                     [ShowMessage showMessage:responseObject[@"message"]];
                                 } failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                     
                                     [MBProgressHUD hideHUDForView:self.view];
                                 } isLogin:^{
                                     [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
                                 }];
}

/**
 *  修改Delete按钮文字为“删除”
 */
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isAttention) {
        return @"取消关注";
    }
    return @"移除粉丝";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isAttention) {
        
        HXAttentionModel *attentionModel = self.sourceArray[indexPath.row];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getAuthorInfo]
                                 headParams:[RCHttpHelper accessHeader]
                                 bodyParams:@{@"uid" : attentionModel.uid}
                                    success:^(AFHTTPSessionManager *operation, id responseObject) {
                                        [MBProgressHUD hideHUDForView:self.view];
                                        if ([responseObject[@"code"] integerValue] == 200) {
                                            HXAuthorModel *model = [HXAuthorModel mj_objectWithKeyValues:responseObject[@"data"][@"user"]];
                                            model.isatt = @"1";
                                            HXAuthorViewController *vwcAuthor = [[HXAuthorViewController alloc] initWithNibName:NSStringFromClass([HXAuthorViewController class]) bundle:[NSBundle mainBundle]];
                                            vwcAuthor.uid = attentionModel.uid;
                                            vwcAuthor.model = model;
                                            [self.navigationController pushViewController:vwcAuthor animated:true];
                                        } else {
                                            [ShowMessage showMessage:responseObject[@"message"]];
                                        }
                                    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                        [MBProgressHUD hideHUDForView:self.view];
                                    } isLogin:^{
                                        [MBProgressHUD hideHUDForView:self.view];
                                        [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
                                    }];
    }
}

#pragma mark - Lazy

/**
 空白页
 */
- (UIView *)blankView {
    if (nil == _blankView) {
        _blankView = [[TXBlankView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight)];
        _blankView.backgroundColor = RGB(255, 255, 255);
        [_blankView createBlankViewWithImage:@"empty" title:@"暂无数据"];
    }
    
    return _blankView;
}


@end
