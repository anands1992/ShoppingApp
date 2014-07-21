//
//  CategoryTableViewCell.h
//  ShoppingApp
//
//  Created by qbadmin on 15/07/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;

@property (weak, nonatomic) IBOutlet UILabel *categoryName;

@end
