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
#import "Constants.h"
#import <Parse/Parse.h>

@interface CategoryViewController()
{
    NSDictionary *categories,*category1,*category2,*watch1,*watch2,*watch3,*watch4,*phone1,*phone2,*phone3,*phone4;
    NSMutableArray *categoryTable,*watchTable,*phoneTable;
    int i;
    }

@end

@implementation CategoryViewController

#pragma mark - UIViewController
- (void)viewDidLoad
{
    categoryTable = [[NSMutableArray alloc]init];
    
    categories=[NSDictionary alloc];
    
    [super viewDidLoad];
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:LOGGEDINSTATUS])
    {
        
    }
    else
    {
        [self performSegueWithIdentifier:PUSHTOLOGINSCREEENFROMCATEGORIESTAB sender:self];
        
    }
    
    [self watches];
    
    [self phones];
    
    category1 = @{@1: WATCHES,@2: @"rolex.jpg"};
    
    category2 = @{@1: PHONES, @2: @"phones.jpg"};

    [categoryTable addObject:category1];
    
    [categoryTable addObject:category2];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    
    categories = [categoryTable objectAtIndex:indexPath.row];
    
    cell.categoryName.text = [categories objectForKey:@1];
    
    cell.categoryImage.image = [UIImage imageNamed:[categories objectForKey:@2]];
    
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
        if (i == 0)
        {
            ProductsTableViewController *products = [segue destinationViewController];
            
            products.categoryDetailViews = watchTable;
            products.passedCategory = @"Watches";
        }
        else if(i == 1)
        {
            ProductsTableViewController *products = [segue destinationViewController];
            
            products.categoryDetailViews = phoneTable;
            products.passedCategory = @"Phones";
        }
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

-(void)watches
{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Products"];
    
    [query whereKey:@"ProductType" equalTo:@"Watch"];
    
    NSArray *findArray = [query findObjects];
    
    watchTable = [[NSMutableArray alloc] initWithArray:findArray];
}

-(void)phones
{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Products"];
    
    [query whereKey:@"ProductType" equalTo:@"Phone"];
    
    NSArray *findArray = [query findObjects];
    
    phoneTable = [[NSMutableArray alloc] initWithArray:findArray];
}

@end
