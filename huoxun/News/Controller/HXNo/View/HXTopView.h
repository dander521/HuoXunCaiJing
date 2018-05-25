//
//  HXTopView.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/5.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXCategroyModel.h"


@protocol HXTopViewDelegate <NSObject>

- (void)selectTopViewWithModel:(HXCategroyModel *)model;

@end
@interface HXTopView : UIView

@property (weak, nonatomic) IBOutlet UIView *myView;
@property (nonatomic, assign) id<HXTopViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataSource;

@end
