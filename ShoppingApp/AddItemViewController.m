//
//  AddItemViewController.m
//  ShoppingApp
//
//  Created by qbadmin on 15/07/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import "AddItemViewController.h"
#import "ProductsTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>

@interface AddItemViewController ()
{
    int flag;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.itemDescription.layer.borderWidth = 5.0f;
    self.itemDescription.layer.borderColor = [[UIColor grayColor]CGColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
         self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 60, self.view.frame.size.width, self.view.frame.size.height);
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 60, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 180, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 180, self.view.frame.size.width, self.view.frame.size.height);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.itemName)
    {
        [self.itemDescription becomeFirstResponder];
    }
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.itemImage.image = chosenImage;
    
    flag = 1;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    flag = 0;
    
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
    if ([self.itemName.text isEqualToString:@""]||[self.itemDescription.text isEqualToString:@""]||flag == 0)
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
