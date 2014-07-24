//
//  AddOfferViewController.m
//  ShoppingApp
//
//  Created by qbadmin on 22/07/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import "AddOfferViewController.h"
#import "Constants.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

@interface AddOfferViewController ()
{
    NSArray *categoryTable;
    
    NSArray *productTable;
    
    NSString *categoryName;
    
    NSString *productName;
    
    PFFile *offerImageData;
    
    int flag;
}
@end

@implementation AddOfferViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    
    }
    return self;
}

#pragma mark - UIViewcontroller
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.categoryPicker.dataSource = self;
    self.categoryPicker.delegate = self;
    
    self.productPicker.dataSource = self;
    self.productPicker.delegate = self;

    self.productPicker.hidden = YES;
    
    self.offerDescription.text = @"Offer Description";
    self.offerDescription.textColor = [UIColor blackColor];
    self.offerDescription.layer.borderWidth = 5.0f;
    self.offerDescription.layer.borderColor = [[UIColor grayColor]CGColor];
    self.offerDescriptionHeight.constant = 80.0f;
    
    self.offerScroll.frame = CGRectMake(self.placeOffer.frame.origin.x, self.placeOffer.frame.origin.y, self.placeOffer.frame.size.width, self.placeOffer.frame.size.height +30);
}

//sets data into category picker
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
         [self.categoryPicker reloadAllComponents];
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.offerDescription.text = @"";
    self.offerDescription.textColor = [UIColor blackColor];
    
    self.offerScroll.frame = CGRectMake(self.offerScroll.frame.origin.x, self.offerScroll.frame.origin.y - 200, self.offerScroll.frame.size.width, self.offerScroll.frame.size.height);
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.offerScroll.frame = CGRectMake(self.offerScroll.frame.origin.x, self.offerScroll.frame.origin.y + 200, self.offerScroll.frame.size.width, self.offerScroll.frame.size.height);
}

#pragma mark - Picker View Delegate Methods
// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView==self.categoryPicker)
    {
        return categoryTable.count;
    }
    else
    {
        return productTable.count;
    }
}

//Title for each row
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView==self.categoryPicker)
    {
        return [[categoryTable objectAtIndex:row]valueForKey:@"CategoryName"];
    }
    else
    {
        return [[productTable objectAtIndex:row]valueForKey:@"ProductName"];
    }
}

// Capture the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
   
    // This method is triggered whenever the user makes a change to the picker selection.
    if (pickerView==self.categoryPicker)
    {
        categoryName = [[categoryTable objectAtIndex:row]valueForKey:@"CategoryName"];
        PFQuery *query = [PFQuery queryWithClassName:@"Products"];
        [query whereKey:@"ProductType" equalTo:[[categoryTable objectAtIndex:row]valueForKey:@"CategoryName"]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             if (!error)
             {
                 productTable = [[NSMutableArray alloc] initWithArray:objects];
                 // The find succeeded. The first 100 objects are available in objects
             }
             else
             {
                 // Log details of the failure
                 NSLog(@"Error: %@ %@", error, [error userInfo]);
             }
             self.productPicker.hidden = NO;
             
             [self.productPicker reloadAllComponents];

         }];
    }
    else
    {
        productName = [[productTable objectAtIndex:row]valueForKey:@"ProductName"];
    }
}

#pragma mark - IBAction
- (IBAction)placeOffer:(id)sender
{
    if ([self.offerDescription.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              
                              initWithTitle:@"Error"
                                    message:@"Offer Description Empty"
                                   delegate:nil
                          cancelButtonTitle:@"Dismiss"
                           otherButtonTitles:nil];
        [alert show];
    }
    else if (categoryName == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              
                              initWithTitle:@"Error!"
                              message:@"Please select a Category"
                              delegate:nil
                              cancelButtonTitle:@"Dismiss"
                              otherButtonTitles:nil];
        [alert show];

    }
    else if (productName == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              
                              initWithTitle:@"Error!"
                              message:@"Please select a Product"
                              delegate:nil
                              cancelButtonTitle:@"Dismiss"
                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSMutableDictionary *addItem = [[NSMutableDictionary alloc]init];
        
        PFObject *offers = [PFObject objectWithClassName:@"Offers"];
        
        offers[@"ProductName"] = productName;
        
        PFQuery *productQuery = [PFQuery queryWithClassName:@"Products"];
        
        [productQuery whereKey:@"ProductName" equalTo:productName];
        
        [productQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
            
            offerImageData = [[objects  objectAtIndex:0] valueForKey:@"ProductImage"];
            
            offers[@"ProductImage"] = offerImageData;
            
            offers[@"ProductDescription"] = self.offerDescription.text;
            
            offers[@"ProductType"] = categoryName;
            
            [offers saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
             {
                 if (succeeded)
                 {
                     [addItem setObject: productName forKey:@1];
                     
                     [addItem setObject: offerImageData forKey:@2];
                     
                     [addItem setObject:self.offerDescription.text forKey:@3];
                     
                     [addItem setObject:categoryName forKey:@4];
                     
                     [self.offerData addObject:addItem];
                     
                     [self.navigationController popViewControllerAnimated:YES];
                 }
                 else
                 {
                     NSLog(@"%@", error);
                     
                     UIAlertView *alert = [[UIAlertView alloc]
                                           
                                           initWithTitle:@"Error!"
                                           message:@"There was an error in adding the new item, please try again"
                                           delegate:nil
                                           cancelButtonTitle:@"Dismiss"
                                           otherButtonTitles:nil];
                     [alert show];
                 }
             }];

        }];
        
    }
}

@end
