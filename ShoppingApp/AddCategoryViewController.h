//
//  AddCategoryViewController.h
//  ShoppingApp
//
//  Created by qburst on 17/07/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCategoryViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;

@property (weak, nonatomic) IBOutlet UITextField *categoryName;

@property (weak, nonatomic) IBOutlet UIView *categoryView;

@property (weak, nonatomic) IBOutlet UIButton *addCategory;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;

@end
