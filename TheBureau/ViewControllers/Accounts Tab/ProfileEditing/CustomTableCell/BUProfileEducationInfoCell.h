//
//  BUProfileEducationInfoCell.h
//  TheBureau
//
//  Created by Manjunath on 25/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BUProfileEditingVC.h"

@interface BUProfileEducationInfoCell : UITableViewCell<UITextFieldDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
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

-(void)setDatasource:(NSMutableDictionary *)inBasicInfoDict;
@end
