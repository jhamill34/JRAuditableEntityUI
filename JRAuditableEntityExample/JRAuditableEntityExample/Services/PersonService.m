//
//  PersonService.m
//  AuditableEntityExample
//
//  Created by Joshua Rasmussen on 11/3/16.
//  Copyright © 2016 Joshua Rasmussen. All rights reserved.
//

#import "PersonService.h"
#import "Person.h"
#import "Device.h"
#import "Pet.h"

@implementation PersonService

- (NSArray<Person *> *)getAllPeople{
    Person *p = [Person new];
    p._id = @1;
    p.name = @"Joshua23";
    p.age = @24;
    Device *d = [Device new];
    d._id = @4;
    d.model = @"iPhone";
    p.device = d;
    Pet *pet = [Pet new];
    pet._id = @1;
    pet.breed = @"Lizard";
    pet.name = @"Moose";
    Pet *pet2 = [Pet new];
    pet2._id = @2;
    pet2.breed = @"Bird";
    pet2.name = @"Bubba";
    Pet *pet3 = [Pet new];
    pet3._id = @3;
    pet3.breed = @"Dog";
    pet3.name = @"Dakota";
    p.pets = @[pet, pet2, pet3];
    
    Person *p2 = [Person new];
    p2._id = @2;
    p2.name = @"Kylie";
    p2.age = @16;
    Device *d2 = [Device new];
    d2._id = @4;
    d2.model = @"BlackBerry";
    p2.device = d2;
    Pet *pet4 = [Pet new];
    pet4._id = @4;
    pet4.breed = @"Cat";
    pet4.name = @"Joey";
    Pet *pet5 = [Pet new];
    pet5._id = @5;
    pet5.breed = @"Cat";
    pet5.name = @"Chandler";
    Pet *pet6 = [Pet new];
    pet6._id = @6;
    pet6.breed = @"Dog";
    pet6.name = @"Bailey";
    p2.pets = @[pet4, pet5, pet6];

    Person *p3 = [Person new];
    p3._id = @3;
    p3.name = @"Robert123";
    p3.age = @44;
    Device *d3 = [Device new];
    d3._id = @5;
    d3.model = @"Android";
    p3.device = d3;
    Pet *pet7 = [Pet new];
    pet7._id = @7;
    pet7.breed = @"Dog";
    pet7.name = @"Toby";
    Pet *pet8 = [Pet new];
    pet8._id = @8;
    pet8.breed = @"Dog";
    pet8.name = @"Bernard";
    p3.pets = @[pet7, pet8];
    
    return @[p, p2, p3];
}

- (Person *)fetchPersonWithId:(NSNumber *)personId{
    if([personId isEqualToNumber:@1]){
        Person *p = [Person new];
        p._id = @1;
        p.name = @"Joshua"; // <- Updated
        p.age = @24;
        Device *d = [Device new];
        d._id = @4;
        d.model = @"iPhone";
        p.device = d;
        Pet *pet = [Pet new];
        pet._id = @1;
        pet.breed = @"Dog";
        pet.name = @"Moose";
        Pet *pet2 = [Pet new];
        pet2._id = @2;
        pet2.breed = @"Cat"; // <- changed
        pet2.name = @"Bubba";
        Pet *pet3 = [Pet new];
        pet3._id = @3;
        pet3.breed = @"Dog";
        pet3.name = @"Dakota";
        p.pets = @[pet, pet2, pet3];
        
        return p;
    }else if([personId isEqualToNumber:@2]){
        Person *p2 = [Person new];
        p2._id = @2;
        p2.name = @"Kylie";
        p2.age = @16;
        Device *d2 = [Device new];
        d2._id = @4;
        d2.model = @"iPhone"; // <- updated
        p2.device = d2;
        Pet *pet4 = [Pet new];
        pet4._id = @4;
        pet4.breed = @"Cat";
        pet4.name = @"Joey";
        Pet *pet5 = [Pet new];
        pet5._id = @5;
        pet5.breed = @"Cat";
        pet5.name = @"Chandler";
        Pet *pet6 = [Pet new];
        pet6._id = @6;
        pet6.breed = @"Dog";
        pet6.name = @"Bailey";
        p2.pets = @[pet4, pet5, pet6];
        
        return p2;
    }else if([personId isEqualToNumber:@3]){
        Person *p3 = [Person new];
        p3._id = @3;
        p3.name = @"Robert123";
        p3.age = @44;
        Device *d3 = [Device new];
        d3._id = @5;
        d3.model = @"Android";
        p3.device = d3;
        Pet *pet7 = [Pet new];
        pet7._id = @7;
        pet7.breed = @"Dog";
        pet7.name = @"Tobyyy";
        Pet *pet8 = [Pet new];
        pet8._id = @9;          // <- insert and delete id of 8
        pet8.breed = @"Dog";
        pet8.name = @"Bean";
        Pet *pet9 = [Pet new];
        pet9._id = @10;         // <- insert
        pet9.name = @"Pikachu";
        pet9.breed = @"Cat";
        
        p3.pets = @[pet7, pet8, pet9];
        
        return p3;
    }
    
    return nil;
}

@end
