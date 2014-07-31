//
//  ProductDetailViewController.m
//  ShoppingApp
//
//  Created by qburst on 04/07/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "ShoppingCartViewController.h"
#import "ShoppingAppDelegate.h"
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
    
    PFQuery *query = [PFQuery queryWithClassName:@"Products"];
    
    [query whereKey:@"ProductName" equalTo:self.productKey];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error)
         {
             self.productDetailViews = [objects objectAtIndex:0];
             // The find succeeded. The first 100 objects are available in objects
             
             self.productName.text = [_productDetailViews valueForKey:@"ProductName"];
             
             PFFile *imageFile = [_productDetailViews valueForKey:@"ProductImage"];
             
             [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
              {
                  if (!error)
                  {
                      self.productImage.image = [UIImage imageWithData:data];
                  }
              }];
             
             self.productDescription.text = [_productDetailViews valueForKey:@"ProductDescription"];
             
             [self.productScroll sizeToFit];
             
             self.productDescription.numberOfLines = 0; //will wrap text in new line
             
             [self.productDescription sizeToFit];
             
             self.productPrice.text = [NSString stringWithFormat:@"Price : Rs %@",[_productDetailViews valueForKey:@"ProductPrice"]];
         }
         else
         {
             // Log details of the failure
             NSLog(@"Error: %@ %@", error, [error userInfo]);
             
             UIAlertView *alert = [[UIAlertView alloc]
                                   
                                   initWithTitle:@"Error!"
                                         message:@"There was an error in retrieving the data, please try again"
                                        delegate:nil
                               cancelButtonTitle:@"Dismiss"
                               otherButtonTitles:nil];
             [alert show];
         }
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (IBAction)addToCart:(id)sender
{
    PFQuery *query = [PFQuery queryWithClassName:@"Cart"];
    
    [query whereKey:@"ProductName" equalTo:[self.productDetailViews valueForKey:@"ProductName"]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (objects.count == 0)
        {
            PFObject *cart = [PFObject objectWithClassName:@"Cart"];
            
            cart[@"ProductName"] = [self.productDetailViews valueForKey:@"ProductName"];
            
            cart[@"ProductImage"] = [self.productDetailViews valueForKey:@"ProductImage"];
            
            cart[@"ProductPrice"] = [self.productDetailViews valueForKey:@"ProductPrice"];
            
            PFUser *user = [PFUser currentUser];
            
            cart[@"User"] = user.email;
            
            [cart saveInBackground];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  
                                  initWithTitle:@"Error!"
                                        message:@"This Item is Already Present in Cart"
                                       delegate:nil
                              cancelButtonTitle:@"Dismiss"
                              otherButtonTitles:nil];
            [alert show];
        }
    }];
}

@end
