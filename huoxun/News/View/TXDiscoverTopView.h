//
//  TXDiscoverTopView.h
//  TailorX
//
//  Created by Qian Shen on 16/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXCategroyModel.h"


@protocol TXDiscoverTopViewDelegate <NSObject>

- (void)selectItemWithModel:(HXCategroyModel *)model;

@end

@interface TXDiscoverTopView : UIView

@property (nonatomic, assign) id<TXDiscoverTopViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataSource;

@end
