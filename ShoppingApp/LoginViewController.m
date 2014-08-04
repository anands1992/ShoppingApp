//
//  LoginViewController.m
//  ShoppingApp
//
//  Created by qburst on 11/07/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import "LoginViewController.h"
#import "Constants.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

#pragma mark - UIViewcontroller
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.Password.secureTextEntry = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UITextfield Delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.loginFrame.frame = CGRectMake(self.loginFrame.frame.origin.x, self.loginFrame.frame.origin.y - 120, self.loginFrame.frame.size.width, self.loginFrame.frame.size.height);
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.loginFrame.frame = CGRectMake(self.loginFrame.frame.origin.x, self.loginFrame.frame.origin.y + 120, self.loginFrame.frame.size.width, self.loginFrame.frame.size.height);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.userName)
    {
        [self.Password becomeFirstResponder];
    }
    else
    {
        [self Login:nil];
    }
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - IBAction
//Checks for a user with entered login details and if he is present, then it signs him in, else alert message is shown
- (IBAction)Login:(id)sender
{
        [PFUser logInWithUsernameInBackground:self.userName.text password:self.Password.text
                                        block:^(PFUser *user, NSError *error) {
                                            if (user)
                                            {
                                                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:LOGGED_IN_STATUS];
                                                [[NSUserDefaults standardUserDefaults] synchronize];
                                                
                                                [self dismissViewControllerAnimated:YES completion:nil];
                                            }
                                            else
                                            {
                                                [self callAlert:@"Invalid Login Credentials"];
                                            }
                                        }];
}

- (IBAction)forgotPassword:(id)sender
{
    if ([self.userName.text isEqualToString:@""])
    {
        [self callAlert:@"Please Enter Username"];
    }
    else
    {
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:self.userName.text];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
        {
             if (objects.count == 0)
             {
                 [self callAlert:@"Such a User Does Not Exist !!"];
             }
             else
             {
                 [PFUser requestPasswordResetForEmailInBackground:self.userName.text];
                 
                 UIAlertView *alert = [[UIAlertView alloc]
                                       
                                       initWithTitle:@"Notification"
                                       message: @"An E-Mail Has been sent to your registered address, you can reset your password from the link given in it"
                                       delegate:nil
                                       cancelButtonTitle:@"Dismiss"
                                       otherButtonTitles:nil];
                 [alert show];

             }
         }];
    }
}


//Function for Calling Alerts
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
