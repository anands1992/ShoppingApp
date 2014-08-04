//
//  WishListTableViewCell.h
//  ShoppingApp
//
//  Created by qburst on 01/08/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

@protocol SwipeableCellDelegate <NSObject>
-(void)deleteButtonAction:(NSInteger)buttonTag;
-(void)addToCartButtonAction:(NSInteger)buttonTag;

@end
#import <UIKit/UIKit.h>

@interface WishListTableViewCell : UITableViewCell<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *productImage;

@property (weak, nonatomic) IBOutlet UILabel *productName;

@property (nonatomic, weak) IBOutlet UIButton *deleteButton;

@property (nonatomic, weak) IBOutlet UIButton *addToCartButton;

@property (nonatomic, weak) id <SwipeableCellDelegate> delegate;

@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;

@property (nonatomic, assign) CGPoint panStartPoint;

@property (nonatomic, assign) CGFloat startingRightLayoutConstraintConstant;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewRightConstraint;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewLeftConstraint;

@property (weak, nonatomic) IBOutlet UIView *myContentView;

@end
