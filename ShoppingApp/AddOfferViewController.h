//
//  AddOfferViewController.h
//  ShoppingApp
//
//  Created by qburst on 22/07/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol pickerviewAnimatefromBottomDelegate <NSObject>

-(void)pickerviewAnimatefromBottom;

@end

@interface AddOfferViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIPickerViewAccessibilityDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIPickerView *categoryPicker;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryPickerHeightFromTop;

@property (strong, nonatomic) IBOutlet UIPickerView *productPicker;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *productPickerHeightFromTop;

@property (weak, nonatomic) IBOutlet UITextView *offerDescription;

@property (weak, nonatomic) IBOutlet UIButton *placeOffer;

@property (weak, nonatomic) IBOutlet UIView *addOfferView;

@property (strong,nonatomic) NSMutableArray *offerData;

@end
