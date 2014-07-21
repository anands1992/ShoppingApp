//
//  ProductsTableViewController.m
//  ShoppingApp
//
//  Created by qbadmin on 15/07/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import "ProductsTableViewController.h"
#import "ProductsTableViewCell.h"
#import "ProductDetailViewController.h"
#import "AddItemViewController.h"
#import "Constants.h"
#import <Parse/Parse.h>

@interface ProductsTableViewController ()
{
    int i;
    NSDictionary *Products;
    NSArray *productTable;
    PFObject *productImages;
    NSMutableArray *productArray;
}
@end

@implementation ProductsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    PFUser *user = [PFUser currentUser];
    if ([user[@"UserID" ] isEqualToString:isAdmin])
    {
        
    }
    else
    {
         self.navigationItem.rightBarButtonItem=nil;
    }

    PFQuery *query = [PFQuery queryWithClassName:@"Products"];
    
    [query whereKey:@"ProductType" equalTo:self.key];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error)
         {
             productArray = [[NSMutableArray alloc] initWithArray:objects];
             // The find succeeded. The first 100 objects are available in objects
         }
         else
         {
             // Log details of the failure
             NSLog(@"Error: %@ %@", error, [error userInfo]);
         }
         [self.tableView reloadData];
     }];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return productArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ProductCell";
    ProductsTableViewCell *cell = (ProductsTableViewCell*)
    [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[ProductsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.productName.text = [[productArray objectAtIndex:indexPath.row]objectForKey:@"ProductName"];

    PFFile *imageFile = [[productArray objectAtIndex:indexPath.row]objectForKey:@"ProductImage"];
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            cell.productImage.image = [UIImage imageWithData:data];
        }
    }];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.productKey = [[productArray objectAtIndex:indexPath.row]objectForKey:@"ProductName"];
    
    [self performSegueWithIdentifier:PUSHTODETAILVIEW sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:PUSHTODETAILVIEW])
    {
        ProductDetailViewController *products = [segue destinationViewController];
        
        products.productKey = self.productKey;
    }
    else  if ([segue.identifier isEqualToString:ADDPRODUCT])
    {
        AddItemViewController *addItem = [segue destinationViewController];
        
        addItem.itemType = _key;
        
        addItem.productData = productArray;
    }
}

- (IBAction)addItem:(id)sender
{
    [self performSegueWithIdentifier:ADDPRODUCT sender:self];
}

@end
