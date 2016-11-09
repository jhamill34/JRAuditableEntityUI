//
//  Device.m
//  AuditableEntityExample
//
//  Created by Joshua Rasmussen on 11/3/16.
//  Copyright © 2016 Joshua Rasmussen. All rights reserved.
//

#import "Device.h"

@implementation Device

- (NSArray<id<Fixable>> *)verify{
    NSMutableArray *fixables = [NSMutableArray array];
    
    FixableText *modelFix = [FixableText fixableWithRegex:@"^(Android|iPhone)$" forParent:self andField:@"model"];
    [modelFix setMessage:@"can only be either Android or iPhone"];
    [modelFix setRelatedAction:[JROptionsFixableAction actionWithChoices:@[@"Android", @"iPhone"]]];
    if(![modelFix validate]){
        [fixables addObject:modelFix];
    }
    
    return [NSArray arrayWithArray:fixables];
}

- (NSArray<NSString *> *)diffableProperties{
    return @[@"model"];
}

- (BOOL)isEqual:(Device *)object{
    if(self == object){
        return YES;
    }else if(object == nil || [self class] != [object class]){
        return NO;
    }else{
        return [self._id isEqualToNumber:object._id];
    }
}

- (NSString *)description{
    return self.model;
}

@end
