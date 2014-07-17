//
//  AddItemViewController.m
//  ShoppingApp
//
//  Created by qbadmin on 15/07/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import "AddItemViewController.h"
#import "ProductsTableViewController.h"
#import <Parse/Parse.h>

@interface AddItemViewController ()

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

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    self.itemImage.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
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

- (IBAction)AddProduct:(id)sender
{
    if ([self.itemName.text isEqualToString:@""]||[self.itemDescription.text isEqualToString:@""])
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
        
   
        
        PFObject *products = [PFObject objectWithClassName:@"Products"];
        
        products[@"ProductName"] = self.itemName.text;
        
        products[@"ProductDescription"] = self.itemDescription.text;
        
        products[@"ProductType"] = self.itemType;
        
        NSData *imagedata = UIImageJPEGRepresentation(self.itemImage.image, 0);
        
        PFFile *imagefile = [PFFile fileWithData:imagedata];
        
        products[@"ProductImage"] = imagefile;
        
        [products saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded)
            {
                NSLog(@"Saved.");
            }
            else
            {
                NSLog(@"%@", error);
            }
        }];
        
        [addItem setObject:self.itemName.text forKey:@1];
        [addItem setObject:imagefile forKey:@2];
        [addItem setObject:self.itemDescription.text forKey:@3];
        [addItem setObject:self.itemType forKey:@4];
        
        [self.transferdata addObject:addItem];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
@end
