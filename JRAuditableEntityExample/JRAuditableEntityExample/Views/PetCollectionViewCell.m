//
//  PetCollectionViewCell.m
//  AuditableEntityExample
//
//  Created by Joshua L Rasmussen on 11/4/16.
//  Copyright © 2016 Joshua Rasmussen. All rights reserved.
//

#import "PetCollectionViewCell.h"

@implementation PetCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        UILabel *breedLabel = [UILabel new];
        [breedLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        UILabel *nameLabel = [UILabel new];
        [nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [nameLabel setFont:[UIFont boldSystemFontOfSize:24.0f]];
        
        [self addSubview:breedLabel];
        [self addSubview:nameLabel];
        
        _breedLabel = breedLabel;
        _nameLabel = nameLabel;
        
        self.layer.masksToBounds = NO;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 7.0f;
        self.layer.contentsScale = [UIScreen mainScreen].scale;
        self.layer.shadowOpacity = 0.5f;
        self.layer.shadowRadius = 3.0f;
        self.layer.shadowOffset = CGSizeMake(0, 5);
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        self.layer.shouldRasterize = YES;
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    NSDictionary *views = @{@"breed" : _breedLabel, @"name" : _nameLabel};
    NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[name]-|" options:0 metrics:nil views:views];
    NSArray *vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[name(40)]-[breed]-|" options:(NSLayoutFormatAlignAllLeft|NSLayoutFormatAlignAllRight) metrics:nil views:views];
    
    [self addConstraints:horizontal];
    [self addConstraints:vertical];
}

@end
