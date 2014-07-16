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
    NSMutableArray *pictureArray;
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
    Products = [NSDictionary alloc];
    productImages = [PFObject objectWithClassName:@"Products"];
    PFFile *userImageFile = productImages[@"ProductImage"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            image = [pictureArray mutableCopy];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categoryDetailViews.count;
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
    
    cell.productName.text = [[self.categoryDetailViews objectAtIndex:indexPath.row]objectForKey:@"ProductName"];

//    cell.productImage.image = [UIImage imageNamed:[[self.categoryDetailViews objectAtIndex:indexPath.row]objectForKey:@"ProductImage"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    i = indexPath.row;
    
    Products = [self.categoryDetailViews objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:PUSHTODETAILVIEW sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:PUSHTODETAILVIEW])
    {
        ProductDetailViewController *products = [segue destinationViewController];
        
        products.productDetailViews = Products;
    }
    else  if ([segue.identifier isEqualToString:ADDPRODUCT])
    {
        AddItemViewController *addItem = [segue destinationViewController];
        
        addItem.transferdata = self.categoryDetailViews;
    }
}

- (IBAction)addItem:(id)sender
{
    [self performSegueWithIdentifier:ADDPRODUCT sender:self];
}


@end
