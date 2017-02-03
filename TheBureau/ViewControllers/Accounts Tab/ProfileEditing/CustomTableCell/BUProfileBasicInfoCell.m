//
//  BUProfileBasicInfoCell.m
//  TheBureau
//
//  Created by Manjunath on 25/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUProfileBasicInfoCell.h"
#import "UIView+FLKAutoLayout.h"

@implementation BUProfileBasicInfoCell

- (void)awakeFromNib {
    // Initialization code
    self.feetMutableArray = [[NSMutableArray alloc]init];
    self.inchesMutableArray = [[NSMutableArray alloc]init];
    
    self.ageArray = [[NSMutableArray alloc]init];
    self.radiusArray = [[NSMutableArray alloc]init];
    
    for (int i=0; i < 12; i++) {
        NSString *inches = [NSString stringWithFormat:@"%d\"",i ];
        [self.inchesMutableArray addObject:inches];
    }
    
    for (int i=4; i < 8; i++) {
        NSString *feet = [NSString stringWithFormat:@"%d'",i ];
        [self.feetMutableArray addObject:feet];
    }
    
    
    for (int i=18; i < 55; i++) {
        NSString *inches = [NSString stringWithFormat:@"%d",i ];
        [self.ageArray addObject:inches];
    }
    
    
    for (int i=1; i < 50; i++) {
        NSString *inches = [NSString stringWithFormat:@"%d",i ];
        [self.radiusArray addObject:inches];
    }
    
    
    _maritalStatusArray = [NSArray arrayWithObjects:@"Never Married",@"Married",@"Divorced",nil];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag == 0)
        [self.basicInfoDict setValue:textField.text forKey:@"profile_first_name"];
    else
        [self.basicInfoDict setValue:textField.text forKey:@"current_zip_code"];
    
    [textField resignFirstResponder];
    return YES;
}


-(void)checkPinCode
{
    
    NSDictionary *parameters = nil;
    parameters = @{@"zip_code": self.radiusLabel.text
                   };
    [self.parentVC startActivityIndicator:YES];
    
    
    NSString *baseURl = [NSString stringWithFormat:@"login/checkZipCodes/zip_code/%@",self.radiusLabel.text];
    
    [[BUWebServicesManager sharedManager] getqueryServer:nil
                                              baseURL:baseURl
                                         successBlock:^(id response, NSError *error)
     {
         [self.parentVC stopActivityIndicator];
         
         if([[[response valueForKey:@"msg"] lowercaseString] isEqualToString:@"success"])
         {
             [self.basicInfoDict setValue:self.radiusLabel.text forKey:@"current_zip_code"];
         }
         else
         {
             self.radiusLabel.text = @"";
             [self.parentVC stopActivityIndicator];
             [self.parentVC showAlert:@"Invalid zip code"];
         }
     }
                                         failureBlock:^(id response, NSError *error)
     {
         self.radiusLabel.text = @"";
         [self.parentVC stopActivityIndicator];
         if (error.code == NSURLErrorTimedOut) {
             [self.parentVC showAlert:@"Connection timed out, please try again later"];
         }
         else
         {
             [self.parentVC showAlert:@"Invalid zip code"];
         }
     }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if(textField.tag == 0)
        [self.basicInfoDict setValue:textField.text forKey:@"profile_first_name"];
    else
        [self checkPinCode];
    [textField resignFirstResponder];
}
#pragma mark - Gender selection

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

-(IBAction)setGender:(id)sender
{
    NSString *femaleImgName,*maleImgName,*genderImgName;
    
    if(0 == self.genderSelectionBtn.tag)
    {
        femaleImgName = @"ic_female_s2.png";
        maleImgName = @"ic_male_s1.png";
        genderImgName = @"switch_female.png";
        self.genderSelectionBtn.tag = 1;
        [self.basicInfoDict setValue:@"Female" forKey:@"profile_gender"];
    }
    else
    {
        self.genderSelectionBtn.tag = 0;
        femaleImgName = @"ic_female_s1.png";
        maleImgName = @"ic_male_s2.png";
        genderImgName = @"switch_male.png";
        [self.basicInfoDict setValue:@"Male" forKey:@"profile_gender"];
    }
    
    self.femaleImgView.image = [UIImage imageNamed:femaleImgName];
    self.maleImgView.image = [UIImage imageNamed:maleImgName];
    [self.genderSelectionBtn setImage:[UIImage imageNamed:genderImgName]
                             forState:UIControlStateNormal];
    
}

#pragma mark -
#pragma mark - Height selection

-(IBAction)setheight {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Height\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIPickerView *picker = [[UIPickerView alloc] init];
    [alertController.view addSubview:picker];
    [picker alignCenterYWithView:alertController.view predicate:@"0.0"];
    [picker alignCenterXWithView:alertController.view predicate:@"0.0"];
    [picker constrainWidth:@"270" ];
    picker.dataSource = self;
    picker.delegate = self ;
    
    
    [picker reloadAllComponents];
    
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"OK");
            
            NSUInteger numComponents = [[picker dataSource] numberOfComponentsInPickerView:picker];
            
            NSMutableString * text = [NSMutableString string];
            for(NSUInteger i = 0; i < numComponents; ++i) {
                NSString *title = [self pickerView:picker titleForRow:[picker selectedRowInComponent:i] forComponent:i];
                [text appendFormat:@"%@", title];
            }
            
            NSLog(@"%@", text);
            self.heighTextField.text = text;
        }];
        action;
    })];
    
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"Cancel");
        }];
        action;
    })];
    [self.parentVC presentViewController:alertController  animated:YES completion:nil];
}

