//
//  PersonDetailViewController.h
//  AuditableEntityExample
//
//  Created by Joshua Rasmussen on 11/3/16.
//  Copyright © 2016 Joshua Rasmussen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Person;
@class PersonDetailsView;
@class DeviceDetailsView;
@class PersonService;

@interface PersonDetailViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

- (instancetype)initWithModel:(Person *)model;

+ (instancetype)controllerWithModel:(Person *)model;

@property (nonatomic, strong) PersonService *personService;

#pragma mark - Model

@property (readonly, nonatomic, strong) Person *model;

#pragma mark - Components

@property (readonly, nonatomic, weak) PersonDetailsView *personDetails;

@property (readonly, nonatomic, weak) DeviceDetailsView *deviceDetails;

@property (readonly, nonatomic, weak) UICollectionView *petsView;

@end
