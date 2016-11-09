//
//  ViewController.m
//  AuditableEntityExample
//
//  Created by Joshua Rasmussen on 11/3/16.
//  Copyright © 2016 Joshua Rasmussen. All rights reserved.
//

#import "PersonViewController.h"
#import "PersonService.h"
#import "Person.h"
#import "PersonTableViewCell.h"
#import "PersonDetailViewController.h"

@interface PersonViewController ()

@end

@implementation PersonViewController

- (PersonService *)personService{
    if(!_personService){
        _personService = [[PersonService alloc] init];
    }
    
    return _personService;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.people = [self.personService getAllPeople];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.people.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ViewControllerCell"];
    
    if(!cell){
        cell = [[PersonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ViewControllerCell"];
    }
    
    Person *model = self.people[(NSUInteger)indexPath.row];
    
    cell.nameLabel.text = model.name;
    cell.ageLabel.text = [model.age stringValue];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Person *model = self.people[(NSUInteger)indexPath.row];
    PersonDetailViewController *personDetail = [PersonDetailViewController controllerWithModel:model];
    personDetail.title = model.name;
    
    [self.navigationController pushViewController:personDetail animated:YES];
}

@end
