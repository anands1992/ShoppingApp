//
//  ProductsTableViewController.h
//  ShoppingApp
//
//  Created by qbadmin on 15/07/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductsTableViewController : UITableViewController

@property (strong,nonatomic) NSMutableArray *categoryDetailViews;

@property(strong,nonatomic) NSString *key;

@property(strong,nonatomic) NSString *productKey;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addItem;

@end
