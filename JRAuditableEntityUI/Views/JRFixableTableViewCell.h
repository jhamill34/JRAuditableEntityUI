//
//  FixableTableViewCell.h
//  AuditableEntityExample
//
//  Created by Joshua L Rasmussen on 11/4/16.
//  Copyright © 2016 Joshua Rasmussen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FixableTableViewCellIndication){
    FixableIndicationInvalid,
    FixableIndicationValid,
    FixableIndicationNone
};

@interface JRFixableTableViewCell : UITableViewCell

@property (readonly, nonatomic, weak) UILabel *fieldLabel;
@property (readonly, nonatomic, weak) UILabel *currentValueLabel;
@property (readonly, nonatomic, weak) UILabel *descriptionLabel;

@property BOOL isComposite;

- (void)setIndicator:(FixableTableViewCellIndication)indication;

@end
