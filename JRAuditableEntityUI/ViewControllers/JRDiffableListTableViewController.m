//
//  DiffableListTableViewController.m
//  AuditableEntityExample
//
//  Created by Joshua L Rasmussen on 11/7/16.
//  Copyright © 2016 Joshua Rasmussen. All rights reserved.
//

#import "JRDiffableUIConstants.h"
#import "JRDiffableListTableViewController.h"
#import "JRDiffableTableViewController.h"

@interface JRDiffableListTableViewController ()

@end

@implementation JRDiffableListTableViewController{
    NSIndexPath *_selectedIndexPath;
    NSMutableSet *_selectedCommands;
    UILabel *_emptyView;
}

- (instancetype)initWithListPatch:(JRListEntityPatch *)listPatch{
    if(self = [super init]){
        _listPatch = listPatch;
        listPatch.delegate = self;
    }
    
    return self;
}

+ (instancetype)controllerWithPatch:(JRListEntityPatch *)listPatch{
    return [[self alloc] initWithListPatch:listPatch];
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
    
    self.tableView.allowsMultipleSelection = YES;
    
    UIBarButtonItem *acceptDiff = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(accept:)];
    self.navigationItem.rightBarButtonItems = @[acceptDiff];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listPatch.listCommands.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiffableListItemCell"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DiffableListItemCell"];
    }
    
    id<JRCommand> cmd = self.listPatch.listCommands[(NSUInteger)indexPath.row];
    
    if([cmd isKindOfClass:[JRInsertListCommand class]]){
        cell.textLabel.text = [[cmd value] description];
        cell.backgroundColor = GREEN_COLOR;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else if([cmd isKindOfClass:[JRDeleteListCommand class]]){
        NSMutableAttributedString *fromString = [[NSMutableAttributedString alloc] initWithString:[[cmd value] description]];
        [fromString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [fromString length])];
        [cell.textLabel setAttributedText:fromString];
        
        cell.backgroundColor = RED_COLOR;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else if([cmd isKindOfClass:[JRUpdateListCommand class]]){
        NSArray *entities = [self.listPatch.parent valueForKey:self.listPatch.field];
        id val = entities[[cmd index]];
        
        cell.textLabel.text = [val description];
        cell.backgroundColor = BLUE_COLOR;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    id<JRCommand> cmd = self.listPatch.listCommands[(NSUInteger)indexPath.row];
    if([cmd isKindOfClass:[JRInsertListCommand class]] || [cmd isKindOfClass:[JRDeleteListCommand class]]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        return indexPath;
    }else{
        // Push on a diffable table view controller
        _selectedIndexPath = indexPath;
        NSArray<id<JRPatch>> *patches = [cmd value];
        NSArray *entities = [self.listPatch.parent valueForKey:self.listPatch.field];
        id entity  = entities[[cmd index]];
        
        JRDiffableTableViewController *childDiff = [JRDiffableTableViewController controllerWithPatches:patches andEntity:entity];
        childDiff.diffableDelegate = self;
        childDiff.title = [NSString stringWithFormat:@"%@ Diff", [entity class]];
        [self.navigationController pushViewController:childDiff animated:YES];
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellSelectionStyleNone;
}

#pragma mark - Bar Buttons

- (void)accept:(UIBarButtonItem *)button{
    _selectedCommands = [NSMutableSet set];
    id<JRCommand> cmd;
    for(NSIndexPath *i in [self.tableView indexPathsForSelectedRows]){
        cmd = self.listPatch.listCommands[(NSUInteger)i.row];
        [_selectedCommands addObject:cmd];
    }
    
    if(_selectedCommands.count == 0){
        UIAlertController *emptyAction = [UIAlertController alertControllerWithTitle:@"Notice" message:@"You haven't selected any actions to perform" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action){}];
        
        [emptyAction addAction:okAction];
        [self presentViewController:emptyAction animated:YES completion:^{}];
    }else{
        [self.listPatch apply:self.listPatch.parent withError:NULL];
        
        [self.listPatch removeCommandsFromList:_selectedCommands];
        
        [self.tableView deleteRowsAtIndexPaths:[self.tableView indexPathsForSelectedRows] withRowAnimation:UITableViewRowAnimationFade];
        
        if(self.listPatch.listCommands.count == 0){
            [_emptyView setHidden:NO];
            if(self.diffableDelegate){
                [self.diffableDelegate appliedPatch];
            }
        }
    }
}

- (void)appliedPatch{
    [self.listPatch removeCommandAtIndex:_selectedIndexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[_selectedIndexPath] withRowAnimation:UITableViewRowAnimationTop];
    
    if(self.listPatch.listCommands.count == 0){
        [_emptyView setHidden:NO];
        if(self.diffableDelegate){
            [self.diffableDelegate appliedPatch];
        }
    }
}

- (BOOL)shouldApplyPatch:(id<JRPatch>)p on:(id<JRDiffableEntityProtocol>)entity{
    return YES;
}

- (BOOL)shouldApplyListCommand:(id<JRCommand>)c on:(NSArray *)list{
    return [_selectedCommands containsObject:c];
}

@end
