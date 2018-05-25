//
//  HXProjectDetailViewController.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/5.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXProjectDetailViewController.h"
#import "HXProjectDetailHeaderTableViewCell.h"
#import "HXProjectDetailIntroductTableViewCell.h"
#import "HXProjectDetailModel.h"
#import "TXShowWebViewController.h"

@interface HXProjectDetailViewController () <UITableViewDataSource, UITableViewDelegate, HXProjectDetailHeaderTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) HXProjectDetailModel *model;
@property (nonatomic, assign) float height;

@end

@implementation HXProjectDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"项目";
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setTableViewCellHight:)  name:@"getProjectCellHightNotification" object:nil];
    
    [self loadData];
    
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionFooterHeight = 0.0;
    self.tableView.estimatedSectionHeaderHeight = 0.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - Request

- (void)loadData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getProjectDetail]
                             headParams:[RCHttpHelper accessHeader]
                             bodyParams:@{@"id" : self.projectId}
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"code"] integerValue] == 200) {
            self.model = [HXProjectDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
            [self.tableView reloadData];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HXProjectDetailHeaderTableViewCell *cell = [HXProjectDetailHeaderTableViewCell cellWithTableView:tableView];
        cell.model = self.model;
        cell.delegate = self;
        return cell;
    } else {
        HXProjectDetailIntroductTableViewCell *cell = [HXProjectDetailIntroductTableViewCell cellWithTableView:tableView];
        cell.htmlString = self.model.des;
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 387;
    } else {
        return _height;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 50;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        header.backgroundColor = [UIColor whiteColor];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 100, 20)];
        nameLabel.text = @"项目介绍";
        nameLabel.font = FONT(16);
        nameLabel.textColor = RGB(46, 46, 46);
        [header addSubview:nameLabel];
        
        return header;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - HXProjectDetailHeaderTableViewCellDelegate

- (void)touchProjectDetailWhitePaperWithPPTUrl:(NSString *)ppturl {
    TXShowWebViewController *vwcWeb = [TXShowWebViewController new];
    vwcWeb.webViewUrl = ppturl;
    vwcWeb.naviTitle = self.model.title;
    [self.navigationController pushViewController:vwcWeb animated:true];
}


@end
