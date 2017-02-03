//
//  HighLevelEducationTVCell.m
//  SampleUI
//
//  Created by Sarath Neeravallil Sasi on 04/02/16.
//  Copyright © 2016 Sarath Neeravallil Sasi. All rights reserved.
//

#import "HighLevelEducationTVCell.h"

@implementation HighLevelEducationTVCell

- (void)awakeFromNib
{
    
}

-(void)updateBtnStatus:(NSDictionary*)dataSource {
    if (![[dataSource objectForKey:@"employment_status"] isEqualToString:@""]) {
    if(self.educationLevel == 1) {
        self.educationlevelLbl.text = [self.dataSourceDict objectForKey:@"highest_education"];
        self.honorTextField.text = [self.dataSourceDict objectForKey:@"honors"];
        self.majorTextField.text = [self.dataSourceDict objectForKey:@"major"];
        self.collegeTextField.text = [self.dataSourceDict objectForKey:@"college"];
        self.yearTextField.text = [self.dataSourceDict objectForKey:@"graduated_year"];
        
        if ([[self.dataSourceDict objectForKey:@"education_second"] length]) {
            [self.addEducationLevelBtn setTitle:@"Remove 2nd Level" forState:UIControlStateNormal];
        }
    }
    else {
        self.educationlevelLbl.text = [self.dataSourceDict objectForKey:@"education_second"] ? [self.dataSourceDict objectForKey:@"education_second"] : @"";
        self.honorTextField.text = [self.dataSourceDict objectForKey:@"honors_second"] ? [self.dataSourceDict objectForKey:@"honors_second"] : @"";
        self.majorTextField.text = [self.dataSourceDict objectForKey:@"majors_second"] ? [self.dataSourceDict objectForKey:@"majors_second"] : @"";
        self.collegeTextField.text = [self.dataSourceDict objectForKey:@"college_second"] ? [self.dataSourceDict objectForKey:@"college_second"] : @"";
        self.yearTextField.text = [self.dataSourceDict objectForKey:@"graduation_years_second"] ? [self.dataSourceDict objectForKey:@"graduation_years_second"] : @"";

    }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (IBAction)addSecondLevelButtonTapped:(id)sender
{
    
    NSString *string = [sender titleLabel].text;
    if ([string rangeOfString:@"Remove"].location == NSNotFound) {
        NSLog(@"string does not contain Remove");
        [sender setTitle:@"Remove 2nd Level" forState:UIControlStateNormal];
    } else {
        NSLog(@"string contains Remove!");
        [sender setTitle:@"Add 2nd Level" forState:UIControlStateNormal];
    }
    
    [self.delegate addNextLevelButtonTapped];
    //self.addEducationLevelBtn.hidden = YES;
}

- (IBAction)HighLevelEducationButtonTapped:(id)sender
{
    [self.delegate updateHighLevelEducationTVCell :_indexpath];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.delegate slideTableUp];
   return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    [self.delegate slideTableDown];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(self.educationLevel == 1)
    {
        switch(textField.tag)
        {
            case 0:
            {
                [self.dataSourceDict setValue:textField.text forKey:@"honors"];
                break;
            }
            case 1:
            {
                [self.dataSourceDict setValue:textField.text forKey:@"major"];
                break;
            }
            case 2:
            {
                [self.dataSourceDict setValue:textField.text forKey:@"college"];
                break;
            }
            case 3:
            {
                [self.dataSourceDict setValue:textField.text forKey:@"graduated_year"];
                break;
            }
        }
    }
    else
    {
        switch(textField.tag)
        {
            case 0:
            {
                [self.dataSourceDict setValue:textField.text forKey:@"honors_second"];
                break;
            }
            case 1:
            {
                [self.dataSourceDict setValue:textField.text forKey:@"majors_second"];
                break;
            }
            case 2:
            {
                [self.dataSourceDict setValue:textField.text forKey:@"college_second"];
                break;
            }
            case 3:
            {
                [self.dataSourceDict setValue:textField.text forKey:@"graduation_years_second"];
                break;
            }
        }
    }
    
    [textField resignFirstResponder];
    [self.delegate slideTableDown];
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.delegate slideTableDown];
    [self endEditing:YES];
}

@end
