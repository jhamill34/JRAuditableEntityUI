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

- (instancetype)initWithPatches:(NSArray<id<JRPatch>> *)patches andEntity:(id<JRDiffableEntityProtocol>)entity;

+ (instancetype)controllerWithPatches:(NSArray<id<JRPatch>> *)patches andEntity:(id<JRDiffableEntityProtocol>)entity;

@property (readonly, nonatomic, strong) NSArray<id<JRPatch>> *patches;
@property (readonly, nonatomic, strong) id<JRDiffableEntityProtocol> entity;

@property (nonatomic, weak) id<JRDiffableTableViewDelegate> diffableDelegate;

@property (nonatomic, weak) UITableView *tableView;

@end
