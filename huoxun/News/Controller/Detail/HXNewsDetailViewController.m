//
//  HXNewsDetailViewController.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/5.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXNewsDetailViewController.h"
#import "HXDetailHeaderTableViewCell.h"
#import "HXDetailTableViewCell.h"
#import "HXKeyWordTableViewCell.h"
#import "HXAuthorTableViewCell.h"
#import "HXAuthorViewController.h"
#import "HXNewsDetailModel.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "HXShareView.h"
#import "TXPublishedView.h"
#import "HXMultiView.h"
#import "HXFlashHeaderView.h"
#import "HXNewsTableViewCell.h"
#import "HXCommentTableViewCell.h"
#import "HXCommentModel.h"
#import "HXNewsModel.h"

@interface HXNewsDetailViewController () <UITableViewDelegate, UITableViewDataSource, HXAuthorTableViewCellDelegate, HXShareViewDelegate, UITextViewDelegate, HXMultiViewDelegate, HXKeyWordTableViewCellDelegate, HXCommentTableViewCellDelegate>

/** 动画开始位置*/
@property (nonatomic, assign) CGFloat beginAnimationY;
/** 动画结束位置*/
@property (nonatomic, assign) CGFloat endAnimationY;

@property (nonatomic, strong) TXPublishedView *publishedView;
@property (nonatomic, strong) HXNewsDetailModel *model;
@property (nonatomic, strong) HXShareView *shareView;
@property (nonatomic, strong) HXMultiView *multiView;

@property (nonatomic, strong) NSMutableDictionary *shareDic;

@property (nonatomic, assign) float height;

@property (nonatomic, strong) NSMutableArray *newsArray;
@property (nonatomic, strong) NSMutableArray *commentArray;

/** 分页数 */
@property (nonatomic, assign) NSInteger page;
/** 分页请求条数 */
@property (nonatomic, assign) NSInteger page_size;
/** 返回数据条数 */
@property (nonatomic, assign) NSInteger dataCount;

@end

@implementation HXNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"详情";
    self.shareDic = [NSMutableDictionary new];
    _height = SCREEN_HEIGHT;
    self.newsArray = [NSMutableArray new];
    self.commentArray = [NSMutableArray new];
    _page = 1;
    _page_size = 6;
    _dataCount = 0;
    // 定义全局leftBarButtonItem
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(touchShareBtn)];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setTableViewCellHight:)  name:@"getCellHightNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(payAttention:)  name:kNotificationPayAttentionSuccess object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectShareImageWithUserId:)  name:kNotificationHtmlAppointmentDesigner object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidHudForWebView)  name:kNotificationWebViewHideHud object:nil];
    
    
    [self.view addSubview:self.publishedView];
    [self.publishedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(@50);
    }];
    
    [self.view addSubview:self.multiView];
    [self.multiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(50);
        make.height.mas_equalTo(@50);
    }];
    self.publishedView.hidden = true;
//    self.multiView.hidden = true;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // tableView 设置
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.automaticallyHidden = true;
    
    
//    self.tableView.estimatedRowHeight = 0;
//    self.tableView.estimatedSectionHeaderHeight = 0;
//    self.tableView.estimatedSectionFooterHeight = 0;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getDetailData];
    [self getHeatNewsList];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGFloat height = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
        [self.publishedView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(-height);
        }];
        [self.publishedView.superview layoutIfNeeded];
    }];
    self.publishedView.hidden = false;
    self.multiView.hidden = true;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        [self.publishedView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.view.mas_bottom);
        }];
        [self.publishedView.superview layoutIfNeeded];
    }];
    self.publishedView.hidden = true;
    self.multiView.hidden = false;
}

- (void)hidHudForWebView {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)payAttention:(NSNotification *)info {
    [self.tableView reloadData];
}

- (void)setTableViewCellHight:(NSNotification *)info {
    // 判断最上控制器是否为当前控制器
    if (self.navigationController.viewControllers.lastObject != self) {
        return;
    }
    
    NSDictionary * dic=info.userInfo;
    //判断通知中的参数是否与原来的值一致,防止死循环
    if (_height != [[dic objectForKey:@"height"] floatValue])
    {
        _height=[[dic objectForKey:@"height"] floatValue];
        [self.tableView reloadData];
    }
}

