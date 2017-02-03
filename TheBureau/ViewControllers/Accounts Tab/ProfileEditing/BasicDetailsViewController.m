//
//  BasicDetailsViewController.m
//  TheBureau
//
//  Created by Ama1's iMac on 29/07/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BasicDetailsViewController.h"
#import "UIView+FLKAutoLayout.h"

@interface BasicDetailsViewController ()
@property BOOL zipChecked;

@end

@implementation BasicDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Basic";
    
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(editProfileDetails:)];
    
    self.feetMutableArray = [[NSMutableArray alloc]init];
    self.inchesMutableArray = [[NSMutableArray alloc]init];
    
    self.ageArray = [[NSMutableArray alloc]init];
    self.radiusArray = [[NSMutableArray alloc]init];
    
    for (int i=0; i < 12; i++) {
        NSString *inches = [NSString stringWithFormat:@"%02d\"",i ];
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
    
    self.nameTF.text = [self.basicInfoDict valueForKey:@"profile_first_name"];
    
    self.ageLabel.text = [self.basicInfoDict valueForKey:@"profile_dob"];
    
    NSString *genderStr  = [self.basicInfoDict valueForKey:@"profile_gender"];
    
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
    
    
    self.radiusLabel.text = [self.basicInfoDict valueForKey:@"current_zip_code"];
    
    self.heighTextField.text = [NSString stringWithFormat:@"%@' %@''",[self.basicInfoDict valueForKey:@"height_feet"],[self.basicInfoDict valueForKey:@"height_inch"]];
    
    
    self.maritalStatus = [self.basicInfoDict valueForKey:@"maritial_status"];
    
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

- (IBAction)editProfileDetails:(id)sender
{
    [self.view endEditing:YES];
    
    [self checkPinCode];
    
    //    [self.profileTableView reloadData];
}

-(void)updateProfile
{
    
    
    
    
    //    [self.profileImageCell saveProfileImages];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    
    [parameters addEntriesFromDictionary:self.basicInfoDict];
    //    [parameters addEntriesFromDictionary:self.educationDict];
    //    [parameters addEntriesFromDictionary:self.occupationDict];
    //    [parameters addEntriesFromDictionary:self.horoscopeDict];
    //    [parameters addEntriesFromDictionary:self.socialHabitsDict];
    //    [parameters addEntriesFromDictionary:self.legalStatus];
    //    [parameters addEntriesFromDictionary:self.heritageDict];
    [parameters setValue:[BUWebServicesManager sharedManager].userID forKey:@"userid"];
    //[parameters setValue:[self.basicInfoDict valueForKey:@"country_residing"] forKey:@"country_residing"];
    
    [[BUWebServicesManager sharedManager] queryServer:parameters
                                              baseURL:@"profile/update"
                                         successBlock:^(id response, NSError *error)
     {
         NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"Profile updated"];
         [message addAttribute:NSFontAttributeName
                         value:[UIFont fontWithName:@"comfortaa" size:15]
                         range:NSMakeRange(0, message.length)];
         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
         [alertController setValue:message forKey:@"attributedTitle"];
         
         [alertController addAction:({
             UIAlertAction *action = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                 NSLog(@"OK");
                 [self.navigationController popViewControllerAnimated:YES];
             }];
             
             action;
         })];
         
         [self presentViewController:alertController  animated:YES completion:nil];
         [self stopActivityIndicator];
     }
                                         failureBlock:^(id response, NSError *error)
     {
         [self stopActivityIndicator];
         if (error.code == NSURLErrorTimedOut) {
             
             [self showAlert:@"Connection timed out, please try again later"];
         }
         else
         {
             [self showAlert:@"Connectivity Error"];
         }
     }];
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
    [self startActivityIndicator:YES];
    
    
    NSString *baseURl = [NSString stringWithFormat:@"login/checkZipCodes/zip_code/%@",self.radiusLabel.text];
    
    [[BUWebServicesManager sharedManager] getqueryServer:nil
                                                 baseURL:baseURl
                                            successBlock:^(id response, NSError *error)
     {
         
         if([[[response valueForKey:@"msg"] lowercaseString] isEqualToString:@"success"])
         {
             [self.basicInfoDict setValue:self.radiusLabel.text forKey:@"current_zip_code"];
             [self.basicInfoDict setValue:[response valueForKey:@"country"] forKey:@"country_residing"];
             [self updateProfile];
         }
         else
         {
             [self stopActivityIndicator];
             self.radiusLabel.text = @"";
             [self stopActivityIndicator];
             [self showAlert:@"Invalid zip code"];
//             NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"Invalid zip code"];
//             [message addAttribute:NSFontAttributeName
//                             value:[UIFont fontWithName:@"comfortaa" size:15]
//                             range:NSMakeRange(0, message.length)];
//             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
//             [alertController setValue:message forKey:@"attributedTitle"];
//             
//             [alertController addAction:({
//                 UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
//                                          {
//                                              
//                                          }];
//                 
//                 action;
//             })];
//             
//             [self presentViewController:alertController  animated:YES completion:nil];
//             
//             
         }
         
     }
                                            failureBlock:^(id response, NSError *error)
     {
         
         self.radiusLabel.text = @"";
         
         [self stopActivityIndicator];
         if (error.code == NSURLErrorTimedOut) {
             
             [self showAlert:@"Connection timed out, please try again later"];
         }
         else
         {
             [self showAlert:@"Invalid zip code"];
//             NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"Invalid zip code"];
//             [message addAttribute:NSFontAttributeName
//                             value:[UIFont fontWithName:@"comfortaa" size:15]
//                             range:NSMakeRange(0, message.length)];
//             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
//             [alertController setValue:message forKey:@"attributedTitle"];
//             
//             [alertController addAction:({
//                 UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
//                                          {
//                                              
//                                          }];
//                 
//                 action;
//             })];
//             
//             [self presentViewController:alertController  animated:YES completion:nil];
//             
         }
         
     }];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if(textField.tag == 0)
        [self.basicInfoDict setValue:textField.text forKey:@"profile_first_name"];
    else
        
        //[self checkPinCode];
        [textField resignFirstResponder];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if(textField.tag == 0)
    {
        if ([string isEqualToString:@" "]) {
            return NO;
        }
        
    }
    
    return  YES;
}

