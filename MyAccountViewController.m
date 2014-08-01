//
//  MyAccountViewController.m
//  ShoppingApp
//
//  Created by qbadmin on 01/08/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import "MyAccountViewController.h"
#import "WishListTableViewCell.h"
#import <Parse/Parse.h>

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
    
    return cell;
}

//Checks whether the cell has to be editable or not
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        PFQuery *query = [PFQuery queryWithClassName:@"Wishlist"];
        
        [query whereKey:@"ProductName" equalTo:[[wishlist objectAtIndex:indexPath.row]valueForKey:@"ProductName"]];
        
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)
         {
             [wishlist removeObjectAtIndex:indexPath.row];
             
             [object deleteInBackground];
             
             [self.wishlistTable reloadData];
         }];
    }
}

@end
