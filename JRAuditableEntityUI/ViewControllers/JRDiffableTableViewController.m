//
//  DiffablesTableViewController.m
//  AuditableEntityExample
//
//  Created by Joshua Rasmussen on 11/4/16.
//  Copyright © 2016 Joshua Rasmussen. All rights reserved.
//

#import "JRDiffableUIConstants.h"
#import "JRDiffableTableViewController.h"
#import "JRDiffableTableViewCell.h"
#import "JRDiffableListTableViewController.h"

@interface JRDiffableTableViewController ()

@end

@implementation JRDiffableTableViewController{
    NSIndexPath *_selectedIndexPath;
    
    UILabel *_emptyView;
}

- (instancetype)initWithPatches:(NSArray<id<Patch>> *)patches andEntity:(id<DiffableEntityProtocol>)entity{
    if(self = [super init]){
        _patches = patches;
        _entity = entity;
    }
    
    return self;
}

+ (instancetype)controllerWithPatches:(NSArray<id<Patch>> *)patches andEntity:(id<DiffableEntityProtocol>)entity{
    return [[self alloc] initWithPatches:patches andEntity:entity];
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
    _emptyView.text = @"No more diferences found...";
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
    return self.patches.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JRDiffableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatchTableCell"];
    
    if(!cell){
        cell = [[JRDiffableTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PatchTableCell"];
    }
    
    
    id<Patch> patch = self.patches[(NSUInteger)indexPath.row];
    
    cell.fieldLabel.text = [patch field];
    
    if([patch isKindOfClass:[CompositeEntityPatch class]]){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.fromLabel.hidden = YES;
        cell.toLabel.hidden = YES;
    }else if([patch isKindOfClass:[ListEntityPatch class]]){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.fromLabel.hidden = YES;
        cell.toLabel.hidden = YES;
    }else{
        EntityPatch *p = (EntityPatch *)patch;
        NSMutableAttributedString *fromString = [[NSMutableAttributedString alloc] initWithString:[[self.entity valueForKey:[p field]] description]];
        [fromString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [fromString length])];
        [cell.fromLabel setAttributedText:fromString];
        cell.toLabel.text = [[p to] description];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id<Patch> patch = self.patches[(NSUInteger)indexPath.row];
    
    if([patch isKindOfClass:[CompositeEntityPatch class]]){
        _selectedIndexPath = indexPath;
        
        CompositeEntityPatch *compPatch = (CompositeEntityPatch *)patch;
        id childEntity = [self.entity valueForKey:[compPatch field]];
        
        JRDiffableTableViewController *subDiff = [JRDiffableTableViewController controllerWithPatches:compPatch.patches andEntity:childEntity];
        subDiff.diffableDelegate = self;
        subDiff.title = [NSString stringWithFormat:@"%@ Patch", [childEntity class]];
        [self.navigationController pushViewController:subDiff animated:YES];
    }else if([patch isKindOfClass:[ListEntityPatch class]]){
        _selectedIndexPath = indexPath;
        
        JRDiffableListTableViewController *listDiff = [JRDiffableListTableViewController controllerWithPatch:patch];
        
        listDiff.diffableDelegate = self;
        listDiff.title = [NSString stringWithFormat:@"%@ List Diff", [patch field]];
        [self.navigationController pushViewController:listDiff animated:YES];
    }else{
        NSMutableArray *mutablePatches = [NSMutableArray arrayWithArray:_patches];
        NSString *message = [NSString stringWithFormat:@"Accept or Decline?"];
        UIAlertController *applyPatch = [UIAlertController alertControllerWithTitle:@"Apply" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *accept = [UIAlertAction actionWithTitle:@"Accept" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action){
            [patch apply:self.entity withError:NULL];
            
            [mutablePatches removeObjectAtIndex:indexPath.row];
            _patches = [NSArray arrayWithArray:mutablePatches];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
            
            if(_patches.count == 0){
                [_emptyView setHidden:NO];
                if(self.diffableDelegate){
                    [self.diffableDelegate appliedPatch];
                }
            }
        }];
        
        UIAlertAction *decline = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
        
        [applyPatch addAction:decline];
        [applyPatch addAction:accept];
        
        [self presentViewController:applyPatch animated:YES completion:^{}];
    }
}

#pragma mark - Diffable Delegate

- (void)appliedPatch{
    NSMutableArray *mutablePatches = [NSMutableArray arrayWithArray:_patches];
    
    [mutablePatches removeObjectAtIndex:_selectedIndexPath.row];
    _patches = [NSArray arrayWithArray:mutablePatches];
    [self.tableView deleteRowsAtIndexPaths:@[_selectedIndexPath] withRowAnimation:UITableViewRowAnimationTop];

    if(_patches.count == 0){
        [_emptyView setHidden:NO];
        if(self.diffableDelegate){
            [self.diffableDelegate appliedPatch];
        }
    }
}

@end
