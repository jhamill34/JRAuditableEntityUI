//
//  PersonService.h
//  AuditableEntityExample
//
//  Created by Joshua Rasmussen on 11/3/16.
//  Copyright © 2016 Joshua Rasmussen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Person;

@interface PersonService : NSObject

- (NSArray<Person *> *)getAllPeople;

- (Person *)fetchPersonWithId:(NSNumber *)personId;

@end
