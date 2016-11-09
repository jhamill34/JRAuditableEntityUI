//
//  Pet.m
//  AuditableEntityExample
//
//  Created by Joshua Rasmussen on 11/3/16.
//  Copyright © 2016 Joshua Rasmussen. All rights reserved.
//

#import "Pet.h"

@implementation Pet

- (NSArray<id<Fixable>> *)verify{
    NSMutableArray *fixables = [NSMutableArray array];
    
    FixableText *breedFix = [FixableText fixableWithRegex:@"^(Cat|Dog)$" forParent:self andField:@"breed"];
    [breedFix setMessage:@"can only be either Cat or Dog"];
    [breedFix setRelatedAction:[JROptionsFixableAction actionWithChoices:@[@"Cat", @"Dog"]]];
    if(![breedFix validate]){
        [fixables addObject:breedFix];
    }
    
    FixableText *nameFix = [FixableText fixableWithRegex:ALPHABET_REGEX forParent:self andField:@"name"];
    [nameFix setMessage:@"can only have alphabetical characters"];
    [nameFix setRelatedAction:[JRTextBoxFixableAction new]];
    if(![nameFix validate]){
        [fixables addObject:nameFix];
    }
    
    return [NSArray arrayWithArray:fixables];
}

- (NSArray<NSString *> *)diffableProperties{
    return @[@"breed", @"name"];
}

- (BOOL)isEqual:(Pet *)object{
    if(self == object){
        return YES;
    }else if(object == nil || [self class] != [object class]){
        return NO;
    }else{
        return [self._id isEqualToNumber:object._id];
    }
}

- (NSString *)description{
    return [NSString stringWithFormat:@"%@ - %@", self.name, self.breed];
}

@end
