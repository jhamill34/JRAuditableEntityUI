//
//  DiffableListTableViewController.h
//  AuditableEntityExample
//
//  Created by Joshua L Rasmussen on 11/7/16.
//  Copyright © 2016 Joshua Rasmussen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JRAuditableEntity/JRAuditableEntity.h>
#import "JRDiffableTableViewDelegate.h"

@interface JRDiffableListTableViewController : UIViewController<JRDiffableTableViewDelegate, DiffRunnerDelegate, UITableViewDelegate, UITableViewDataSource>

- (instancetype)initWithListPatch:(ListEntityPatch *)listPatch;

+ (instancetype)controllerWithPatch:(ListEntityPatch *)listPatch;

@property (readonly, nonatomic, strong) ListEntityPatch *listPatch;

@property (nonatomic, weak) id<JRDiffableTableViewDelegate> diffableDelegate;

@property (nonatomic, weak) UITableView *tableView;

@end
