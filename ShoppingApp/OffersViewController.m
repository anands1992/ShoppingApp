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
#import <GooglePlus/GooglePlus.h>
#import <Parse/Parse.h>
#import "Constants.h"

@interface OffersViewController ()
{
    NSDictionary *dict, *product1, *product2, *product3, *product4;
    NSArray *offerTable;
    int i;
}

@end

@implementation OffersViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    product1 = @{@1: SUBMARINER,@2: @"submariner date.jpg",@3:OFFER1};
    
    product2 = @{@1: YACHTMASTER, @2: @"Rolex Yacht Master Rolesium platinum dial.jpg",@3: OFFER1};
    
    product3 = @{@1: DAYTONA, @2: @"Oyster perpetual.jpg",@3:OFFER2};
    
    product4 = @{@1: MILGAUSS, @2: @"Milgauss.jpg",@3:OFFER2};
    
    offerTable = @[product1,product2,product3,product4];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
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
    
    dict = [offerTable objectAtIndex:indexPath.row%4];
    
    cell.offerImage.image = [UIImage imageNamed:[dict objectForKey:@2]];
    
    cell.offerDescription.text = [dict objectForKey:@1];
    
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
