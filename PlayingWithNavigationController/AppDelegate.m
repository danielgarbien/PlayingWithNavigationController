//
//  AppDelegate.m
//  PlayingWithNavigationController
//
//  Created by Daniel Garbień on 10/10/13.
//  Copyright (c) 2013 Daniel Garbień. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstViewController.h"
#import "NavigationControllerDelegate.h"


@interface AppDelegate ()

@property (strong, nonatomic) NavigationControllerDelegate * navigationControllerDelegate;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    FirstViewController * first = [[FirstViewController alloc] init];
    UINavigationController * navController = [[UINavigationController alloc] init];
    [navController pushViewController:first animated:NO];
    
    // a strong reference to the delegate object has to be held somewhere
    self.navigationControllerDelegate = [[NavigationControllerDelegate alloc] init];
    navController.delegate = self.navigationControllerDelegate;
    
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
