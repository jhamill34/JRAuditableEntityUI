//
//  FixablesTableViewController.h
//  AuditableEntityExample
//
//  Created by Joshua L Rasmussen on 11/4/16.
//  Copyright © 2016 Joshua Rasmussen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JRAuditableEntity/JRAuditableEntity.h>
#import "JRFixableTableViewDelegate.h"

@protocol JRVerifiableEntityProtocol;

@interface JRFixableTableViewController : UIViewController<JRFixableTableViewDelegate, UITableViewDataSource, UITableViewDelegate>

- (instancetype)initWithEntity:(id<JRVerifiableEntityProtocol>)entity andFixes:(NSArray<id<JRFixable>> *)fixes;

+ (instancetype)controllerWithEntity:(id<JRVerifiableEntityProtocol>)entity andFixes:(NSArray<id<JRFixable>> *)fixes;

#pragma mark - Data

@property (readonly, nonatomic, strong) id<JRVerifiableEntityProtocol> entity;

@property (readonly, nonatomic, strong) NSArray<id<JRFixable>> *fixes;

@property (nonatomic, weak) id<JRFixableTableViewDelegate> fixableDelegate;

@property (nonatomic, weak) UITableView *tableView;

@end
