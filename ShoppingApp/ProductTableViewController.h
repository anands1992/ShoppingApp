//
//  ProductTableViewController.h
//  ShoppingApp
//
//  Created by qburst on 15/07/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductTableViewController : UITableViewController

@property (strong,nonatomic) NSMutableArray *categoryDetailViews;

@property(strong,nonatomic) NSString *key;

@property(strong,nonatomic) NSString *productKey;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addItem;

@end