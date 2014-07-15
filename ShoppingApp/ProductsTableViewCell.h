//
//  ProductsTableViewCell.h
//  ShoppingApp
//
//  Created by qburst on 03/07/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *productName;

@end
