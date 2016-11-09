//
//  OptionsFixableAction.h
//  AuditableEntityExample
//
//  Created by Joshua Rasmussen on 11/8/16.
//  Copyright © 2016 Joshua Rasmussen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JRAuditableEntity/JRAuditableEntity.h>

@interface JROptionsFixableAction : NSObject<FixableAction, UITableViewDelegate, UITableViewDataSource>

@property (readonly, nonatomic, strong) NSArray *options;

- (instancetype)initWithChoices:(NSArray *)options;

+ (instancetype)actionWithChoices:(NSArray *)options;

@end
