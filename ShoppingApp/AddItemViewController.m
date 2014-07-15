//
//  AddItemViewController.m
//  ShoppingApp
//
//  Created by qbadmin on 15/07/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import "AddItemViewController.h"
#import "ProductsTableViewController.h"

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
        
        [addItem setObject:self.itemName.text forKey:@1];
        [addItem setObject:self.itemImage.image forKey:@2];
        [addItem setObject:self.itemDescription.text forKey:@3];
        ProductsTableViewController *table;
        [table.categoryDetailViews addObject:addItem];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
@end
