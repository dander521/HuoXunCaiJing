//
//  HXProjectHeaderTableViewCell.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/5.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXProjectHeaderTableViewCell.h"
#import "HXProjectCollectionViewCell.h"

static NSString *cellID = @"HXProjectCollectionViewCell";

@interface HXProjectHeaderTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImg;
@property (weak, nonatomic) IBOutlet UIImageView *rightImg;


@end

@implementation HXProjectHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initializeInterface];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)touchLeftButton:(id)sender {
    NSIndexPath *indexPathFirst = self.collectionView.indexPathsForVisibleItems.firstObject;
    NSIndexPath *indexPathLast = self.collectionView.indexPathsForVisibleItems.lastObject;
    
    NSIndexPath *indexPath = [NSIndexPath new];
    if ([indexPathFirst compare:indexPathLast] == NSOrderedAscending) {
        indexPath = indexPathLast;
    } else if ([indexPathFirst compare:indexPathLast] == NSOrderedDescending) {
        indexPath = indexPathFirst;
    }
    [self.collectionView layoutIfNeeded];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:true];
}

- (IBAction)touchRightButton:(id)sender {
    NSIndexPath *indexPathFirst = self.collectionView.indexPathsForVisibleItems.firstObject;
    NSIndexPath *indexPathLast = self.collectionView.indexPathsForVisibleItems.lastObject;
    
    NSIndexPath *indexPath = nil;
    if ([indexPathFirst compare:indexPathLast] == NSOrderedAscending) {
        indexPath = indexPathFirst;
    } else if ([indexPathFirst compare:indexPathLast] == NSOrderedDescending) {
        indexPath = indexPathLast;
    }
    
    [self.collectionView layoutIfNeeded];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:true];
}

#pragma mark - init

- (void)initializeInterface {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.collectionViewLayout = flowLayout;
    //设置最小间距
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 15;
    //设置格子大小
    CGFloat w = SCREEN_WIDTH/2-55;
    CGFloat h = 183.5;
    flowLayout.itemSize = CGSizeMake(w, h);
    self.collectionView.showsHorizontalScrollIndicator = false;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.pagingEnabled = true;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    [self.collectionView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellWithReuseIdentifier:cellID];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HXProjectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    if (self.dataSource.count > indexPath.row) {
        cell.model = self.dataSource[indexPath.row];
    }
    return cell;
}

#pragma - mark  UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HXProjectModel *model = self.dataSource[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectItemViewWithModel:)]) {
        [self.delegate selectItemViewWithModel:model];
    }
}

#pragma mark - setters

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self.collectionView reloadData];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"HXProjectHeaderTableViewCell";
    HXProjectHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

@end