- (void)selectShareImageWithUserId:(NSNotification *)info {
    if (![[TXUserModel defaultUser] userLoginStatus]) {
        [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
        return;
    }
    
    if (info.object) {
        NSString *content =info.object;
        NSArray *contentArray = [content componentsSeparatedByString:@"||"];
        
        [self.shareDic setValue:contentArray[0] forKey:@"logo"];
        [self.shareDic setValue:contentArray[1] forKey:@"title"];
        [self.shareDic setValue:contentArray[2] forKey:@"des"];
        [self.shareDic setValue:contentArray[3] forKey:@"url"];
    }
    
    [self shareContent];
}

#pragma mark - Request

- (void)getDetailData {
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getNewsOrHXNoDetail]
                             headParams:[RCHttpHelper accessAndLoginTokenHeader]
                             bodyParams:@{@"id" : self.articleId}
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            self.model = [HXNewsDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
            
            NSString *imageName = [self.model.is_collect isEqualToString:@"0"] ? @"collection" : @"collection_cur";
            [self.multiView.collectionButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            
            [self.tableView reloadData];
        }
//        [ShowMessage showMessage:responseObject[@"message"]];
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [ShowMessage showMessage:error.description];
    } isLogin:^{
        [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
    }];
}

- (void)getHeatNewsList {
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getHeatList]
                             headParams:[RCHttpHelper accessHeader]
                             bodyParams:@{@"page" : @"1", @"page_size" : @"6"}
                                success:^(AFHTTPSessionManager *operation, id responseObject) {

                                    if ([responseObject[@"code"] integerValue] == 200) {
                                        HXNewsCollectionModel *collectionModel = [HXNewsCollectionModel mj_objectWithKeyValues:responseObject];
                                        self.newsArray = [NSMutableArray arrayWithArray:collectionModel.data];
                                        [self.tableView reloadData];
                                    }
//                                    [ShowMessage showMessage:responseObject[@"message"]];
                                } failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                    [ShowMessage showMessage:error.description];
                                } isLogin:^{
                                    [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
                                }];
}

- (void)loadData {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:self.articleId forKey:@"nid"];
    [param setValue:[NSString stringWithFormat:@"%zd", self.page] forKey:@"page"];
    [param setValue:[NSString stringWithFormat:@"%zd", self.page_size] forKey:@"page_size"];
    
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getCommentList]
                             headParams:[RCHttpHelper accessHeader]
                             bodyParams:param
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
                                    
                                    if ([responseObject[@"code"] integerValue] == 200) {
                                        _page += 1;
                                        HXCommentCollectionModel *colloectionModel = [HXCommentCollectionModel mj_objectWithKeyValues:responseObject];
                                        _dataCount = colloectionModel.data.count;
                                        if (_dataCount > 0) {
                                            [self.commentArray addObjectsFromArray:colloectionModel.data];
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
//                                        [ShowMessage showMessage:responseObject[@"message"]];
                                    }
                                    [self.tableView.mj_header endRefreshing];
                                    [self.tableView.mj_footer endRefreshing];
                                } failure:^(AFHTTPSessionManager *operation, NSError *error) {
//                                    [MBProgressHUD hideHUDForView:self.view];
                                    
                                    [self.tableView.mj_header endRefreshing];
                                    [self.tableView.mj_footer endRefreshing];
                                } isLogin:^{
                                    [self.tableView.mj_header endRefreshing];
                                    [self.tableView.mj_footer endRefreshing];
                                    [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
                                }];
}

