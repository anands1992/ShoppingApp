//
//  AddCategoryViewController.m
//  ShoppingApp
//
//  Created by qburst on 17/07/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import "AddCategoryViewController.h"
#import "ProductTableViewController.h"
#import "Constants.h"
#import <Parse/Parse.h>

@interface AddCategoryViewController ()
{
    NSMutableArray *categoryDetails;
    int imageSetFlag;
}
@end

@implementation AddCategoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageHeight.constant = 0;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Categories"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            categoryDetails = [[NSMutableArray alloc] initWithArray:objects];
            // The find succeeded. The first 100 objects are available in objects
        }
        else
        {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITextfield Delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.categoryView.frame = CGRectMake(self.categoryView.frame.origin.x, self.categoryView.frame.origin.y - 100, self.categoryView.frame.size.width, self.categoryView.frame.size.height);
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.categoryView.frame = CGRectMake(self.categoryView.frame.origin.x, self.categoryView.frame.origin.y + 100, self.categoryView.frame.size.width, self.categoryView.frame.size.height);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - Image Picker Controller delegate methods
//Gets called if the image has been successfully chosen
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.categoryImage.image = chosenImage;
    
    imageSetFlag = 1;
    
    self.imageHeight.constant = Image_Height;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
//Gets called when the user cancels his image selection
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

//This Button checks if the user has entered all parameters and adds a category to the table
- (IBAction)addCategory:(id)sender
{
        if ([self.categoryName.text isEqualToString:@""])
        {
            [self callAlert:@"Category Name not Filled"];
        }
        else if (imageSetFlag == 0)
        {
            [self callAlert:@"Image not Given"];
        }
        else
        {
            self.addCategory.enabled = NO;
            
            NSMutableDictionary *addItem = [[NSMutableDictionary alloc]init];
            
            PFObject *categories = [PFObject objectWithClassName:@"Categories"];
            
            categories[@"CategoryName"] = self.categoryName.text;
            
            PFQuery *query = [PFQuery queryWithClassName:@"Categories"];
            
            [query whereKey:@"CategoryName" equalTo:self.categoryName.text];
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
             {
                 if (objects.count == 0)
                 {
                     
                     NSData *imagedata = UIImageJPEGRepresentation(self.categoryImage.image, 0);
                     
                     PFFile *imagefile = [PFFile fileWithData:imagedata];
                     
                     categories[@"categoryImage"] = imagefile;
                     
                     [categories saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                      {
                          if (succeeded)
                          {
                              NSLog(@"Saved.");
                              
                              [addItem setObject:self.categoryName.text forKey:@"Category Name"];
                              
                              [addItem setObject:imagefile forKey:@"Category Image"];
                              
                              [categoryDetails addObject:addItem];
                              
                              [self.navigationController popViewControllerAnimated:YES];
                              
                          }
                          else
                          {
                              NSLog(@"%@", error);
                              
                              [self callAlert:@"There was an error in adding the new category,please try again"];
                          }
                      }];
                 }
                 else
                 {
                     // Log details of the failure
                     NSLog(@"Error: %@ %@", error, [error userInfo]);
                     
                     self.addCategory.enabled = YES;
                     
                     [self callAlert:@"The entered category name has already been taken, please specify a different item name"];
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
