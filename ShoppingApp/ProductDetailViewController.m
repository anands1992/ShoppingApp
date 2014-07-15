//
//  ProductDetailViewController.m
//  ShoppingApp
//
//  Created by qburst on 04/07/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "Constants.h"

@interface ProductDetailViewController ()

@end

@implementation ProductDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    self.productName.text = [_productDetailViews objectForKey:@1];
    
    self.productImage.image = [UIImage imageNamed:[_productDetailViews objectForKey:@2]];
    
    self.productDescription.text = [_productDetailViews objectForKey:@3];
    
    [self.productScroll sizeToFit];
    
    self.productName.text = [_productDetailViews objectForKey:@1];
    
    self.productImage.image = [UIImage imageNamed:[_productDetailViews objectForKey:@2]];
    
    self.productDescription.text = [_productDetailViews objectForKey:@3];
    
    _productDescription.numberOfLines = 0; //will wrap text in new line
    
    [_productDescription sizeToFit];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
