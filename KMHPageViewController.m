//
//  KMHPageViewController.m
//  KMHPageViewController
//
//  Created by Ken M. Haggerty on 12/2/16.
//  Copyright © 2016 Ken M. Haggerty. All rights reserved.
//

#pragma mark - // NOTES (Private) //

#pragma mark - // IMPORTS (Private) //

#import "KMHPageViewController.h"

#pragma mark - // KMHPageViewCell //

#pragma mark Public Interface

@interface KMHPageViewCell : UICollectionViewCell
@property (nonatomic, strong) UIView *view;
@end

#pragma mark Implementation

@implementation KMHPageViewCell

#pragma mark // Setters and Getters (Public) //

- (void)setView:(UIView *)view {
    if ((!view && !_view) || [view isEqual:_view]) {
        return;
    }
    
    if (_view) {
        [_view removeFromSuperview];
    }
    
    _view = view;
    
    if (view) {
        view.frame = self.contentView.bounds;
        [self.contentView addSubview:view];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];
    }
}

#pragma mark // Inits and Loads //

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.view = nil;
}

@end

#pragma mark - // KMHPageViewController //

#pragma mark Private Interface

@interface KMHPageViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
- (void)setup;
@end

#pragma mark Implementation

@implementation KMHPageViewController

#pragma mark // Setters and Getters (Overwritten) //

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
    [super setViewControllers:viewControllers];
    
    [self.collectionView reloadData];
    
    self.pageControl.numberOfPages = viewControllers.count;
    self.pageControl.currentPage = self.selectedIndex;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    self.pageControl.currentPage = selectedIndex;
}

- (NSUInteger)selectedIndex {
    return self.pageControl.currentPage;
}

#pragma mark // Inits and Loads //

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setup];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.allowsSelection = NO;
}

#pragma mark // Delegated Methods (UICollectionViewDataSource) //

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    KMHPageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.view = self.viewControllers[indexPath.item].view;
    cell.view.backgroundColor = indexPath.item % 2 ? [UIColor redColor] : [UIColor blueColor]; // test
//    [cell.view.superview setNeedsUpdateConstraints];
//    [cell.view.superview layoutIfNeeded];
    return cell;
}

#pragma mark // Delegated Methods (UICollectionViewDelegateFlowLayout) //

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.frame.size;
}

#pragma mark // Delegated Methods (UIScrollViewDelegate) //

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.selectedIndex = roundf(scrollView.contentOffset.x / scrollView.frame.size.width);
}

#pragma mark // Private Methods //

- (void)setup {
    self.view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([KMHPageViewController class]) owner:self options:nil].firstObject;
    [self.collectionView registerClass:[KMHPageViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

@end
