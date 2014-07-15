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
    self.offerName.text = [_offerDetailViews objectForKey:@1];
    self.offerImage.image = [UIImage imageNamed:[_offerDetailViews objectForKey:@2]];
    self.offerDescription.text = [_offerDetailViews objectForKey:@3];
    
    self.offerDescription.numberOfLines = 0; //will wrap text in new line
    
    [self.offerDescription sizeToFit];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
