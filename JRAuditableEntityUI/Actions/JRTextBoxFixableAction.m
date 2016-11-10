//
//  TextBoxFixableAction.m
//  AuditableEntityExample
//
//  Created by Joshua L Rasmussen on 11/8/16.
//  Copyright © 2016 Joshua Rasmussen. All rights reserved.
//

#import "JRTextBoxFixableAction.h"

@implementation JRTextBoxFixableAction

- (void)execute:(UIViewController *)context withFixable:(id<JRFixable>)fix andSuccess:(FixableSuccess)success andFailure:(FixableFailure)failure{
    NSString *title = [NSString stringWithFormat:@"New Value for %@", [fix field]];
    NSString *message = [NSString stringWithFormat:@"%@", [fix description]];
    UIAlertController *newValueAlert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    UIAlertAction *submitVal = [UIAlertAction actionWithTitle:@"Submit" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        // Update value here
        UITextView *textView = (UITextView *)newValueAlert.textFields[0];
        
        id previousValue = [fix value];

        [fix setNewValue:textView.text];
        
        // if its valid remove cell if not just leave the indicator
        if(![fix validate]){
            [fix setNewValue:previousValue];
            failure(textView.text, @"Invalid REGEX");
        }else{
            success(textView.text);
        }
    }];
    
    [newValueAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {}];
    [newValueAlert addAction:cancel];
    [newValueAlert addAction:submitVal];
    
    [context presentViewController:newValueAlert animated:YES completion:^{}];
}

@end
