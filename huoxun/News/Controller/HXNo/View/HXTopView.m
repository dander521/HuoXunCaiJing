//
//  HXTopView.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/5.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXTopView.h"
#import "HXHeaderCollectionViewCell.h"

static NSString *cellID = @"HXHeaderCollectionViewCell";

@interface HXTopView ()<UICollectionViewDelegate,UICollectionViewDataSource>




@end

@implementation HXTopView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initializeInterface];
}

#pragma mark - init

- (void)initializeInterface {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.collectionViewLayout = flowLayout;
    //设置最小间距
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    //设置格子大小
    CGFloat w = 91;
    CGFloat h = 62;
    flowLayout.itemSize = CGSizeMake(w, h);
    self.collectionView.showsHorizontalScrollIndicator = false;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 2, 0, 2);
    [self.collectionView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellWithReuseIdentifier:cellID];
    self.collectionView.backgroundColor = RGB(247, 247, 247);
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, 60, 62);
    gradientLayer.colors = @[(id)RGBA(255, 255, 255, 0).CGColor,
                             (id)RGB(255, 255, 255).CGColor];
    gradientLayer.locations = @[@(0.1f)];
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    [self.myView.layer addSublayer:gradientLayer];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HXHeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

#pragma - mark  UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    for (int i = 0; i<self.dataSource.count; i++) {
        HXCategroyModel *model = self.dataSource[i];
        if (indexPath.row == i) {
            model.isSelected = true;
        } else {
            model.isSelected = false;
        }
    }
    [self.collectionView reloadData];
    HXCategroyModel *model = self.dataSource[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectTopViewWithModel:)]) {
        [self.delegate selectTopViewWithModel:model];
    }
    
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:true];
}

#pragma mark - setters

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self.collectionView reloadData];
}


@end
