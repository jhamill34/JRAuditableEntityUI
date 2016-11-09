//
//  FixableTableViewCell.m
//  AuditableEntityExample
//
//  Created by Joshua L Rasmussen on 11/4/16.
//  Copyright © 2016 Joshua Rasmussen. All rights reserved.
//

#import "JRDiffableUIConstants.h"
#import "JRFixableTableViewCell.h"

@implementation JRFixableTableViewCell{
    UIView *_indicator;
    UIView *_container;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        _container = [UIView new];
        [_container setTranslatesAutoresizingMaskIntoConstraints:NO];
        _indicator = [UIView new];
        [_indicator setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        
        UILabel *valueLabel = [UILabel new];
        [valueLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        UILabel *fieldLabel = [UILabel new];
        [fieldLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [fieldLabel setFont:[UIFont boldSystemFontOfSize:24.0f]];
        
        UILabel *descriptionLabel = [UILabel new];
        [descriptionLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [descriptionLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [descriptionLabel setTextColor:LIGHT_GREY];
        [descriptionLabel setNumberOfLines:3];
        
        [_container addSubview:fieldLabel];
        [_container addSubview:valueLabel];
        [_container addSubview:descriptionLabel];

        [self addSubview:_indicator];
        [self addSubview:_container];
        
        _fieldLabel = fieldLabel;
        _currentValueLabel = valueLabel;
        _descriptionLabel = descriptionLabel;
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    NSDictionary *containerViews = @{@"field" : _fieldLabel, @"value" : _currentValueLabel, @"description" : _descriptionLabel};

    NSArray *horizontalA = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[field(>=100)]-[description]-|" options:NSLayoutFormatAlignAllTop metrics:nil views:containerViews];
    NSArray *horizontalB = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[value(>=100)]-[description]-|" options:NSLayoutFormatAlignAllBottom metrics:nil views:containerViews];
    NSArray *verticalA    = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[description]-|" options:0 metrics:nil views:containerViews];
    
    [self addConstraints:horizontalA];
    [self addConstraints:horizontalB];
    [self addConstraints:verticalA];
    
    NSDictionary *views = @{@"indicator" : _indicator, @"container" : _container};
    NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[indicator(10)]-[container]|" options:(NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom) metrics:nil views:views];
    NSArray *vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[indicator]|" options:0 metrics:nil views:views];
    
    [self addConstraints:horizontal];
    [self addConstraints:vertical];
}

- (void)setIndicator:(FixableTableViewCellIndication)indication{
    switch (indication) {
        case FixableIndicationNone:
            [_indicator setBackgroundColor:CLEAR_COLOR];
            break;
        case FixableIndicationValid:
            [_indicator setBackgroundColor:GREEN_COLOR];
            break;
        case FixableIndicationInvalid:
            [_indicator setBackgroundColor:RED_COLOR];
            break;
        default:
            break;
    }
}

@end
