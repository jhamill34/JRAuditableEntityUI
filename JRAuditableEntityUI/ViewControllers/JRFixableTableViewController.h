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

@protocol VerifiableEntityProtocol;

@interface JRFixableTableViewController : UIViewController<JRFixableTableViewDelegate, UITableViewDataSource, UITableViewDelegate>

- (instancetype)initWithEntity:(id<VerifiableEntityProtocol>)entity andFixes:(NSArray<id<Fixable>> *)fixes;

+ (instancetype)controllerWithEntity:(id<VerifiableEntityProtocol>)entity andFixes:(NSArray<id<Fixable>> *)fixes;

#pragma mark - Data

@property (readonly, nonatomic, strong) id<VerifiableEntityProtocol> entity;

@property (readonly, nonatomic, strong) NSArray<id<Fixable>> *fixes;

@property (nonatomic, weak) id<JRFixableTableViewDelegate> fixableDelegate;

@property (nonatomic, weak) UITableView *tableView;

@end