#pragma mark- Picker View Delegate
#pragma mark -
#pragma mark - Age selection

-(IBAction)setAge
{
    
    [self.parentVC.view endEditing:YES];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Birthday\n\n\n\n\n\n\n" message:@"\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
    UIDatePicker *picker = [[UIDatePicker alloc] init];
    [picker setDatePickerMode:UIDatePickerModeDate];
    [alertController.view addSubview:picker];
    
    [picker alignCenterYWithView:alertController.view predicate:@"0.0"];
    [picker alignCenterXWithView:alertController.view predicate:@"0.0"];
    [picker constrainWidth:@"270" ];
    //
    
    
    
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    [comps setMonth:1];
    [comps setYear:1990];
    NSDate *currentDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    
    NSDate *todayDate = [NSDate date];
    NSDate *newDate = [todayDate dateByAddingTimeInterval:(-1*18*365*24*60*60)];
    picker.maximumDate = newDate;
    picker.date = currentDate;
    
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"OK");
            NSLog(@"%@",picker.date);
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MM-dd-yyyy"];
            NSString *dateString = [dateFormat stringFromDate:picker.date];
            self.ageLabel.text = dateString;
            [self.basicInfoDict setValue:dateString forKey:@"profile_dob"];
        }];
        action;
    })];
    
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"Cancel");
            //NSLog(@"%@",picker.date);
        }];
        action;
    })];
    [self.parentVC presentViewController:alertController  animated:YES completion:nil];
}



#pragma mark -
#pragma mark - Radius selection

-(IBAction)setRadius {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Location Radius\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.tag = 101;
    [alertController.view addSubview:picker];
    [picker alignCenterYWithView:alertController.view predicate:@"0.0"];
    [picker alignCenterXWithView:alertController.view predicate:@"0.0"];
    [picker constrainWidth:@"270" ];
    picker.dataSource = self;
    picker.delegate = self ;
    
    
    [picker reloadAllComponents];
    
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"OK");
            
            NSUInteger numComponents = [[picker dataSource] numberOfComponentsInPickerView:picker];
            
            NSMutableString * text = [NSMutableString string];
            for(NSUInteger i = 0; i < numComponents; ++i) {
                
                NSString *title = [self pickerView:picker titleForRow:[picker selectedRowInComponent:i] forComponent:i];
                [text appendFormat:@"%@", title];
            }
            
            NSLog(@"%@", text);
            self.radiusLabel.text = [NSString stringWithFormat:@"%@ miles",text];
            
            
            [self.basicInfoDict setValue:text forKey:@"current_zip_code"];
            
        }];
        action;
    })];
    
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"Cancel");
        }];
        action;
    })];
    [self.parentVC presentViewController:alertController  animated:YES completion:nil];
}

#pragma mark- Picker View Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    
    if(pickerView.tag == 100)
    {
    }
    else if(pickerView.tag == 101)
    {
    }
    else
    {
        
        if (component == 1)
        {
            self.inchStr = [_inchesMutableArray objectAtIndex:row];
            
            [self.basicInfoDict setValue:self.inchStr forKey:@"height_inch"];
            
        }
        else
        {
            self.feetStr = [_feetMutableArray objectAtIndex:row];
            [self.basicInfoDict setValue:self.feetStr forKey:@"height_feet"];
        }
    }
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component
{
    
    if(pickerView.tag == 100)
    {
        return [self.ageArray objectAtIndex:row];
    }
    else if(pickerView.tag == 101)
    {
        return [self.radiusArray objectAtIndex:row];
    }
    else
    {
        if (component ==1) {
            return [_inchesMutableArray objectAtIndex:row];
        }
        else
        {
            
            return [_feetMutableArray objectAtIndex:row];
        }
    }
}


#pragma mark - Picker View Data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if(pickerView.tag == 100)
    {
        return 1;
    }
    else if(pickerView.tag == 101)
    {
        return 1;
    }
    return 2;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    
    if(pickerView.tag == 100)
    {
        return [self.ageArray count];
    }
    else if(pickerView.tag == 101)
    {
        return [self.radiusArray count];
    }
    else
    {
        if (component ==1) {
            return [_inchesMutableArray count];
        }
        else
        {
            
            return [_feetMutableArray count];
        }
    }
}


