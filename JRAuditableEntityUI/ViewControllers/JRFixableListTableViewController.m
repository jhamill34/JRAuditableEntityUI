//
//  FixablesCollectionTableViewController.m
//  AuditableEntityExample
//
//  Created by Joshua L Rasmussen on 11/4/16.
//  Copyright © 2016 Joshua Rasmussen. All rights reserved.
//

#import "JRDiffableUIConstants.h"
#import "JRFixableListTableViewController.h"
#import "JRFixableTableViewCell.h"
#import "JRFixableTableViewController.h"

@interface JRFixableListTableViewController ()

@end

@implementation JRFixableListTableViewController{
    NSIndexPath *_selectedIndexPath;
    NSUInteger _totalInvalid;
    NSMutableArray *_entities;
    UILabel *_emptyView;
}

- (instancetype)initWithFix:(JRFixableListItem *)fix{
    if(self = [super init]){
        _listFix = fix;
        _entities = [fix value];
    }
    
    return self;
    
}

+ (instancetype)controllerWithFix:(JRFixableListItem *)fix{
    return [[self alloc] initWithFix:fix];
}

- (void)loadView{
    UIView *view = [UIView new];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:view.frame style:UITableViewStylePlain];
    [tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    tableView.dataSource = self;
    tableView.delegate = self;
    
    [view addSubview:tableView];
    
    _tableView = tableView;
    
    _emptyView = [UILabel new];
    [_emptyView setTranslatesAutoresizingMaskIntoConstraints:NO];
    _emptyView.text = @"No more invalid properties found...";
    [_emptyView setBackgroundColor:DARK_GREY];
    [_emptyView setTextAlignment:NSTextAlignmentCenter];
    [_emptyView setTextColor:LIGHT_GREY];
    [_emptyView setHidden:YES];
    [view addSubview:_emptyView];
    
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *views = @{ @"table" : _tableView, @"empty" : _emptyView};
    NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[table]|" options:0 metrics:nil views:views];
    NSArray *vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[table]|" options:0 metrics:nil views:views];
    
    NSArray *horizontalE = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[empty]|" options:0 metrics:nil views:views];
    NSArray *verticalE = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[empty]|" options:0 metrics:nil views:views];
    
    [self.view addConstraints:horizontal];
    [self.view addConstraints:vertical];
    
    [self.view addConstraints:horizontalE];
    [self.view addConstraints:verticalE];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _entities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JRFixableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FixableCollectionViewCell"];
    
    if(!cell){
        cell = [[JRFixableTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FixableCollectionViewCell"];
    }
    
    id<JRVerifiableEntityProtocol> val = _entities[(NSUInteger)indexPath.row];
    
    // Verifiable Entities need a short description to display
    cell.fieldLabel.text = [NSString stringWithFormat:@"%@", [val class]];
    cell.currentValueLabel.text = [val description];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [cell setIndicator:FixableIndicationInvalid];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // Push FixablesTableViewController on
    id<JRVerifiableEntityProtocol> val = _entities[(NSUInteger)indexPath.row];
    NSArray<id<JRFixable>> *childFixes = [val verify];
        
    _selectedIndexPath = indexPath;
        
    JRFixableTableViewController *childFixController = [JRFixableTableViewController controllerWithEntity:val andFixes:childFixes];
    childFixController.fixableDelegate = self;
    childFixController.title = [NSString stringWithFormat:@"%@ Fix", [val class]];
    [self.navigationController pushViewController:childFixController animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        // Ask to verify removal rather than fix
        UIAlertController *confirmRemoval = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Are you sure you want to remove instead of fixing the entity" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action){
            id<JRVerifiableEntityProtocol> entity = _entities[(NSUInteger)indexPath.row];
            [self.listFix removeObjectFromParentsCollection:entity];
            [_entities removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            if(_entities.count == 0){
                [_emptyView setHidden:NO];
            }
            
            if(self.fixableDelegate){
                [self.fixableDelegate appliedFix];
            }
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action){}];
        
        [confirmRemoval addAction:cancel];
        [confirmRemoval addAction:confirm];
        
        [self presentViewController:confirmRemoval animated:YES completion:^{}];
    }
}

#pragma mark - Fixable Delegate

- (void)appliedFix{
    [_entities removeObjectAtIndex:_selectedIndexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[_selectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    if(_entities.count == 0){
        [_emptyView setHidden:NO];
    }
    
    if(self.fixableDelegate){
        [self.fixableDelegate appliedFix];
    }
}

@end
