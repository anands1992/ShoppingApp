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
    PFObject *object;
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
    
    categories = [categoryTable objectAtIndex:indexPath.row];
    
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
        }
        else if(i == 1)
        {
            ProductsTableViewController *products = [segue destinationViewController];
            
            products.categoryDetailViews = phoneTable;
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
    watchTable= [[NSMutableArray alloc]init];
    
    watch1 = @{@1:SUBMARINER,@2:@"submariner date.jpg",@3:watchDecsription1};
    watch2 = @{@1:YACHTMASTER,@2:@"Rolex Yacht Master Rolesium platinum dial.jpg",@3:watchDecsription2};
    watch3 = @{@1:DAYTONA,@2:@"Oyster perpetual.jpg",@3:watchDecsription3};
    watch4 = @{@1:MILGAUSS,@2:@"Milgauss.jpg",@3:watchDecsription4};
    
        [watchTable addObject:watch1];
        [watchTable addObject:watch2];
        [watchTable addObject:watch3];
        [watchTable addObject:watch4];
    
    object = [PFObject objectWithClassName:@"Products"];
    object[@"Watches"] = watchTable;
}

-(void)phones
{
    phoneTable = [[NSMutableArray alloc]init];
    
    phone1 = @{@1:GALAXYS5,@2:@"S5.jpg",@3:GALAXYS5DESCRIPTION};
    phone2 = @{@1:IPHONE,@2:@"5S.jpeg",@3:IPHONEDESCRIPTION};
    phone3 = @{@1:HTC,@2:@"htcone.jpeg",@3:HTCDESCRIPTION};
    phone4 = @{@1:XPERIA,@2:@"xperia.jpeg",@3:XPERIADESCRIPTION};
    
        [phoneTable addObject:phone1];
        [phoneTable addObject:phone2];
        [phoneTable addObject:phone3];
        [phoneTable addObject:phone4];
    
    object = [PFObject objectWithClassName:@"Products"];
    object[@"Phones"] = phoneTable;
}

@end
