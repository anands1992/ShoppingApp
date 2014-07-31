//
//  LoginViewController.h
//  ShoppingApp
//
//  Created by qburst on 11/07/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userName;

@property (weak, nonatomic) IBOutlet UITextField *Password;

@property (weak, nonatomic) IBOutlet UIButton *Login;

@property (weak, nonatomic) IBOutlet UIView *loginFrame;

@property (weak, nonatomic) IBOutlet UILabel *securityQuestion;

@property (weak, nonatomic) IBOutlet UITextField *securityQuestionAnswer;

@property (weak, nonatomic) IBOutlet UIButton *Signup;

@property (weak, nonatomic) IBOutlet UIButton *Submit;

@property (weak, nonatomic) IBOutlet UIButton *Cancel;

@end
