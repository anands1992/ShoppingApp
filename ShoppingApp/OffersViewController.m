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
    
    NSMutableArray *offerTable;
    
    int i;
}

@end

@implementation OffersViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) viewWillAppear:(BOOL)animated
{
    PFUser *user = [PFUser currentUser];
    
    if ([user[@"UserType"] isEqualToString:is_User])
        self.navigationItem.leftBarButtonItem=nil;
    
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
    
    [self performSegueWithIdentifier:PUSH_TO_DETAIL_VIEW sender:self];
}

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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        PFQuery *query = [PFQuery queryWithClassName:@"Offers"];
        
        [query whereKey:@"ProductName" equalTo:[[offerTable objectAtIndex:indexPath.row]valueForKey:@"ProductName"]];
        
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)
         {
             [offerTable removeObjectAtIndex:indexPath.row];
             
             [object deleteInBackground];
             
             [self.tableView reloadData];
         }];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:PUSH_TO_DETAIL_VIEW])
    {
        OfferDetailViewController *offers = [segue destinationViewController];
        
        offers.offerDetailViews = dict;
    }
    else if ([segue.identifier isEqualToString:ADD_OFFER])
    {
        AddOfferViewController *offers = [segue destinationViewController];
        
        offers.offerData = [[NSMutableArray alloc] initWithArray:offerTable];
    }
}

#pragma mark - IBAction

- (IBAction)Logout:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:LOGGED_IN_STATUS];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[GPPSignIn sharedInstance] signOut];
    [PFUser logOut];
    [self performSegueWithIdentifier:PUSH_TO_LOGIN_SCREEEN_FROM_OFFERS_TAB sender:self];
}

@end
