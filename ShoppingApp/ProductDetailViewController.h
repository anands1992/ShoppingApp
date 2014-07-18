//
//  ProductDetailViewController.h
//  ShoppingApp
//
//  Created by qburst on 04/07/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIImageView *productImage;

@property (weak, nonatomic) IBOutlet UILabel *productName;

@property (weak, nonatomic) IBOutlet UILabel *productDescription;

@property (weak, nonatomic) IBOutlet UIButton *Purchase;

@property (weak,nonatomic) NSDictionary *productDetailViews;

@property (weak, nonatomic) IBOutlet UIScrollView *productScroll;

@end
