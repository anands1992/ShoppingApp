//
//  RegisterViewController.m
//  ShoppingApp
//
//  Created by qburst on 11/07/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import "RegisterViewController.h"
#import "Constants.h"
#import <Parse/Parse.h>

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark -UIViewcontroller
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.password.secureTextEntry = YES;
    self.confirmPassword.secureTextEntry = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - TextField Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.name)
        [self.eMail becomeFirstResponder];
    else if(textField == self.eMail)
        [self.password becomeFirstResponder];
    else if(textField == self.password)
        [self.confirmPassword becomeFirstResponder];
    else
        [self Register:nil];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.registerFrame.frame = CGRectMake(self.registerFrame.frame.origin.x, self.registerFrame.frame.origin.y - 90, self.registerFrame.frame.size.width, self.registerFrame.frame.size.height);
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.registerFrame.frame = CGRectMake(self.registerFrame.frame.origin.x, self.registerFrame.frame.origin.y + 90, self.registerFrame.frame.size.width, self.registerFrame.frame.size.height);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - IBAction

//This Button checks if the user has entered all the fields and if true, then checks if the enetered e-mail is already registered in the database, if no, the details are entered and the user is signed up.
- (IBAction)Register:(id)sender
{
    if ([self.name.text isEqualToString:@""]||[self.eMail.text isEqualToString:@""]||[self.password.text isEqualToString:@""]||[self.confirmPassword.text isEqualToString:@""])
    {
        [self callAlert:@"Fields not Filled"];
    }
    
    else if (![self.password.text isEqualToString:self.confirmPassword.text])
    {
        [self callAlert:@"Passwords Do Not Match"];
    }
    
    else
    {
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@qburst.com";
        NSPredicate *emailTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        BOOL myStringMatchesRegEx=[emailTest evaluateWithObject:self.eMail.text];
        
        PFUser *user = [PFUser user];
        user[@"Name"] = self.name.text;
        
        if (myStringMatchesRegEx)
        {
            user.username = self.eMail.text;
            
            user[@"email"] = self.eMail.text;
            
            PFQuery *query = [PFQuery queryWithClassName:@"User"];
            [query whereKey:@"username" equalTo:self.eMail.text];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
            {
                if (objects.count == 0)
                {
                    user.password = self.password.text;
                    
                    user[@"UserID"] = is_User;
                    
                    [user signUpInBackground];
                    
                    [user saveInBackground];
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                else
                {
                    [self callAlert:@"This E-Mail is Already Registered"];
                }
            }];
        }
        else
        {
            [self callAlert:@"E-Mail Format Invalid"];
        }
        
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
