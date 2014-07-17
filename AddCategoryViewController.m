//
//  AddCategoryViewController.m
//  ShoppingApp
//
//  Created by qbadmin on 17/07/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import "AddCategoryViewController.h"
#import "ProductsTableViewController.h"
#import <Parse/Parse.h>

@interface AddCategoryViewController ()
{
    NSMutableArray *categoryDetails;
}
@end

@implementation AddCategoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.categoryImage.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)addImage:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)addCategory:(id)sender
{
    if ([self.categoryName.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              
                              initWithTitle:@"Error!"
                              message:@"Fields not Filled"
                              delegate:nil
                              cancelButtonTitle:@"Dismiss"
                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSMutableDictionary *addItem = [[NSMutableDictionary alloc]init];
        
        PFObject *categories = [PFObject objectWithClassName:@"Categories"];
        
        categories[@"CategoryName"] = self.categoryName.text;
        
        NSData *imagedata = UIImageJPEGRepresentation(self.categoryImage.image, 0);
        
        PFFile *imagefile = [PFFile fileWithData:imagedata];
        
        categories[@"categoryImage"] = imagefile;
        
        [categories saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
        {
            if (succeeded)
            {
                NSLog(@"Saved.");
            }
            else
            {
                NSLog(@"%@", error);
            }
        }];
        
        [addItem setObject:self.categoryName.text forKey:@1];
        
        [addItem setObject:imagefile forKey:@2];
        
        [categoryDetails addObject:addItem];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

@end
