//
//  DiffableTableViewCell.h
//  AuditableEntityExample
//
//  Created by Joshua Rasmussen on 11/4/16.
//  Copyright © 2016 Joshua Rasmussen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JRDiffableTableViewCell : UITableViewCell

@property (readonly, nonatomic, weak) UILabel *fieldLabel;
@property (readonly, nonatomic, weak) UILabel *fromLabel;
@property (readonly, nonatomic, weak) UILabel *toLabel;

@end
