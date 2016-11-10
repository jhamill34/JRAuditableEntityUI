//
//  OptionsFixableAction.m
//  AuditableEntityExample
//
//  Created by Joshua Rasmussen on 11/8/16.
//  Copyright © 2016 Joshua Rasmussen. All rights reserved.
//

#import "JROptionsFixableAction.h"
#import "JRDiffableUIConstants.h"

typedef void(^SelectCallback)(id value);

@implementation JROptionsFixableAction{
    SelectCallback _callback;
}

- (instancetype)initWithChoices:(NSArray *)options{
    if(self = [super init]){
        _options = options;
    }
    
    return self;
}

+ (instancetype)actionWithChoices:(NSArray *)options{
    return [[self alloc] initWithChoices:options];
}

-(void)execute:(UIViewController *)context withFixable:(id<JRFixable>)fix andSuccess:(FixableSuccess)success andFailure:(FixableFailure)failure{
    UIViewController *vc = [UIViewController new];
    vc.title = @"Please select an option";
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:vc.view.frame style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [vc.view addSubview:tableView];
    
    _callback = ^(id value){
        id previousValue = [fix value];
        [fix setNewValue:value];
        if(![fix validate]){
            [fix setNewValue:previousValue];
            failure(value, @"Invalid choice");
        }else{
            success(value);
        }
        [context dismissViewControllerAnimated:YES completion:^{}];
    };
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [context setModalPresentationStyle:UIModalPresentationPageSheet];
    [context presentViewController:nav animated:YES completion:^{}];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceTableCell"];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChoiceTableCell"];
    }
    
    cell.textLabel.text = self.options[(NSUInteger)indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_callback){
        _callback(self.options[(NSUInteger)indexPath.row]);
    }
}

@end
