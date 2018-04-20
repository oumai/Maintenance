//
//  KMMCourseCategoryView.m
//  Maintenance
//
//  Created by kmcompany on 2017/6/13.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMCourseCategoryView.h"
#import "BATMyFindEqualCellFlowLayout.h"
#import "KMMKeyWordCell.h"

@interface KMMCourseCategoryView()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation KMMCourseCategoryView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        [self pageLayout];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    KMMKeyWordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KMMKeyWordCell" forIndexPath:indexPath];
    
//    if (self.listModel.Data.count > 0) {
//        
//        HotTopicListData *data = self.listModel.Data[indexPath.row];
//        
//        [cell.keyLabel setTitle:data.Topic forState:UIControlStateNormal];
//        
//        if (data.isSelect) {
//            [cell.keyLabel setGradientColors:@[START_COLOR,END_COLOR]];
//            cell.layer.borderColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img-qryy"]].CGColor;
//        }else {
//            [cell.keyLabel setGradientColors:@[UIColorFromHEX(0X333333, 1),UIColorFromHEX(0X333333, 1)]];
//            cell.layer.borderColor = BASE_LINECOLOR.CGColor;
//        }
//    }
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.listModel.Data.count > 0) {
//        
//        for (HotTopicListData *data in self.listModel.Data) {
//            data.isSelect = NO;
//        }
//        
//        HotTopicListData *data = self.listModel.Data[indexPath.row];
//        data.isSelect = YES;
//        [self.collectionView reloadData];
//        
//        if (self.topicKeyTapBlock) {
//            HotTopicListData *data = self.listModel.Data[indexPath.row];
//            self.topicKeyTapBlock(indexPath,data.ID);
//        }
//    }
}

//上下间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

//行间距 每个section items 左右行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 20;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.listModel.Data.count > 0) {
//        HotTopicListData *data = self.listModel.Data[indexPath.row];
//        
//        CGSize textSize = [data.Topic boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
//        return CGSizeMake(textSize.width+20, 30);
//    }
    return CGSizeZero;
}

- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority
{
    self.collectionView.frame = CGRectMake(0, 0, targetSize.width, MAXFLOAT);
    //    [self.collectionView layoutIfNeeded];
    
    return [self.collectionView.collectionViewLayout collectionViewContentSize];
}


#pragma mark - get&set
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        BATMyFindEqualCellFlowLayout *flowLayout = [[BATMyFindEqualCellFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.scrollEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
    }
    return _collectionView;
}

#pragma makr - Layout
- (void)pageLayout
{
    [self addSubview:self.collectionView];
    
    WEAK_SELF(self);
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self);
    }];
}


@end
