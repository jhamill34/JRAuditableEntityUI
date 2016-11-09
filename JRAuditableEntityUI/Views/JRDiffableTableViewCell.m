//
//  DiffableTableViewCell.m
//  AuditableEntityExample
//
//  Created by Joshua Rasmussen on 11/4/16.
//  Copyright © 2016 Joshua Rasmussen. All rights reserved.
//

#import "JRDiffableTableViewCell.h"
#import "JRDiffableUIConstants.h"

@implementation JRDiffableTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        UILabel *fieldLabel = [UILabel new];
        [fieldLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        UILabel *fromLabel = [UILabel new];
        [fromLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [fromLabel setBackgroundColor:RED_COLOR];
        [fromLabel setTextAlignment:NSTextAlignmentCenter];
        
        UILabel *toLabel = [UILabel new];
        [toLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [toLabel setBackgroundColor:GREEN_COLOR];
        [toLabel setTextAlignment:NSTextAlignmentCenter];
        
        [self addSubview:fieldLabel];
        [self addSubview:fromLabel];
        [self addSubview:toLabel];
        
        _fieldLabel = fieldLabel;
        _fromLabel = fromLabel;
        _toLabel = toLabel;
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    NSDictionary *views = @{@"field" : _fieldLabel, @"from" : _fromLabel, @"to" : _toLabel};
    NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[field(from)]-[from(to)][to]|" options:(NSLayoutFormatAlignAllTop|NSLayoutFormatAlignAllBottom) metrics:nil views:views];
    NSArray *vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[field]|" options:0 metrics:nil views:views];
    
    [self addConstraints:horizontal];
    [self addConstraints:vertical];
}

@end
