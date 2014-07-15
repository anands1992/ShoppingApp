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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.Password.secureTextEntry = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.userName)
        [self.Password becomeFirstResponder];
    else
        [ self Login:nil];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)Login:(id)sender
{
        [PFUser logInWithUsernameInBackground:self.userName.text password:self.Password.text
                                        block:^(PFUser *user, NSError *error) {
                                            if (user)
                                            {
                                                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:LOGGEDINSTATUS];
                                                [[NSUserDefaults standardUserDefaults] synchronize];
                                                
                                                [self dismissViewControllerAnimated:YES completion:nil];
                                            }
                                            else
                                            {
                                                UIAlertView *alert = [[UIAlertView alloc]
                                                                      
                                                                      initWithTitle:@"Error!"
                                                                            message:@"Invalid Login Credentials"
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"Dismiss"
                                                                  otherButtonTitles:nil];
                                                [alert show];

                                            }
                                        }];
        
    
}

@end
