//
//  HXNewsDetailViewController.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/5.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXNewsDetailViewController : UIViewController

@property (nonatomic, strong) NSString *articleId;
@property (nonatomic, strong) NSString *nId;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