- (void)loadNewData {
    [self.commentArray removeAllObjects];
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
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 4) {
        return self.newsArray.count;
    } else if (section == 5) {
        return self.commentArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *defaultCell = nil;
    if (indexPath.section == 0) {
        HXDetailHeaderTableViewCell *cell = [HXDetailHeaderTableViewCell cellWithTableView:tableView];
        cell.model = self.model;
        defaultCell = cell;
    } else if (indexPath.section == 2) {
        HXKeyWordTableViewCell *cell = [HXKeyWordTableViewCell cellWithTableView:tableView];
        cell.cellLineRightMargin = TXCellRightMarginType16;
        cell.cellLineType = TXCellSeperateLinePositionType_None;
        cell.model = self.model;
        cell.delegate = self;
        defaultCell = cell;
    } else if (indexPath.section == 3) {
        HXAuthorTableViewCell *cell = [HXAuthorTableViewCell cellWithTableView:tableView];
        cell.modle = self.model.user;
        cell.delegate = self;
        cell.fromLabel.text = self.model.source;
        defaultCell = cell;
    } else if (indexPath.section == 1) {
        HXDetailTableViewCell *cell = [HXDetailTableViewCell cellWithTableView:tableView];
        cell.htmlString = self.model.content;
        cell.controllerView = self;
        defaultCell = cell;
    }  else if (indexPath.section == 4) {
        HXNewsTableViewCell *cell = [HXNewsTableViewCell cellWithTableView:tableView];
        cell.cellLineType = TXCellSeperateLinePositionType_Single;
        cell.cellLineRightMargin = TXCellRightMarginType16;
        if (self.newsArray.count > indexPath.row) {
            cell.model = self.newsArray[indexPath.row];
        }
        defaultCell = cell;
    } else {
        HXCommentTableViewCell *cell = [HXCommentTableViewCell cellWithTableView:tableView];
        if (self.commentArray.count > indexPath.row) {
            cell.model = self.commentArray[indexPath.row];
        }
        cell.delegate = self;
        defaultCell = cell;
    }
    return defaultCell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        // 作者
        HXAuthorViewController *vwcAuthor = [[HXAuthorViewController alloc] initWithNibName:NSStringFromClass([HXAuthorViewController class]) bundle:[NSBundle mainBundle]];
        vwcAuthor.uid = self.model.uid;
        vwcAuthor.model = self.model.user;
        [self.navigationController pushViewController:vwcAuthor animated:true];
    } else if (indexPath.section == 4) {
        HXNewsModel *model = self.newsArray[indexPath.row];
        HXNewsDetailViewController *vwcDetail = [[HXNewsDetailViewController alloc] initWithNibName:NSStringFromClass([HXNewsDetailViewController class]) bundle:[NSBundle mainBundle]];
        vwcDetail.articleId = model.idField;
        [self.navigationController pushViewController:vwcDetail animated:true];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return 125;
    if (indexPath.section == 1) return _height;
    if (indexPath.section == 2) return 60;
    if (indexPath.section == 3) return 160;
    if (indexPath.section == 4) return 100;
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1 || section == 2 || section == 3) {
        return 0.01;
    } else {
        return 36.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 0.01;
    } else if (section == 5 && self.commentArray.count == 0) {
        return 150;
    } else {
        return 20.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 4) {
        HXFlashHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"HXFlashHeaderView" owner:nil options:nil] lastObject];
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 36);
        headerView.nameLabel.text = @"相关新闻";
        headerView.moreBtn.hidden = true;
        return headerView;
    } else if (section == 5) {
        HXFlashHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"HXFlashHeaderView" owner:nil options:nil] lastObject];
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 36);
        headerView.nameLabel.text = @"全部评论";
        headerView.moreBtn.hidden = true;
        return headerView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 5 && self.commentArray.count == 0) {
        return [self setTableFooterView];
    }
    return nil;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate {
//    HXDetailTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
//    if([UIDevice currentDevice].systemVersion.floatValue >= 10) {
//        [cell.webView setNeedsLayout];
//    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    HXDetailTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    if([UIDevice currentDevice].systemVersion.floatValue >= 10) {
        [cell.webView setNeedsLayout];
    }
}

#pragma mark - HXKeyWordTableViewCellDelegate

