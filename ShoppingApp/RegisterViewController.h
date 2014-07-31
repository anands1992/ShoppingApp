//
//  RegisterViewController.h
//  ShoppingApp
//
//  Created by qburst on 11/07/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *name;

@property (weak, nonatomic) IBOutlet UITextField *eMail;

@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;

@property (weak, nonatomic) IBOutlet UIButton *Register;

@property (weak, nonatomic) IBOutlet UIView *registerFrame;

@property (weak, nonatomic) IBOutlet UIPickerView *securityQuestionPicker;

@property (weak, nonatomic) IBOutlet UITextField *securityQuestionAnswer;
@end
