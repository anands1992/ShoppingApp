//
//  WishListTableViewCell.h
//  ShoppingApp
//
//  Created by qbadmin on 01/08/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WishListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productImage;

@property (weak, nonatomic) IBOutlet UILabel *productName;

@end
