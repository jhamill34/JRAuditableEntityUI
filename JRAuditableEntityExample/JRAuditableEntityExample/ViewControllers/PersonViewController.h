//
//  ViewController.h
//  AuditableEntityExample
//
//  Created by Joshua Rasmussen on 11/3/16.
//  Copyright © 2016 Joshua Rasmussen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Person;
@class PersonService;

@interface PersonViewController : UITableViewController

@property (nonatomic, strong) PersonService *personService;

@property (nonatomic, strong) NSArray<Person *> *people;

@end

