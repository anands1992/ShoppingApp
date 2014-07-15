//
//  OfferDetailViewController.h
//  ShoppingApp
//
//  Created by qburst on 04/07/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfferDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *offerImage;
@property (weak, nonatomic) IBOutlet UILabel *offerName;
@property (weak, nonatomic) IBOutlet UILabel *offerDescription;
@property (weak, nonatomic) IBOutlet UIButton *buyProduct;
@property (weak,nonatomic) NSDictionary *offerDetailViews;
@property (weak, nonatomic) IBOutlet UIScrollView *offerScroll;
@end