#pragma mark - Account selection

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0)
    {
        self.maritalStatusTF.text = self.maritalStatusArray[buttonIndex - 1];
        
    }
}


-(void)setDatasource:(NSMutableDictionary *)inBasicInfoDict
{
    
    
    self.basicInfoDict = inBasicInfoDict;
    self.nameTF.text = [inBasicInfoDict valueForKey:@"profile_first_name"];
    
    self.ageLabel.text = [inBasicInfoDict valueForKey:@"profile_dob"];
    
    NSString *genderStr  = [inBasicInfoDict valueForKey:@"profile_gender"];
    
    NSString *femaleImgName,*maleImgName,*genderImgName;
    
    if([[genderStr lowercaseString] isEqualToString:@"female"])
    {
        femaleImgName = @"ic_female_s2.png";
        maleImgName = @"ic_male_s1.png";
        genderImgName = @"switch_female.png";
        self.genderSelectionBtn.tag = 1;
    }
    else
    {
        self.genderSelectionBtn.tag = 0;
        femaleImgName = @"ic_female_s1.png";
        maleImgName = @"ic_male_s2.png";
        genderImgName = @"switch_male.png";
    }
    
    self.femaleImgView.image = [UIImage imageNamed:femaleImgName];
    self.maleImgView.image = [UIImage imageNamed:maleImgName];
    [self.genderSelectionBtn setImage:[UIImage imageNamed:genderImgName]
                             forState:UIControlStateNormal];
    
    
    self.radiusLabel.text = [inBasicInfoDict valueForKey:@"current_zip_code"];
    
    self.heighTextField.text = [NSString stringWithFormat:@"%@' %@''",[inBasicInfoDict valueForKey:@"height_feet"],[inBasicInfoDict valueForKey:@"height_inch"]];
    
    
    self.maritalStatus = [inBasicInfoDict valueForKey:@"maritial_status"];
    
    NSInteger tag = 1;
    
    if([self.maritalStatus  containsString:@"Never"] || [self.maritalStatus  isEqualToString:@""])
    {
        tag = 1;
    }
    else if([self.maritalStatus  containsString:@"Divor"])
    {
        tag = 2;
    }
    else
    {
        tag = 3;
    }
    [self setMAritalStatusForState:tag];
}


-(void)updateProfile
{
    [self.parentVC startActivityIndicator:YES];
    
    NSDictionary *parameters = nil;
    parameters = @{@"userid": [BUWebServicesManager sharedManager].userID,
                   @"profile_gender": @"Male",
                   @"height_feet": self.feetStr,
                   @"height_inch":self.inchStr,
                   @"maritial_status": self.maritalStatusTF.text,
                   @"current_zip_code": self.radiusLabel.text,
                   };
    
    [[BUWebServicesManager sharedManager] queryServer:parameters
                                              baseURL:@"profile/update_profile_step1"
                                         successBlock:^(id response, NSError *error)
     {
         [self.parentVC stopActivityIndicator];
         
     }
                                         failureBlock:^(id response, NSError *error)
     {
         [self.parentVC stopActivityIndicator];
     }];
}


#pragma mark - Martial status


-(IBAction)getMatialStatus:(id)sender
{
    [self setMAritalStatusForState:[sender tag]];
    
}
-(void)setMAritalStatusForState:(NSInteger)inTag
{
    if (inTag == 1)
    {
        self.maritalStatus = @"Never married";
        
        [self.neverMarriedBtn setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s2"] forState:UIControlStateNormal];
        [self.divorcedBtn setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s1"] forState:UIControlStateNormal];
        [self.widowedBtn setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s1"] forState:UIControlStateNormal];
        
        
        
        [self.neverMarriedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.widowedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.divorcedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        
        
        
    }
    else if (inTag == 2){
        
        self.maritalStatus = @"Divorced";
        
        [self.divorcedBtn setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s2"] forState:UIControlStateNormal];
        [self.neverMarriedBtn setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s1"] forState:UIControlStateNormal];
        [self.widowedBtn setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s1"] forState:UIControlStateNormal];
        
        
        [self.divorcedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.widowedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.neverMarriedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        
        
    }
    else{
        
        self.maritalStatus = @"Widowed";
        
        [self.widowedBtn setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s2"] forState:UIControlStateNormal];
        [self.neverMarriedBtn setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s1"] forState:UIControlStateNormal];
        [self.divorcedBtn setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s1"] forState:UIControlStateNormal];
        
        [self.widowedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.divorcedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.neverMarriedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    [self.basicInfoDict setValue:self.maritalStatus forKey:@"maritial_status"];
}
@end