- (void)selectPraiseButtonWithModel:(HXNewsDetailModel *)model {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:postPraise]
                              headParams:[RCHttpHelper accessAndLoginTokenHeader]
                              bodyParams:@{@"id" : self.articleId}
                                 success:^(AFHTTPSessionManager *operation, id responseObject) {
                                     [MBProgressHUD hideHUDForView:self.view];
                                     if ([responseObject[@"code"] integerValue] == 200) {
                                         self.model.is_praise = [self.model.is_praise isEqualToString:@"0"] ? @"1" : @"0";
                                         HXKeyWordTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
                                         cell.praiseImageView.image = [self.model.is_praise isEqualToString:@"0"] ? [UIImage imageNamed:@"zan_cur"] : [UIImage imageNamed:@"zan"];
                                         self.model.praise_num = [self.model.is_praise isEqualToString:@"0"] ? [NSString stringWithFormat:@"%ld", [self.model.praise_num integerValue] - 1] : [NSString stringWithFormat:@"%ld", [self.model.praise_num integerValue] + 1];
                                         cell.praiseLabel.text = self.model.praise_num;
                                     }
                                     [ShowMessage showMessage:responseObject[@"message"]];
                                 } failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                     [MBProgressHUD hideHUDForView:self.view];
                                 } isLogin:^{
                                     [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
                                 }];
}

#pragma mark - HXAuthorTableViewCellDelegate

- (void)selectAttentionWithModel:(HXAuthorModel *)model {
    NSString *attStr = [model.isatt isEqualToString:@"0"] ? @"add" : @"del";
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:postAttention]
                              headParams:[RCHttpHelper accessAndLoginTokenHeader]
                              bodyParams:@{@"to_id" : self.model.uid, @"type" : attStr}
                                 success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"code"] integerValue] == 200) {
            model.isatt = [model.isatt isEqualToString:@"0"] ? @"1" : @"0";
            model.fans_num = [model.isatt isEqualToString:@"0"] ? [NSString stringWithFormat:@"%ld", [model.fans_num integerValue]-1] : [NSString stringWithFormat:@"%ld", [model.fans_num integerValue]+1];
            NSString *btnTitle = [model.isatt isEqualToString:@"0"] ? @"关注" : @"取消关注";
            HXAuthorTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
            [cell.attentionBtn setTitle:btnTitle forState:UIControlStateNormal];
            if ([model.isatt isEqualToString:@"0"]) {
                [cell.attentionBtn setTitleColor:RGB(230, 33, 42) forState:UIControlStateNormal];
                cell.attentionBtn.layer.borderColor = RGB(230, 33, 42).CGColor;
            } else {
                [cell.attentionBtn setTitleColor:RGB(136, 136, 136) forState:UIControlStateNormal];
                cell.attentionBtn.layer.borderColor = RGB(136, 136, 136).CGColor;
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPayAttentionSuccess object:nil userInfo:nil];
        }
        [ShowMessage showMessage:responseObject[@"message"]];
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view];
        // [ShowMessage showMessage:error.description];
    } isLogin:^{
        [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
    }];
}

#pragma mark - Custom

- (void)touchShareBtn {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:getShare]
                              headParams:[RCHttpHelper accessAndLoginTokenHeader]
                              bodyParams:@{@"id" : self.model.idField, @"type" : @"news"}
                                 success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"code"] integerValue] == 200) {
            NSDictionary *dic = responseObject[@"data"];
            self.shareDic = dic;
            [self shareContent];
        }
//        [ShowMessage showMessage:responseObject[@"message"]];
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        // [ShowMessage showMessage:error.description];
    } isLogin:^{
        [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
    }];
}

- (void)shareContent {
    self.shareView = [HXShareView shareInstanceManager];
    self.shareView.interfaceType = HXShareViewInterfaceTypeNews;
    self.shareView.delegate = self;
    [self.shareView show];
}

#pragma mark - HXShareViewDelegate

