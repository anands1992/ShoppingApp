//
//  AddOfferViewController.h
//  ShoppingApp
//
//  Created by qbadmin on 22/07/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddOfferViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIPickerViewAccessibilityDelegate>

@property (strong, nonatomic) IBOutlet UIPickerView *categoryPicker;

@property (strong, nonatomic) IBOutlet UIPickerView *productPicker;

@property (weak, nonatomic) IBOutlet UITextView *offerDescription;

@property (weak, nonatomic) IBOutlet UIButton *placeOffer;

@property (weak, nonatomic) IBOutlet UIScrollView *offerScroll;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *offerDescriptionHeight;

@property (strong,nonatomic) NSMutableArray *offerData;

@end
