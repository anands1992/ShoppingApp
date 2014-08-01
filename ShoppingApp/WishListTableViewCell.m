//
//  WishListTableViewCell.m
//  ShoppingApp
//
//  Created by qbadmin on 01/08/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import "WishListTableViewCell.h"

@implementation WishListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)buttonClicked:(id)sender {
    if (sender == self.deleteButton)
    {
        [self.delegate deleteButtonAction];
    }
    else if (sender == self.addToCartButton)
    {
        [self.delegate addToCartButtonAction];
    }
    else
    {
        NSLog(@"Clicked unknown button!");
    }
}


@end
