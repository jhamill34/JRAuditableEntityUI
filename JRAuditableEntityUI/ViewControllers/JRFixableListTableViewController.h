//
//  FixablesCollectionTableViewController.h
//  AuditableEntityExample
//
//  Created by Joshua L Rasmussen on 11/4/16.
//  Copyright © 2016 Joshua Rasmussen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JRAuditableEntity/JRAuditableEntity.h>
#import "JRFixableTableViewDelegate.h"

@protocol VerifiableEntityProtocol;

@interface JRFixableListTableViewController : UIViewController<JRFixableTableViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (readonly, nonatomic, strong) FixableListItem *listFix;

- (instancetype)initWithFix:(FixableListItem *)fix;

+ (instancetype)controllerWithFix:(FixableListItem *)fix;

@property (nonatomic, weak) id<JRFixableTableViewDelegate> fixableDelegate;

@property (nonatomic, weak) UITableView *tableView;

@end
