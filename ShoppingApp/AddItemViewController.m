//
//  AddItemViewController.m
//  ShoppingApp
//
//  Created by qburst on 15/07/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import "AddItemViewController.h"
#import "ProductTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>
#import "Constants.h"

@interface AddItemViewController ()
{
    int imageSetFlag;
}
@end

@implementation AddItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - UIViewcontroller

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.itemDescription.layer.borderWidth = 5.0f;
    
    self.itemDescription.layer.borderColor = [[UIColor grayColor]CGColor];
    
    self.imageHeight.constant = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Textfield Delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (imageSetFlag == 0)
    {
        self.addItemView.frame = CGRectMake(self.addItemView.frame.origin.x, self.addItemView.frame.origin.y - 45, self.addItemView.frame.size.width, self.addItemView.frame.size.height);
    }
    else
        self.addItemView.frame = CGRectMake(self.addItemView.frame.origin.x, self.addItemView.frame.origin.y - 60, self.addItemView.frame.size.width, self.addItemView.frame.size.height);
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (imageSetFlag == 0)
    {
        self.addItemView.frame = CGRectMake(self.addItemView.frame.origin.x, self.addItemView.frame.origin.y + 45, self.addItemView.frame.size.width, self.addItemView.frame.size.height);
    }
    else
        self.addItemView.frame = CGRectMake(self.addItemView.frame.origin.x, self.addItemView.frame.origin.y + 60, self.addItemView.frame.size.width, self.addItemView.frame.size.height);
}

#pragma mark - Textview Delegates

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (imageSetFlag == 0)
    {
        self.addItemView.frame = CGRectMake(self.addItemView.frame.origin.x, self.addItemView.frame.origin.y - 110, self.addItemView.frame.size.width, self.addItemView.frame.size.height);
    }
    else
        self.addItemView.frame = CGRectMake(self.addItemView.frame.origin.x, self.addItemView.frame.origin.y - 180, self.addItemView.frame.size.width, self.addItemView.frame.size.height);
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (imageSetFlag == 0)
    {
        self.addItemView.frame = CGRectMake(self.addItemView.frame.origin.x, self.addItemView.frame.origin.y + 110, self.addItemView.frame.size.width, self.addItemView.frame.size.height);
    }
    else
        self.addItemView.frame = CGRectMake(self.addItemView.frame.origin.x, self.addItemView.frame.origin.y + 180, self.addItemView.frame.size.width, self.addItemView.frame.size.height);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.itemName)
    {
        [self.itemDescription becomeFirstResponder];
    }
    else
    {
        [self AddProduct:nil];
    }
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    self.itemImage.image = chosenImage;
    
    imageSetFlag = 1;
    
    self.imageHeight.constant = Image_Height;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    imageSetFlag = 0;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - IBAction
//This Button action allows to add an image to the category
- (IBAction)addImage:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

//This Button checks if the user has entered all parameters and adds a product to the table
- (IBAction)AddProduct:(id)sender
{
    [self.view endEditing:YES];
    
    if ([self.itemName.text isEqualToString:@""]||[self.itemDescription.text isEqualToString:@""]||[self.itemPrice.text isEqualToString:@""]) // checks if the textfields are left empty
    {
        [self callAlert:@"Textfields not Filled"];
    }
    else if (imageSetFlag != 1) // checks if the image has been entered
    {
        [self callAlert:@"Image Not Given"];
    }
    else
    {
        
        NSMutableDictionary *addItem = [[NSMutableDictionary alloc]init];
        
        PFObject *products = [PFObject objectWithClassName:@"Products"];
        
        products[@"ProductName"] = self.itemName.text;
        
        PFQuery *query = [PFQuery queryWithClassName:@"Products"];
        
        // to check if the given item with same name already exists in the database
        [query whereKey:@"ProductName" equalTo:self.itemName.text];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             if (objects.count == 0)
             {
                 self.addProduct.enabled = NO;
                 
                 products[@"ProductDescription"] = self.itemDescription.text;
                 
                 products[@"ProductType"] = self.itemType;
                 
                 NSString *itemPriceRegex = @"[0-999999999999]";
                 NSPredicate *itemPriceTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", itemPriceRegex];
                 BOOL myStringMatchesRegEx=[itemPriceTest evaluateWithObject:self.itemPrice.text];

                 if (myStringMatchesRegEx)
                 {
                     products[@"ProductPrice"] = self.itemPrice.text;
                     
                     NSData *imagedata = UIImageJPEGRepresentation(self.itemImage.image, 0);
                     
                     PFFile *imagefile = [PFFile fileWithData:imagedata];
                     
                     products[@"ProductImage"] = imagefile;
                     
                     [products saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                      {
                          if (succeeded)
                          {
                              NSLog(@"Saved.");
                              
                              [addItem setObject:self.itemName.text forKey:@"Product Name"];
                              
                              [addItem setObject:imagefile forKey:@"Product Image"];
                              
                              [addItem setObject:self.itemDescription.text forKey:@"Product Description"];
                              
                              [addItem setObject:self.itemType forKey:@"Product Type"];
                              
                              [addItem setObject:self.itemPrice.text forKey:@"Product Price"];
                              
                              [self.productData addObject:addItem];
                              
                              [self.navigationController popViewControllerAnimated:YES];
                              
                          }
                          else
                          {
                              NSLog(@"%@", error);
                              
                              [self callAlert:@"There was an error in adding the new item, please try again"];
                          }
                      }];
                 }
                 else
                 {
                     [self callAlert:@"Please Input a number for The Product Price"];
                     self.addProduct.enabled = YES;
                 }
             }
             else
             {
                 // Log details of the failure
                 NSLog(@"Error: %@ %@", error, [error userInfo]);
                 
                 self.addProduct.enabled = YES;
                 
                 [self callAlert:@"The entered itemname has already been taken, please specify a different item name"];

             }
         }];
    }
}

//Function for Calling alerts
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
