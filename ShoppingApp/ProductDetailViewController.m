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
{
    NSMutableArray *wishlistArray;
}
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
    
    wishlistArray = [[NSMutableArray alloc]init];
    
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
             
             [self callAlert:@"There was an error in retrieving the data, please try again"];
         }
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (IBAction)addToCart:(id)sender
{
    PFUser *user = [PFUser currentUser];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Cart"];
    
    [query whereKey:@"ProductName" equalTo:[self.productDetailViews valueForKey:@"ProductName"]];
    
    [query whereKey:@"User" equalTo:user.username];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (objects.count == 0)
        {
            PFObject *cart = [PFObject objectWithClassName:@"Cart"];
            
            cart[@"ProductName"] = [self.productDetailViews valueForKey:@"ProductName"];
            
            cart[@"ProductImage"] = [self.productDetailViews valueForKey:@"ProductImage"];
            
            cart[@"ProductPrice"] = [self.productDetailViews valueForKey:@"ProductPrice"];
            
            cart[@"User"] = user.username;
            
            [cart saveInBackground];
        }
        else
        {
            [self callAlert:@"This Item is Already Present in Cart"];
        }
    }];
}

- (IBAction)Wishlist:(id)sender
{
    PFObject *wishlist = [PFObject objectWithClassName:@"Wishlist"];
    
    PFQuery *wishlistquery = [PFQuery queryWithClassName:@"Wishlist"];
    
    [wishlistquery whereKey:@"ProductName" equalTo:[self.productDetailViews valueForKey:@"ProductName"]];
    
    [wishlistquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count == 0)
        {
            wishlist[@"ProductName"] = [self.productDetailViews valueForKey:@"ProductName"];
            
            wishlist[@"ProductImage"] = [self.productDetailViews valueForKey:@"ProductImage"];
            
            PFUser *user = [PFUser currentUser];
            
            wishlist[@"User"] = user.email;
            
            [wishlist saveInBackground];
        }
        else
        {
            [self callAlert:@"This Item Already Exists in the Wishlist"];
        }
    }];
}

//Function for Calling alerts
- (void) callAlert:(NSString*)alertMessage
{
    UIAlertView *alert = [[UIAlertView alloc]
                          
                          initWithTitle:@"Error"
                          message: alertMessage
                          delegate:nil
                          cancelButtonTitle:@"Dismiss"
                          otherButtonTitles:nil];
    [alert show];
}

@end