- (void)touchShareButtonWithType:(HXShareViewType)type {
    switch (type) {
        case HXShareViewTypeWechat: {
            [self startSharePlatform: SSDKPlatformSubTypeWechatSession];
        }
            break;
        case HXShareViewTypeFriend: {
            [self startSharePlatform: SSDKPlatformSubTypeWechatTimeline];
        }
            break;
        case HXShareViewTypeQQ: {
//            [self startSharePlatform: SSDKPlatformSubTypeQQFriend];
            [ShowMessage showMessage:@"此功能暂未开通"];
        }
            break;
        case HXShareViewTypeQQZone: {
//            [self startSharePlatform: SSDKPlatformSubTypeQZone];
            [ShowMessage showMessage:@"此功能暂未开通"];
        }
            break;
        case HXShareViewTypeCopy: {
            [self.shareView hide];
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.shareDic[@"url"];
        }
            break;
        case HXShareViewTypeSafari: {
            [self.shareView hide];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.shareDic[@"url"]]];
        }
            break;
        case HXShareViewTypeCancel: {
            [self.shareView hide];
        }
            break;
        case HXShareViewTypeMail: {
            [self.shareView hide];
            NSString *mailStr = [NSString stringWithFormat:@"mailto://%@", self.shareDic[@"url"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailStr]];
        }
            break;
            
        default:
            break;
    }
}

//开始分享
- (void)startSharePlatform:(SSDKPlatformType)platform {
    [self.shareView hide];
    
    NSArray* imageArray = [NSArray new];
    if ([NSString isTextEmpty:self.shareDic[@"logo"]]) {
        imageArray = @[[UIImage imageNamed:@"logo.png"]];
    } else {
        NSURL *imageUrl = [NSURL URLWithString:[self.shareDic[@"logo"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
        imageArray = @[imageUrl];
    }
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:self.shareDic[@"des"]
                                     images:imageArray
                                        url:[NSURL URLWithString:self.shareDic[@"url"]]
                                      title:self.shareDic[@"title"]
                                       type:SSDKContentTypeAuto];
    
    [ShareSDK share:platform parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
                break;
            }
            case SSDKResponseStateFail:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                break;
            }
            default:
                break;
        }
    }];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
//    [UIView textView:textView maxLength:200 showEmoji:false];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // 文本内容
    NSString *newStr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if ([text isEqualToString:@"\n"]) {
        [self submit];
        [textView resignFirstResponder];
        self.publishedView.hidden = true;
        self.multiView.hidden = false;
        return NO;
    }else if (newStr.length > 200) {
        [ShowMessage showMessage:@"输入内容要在200字以内哦！" withCenter:self.view.center];
        return NO;
    }else {
        CGFloat textViewW = CGRectGetWidth(textView.frame);
        // 动态计算文本高度
        CGSize size = [self heightForString:newStr fontSize:14 andWidth:textViewW];
        if (size.height < 34) {
            textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textViewW, 34);
            size.height = 34;
        }else if (size.height > 100) {
            textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textViewW, 100);
            size.height = 100;
        }else {
            textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textViewW, size.height);
        }
        [self.publishedView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@(size.height + 16));
        }];
        return YES;
    }
}

- (CGSize)heightForString:(NSString *)value fontSize:(CGFloat)fontSize andWidth:(CGFloat)width {
    UITextView *detailTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont systemFontOfSize:fontSize];
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize;
}

#pragma mark - events

- (void)respondsToPublishBtn:(UIButton*)sender {
    [self.view endEditing:YES];
    self.publishedView.hidden = true;
    self.multiView.hidden = false;
    [self submit];
}

#pragma mark - UIScrollViewDelegate

//- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
////    self.oldOffset = scrollView.contentOffset.y;
//}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {

    self.endAnimationY = scrollView.contentOffset.y;
    if (self.endAnimationY-self.beginAnimationY > 0) {
//        self.multiView.hidden = false;
        [UIView animateWithDuration:0.2 animations:^{
            self.multiView.frame = CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50);
        }];
    } else {
//        self.multiView.hidden = true;
        [UIView animateWithDuration:0.2 animations:^{
            self.multiView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 50);
        }];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.beginAnimationY = scrollView.contentOffset.y;
}


#pragma mark - HXMultiViewDelegate

- (void)selectInputButton {
    [self.publishedView.inputTextView becomeFirstResponder];
    self.publishedView.hidden = false;
    self.multiView.hidden = true;
}

