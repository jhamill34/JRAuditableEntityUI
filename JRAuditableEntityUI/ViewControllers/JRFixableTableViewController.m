//
//  FixablesTableViewController.m
//  AuditableEntityExample
//
//  Created by Joshua L Rasmussen on 11/4/16.
//  Copyright © 2016 Joshua Rasmussen. All rights reserved.
//

#import "JRDiffableUIConstants.h"
#import "JRFixableTableViewController.h"
#import "JRFixableTableViewCell.h"
#import "JRFixableListTableViewController.h"
#import "JRFixableTableViewDelegate.h"

@interface JRFixableTableViewController ()

@end

@implementation JRFixableTableViewController{
    id<Fixable> _selectedFix;
    NSIndexPath *_selectedIndexPath;
    UILabel *_emptyView;
}

- (instancetype)initWithEntity:(id<VerifiableEntityProtocol>)entity andFixes:(NSArray<id<Fixable>> *)fixes{
    if(self = [super init]){
        _entity = entity;
        _fixes = fixes;
    }
    
    return self;
}

+ (instancetype)controllerWithEntity:(id<VerifiableEntityProtocol>)entity andFixes:(NSArray<id<Fixable>> *)fixes{
    return [[self alloc] initWithEntity:entity andFixes:fixes];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fixes.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JRFixableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FixableCell"];
    if(!cell){
        cell = [[JRFixableTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FixableCell"];
    }
    
    id<Fixable> model = self.fixes[(NSUInteger)indexPath.row];

    cell.fieldLabel.text = [model field];
    
    if([model isKindOfClass:[FixableListItem class]]){
        FixableListItem *listModel = (FixableListItem *)model;
        cell.currentValueLabel.text = [NSString stringWithFormat:@"%lu invalid", listModel.invalidCount];
        cell.descriptionLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if([model isKindOfClass:[CompositeFixableEntity class]]){
        id val = [model value];
        cell.currentValueLabel.text = [NSString stringWithFormat:@"invalid %@", [val class]];
        cell.descriptionLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.currentValueLabel.text = [[model value] description];
        cell.descriptionLabel.text = [model description];
    }
    
    [cell setIndicator:FixableIndicationInvalid];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id<Fixable> model = self.fixes[(NSUInteger)indexPath.row];
    JRFixableTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
    if([model isKindOfClass:[FixableListItem class]]){
        // Store the attempted fix
        _selectedFix = model;
        _selectedIndexPath = indexPath;
        
        // Push FixablesCollectionTableViewController on
        JRFixableListTableViewController *collectionViewCtl = [JRFixableListTableViewController controllerWithFix:model];
        collectionViewCtl.fixableDelegate = self;
        collectionViewCtl.title = [NSString stringWithFormat:@"%@ fixes", [model field]];
        [self.navigationController pushViewController:collectionViewCtl animated:YES];
    }else if([model isKindOfClass:[CompositeFixableEntity class]]){
        // Push FixablesTableViewController on
        id<VerifiableEntityProtocol> val = [model value];
        NSArray<id<Fixable>> *childFixes = [val verify];
        
        // Store the attempted fix
        _selectedFix = model;
        _selectedIndexPath = indexPath;
        
        // Display
        JRFixableTableViewController *childFixController = [JRFixableTableViewController controllerWithEntity:val andFixes:childFixes];
        childFixController.fixableDelegate = self;
        childFixController.title = [NSString stringWithFormat:@"%@ fix", [val class]];
        [self.navigationController pushViewController:childFixController animated:YES];
    }else{
        [model fix:self withSuccess:^(id value) {
            NSMutableArray *mutableFixes = [NSMutableArray arrayWithArray:self.fixes];
            [mutableFixes removeObjectAtIndex:indexPath.row];
            _fixes = [NSArray arrayWithArray:mutableFixes];
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            if(self.fixes.count == 0){
                [_emptyView setHidden:NO];
                if(self.fixableDelegate){
                    [self.fixableDelegate appliedFix];
                }
            }
        } andFailure:^(id value, NSString *reason) {
            [cell setIndicator:FixableIndicationInvalid];
        }];
    }
}

#pragma mark - FixablesTableViewDelegate

- (void)appliedFix{
    BOOL shouldRemoveFromList = YES;
    
    if([_selectedFix isKindOfClass:[FixableListItem class]]){
        FixableListItem *listFix = (FixableListItem *)_selectedFix;
        JRFixableTableViewCell *cell = [self.tableView cellForRowAtIndexPath:_selectedIndexPath];
        
        NSUInteger count = listFix.invalidCount;
        cell.currentValueLabel.text = [NSString stringWithFormat:@"%lu invalid", count];
        shouldRemoveFromList = (count == 0);
    }
    
    if(shouldRemoveFromList){
        NSMutableArray *mutableFixes = [NSMutableArray arrayWithArray:self.fixes];
        [mutableFixes removeObjectAtIndex:_selectedIndexPath.row];
        _fixes = [NSArray arrayWithArray:mutableFixes];
        
        [self.tableView deleteRowsAtIndexPaths:@[_selectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        if(self.fixes.count == 0){
            [_emptyView setHidden:NO];
            if(self.fixableDelegate){
                [self.fixableDelegate appliedFix];
            }
        }
    }
}

@end
