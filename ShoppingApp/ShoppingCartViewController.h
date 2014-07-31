//
//  ShoppingCartViewController.h
//  ShoppingApp
//
//  Created by qbadmin on 30/07/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingCartViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *shoppingCart;

@property (weak, nonatomic) IBOutlet UILabel *numberOfItems;

@end