#pragma mark - Gender selection

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
                [text appendFormat:@" %@", title];
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
    [self presentViewController:alertController  animated:YES completion:nil];
}

#pragma mark- Picker View Delegate
#pragma mark -
#pragma mark - Age selection

-(IBAction)setAge
{
    
    [self.view endEditing:YES];
    
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
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-yyyy"];
    
    if ([self.ageLabel.text isEqualToString:@""]) {
        picker.date = currentDate;
    }
    else {
        picker.date = [dateFormat dateFromString:self.ageLabel.text];
    }
    
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"OK");
            NSLog(@"%@",picker.date);
            
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
    [self presentViewController:alertController  animated:YES completion:nil];
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
    [self presentViewController:alertController  animated:YES completion:nil];
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


//-(void)updateProfile
//{
//    [self startActivityIndicator:YES];
//
//    NSDictionary *parameters = nil;
//    parameters = @{@"userid": [BUWebServicesManager sharedManager].userID,
//                   @"profile_gender": @"Male",
//                   @"height_feet": self.feetStr,
//                   @"height_inch":self.inchStr,
//                   @"maritial_status": self.maritalStatusTF.text,
//                   @"current_zip_code": self.radiusLabel.text,
//
//                   };
//
//    NSString *baseURl = @"http://app.thebureauapp.com/admin/update_profile_step1";
//    [[BUWebServicesManager sharedManager] queryServer:parameters
//                                              baseURL:baseURl
//                                         successBlock:^(id response, NSError *error)
//     {
//         [self stopActivityIndicator];
//
//     }
//                                         failureBlock:^(id response, NSError *error) {
//                                             [self stopActivityIndicator];
//                                         }
//     ];
//}


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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
