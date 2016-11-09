//
//  PersonDetailViewController.m
//  AuditableEntityExample
//
//  Created by Joshua Rasmussen on 11/3/16.
//  Copyright © 2016 Joshua Rasmussen. All rights reserved.
//

#import <JRAuditableEntityUI/JRAuditableEntityUI.h>

#import "PersonDetailViewController.h"

#import "Person.h"
#import "Device.h"
#import "Pet.h"

#import "PersonDetailsView.h"
#import "DeviceDetailsView.h"
#import "PetCollectionViewCell.h"

#import "PersonService.h"

@interface PersonDetailViewController ()

@end

@implementation PersonDetailViewController

- (instancetype)initWithModel:(Person *)model{
    if(self = [super init]){
        _model = model;
    }
    
    return self;
}

+ (instancetype)controllerWithModel:(Person *)model{
    return [[self alloc] initWithModel:model];
}

- (PersonService *)personService{
    if(!_personService){
        _personService = [[PersonService alloc] init];
    }
    
    return _personService;
}

- (void)loadView{
    UIView *view = [UIView new];
    [view setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0]];
    
    PersonDetailsView *personView = [PersonDetailsView new];
    [personView setTranslatesAutoresizingMaskIntoConstraints:NO];
    DeviceDetailsView *deviceView = [DeviceDetailsView new];
    [deviceView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *petsView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) collectionViewLayout:layout];
    petsView.delegate = self;
    petsView.dataSource = self;
    [petsView setBackgroundColor:[UIColor clearColor]];
    [petsView registerClass:[PetCollectionViewCell class] forCellWithReuseIdentifier:@"PetsViewCell"];
    [petsView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [view addSubview:personView];
    [view addSubview:deviceView];
    [view addSubview:petsView];
    
    _personDetails = personView;
    _deviceDetails = deviceView;
    _petsView = petsView;
    
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // layout components
    NSDictionary *views = @{@"person" : _personDetails, @"device" : _deviceDetails, @"pets" : _petsView};
    
    NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[person]-|" options:0 metrics:nil views:views];
    
    NSArray *vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(100)-[person(50)]-[device(50)]-[pets]-|" options:(NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight) metrics:nil views:views];
 
    [self.view addConstraints:horizontal];
    [self.view addConstraints:vertical];

    UIBarButtonItem *diff = [[UIBarButtonItem alloc] initWithTitle:@"Diff" style:UIBarButtonItemStylePlain target:self action:@selector(diffableHandler:)];
    UIBarButtonItem *fix = [[UIBarButtonItem alloc] initWithTitle:@"Fix" style:UIBarButtonItemStylePlain target:self action:@selector(fixableHandler:)];
    self.navigationItem.rightBarButtonItems = @[diff, fix];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title = self.model.name;
    
    // set data from model
    self.personDetails.nameLabel.text = self.model.name;
    self.personDetails.ageLabel.text = [self.model.age description];
    self.deviceDetails.deviceName.text = self.model.device.model;
    [self.petsView reloadData];
}

#pragma mark - Collection view

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(0.9 * collectionView.frame.size.width / 2, 0.9 * collectionView.frame.size.width / 2);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.model.pets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PetsViewCell" forIndexPath:indexPath];
    
    Pet *petModel = self.model.pets[(NSUInteger)indexPath.row];
    
    cell.nameLabel.text = petModel.name;
    cell.breedLabel.text = petModel.breed;
        
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(8, 8, 8, 8);
}

#pragma mark - Navigation Button Handlers

- (void)fixableHandler:(UIBarButtonItem *)button{
    NSArray<id<Fixable>> *fixes = [self.model verify];
    if(fixes.count > 0){
        UIAlertController *invalidFound = [UIAlertController alertControllerWithTitle:@"Warning!" message:@"There were invalid properties found on this model" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ignore = [UIAlertAction actionWithTitle:@"Ignore" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
        UIAlertAction *fix = [UIAlertAction actionWithTitle:@"Fix" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *_Nonnull action) {
            JRFixableTableViewController *fixController = [JRFixableTableViewController controllerWithEntity:self.model andFixes:fixes];
            fixController.title = [NSString stringWithFormat:@"%@ Fix", [self.model class]];
            [self.navigationController pushViewController:fixController animated:YES];
        }];
        
        [invalidFound addAction:ignore];
        [invalidFound addAction:fix];
        
        [self presentViewController:invalidFound animated:YES completion:^{}];
    }else{
        UIAlertController *nothingToFixAlert = [UIAlertController alertControllerWithTitle:@"Success!" message:@"There is nothing to fix here" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *awesome = [UIAlertAction actionWithTitle:@"Awesome" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        
        [nothingToFixAlert addAction:awesome];
        
        [self presentViewController:nothingToFixAlert animated:YES completion:^{}];
    }
}

- (void)diffableHandler:(UIBarButtonItem *)button{
    Person *updatedPerson = [self.personService fetchPersonWithId:self.model._id];
    
    NSError *error;
    DiffRunner *dr = [DiffRunner new];
    NSArray<id<Patch>> *patches = [dr computeDiff:self.model against:updatedPerson withError:&error];
    if(patches.count > 0){
        UIAlertController *invalidFound = [UIAlertController alertControllerWithTitle:@"Notice!" message:@"There are pending changes for this model" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ignore = [UIAlertAction actionWithTitle:@"Ignore" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
        UIAlertAction *fix = [UIAlertAction actionWithTitle:@"Merge" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *_Nonnull action) {
            JRDiffableTableViewController *diffableController = [JRDiffableTableViewController controllerWithPatches:patches andEntity:self.model];
            diffableController.title = [NSString stringWithFormat:@"%@ Patch", [self.model class]];
            [self.navigationController pushViewController:diffableController animated:YES];
        }];
        
        [invalidFound addAction:ignore];
        [invalidFound addAction:fix];
        
        [self presentViewController:invalidFound animated:YES completion:^{}];
    }else{
        UIAlertController *nothingToChangeAlert = [UIAlertController alertControllerWithTitle:@"Success!" message:@"There are no pending changes" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *awesome = [UIAlertAction actionWithTitle:@"Awesome" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        
        [nothingToChangeAlert addAction:awesome];
        
        [self presentViewController:nothingToChangeAlert animated:YES completion:^{}];
    }
}

@end
