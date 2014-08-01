//
//  WishListTableViewCell.h
//  ShoppingApp
//
//  Created by qbadmin on 01/08/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

@protocol SwipeableCellDelegate <NSObject>
-(void)deleteButtonAction;
-(void)addToCartButtonAction;

@end
#import <UIKit/UIKit.h>

@interface WishListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *productImage;

@property (weak, nonatomic) IBOutlet UILabel *productName;

@property (nonatomic, weak) IBOutlet UIButton *deleteButton;

@property (nonatomic, weak) IBOutlet UIButton *addToCartButton;

@property (nonatomic, weak) id <SwipeableCellDelegate> delegate;

@end
