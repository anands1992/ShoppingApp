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
    self.securityQuestion.hidden = YES;
    self.securityQuestionAnswer.hidden = YES;
    self.Submit.hidden = YES;
    self.Cancel.hidden = YES;
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
                 self.loginFrame.frame = CGRectMake(self.loginFrame.frame.origin.x, self.loginFrame.frame.origin.y -200, self.loginFrame.frame.size.width, self.loginFrame.frame.size.height);

                 self.securityQuestion.text = [[objects objectAtIndex:0] valueForKey:@"SecurityQuestion"];
                 self.Signup.hidden = YES;
                 self.securityQuestion.hidden = NO;
                 self.securityQuestionAnswer.hidden = NO;
                 self.Submit.hidden = NO;
                 self.Cancel.hidden = NO;
             }
         }];
    }
}

- (IBAction)Submit:(id)sender
{
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:self.userName.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if ([self.securityQuestionAnswer.text isEqualToString:[[objects objectAtIndex:0] valueForKey:@"SecurityQuestionAnswer"]])
         {
             [PFUser requestPasswordResetForEmailInBackground:self.userName.text];
         }
         else
         {
             [self callAlert:@"Sorry, the answer you entered is wrong !!"];
         }
     }];
}

- (IBAction)Cancel:(id)sender
{
    self.loginFrame.frame = CGRectMake(self.loginFrame.frame.origin.x, self.loginFrame.frame.origin.y + 200, self.loginFrame.frame.size.width, self.loginFrame.frame.size.height);
    
    self.securityQuestion.hidden = YES;
    self.securityQuestionAnswer.hidden = YES;
    self.Submit.hidden = YES;
    self.Cancel.hidden = YES;
    self.Signup.hidden = NO;
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
