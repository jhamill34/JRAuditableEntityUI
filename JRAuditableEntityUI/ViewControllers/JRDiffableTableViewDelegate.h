//
//  DiffablesTableViewDelegate.h
//  AuditableEntityExample
//
//  Created by Joshua L Rasmussen on 11/7/16.
//  Copyright © 2016 Joshua Rasmussen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JRDiffableTableViewDelegate <NSObject>

- (void)appliedPatch;

@end
