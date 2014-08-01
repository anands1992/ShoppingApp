//
//  CategoryViewController.m
//  ShoppingApp
//
//  Created by qburst on 03/07/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import "CategoryViewController.h"
#import "CategoryTableViewCell.h"
#import "ProductTableViewController.h"
#import "AddCategoryViewController.h"
#import "Constants.h"
#import <Parse/Parse.h>

@interface CategoryViewController()
{
    NSMutableArray *categoryTable;
    
    NSInteger i;
}
@end

@implementation CategoryViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:LOGGED_IN_STATUS])
    {
        
    }
    else
    {
        [self performSegueWithIdentifier:PUSH_TO_LOGIN_SCREEEN_FROM_CATEGORIES_TAB sender:self];
    }
    
    categoryTable = [[NSMutableArray alloc]init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    PFUser *user = [PFUser currentUser];
    
    if ([user[@"UserType"] isEqualToString:is_User])
        
        self.navigationItem.leftBarButtonItem=nil;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Categories"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error)
         {
             categoryTable = [[NSMutableArray alloc] initWithArray:objects];
             // The find succeeded. The first 100 objects are available in objects
         }
         else
         {
             // Log details of the failure
             NSLog(@"Error: %@ %@", error, [error userInfo]);
         }
         [self.tableView reloadData];
     }];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return categoryTable.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CategoryCell";
    CategoryTableViewCell *cell = (CategoryTableViewCell*)
    [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[CategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.categoryName.text = [[categoryTable objectAtIndex:indexPath.row]objectForKey:@"CategoryName"];
    
    PFFile *imageFile = [[categoryTable objectAtIndex:indexPath.row]objectForKey:@"categoryImage"];
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        
        if (!error) {
            cell.categoryImage.image = [UIImage imageWithData:data];
        }
    }];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    i = indexPath.row;
   
    [self performSegueWithIdentifier:PUSH_TO_PRODUCT_SCREEN sender:self];
}

//Checks whether the cell has to be editable or not
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    PFUser *user = [PFUser currentUser];
    if ([user[@"UserID" ] isEqualToString:is_Admin])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
//This function is responsible for enabling the swipeable cell feature
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        PFQuery *categoryQuery = [PFQuery queryWithClassName:@"Categories"];
        
        [categoryQuery whereKey:@"CategoryName" equalTo:[[categoryTable objectAtIndex:indexPath.row]valueForKey:@"CategoryName"]];
        
        [categoryQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)
         {
             [categoryTable removeObjectAtIndex:indexPath.row];
             
             [object deleteInBackground];
             
             [self.tableView reloadData];
         }];
        
        PFQuery *productQuery = [PFQuery queryWithClassName:@"Products"];
        
        [productQuery whereKey:@"ProductType" equalTo:[[categoryTable objectAtIndex:indexPath.row]valueForKey:@"CategoryName"]];
        
        [productQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
        {
            for (int j = 0; j <objects.count; j ++)
            {
                [[objects objectAtIndex:j] deleteInBackground];
            }
        }];
    }
}

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:PUSH_TO_PRODUCT_SCREEN])
    {
            ProductTableViewController *products = [segue destinationViewController];
            
            products.key = [[categoryTable objectAtIndex:i]objectForKey:@"CategoryName"];
    }
}

#pragma mark - IBAction
- (IBAction)Logout:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:LOGGED_IN_STATUS];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [PFUser logOut];
    
    [self performSegueWithIdentifier:PUSH_TO_LOGIN_SCREEEN_FROM_CATEGORIES_TAB sender:self];
}

- (IBAction)addCategory:(id)sender
{
    [self performSegueWithIdentifier:ADD_CATEGORY sender:self];
}

@end
