//
//  EducationDetails.h
//  TheBureau
//
//  Created by Ama1's iMac on 01/08/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUBaseViewController.h"
#import "BUProfileEditingVC.h"

@interface EducationDetails : BUBaseViewController<UITextFieldDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property(weak, nonatomic) IBOutlet UIView *nonEditingView,*editingView;
@property(weak, nonatomic) IBOutlet BUProfileEditingVC *parentVC;
@property(nonatomic,strong)NSArray* relationCircle,*educationLevelArray;

@property (strong, nonatomic) NSMutableDictionary *educationInfo;

#pragma mark -
#pragma mark - Education selection
@property (weak, nonatomic) IBOutlet UILabel *educationlevelLbl,*educationlevelLbl2;

@property (nonatomic,weak) IBOutlet UITextField *honorTextField,*honorTextField2;
@property (nonatomic,weak) IBOutlet UITextField *yearTextField,*yearTextField2;

@property (nonatomic,weak) IBOutlet UITextField *collegeTextField,*collegeTextField2;
@property (nonatomic,weak) IBOutlet UITextField *majorTextField,*majorTextField2;
@property (strong, nonatomic) IBOutlet UIButton *headerBtn;
@end
