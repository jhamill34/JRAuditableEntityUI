//
//  JRAuditableEntityUI.h
//  JRAuditableEntityUI
//
//  Created by Joshua L Rasmussen on 11/9/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for JRAuditableEntityUI.
FOUNDATION_EXPORT double JRAuditableEntityUIVersionNumber;

//! Project version string for JRAuditableEntityUI.
FOUNDATION_EXPORT const unsigned char JRAuditableEntityUIVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <JRAuditableEntityUI/PublicHeader.h>

// Actions
#import "JRNumberBoxFixableAction.h"
#import "JROptionsFixableAction.h"
#import "JRTextBoxFixableAction.h"

// Constants
#import "JRDiffableUIConstants.h"

// Diffable
#import "JRDiffableListTableViewController.h"
#import "JRDiffableTableViewController.h"
#import "JRDiffableTableViewDelegate.h"
#import "JRDiffableTableViewCell.h"

//Fixable
#import "JRFixableListTableViewController.h"
#import "JRFixableTableViewController.h"
#import "JRFixableTableViewDelegate.h"
#import "JRFixableTableViewCell.h"
