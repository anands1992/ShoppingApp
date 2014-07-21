//
//  OfferDetailViewController.m
//  ShoppingApp
//
//  Created by qburst on 04/07/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import "OfferDetailViewController.h"
#import "ProductDetailViewController.h"
#import "Constants.h"
#import <Parse/Parse.h>

@interface OfferDetailViewController ()

@end

@implementation OfferDetailViewController

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
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.offerName.text = [_offerDetailViews objectForKey:@"ProductName"];
    
    PFFile *imageFile = [_offerDetailViews objectForKey:@"ProductImage"];
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            self.offerImage.image = [UIImage imageWithData:data];
        }
    }];
    
    
    self.offerDescription.text = [_offerDetailViews objectForKey:@"ProductDescription"];
    
    self.offerDescription.numberOfLines = 0; //will wrap text in new line
    
    [self.offerDescription sizeToFit];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:PUSHTOPURCHASESCREEN])
    {
        ProductDetailViewController *products = [segue destinationViewController];
        
        products.productDetailViews = _offerDetailViews;
    }
}
#pragma mark - IBAction
- (IBAction)proceedToBuy:(id)sender
{
    [self performSegueWithIdentifier: PUSHTOPURCHASESCREEN sender:self];
}

@end
