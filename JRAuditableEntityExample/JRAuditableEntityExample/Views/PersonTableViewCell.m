//
//  PersonTableViewCell.m
//  AuditableEntityExample
//
//  Created by Joshua Rasmussen on 11/3/16.
//  Copyright © 2016 Joshua Rasmussen. All rights reserved.
//

#import "PersonTableViewCell.h"

@implementation PersonTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        UILabel *nameLabel = [UILabel new];
        [nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
