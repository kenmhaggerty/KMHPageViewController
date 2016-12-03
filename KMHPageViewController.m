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

#pragma mark - // KMHPageViewTabBarCell //

#pragma mark Public Interface

@interface KMHPageViewTabBarCell : UICollectionViewCell
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *title;
@end

#pragma mark Private Interface

@interface KMHPageViewTabBarCell ()
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *label;
@end

#pragma mark Implementation

@implementation KMHPageViewTabBarCell

#pragma mark // Setters and Getters (Public) //

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
}

- (UIImage *)image {
    return self.imageView.image;
}

- (void)setTitle:(NSString *)title {
    self.label.text = title;
    [self.label.superview setNeedsUpdateConstraints];
    
}

- (NSString *)title {
    return self.label.text;
}

@end

#pragma mark - // KMHPageViewController //

#pragma mark Private Interface

@interface KMHPageViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UICollectionView *tabBarCollectionView;
@property (nonatomic, strong) NSMutableSet *preloadedTabBarCells;
- (void)setup;
@end

#pragma mark Implementation

@implementation KMHPageViewController

#pragma mark // Setters and Getters (Overwritten) //

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
    [super setViewControllers:viewControllers];
    
    [self.collectionView reloadData];
    [self.tabBarCollectionView reloadData];
    
    self.pageControl.numberOfPages = viewControllers.count;
    self.pageControl.currentPage = self.selectedIndex;
    
    [self.preloadedTabBarCells removeAllObjects];
    for (int i = 0; i < viewControllers.count; i++) {
        [self.preloadedTabBarCells addObject:[self.tabBarCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]]];
    }
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
    if ([collectionView isEqual:self.collectionView]) {
        KMHPageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        cell.view = self.viewControllers[indexPath.item].view;
        cell.view.backgroundColor = indexPath.item % 2 ? [UIColor redColor] : [UIColor blueColor]; // test
//        [cell.view.superview setNeedsUpdateConstraints];
//        [cell.view.superview layoutIfNeeded];
        return cell;
    }
    
    if ([collectionView isEqual:self.tabBarCollectionView]) {
        KMHPageViewTabBarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tabBarCell" forIndexPath:indexPath];
        UITabBarItem *tabBarItem = self.viewControllers[indexPath.item].tabBarItem;
        cell.image = tabBarItem.image;
        cell.title = tabBarItem.title;
        cell.backgroundColor = indexPath.item % 2 ? [UIColor greenColor] : [UIColor yellowColor]; // test
        return cell;
    }
    
    return nil;
}

#pragma mark // Delegated Methods (UICollectionViewDelegateFlowLayout) //

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.frame.size;
}

#pragma mark // Delegated Methods (UIScrollViewDelegate) //

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat percent = scrollView.contentOffset.x / scrollView.frame.size.width;
//    if (![scrollView isEqual:self.collectionView]) {
//        [self.collectionView setContentOffset:CGPointMake(CGRectGetWidth(self.collectionView.frame)*percent, self.collectionView.contentOffset.y) animated:YES];
//    }
//    if (![scrollView isEqual:self.tabBarCollectionView]) {
//        [self.tabBarCollectionView setContentOffset:CGPointMake(CGRectGetWidth(self.tabBarCollectionView.frame)*percent, self.tabBarCollectionView.contentOffset.y) animated:YES];
//    }
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.selectedIndex = roundf(scrollView.contentOffset.x / scrollView.frame.size.width);
}

#pragma mark // Private Methods //

- (void)setup {
    self.view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    [self.collectionView registerClass:[KMHPageViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.tabBarCollectionView registerClass:[KMHPageViewTabBarCell class] forCellWithReuseIdentifier:@"tabBarCell"];
}

@end
