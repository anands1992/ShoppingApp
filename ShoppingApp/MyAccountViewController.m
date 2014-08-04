//
//  MyAccountViewController.m
//  ShoppingApp
//
//  Created by qburst on 01/08/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import "MyAccountViewController.h"
#import "WishListTableViewCell.h"
#import <Parse/Parse.h>
#import "Constants.h"

@interface MyAccountViewController ()
{
    NSMutableArray *wishlist;
}
@end

@implementation MyAccountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Wishlist"];
    [query whereKey:@"User" equalTo:user.username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error)
         {
             wishlist = [[NSMutableArray alloc] initWithArray:objects];
             // The find succeeded. The first 100 objects are available in objects
         }
         else
         {
             // Log details of the failure
             NSLog(@"Error: %@ %@", error, [error userInfo]);
         }
         [self.wishlistTable reloadData];
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return wishlist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"WishlistCell";
    WishListTableViewCell *cell = (WishListTableViewCell*)
    [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[WishListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.productName.text = [[wishlist objectAtIndex:indexPath.row]objectForKey:@"ProductName"];
    
    PFFile *imageFile = [[wishlist objectAtIndex:indexPath.row]objectForKey:@"ProductImage"];
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
     {
         if (!error)
         {
             cell.productImage.image = [UIImage imageWithData:data];
         }
     }];
    
    cell.deleteButton.tag = indexPath.row;
    
    cell.addToCartButton.tag = indexPath.row;
    
    cell.delegate = self;
    
    return cell;
}

- (IBAction)Logout:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:LOGGED_IN_STATUS];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [PFUser logOut];
    
    [self performSegueWithIdentifier:PUSH_TO_LOGIN_SCREEEN_FROM_MYACCOUNT_TAB sender:self];
}

#pragma mark - SwipeableCellDelegate
- (void)deleteButtonAction:(NSInteger)buttonTag
{
    PFQuery *query = [PFQuery queryWithClassName:@"Wishlist"];
    
            [query whereKey:@"ProductName" equalTo:[[wishlist objectAtIndex:buttonTag]valueForKey:@"ProductName"]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        [wishlist removeObjectAtIndex:buttonTag];
        
        [[objects objectAtIndex:0] deleteInBackground];
        
        [self.wishlistTable reloadData];
    }];
}

- (void)addToCartButtonAction:(NSInteger)buttonTag
{
    PFObject *cart = [PFObject objectWithClassName:@"Cart"];
    
    PFQuery *cartQuery = [PFQuery queryWithClassName:@"Cart"];
    
    [cartQuery whereKey:@"ProductName" equalTo:[[wishlist objectAtIndex:buttonTag] valueForKey:@"ProductName"]];
    
    [cartQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
        if (objects.count == 0)
        {
            cart[@"ProductName"] = [[wishlist objectAtIndex:buttonTag]  valueForKey:@"ProductName"];
    
            cart[@"ProductImage"] = [[wishlist objectAtIndex:buttonTag]  valueForKey:@"ProductImage"];
            
            cart[@"ProductPrice"] = [[wishlist objectAtIndex:buttonTag]  valueForKey:@"ProductPrice"];
    
            PFUser *user = [PFUser currentUser];
    
            cart[@"User"] = user.email;
    
            [cart saveInBackground];
        }
        else
        {
            [self callAlert:@"This Item Already Exists in the Cart"];
        }
    }];

}

#pragma mark - Alert Messages
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
