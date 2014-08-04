//
//  MyAccountViewController.h
//  ShoppingApp
//
//  Created by qburst on 01/08/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WishListTableViewCell.h"

@interface MyAccountViewController : UIViewController<SwipeableCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *wishlistTable;
@end
