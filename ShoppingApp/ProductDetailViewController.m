//
//  ProductDetailViewController.m
//  ShoppingApp
//
//  Created by qburst on 04/07/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import "ProductDetailViewController.h"
#import <Parse/Parse.h>
#import "Constants.h"

@interface ProductDetailViewController ()

@end

@implementation ProductDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.productName.text = [_productDetailViews valueForKey:@"ProductName"];
    
    PFFile *imageFile = [_productDetailViews valueForKey:@"ProductImage"];
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
    {
        if (!error) {
            self.productImage.image = [UIImage imageWithData:data];
        }
    }];
    
    self.productDescription.text = [_productDetailViews valueForKey:@"ProductDescription"];
    
    [self.productScroll sizeToFit];
    
    _productDescription.numberOfLines = 0; //will wrap text in new line
    
    [_productDescription sizeToFit];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
