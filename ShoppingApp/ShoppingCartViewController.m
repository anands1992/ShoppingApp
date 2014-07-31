//
//  ShoppingCartViewController.m
//  ShoppingApp
//
//  Created by qburst on 30/07/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "ShoppingCartTableViewCell.h"
#import "TotalAmountTableViewCell.h"
#import <Parse/Parse.h>
#import "Constants.h"

@interface ShoppingCartViewController ()
{
    NSMutableArray *Cart;
}
@end

@implementation ShoppingCartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
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
    [super viewWillAppear:YES];
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Cart"];
    [query whereKey:@"User" equalTo:user.username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         Cart = [[NSMutableArray alloc]initWithArray:objects];
         self.numberOfItems.text = [NSString stringWithFormat:(@"%d Items in cart"),Cart.count];
        [self.shoppingCart reloadData];
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return Cart.count+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < Cart.count)
    {
    static NSString *cellIdentifier = @"cartItem";
    ShoppingCartTableViewCell *cell = (ShoppingCartTableViewCell*)
    [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[ShoppingCartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.productName.text = [[Cart objectAtIndex:indexPath.row]objectForKey:@"ProductName"];
    
    cell.productPrice.text = [NSString stringWithFormat:@"Price : %@",[[Cart objectAtIndex:indexPath.row]objectForKey:@"ProductPrice"]];
    
    PFFile *imageFile = [[Cart objectAtIndex:indexPath.row]objectForKey:@"ProductImage"];
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
    {
        if (!error)
        {
            cell.productImage.image = [UIImage imageWithData:data];
        }
    }];
    
    return cell;
    }
    else if (indexPath.row==Cart.count)
    {
        NSArray *priceArray = [Cart valueForKey:@"ProductPrice"];
        float totalprice = 0.0;
        for (NSString *price in priceArray)
        {
            totalprice += [price floatValue];
        }
        static NSString *cellName = @"TotalAmountCell";
        TotalAmountTableViewCell *totalAmountCell = (TotalAmountTableViewCell*)
        [tableView dequeueReusableCellWithIdentifier:cellName];
        if(totalAmountCell == nil)
        {
            totalAmountCell = [[TotalAmountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        }
        NSLog(@"%f",totalprice);
        totalAmountCell.totalAmount.text = [NSString stringWithFormat:@"%f",totalprice];
        return totalAmountCell;
    }
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==Cart.count)
    {
        return NO;
    }
    else
        return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        PFQuery *cartQuery = [PFQuery queryWithClassName:@"Cart"];
        
        [cartQuery whereKey:@"ProductName" equalTo:[[Cart objectAtIndex:indexPath.row]valueForKey:@"ProductName"]];
        
        [cartQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)
         {
             [Cart removeObjectAtIndex:indexPath.row];
             
             [object deleteInBackground];
             
             [self.shoppingCart reloadData];
         }];
    }
}

- (IBAction)Logout:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:LOGGED_IN_STATUS];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [PFUser logOut];
    
    [self performSegueWithIdentifier:PUSH_TO_LOGIN_SCREEEN_FROM_CART_TAB sender:self];
}

@end