- (void)selectCommentButton {
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:5 inSection:4];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)selectCollectionButton {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:postCollection]
                              headParams:[RCHttpHelper accessAndLoginTokenHeader]
                              bodyParams:@{@"id" : self.articleId}
                                 success:^(AFHTTPSessionManager *operation, id responseObject) {
                                     [MBProgressHUD hideHUDForView:self.view];
                                     if ([responseObject[@"code"] integerValue] == 200) {
                                         self.model.is_collect = [self.model.is_collect isEqualToString:@"0"] ? @"1" : @"0";
                                         NSString *imageName = [self.model.is_collect isEqualToString:@"0"] ? @"collection" : @"collection_cur";
                                         [self.multiView.collectionButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
                                     }
                                     [ShowMessage showMessage:responseObject[@"message"]];
                                 } failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                     [MBProgressHUD hideHUDForView:self.view];
                                     // [ShowMessage showMessage:error.description];
                                 } isLogin:^{
                                     [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
                                 }];
}

- (void)selectShareButton {
    [self touchShareBtn];
}

#pragma mark - HXCommentTableViewCellDelegate

- (void)selectCommentPraiseButtonWithModel:(HXCommentModel *)model cell:(HXCommentTableViewCell *)cell {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:postCommentPraise]
                              headParams:[RCHttpHelper accessAndLoginTokenHeader]
                              bodyParams:@{@"id" : model.idField}
                                 success:^(AFHTTPSessionManager *operation, id responseObject) {
                                     [MBProgressHUD hideHUDForView:self.view];
                                     if ([responseObject[@"code"] integerValue] == 200) {
                                         model.is_praise = [model.is_praise isEqualToString:@"0"] ? @"1" : @"0";
                                         
                                         cell.praiseImageView.image = [model.is_praise isEqualToString:@"0"] ? [UIImage imageNamed:@"zan_cur"] : [UIImage imageNamed:@"zan"];
                                         model.znum = [model.is_praise isEqualToString:@"0"] ? [NSString stringWithFormat:@"%ld", [model.znum integerValue] - 1] : [NSString stringWithFormat:@"%ld", [model.znum integerValue] + 1];
                                         cell.praiseLabel.text = model.znum;
                                     }
                                     [ShowMessage showMessage:responseObject[@"message"]];
                                 } failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                     [MBProgressHUD hideHUDForView:self.view];
                                 } isLogin:^{
                                     [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
                                 }];
}

#pragma mark - Custom Method

- (void)submit {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:postComment]
                             headParams:[RCHttpHelper accessAndLoginTokenHeader]
                              bodyParams:@{@"nid" : self.articleId, @"content" : self.publishedView.inputTextView.text}
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
                                    [MBProgressHUD hideHUDForView:self.view];
                                    if ([responseObject[@"code"] integerValue] == 200) {
                                        [self loadNewData];
                                        self.multiView.inputTF.text = @"";
                                        self.publishedView.inputTextView.text = @"";
                                    }
                                    [ShowMessage showMessage:responseObject[@"message"]];
                                } failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                    [MBProgressHUD hideHUDForView:self.view];
                                    // [ShowMessage showMessage:error.description];
                                } isLogin:^{
                                    [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
                                }];
}

#pragma mark - Table Footer View

- (UIView *)setTableFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    footerView.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-15, 45, 30, 30)];
    imageView.image = [UIImage imageNamed:@"empty"];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, CGRectGetMaxY(imageView.frame)+8, 100, 14)];
    label.text = @"暂无评论";
    label.font = FONT(14);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = RGB(153, 153, 153);
    
    [footerView addSubview:imageView];
    [footerView addSubview:label];
    
    return footerView;
}

#pragma mark - Lazy

- (HXMultiView *)multiView {
    if (!_multiView) {
        _multiView  =  [[[NSBundle mainBundle] loadNibNamed:@"HXMultiView" owner:nil options:nil] lastObject];
        _multiView.delegate = self;
    }
    return _multiView;
}

- (TXPublishedView *)publishedView {
    if (!_publishedView) {
        _publishedView  =  [[[NSBundle mainBundle] loadNibNamed:@"TXPublishedView" owner:nil options:nil] lastObject];
        _publishedView.inputTextView.delegate = self;
        [_publishedView.publishBtn addTarget:self action:@selector(respondsToPublishBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _publishedView;
}

@end
