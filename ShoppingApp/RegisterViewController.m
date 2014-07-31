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
{
    NSArray *securityQuestionSet;
    NSString *securityQuestion;
}
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
    
    securityQuestionSet = @[@"Your favorite Colour ?",@"Your favorite Song ?",@"Your favorite author ?",@"Your first Boss ?",@"Your best friend ?"];
    
    self.securityQuestionPicker.delegate = self;
    self.securityQuestionPicker.dataSource = self;
    
    
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
    self.registerFrame.frame = CGRectMake(self.registerFrame.frame.origin.x, self.registerFrame.frame.origin.y - 40, self.registerFrame.frame.size.width, self.registerFrame.frame.size.height);
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.registerFrame.frame = CGRectMake(self.registerFrame.frame.origin.x, self.registerFrame.frame.origin.y + 40, self.registerFrame.frame.size.width, self.registerFrame.frame.size.height);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return securityQuestionSet.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return securityQuestionSet[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    securityQuestion = [securityQuestionSet objectAtIndex:row];
}

#pragma mark - IBAction

//This Button checks if the user has entered all the fields and if true, then checks if the enetered e-mail is already registered in the database, if no, the details are entered and the user is signed up.
- (IBAction)Register:(id)sender
{
    if ([self.name.text isEqualToString:@""]||[self.eMail.text isEqualToString:@""]||[self.password.text isEqualToString:@""]||[self.confirmPassword.text isEqualToString:@""]||[self.securityQuestionAnswer.text isEqualToString:@""])
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
                    
                    user[@"SecurityQuestion"] = securityQuestion;
                    
                    user[@"SecurityQuestionAnswer"] = self.securityQuestionAnswer.text;
                    
                    [user signUpInBackground];
                    
                    [user saveInBackground];
                    
                    [self.navigationController popViewControllerAnimated:YES];
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
