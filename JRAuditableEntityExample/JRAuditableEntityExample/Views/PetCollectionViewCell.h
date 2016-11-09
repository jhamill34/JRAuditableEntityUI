//
//  PetCollectionViewCell.h
//  AuditableEntityExample
//
//  Created by Joshua L Rasmussen on 11/4/16.
//  Copyright © 2016 Joshua Rasmussen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PetCollectionViewCell : UICollectionViewCell

@property (readonly, nonatomic, weak) UILabel *breedLabel;

@property (readonly, nonatomic, weak) UILabel *nameLabel;

@end
