//
//  DeviceDetailsView.m
//  AuditableEntityExample
//
//  Created by Joshua Rasmussen on 11/4/16.
//  Copyright © 2016 Joshua Rasmussen. All rights reserved.
//

#import "DeviceDetailsView.h"

@implementation DeviceDetailsView

- (instancetype)init{
    if(self = [super init]){
        UILabel *deviceLabel = [UILabel new];
        [deviceLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:deviceLabel];
        
        _deviceName = deviceLabel;
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    NSDictionary *views = @{ @"deviceName" : _deviceName };
    
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[deviceName]-|" options:0 metrics:nil views:views];
    NSArray *vericalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[deviceName]-|" options:0 metrics:nil views:views];
    
    [self addConstraints:horizontalConstraints];
    [self addConstraints:vericalConstraints];}

@end
