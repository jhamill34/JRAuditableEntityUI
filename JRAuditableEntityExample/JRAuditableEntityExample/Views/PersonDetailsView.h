//
//  PersonDetailsView.h
//  AuditableEntityExample
//
//  Created by Joshua Rasmussen on 11/4/16.
//  Copyright © 2016 Joshua Rasmussen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonDetailsView : UIView

@property (readonly, nonatomic, weak) UILabel *nameLabel;

@property (readonly, nonatomic, weak) UILabel *ageLabel;

@end
