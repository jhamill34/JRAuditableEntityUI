//
//  AppDelegate.m
//  AuditableEntityExample
//
//  Created by Joshua Rasmussen on 11/3/16.
//  Copyright © 2016 Joshua Rasmussen. All rights reserved.
//

#import "AppDelegate.h"
#import "PersonViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [UIWindow new];
    
    PersonViewController *vc = [PersonViewController new];
    vc.title = @"People";
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self.window setRootViewController:nav];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
