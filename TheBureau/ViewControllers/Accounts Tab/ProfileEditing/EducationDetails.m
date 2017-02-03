//
//  EducationDetails.m
//  TheBureau
//
//  Created by Ama1's iMac on 01/08/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "EducationDetails.h"

@interface EducationDetails ()

@end

@implementation EducationDetails

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Education";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(editProfileDetails:)];
    
    _educationLevelArray = [[NSArray alloc]initWithObjects:@"Doctorate",@"Masters",@"Bachelors",@"Associates",@"Grade School", nil];
    
    self.educationlevelLbl.text = [self.educationInfo valueForKey:@"highest_education"];
    self.honorTextField.text =     [self.educationInfo valueForKey:@"honors"];
    self.majorTextField.text =     [self.educationInfo valueForKey:@"major"];
    self.collegeTextField.text =     [self.educationInfo valueForKey:@"college"];
    self.yearTextField.text =     [self.educationInfo valueForKey:@"graduated_year"];
    
    self.educationlevelLbl2.text = [self.educationInfo valueForKey:@"education_second"];
    self.honorTextField2.text =     [self.educationInfo valueForKey:@"honors_second"];
    self.majorTextField2.text =     [self.educationInfo valueForKey:@"majors_second"];
    self.collegeTextField2.text =     [self.educationInfo valueForKey:@"college_second"];
    self.yearTextField2.text =     [self.educationInfo valueForKey:@"graduation_years_second"];
    
}

- (IBAction)editProfileDetails:(id)sender
{
    [self.view endEditing:YES];
    [self updateProfile];
    //    [self.profileTableView reloadData];
}

-(void)updateProfile {
    
    //NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    
    NSLog(@"%@,%lu",[self.educationInfo objectForKey:@"graduated_year"],[[self.educationInfo objectForKey:@"graduated_year"] length]);
    
    if ([[self.educationInfo objectForKey:@"graduated_year"] length]) {
        if (([[self.educationInfo objectForKey:@"graduated_year"] length] != 4)) {
            
            [self.educationInfo setObject:@"" forKey:@"graduated_year"];
            
            NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"Please provide valid year"];
            [message addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName:@"comfortaa" size:15]
                            range:NSMakeRange(0, message.length)];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController setValue:message forKey:@"attributedTitle"];
            [alertController addAction:({
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    NSLog(@"OK");
                }];
                
                action;
            })];
            
            [self presentViewController:alertController  animated:YES completion:nil];
            
            return;
        }
    }
    
    NSLog(@"%@,%lu",[self.educationInfo objectForKey:@"graduation_years_second"],[[self.educationInfo objectForKey:@"graduation_years_second"] length]);
    
    if ([self.educationInfo objectForKey:@"graduation_years_second"]) {
        if ([[self.educationInfo objectForKey:@"graduation_years_second"] length]) {
            if (([[self.educationInfo objectForKey:@"graduation_years_second"] length] != 4)) {
                
                [self.educationInfo setObject:@"" forKey:@"graduation_years_second"];
                
                NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"Please provide valid year"];
                [message addAttribute:NSFontAttributeName
                                value:[UIFont fontWithName:@"comfortaa" size:15]
                                range:NSMakeRange(0, message.length)];
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
                
                [alertController setValue:message forKey:@"attributedTitle"];
                [alertController addAction:({
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        NSLog(@"OK");
                    }];
                    
                    action;
                })];
                
                [self presentViewController:alertController  animated:YES completion:nil];
                
                return;
            }
        }
    }

    
    //    [self.profileImageCell saveProfileImages];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    
//    [parameters addEntriesFromDictionary:self.basicInfoDict];
        [parameters addEntriesFromDictionary:self.educationInfo];
    //    [parameters addEntriesFromDictionary:self.occupationDict];
    //    [parameters addEntriesFromDictionary:self.horoscopeDict];
    //    [parameters addEntriesFromDictionary:self.socialHabitsDict];
    //    [parameters addEntriesFromDictionary:self.legalStatus];
    //    [parameters addEntriesFromDictionary:self.heritageDict];
    
    [parameters setValue:[BUWebServicesManager sharedManager].userID forKey:@"userid"];
    
    [self startActivityIndicator:YES];
    
    [[BUWebServicesManager sharedManager] queryServer:parameters
                                              baseURL:@"profile/update"
                                         successBlock:^(id response, NSError *error)
     {
         [self stopActivityIndicator];
         
         
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
    
    [acSheet showInView:self.view];
    
}



-(IBAction)selectSecondaryEducationLevel{
    UIActionSheet *acSheet = [[UIActionSheet alloc] initWithTitle:@"Select Education Level" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: nil];
    
    acSheet.tag = 102;
    for (NSString *str in _educationLevelArray)
    {
        [acSheet addButtonWithTitle:str];
    }
    
    [acSheet showInView:self.view];
    
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
