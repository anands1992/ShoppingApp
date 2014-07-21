//
//  AddItemViewController.h
//  ShoppingApp
//
//  Created by qbadmin on 15/07/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddItemViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *itemImage;

@property (weak, nonatomic) IBOutlet UITextField *itemName;

@property (weak, nonatomic) IBOutlet UITextView *itemDescription;

@property (weak, nonatomic) IBOutlet UIButton *addItem;

@property (strong,nonatomic) NSMutableArray *productData;

@property (strong,nonatomic) NSString *itemType;

@end
