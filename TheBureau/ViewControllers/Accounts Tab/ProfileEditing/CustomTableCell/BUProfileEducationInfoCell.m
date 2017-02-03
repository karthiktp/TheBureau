//
//  BUProfileEducationInfoCell.m
//  TheBureau
//
//  Created by Manjunath on 25/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUProfileEducationInfoCell.h"

@implementation BUProfileEducationInfoCell

- (void)awakeFromNib {
    // Initialization code
    _educationLevelArray = [[NSArray alloc]initWithObjects:@"Doctorate",@"Masters",@"Bachelors",@"Associates",@"Grade School", nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    switch ([textField tag])
    {
        case 0:
        {
            [self.educationInfo setValue:textField.text forKey:@"honors"];
            break;
        }
        case 1:
        {
            [self.educationInfo setValue:textField.text forKey:@"major"];
            break;
        }
        case 2:
        {
            [self.educationInfo setValue:textField.text forKey:@"college"];
            break;
        }
        case 3:
        {
            [self.educationInfo setValue:textField.text forKey:@"graduated_year"];
            break;
        }
        case 4:
        {
            [self.educationInfo setValue:textField.text forKey:@"honors_second"];
            break;
        }
        case 5:
        {
            [self.educationInfo setValue:textField.text forKey:@"majors_second"];
            break;
        }
        case 6:
        {
            [self.educationInfo setValue:textField.text forKey:@"college_second"];
            break;
        }
        case 7:
        {
            [self.educationInfo setValue:textField.text forKey:@"graduation_years_second"];
            break;
        }
            
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    switch ([textField tag])
    {
        case 0:
        {
            [self.educationInfo setValue:textField.text forKey:@"honors"];
            break;
        }
        case 1:
        {
            [self.educationInfo setValue:textField.text forKey:@"major"];
            break;
        }
        case 2:
        {
            [self.educationInfo setValue:textField.text forKey:@"college"];
            break;
        }
        case 3:
        {
            [self.educationInfo setValue:textField.text forKey:@"graduated_year"];
            break;
        }
        case 4:
        {
            [self.educationInfo setValue:textField.text forKey:@"honors_second"];
            break;
        }
        case 5:
        {
            [self.educationInfo setValue:textField.text forKey:@"majors_second"];
            break;
        }
        case 6:
        {
            [self.educationInfo setValue:textField.text forKey:@"college_second"];
            break;
        }
        case 7:
        {
            [self.educationInfo setValue:textField.text forKey:@"graduation_years_second"];
            break;
        }
            
        default:
            break;
    }
    


    


    return YES;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0)
    {
        if(actionSheet.tag == 101)
        {
            self.educationlevelLbl.text = _educationLevelArray[buttonIndex - 1];
            [self.educationInfo setValue:self.educationlevelLbl.text forKey:@"highest_education"];
        }
        else if(actionSheet.tag == 102)
        {
            self.educationlevelLbl2.text = _educationLevelArray[buttonIndex - 1];
            [self.educationInfo setValue:self.educationlevelLbl2.text forKey:@"education_second"];
        }
    }
}


#pragma mark -
#pragma mark - Education selection

-(IBAction)selectEducationLevel{
    UIActionSheet *acSheet = [[UIActionSheet alloc] initWithTitle:@"Select Education Level" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: nil];
    
    acSheet.tag = 101;
    for (NSString *str in _educationLevelArray)
    {
        [acSheet addButtonWithTitle:str];
    }
    
    [acSheet showInView:self.parentVC.view];
    
}



-(IBAction)selectSecondaryEducationLevel{
    UIActionSheet *acSheet = [[UIActionSheet alloc] initWithTitle:@"Select Education Level" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: nil];
    
    acSheet.tag = 102;
    for (NSString *str in _educationLevelArray)
    {
        [acSheet addButtonWithTitle:str];
    }
    
    [acSheet showInView:self.parentVC.view];
    
}


-(void)updateProfile
{
    
}

-(void)setDatasource:(NSMutableDictionary *)inBasicInfoDict
{
    self.educationInfo = inBasicInfoDict;
   self.educationlevelLbl.text = [inBasicInfoDict valueForKey:@"highest_education"];
   self.honorTextField.text =     [inBasicInfoDict valueForKey:@"honors"];
   self.majorTextField.text =     [inBasicInfoDict valueForKey:@"major"];
   self.collegeTextField.text =     [inBasicInfoDict valueForKey:@"college"];
   self.yearTextField.text =     [inBasicInfoDict valueForKey:@"graduated_year"];

    
    self.educationlevelLbl2.text = [inBasicInfoDict valueForKey:@"education_second"];
    self.honorTextField2.text =     [inBasicInfoDict valueForKey:@"honors_second"];
    self.majorTextField2.text =     [inBasicInfoDict valueForKey:@"majors_second"];
    self.collegeTextField2.text =     [inBasicInfoDict valueForKey:@"college_second"];
    self.yearTextField2.text =     [inBasicInfoDict valueForKey:@"graduation_years_second"];

    
}

@end
