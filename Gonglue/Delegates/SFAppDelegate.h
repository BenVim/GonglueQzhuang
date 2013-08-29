//
//  SFAppDelegate.h
//  Gonglue
//
//  Created by jiajun on 11/24/12.
//  Copyright (c) 2012 Gonglue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SFSlideNavViewController;
@class UMNavigationController;

@interface SFAppDelegate : UIResponder <UIApplicationDelegate>

- (void)initSlideNavigator;

@property (strong, nonatomic)   UIWindow                          *window;
@property (strong, nonatomic)   SFSlideNavViewController          *navigator;

@property (strong, nonatomic)   UMNavigationController            *followedQuestionsNavigator;
@property (strong, nonatomic)   UMNavigationController            *hottestNavigator;
@property (strong, nonatomic)   UMNavigationController            *loginNavigator;
@property (strong, nonatomic)   UMNavigationController            *logoutNavigator;
@property (strong, nonatomic)   UMNavigationController            *newestNavigator;
@property (strong, nonatomic)   UMNavigationController            *userProfileNavigator;
@property (strong, nonatomic)   UMNavigationController            *userSettingsNavigator;
@property (strong, nonatomic)   NSMutableArray  *navList;


@end
