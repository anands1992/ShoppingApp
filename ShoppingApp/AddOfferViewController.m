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
    
    self.categoryPickerHeightFromTop.constant = self.view.frame.size.height;
    self.productPickerHeightFromTop.constant = self.view.frame.size.height;
    
    self.offerDescription.text = @"Offer Description";
    self.offerDescription.textColor = [UIColor lightGrayColor];
    self.offerDescription.layer.borderWidth = 5.0f;
    self.offerDescription.layer.borderColor = [[UIColor cyanColor]CGColor];
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

#pragma mark - Textview Delegate Methods
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.offerDescription.text = @"";
    self.offerDescription.textColor = [UIColor lightGrayColor];
    
    self.addOfferView.frame = CGRectMake(self.addOfferView.frame.origin.x, self.addOfferView.frame.origin.y - 100, self.addOfferView.frame.size.width, self.addOfferView.frame.size.height);
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.addOfferView.frame = CGRectMake(self.addOfferView.frame.origin.x, self.addOfferView.frame.origin.y + 100, self.addOfferView.frame.size.width, self.addOfferView.frame.size.height);
    
    if ([self.offerDescription.text  isEqual: @""])
    {
        self.offerDescription.text = @"Offer Description";
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
        [query whereKey:@"ProductType" equalTo:categoryName];
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
        [self callAlert:@"Offer Description Empty"];
    }
    else if (categoryName == nil)
    {
      //  [self callAlert:@"Please Select a Category"];
        categoryName = [[categoryTable objectAtIndex:0]valueForKey:@"CategoryName"];
    }
    else if (productName == nil)
    {
       // [self callAlert:@"Please Select a Product"];
        productName = [[productTable objectAtIndex:0]valueForKey:@"ProductName"];
    }
    else
    {
        self.placeOffer.enabled = NO;
        
        NSMutableDictionary *addItem = [[NSMutableDictionary alloc]init];
        
        PFObject *offers = [PFObject objectWithClassName:@"Offers"];
        
        offers[@"ProductName"] = productName;
        
        PFQuery *offerQuery = [PFQuery queryWithClassName:@"Offers"];
        
        [offerQuery whereKey:@"ProductName" equalTo:productName];
        
        [offerQuery findObjectsInBackgroundWithBlock:^(NSArray *offer, NSError *error)
        {
            if (offer.count == 0)
            {
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
                              [addItem setObject: productName forKey:@"Product Name"];
                              
                              [addItem setObject: offerImageData forKey:@"Offer Image"];
                              
                              [addItem setObject:self.offerDescription.text forKey:@"Offer Description"];
                              
                              [addItem setObject:categoryName forKey:@"Category Name"];
                              
                              [self.offerData addObject:addItem];
                              
                              [self.navigationController popViewControllerAnimated:YES];
                          }
                          else
                          {
                              NSLog(@"%@", error);
                              [self callAlert:@"There was an error in adding the new item, please try again"];
                          }
                      }];
                 }];
            }
            else
            {
                self.placeOffer.enabled = YES;
                [self callAlert:@"An Offer already exists for this product !!"];
            }
        }];
    }
}

- (IBAction)categoryPicker:(id)sender
{
    
    self.productPickerHeightFromTop.constant = self.view.frame.size.height;

    [self.view layoutIfNeeded];
    [UIView animateWithDuration:1.0 animations:^{
       
        self.categoryPickerHeightFromTop.constant = Picker_Height;
        [self.view layoutIfNeeded];
    }];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
}

- (IBAction)productPicker:(id)sender
{
    self.categoryPickerHeightFromTop.constant = self.view.frame.size.height;

    [self.view layoutIfNeeded];
    [UIView animateWithDuration:1.0 animations:^{
        
        self.productPickerHeightFromTop.constant = Picker_Height;
        [self.view layoutIfNeeded];
    }];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];

    if (categoryName == nil)
    {
        categoryName = [[categoryTable objectAtIndex:0]valueForKey:@"CategoryName"];
        PFQuery *query = [PFQuery queryWithClassName:@"Products"];
        [query whereKey:@"ProductType" equalTo:categoryName];
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
             
             [self.productPicker reloadAllComponents];
             
         }];
    }
}

//Function for calling alerts
- (void) callAlert:(NSString*)alertMessage
{
    UIAlertView *alert = [[UIAlertView alloc]
                          
                          initWithTitle:@"Error"
                          message: alertMessage
                          delegate:nil
                          cancelButtonTitle:@"Dismiss"
                          otherButtonTitles:nil];
    [alert show];
}

@end
