//
//  CategoryViewController.h
//  ShoppingApp
//
//  Created by qburst on 03/07/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
