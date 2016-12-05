//
//  KMHPageViewController.h
//  KMHPageViewController
//
//  Created by Ken M. Haggerty on 12/2/16.
//  Copyright © 2016 Ken M. Haggerty. All rights reserved.
//

#pragma mark - // NOTES (Public) //

#pragma mark - // IMPORTS (Public) //

#import <UIKit/UIKit.h>

#pragma mark - // KMHPageViewController //

#pragma mark Public Interface

@interface KMHPageViewController : UITabBarController
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;

// GENERAL //

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated;

// IBACTIONS //

- (IBAction)close:(id)sender;

@end
