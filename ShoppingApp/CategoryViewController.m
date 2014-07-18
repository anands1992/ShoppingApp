//
//  CategoryViewController.m
//  ShoppingApp
//
//  Created by qburst on 03/07/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import "CategoryViewController.h"
#import "CategoryTableViewCell.h"
#import "ProductsTableViewController.h"
#import "AddCategoryViewController.h"
#import "Constants.h"
#import <Parse/Parse.h>

@interface CategoryViewController()
{
    NSDictionary *category1,*category2,*watch1,*watch2,*watch3,*watch4,*phone1,*phone2,*phone3,*phone4;
    
    NSMutableArray *categoryTable,*watchTable,*phoneTable;
    
    int i;
}

@end

@implementation CategoryViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    categoryTable = [[NSMutableArray alloc]init];
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:LOGGEDINSTATUS])
    {
        
    }
    else
    {
        [self performSegueWithIdentifier:PUSHTOLOGINSCREEENFROMCATEGORIESTAB sender:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
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
   
    [self performSegueWithIdentifier:PUSHTOPRODUCTSCREEN sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:PUSHTOPRODUCTSCREEN])
    {
            ProductsTableViewController *products = [segue destinationViewController];
            
            products.key = [[categoryTable objectAtIndex:i]objectForKey:@"CategoryName"];
        
    }
}

#pragma mark - IBAction
- (IBAction)Logout:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:LOGGEDINSTATUS];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [PFUser logOut];
    [self performSegueWithIdentifier:PUSHTOLOGINSCREEENFROMCATEGORIESTAB sender:self];
}

- (IBAction)addCategory:(id)sender
{
    [self performSegueWithIdentifier:ADDCATEGORY sender:self];
}

@end
