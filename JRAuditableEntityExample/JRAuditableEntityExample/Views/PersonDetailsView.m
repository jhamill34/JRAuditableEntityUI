//
//  PersonDetailsView.m
//  AuditableEntityExample
//
//  Created by Joshua Rasmussen on 11/4/16.
//  Copyright © 2016 Joshua Rasmussen. All rights reserved.
//

#import "PersonDetailsView.h"

@implementation PersonDetailsView

- (instancetype)init{
    if(self = [super init]){
        UILabel *nameLabel = [UILabel new];
        [nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [nameLabel setFont:[UIFont boldSystemFontOfSize:24.0f]];
        
        UILabel *ageLabel = [UILabel new];
        [ageLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:nameLabel];
        [self addSubview:ageLabel];
        
        _nameLabel = nameLabel;
        _ageLabel = ageLabel;
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    NSDictionary *views = @{ @"name" : _nameLabel, @"age" : _ageLabel };
    
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[name]-[age]-|" options:(NSLayoutFormatAlignAllBottom | NSLayoutFormatAlignAllTop) metrics:nil views:views];
    NSArray *vericalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[name]-|" options:0 metrics:nil views:views];
    
    [self addConstraints:horizontalConstraints];
    [self addConstraints:vericalConstraints];
}

@end
