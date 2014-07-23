//
//  OffersViewController.m
//  ShoppingApp
//
//  Created by qburst on 03/07/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import "OffersViewController.h"
#import "OffersTableViewCell.h"
#import "OfferDetailViewController.h"
#import "AddOfferViewController.h"
#import <GooglePlus/GooglePlus.h>
#import <Parse/Parse.h>
#import "Constants.h"

@interface OffersViewController ()
{
    NSDictionary *dict;
    
    NSArray *offerTable;
    
    int i;
}

@end

@implementation OffersViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PFUser *user = [PFUser currentUser];
    
    if ([user[@"UserID"] isEqualToString:isAdmin])
    {
        
    }
    else
    {
        self.navigationItem.leftBarButtonItem=nil;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) viewWillAppear:(BOOL)animated
{
    PFQuery *query = [PFQuery queryWithClassName:@"Offers"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error)
         {
             offerTable = [[NSMutableArray alloc] initWithArray:objects];
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
    return offerTable.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"OffersCell";
    OffersTableViewCell *cell = (OffersTableViewCell*)
    [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[OffersTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    dict = [offerTable objectAtIndex:indexPath.row];
    
    cell.offerName.text = [dict objectForKey:@"ProductName"];
    
    PFFile *imageFile = [[offerTable objectAtIndex:indexPath.row]objectForKey:@"ProductImage"];
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            cell.offerImage.image = [UIImage imageWithData:data];
        }
    }];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    dict = [offerTable objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:PUSHTODETAILVIEW sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:PUSHTODETAILVIEW])
    {
        OfferDetailViewController *offers = [segue destinationViewController];
        
        offers.offerDetailViews = dict;
    }
    else if ([segue.identifier isEqualToString:ADDOFFER])
    {
        AddOfferViewController *offers = [segue destinationViewController];
        
        offers.offerData = [[NSMutableArray alloc] initWithArray:offerTable];
    }
}

#pragma mark - IBAction

- (IBAction)Logout:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:LOGGEDINSTATUS];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[GPPSignIn sharedInstance] signOut];
    [PFUser logOut];
    [self performSegueWithIdentifier:PUSHTOLOGINSCREENFROMOFFERSTAB sender:self];
}

@end
