//
//  DiffablesTableViewController.h
//  AuditableEntityExample
//
//  Created by Joshua Rasmussen on 11/4/16.
//  Copyright © 2016 Joshua Rasmussen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JRAuditableEntity/JRAuditableEntity.h>
#import "JRDiffableTableViewDelegate.h"

@interface JRDiffableTableViewController : UIViewController<JRDiffableTableViewDelegate, UITableViewDelegate, UITableViewDataSource>

- (instancetype)initWithPatches:(NSArray<id<Patch>> *)patches andEntity:(id<DiffableEntityProtocol>)entity;

+ (instancetype)controllerWithPatches:(NSArray<id<Patch>> *)patches andEntity:(id<DiffableEntityProtocol>)entity;

@property (readonly, nonatomic, strong) NSArray<id<Patch>> *patches;
@property (readonly, nonatomic, strong) id<DiffableEntityProtocol> entity;

@property (nonatomic, weak) id<JRDiffableTableViewDelegate> diffableDelegate;

@property (nonatomic, weak) UITableView *tableView;

@end
