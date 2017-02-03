//
//  HeritageDetails.m
//  TheBureau
//
//  Created by Ama1's iMac on 01/08/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "HeritageDetails.h"

@interface HeritageDetails ()

@end

@implementation HeritageDetails

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Heritage";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(editProfileDetails:)];
    
    self.religionTF.text = [self.heritageDict valueForKey:@"religion_name"];
    self.motherToungueTF.text = [self.heritageDict valueForKey:@"mother_tongue"];
    self.familyOriginTF.text = [self.heritageDict valueForKey:@"family_origin_name"];
    self.specificationTF.text = [self.heritageDict valueForKey:@"specification_name"];
    self.gothraTF.text = [self.heritageDict valueForKey:@"gothra"];
    
    
    self.religionID = [self.heritageDict valueForKey:@"religion_id"];
    self.motherToungueID = [self.heritageDict valueForKey:@"mother_tongue_id"];
    self.famliyID = [self.heritageDict valueForKey:@"family_origin_id"];
    self.specificationID = [self.heritageDict valueForKey:@"specification_id"];
    
}

- (IBAction)editProfileDetails:(id)sender
{
    [self.view endEditing:YES];
    [self updateProfile];
    //    [self.profileTableView reloadData];
}

-(void)updateProfile
{
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    
    //    [parameters addEntriesFromDictionary:self.basicInfoDict];
    //    [parameters addEntriesFromDictionary:self.educationInfo];
//    [parameters addEntriesFromDictionary:self.occupationInfoDict];
    //    [parameters addEntriesFromDictionary:self.horoscopeDict];
    //    [parameters addEntriesFromDictionary:self.socialHabitsDict];
    //    [parameters addEntriesFromDictionary:self.legalStatus];
        [parameters addEntriesFromDictionary:self.heritageDict];
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
             
             [self timeoutError:@"Connection timed out, please try again later"];
         }
         else
         {
             [self showAlert:@"Connectivity Error"];
         }
     }];
}

-(void)showPickerWithDataSource:(id)inResult
{
    [self stopActivityIndicator];
    
    UIStoryboard *sb =[UIStoryboard storyboardWithName:@"CustomPicker" bundle:nil];
    self.customPickerView = [sb instantiateViewControllerWithIdentifier:@"PWCustomPickerView"];
    self.customPickerView.allowMultipleSelection = NO;
    self.customPickerView.pickerDataSource = inResult;
    self.customPickerView.selectedHeritage = self.heritageList;
    [self.customPickerView showCusptomPickeWithDelegate:self];
    self.customPickerView.titleLabel.text = @"Heritage";
}

-(void)showFailureAlert
{
    [self startActivityIndicator:YES];
    [self showAlert:@"Connectivity Error"];
   // NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:];
   // [message addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"comfortaa" size:15]                   range:NSMakeRange(0, message.length)];
   // UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
   // [alertController setValue:message forKey:@"attributedTitle"];
   // [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
   // [self presentViewController:alertController animated:YES completion:nil];
}

-(IBAction)getReligion:(id)sender
{
    [self startActivityIndicator:YES];
    self.heritageList = eReligionList;
    [[BUWebServicesManager sharedManager] getqueryServer:nil baseURL:@"read/religion"
                                            successBlock:^(id response, NSError *error) {
                                                [self showPickerWithDataSource:response];
                                            } failureBlock:^(id response, NSError *error) {
                                                [self showFailureAlert];
                                                
                                            }];

}


-(IBAction)getMotherToungue:(id)sender
{
    NSDictionary *parameters = nil;
    [self startActivityIndicator:YES];
    self.heritageList = eMotherToungueList;
    [[BUWebServicesManager sharedManager] getqueryServer:nil
                                                 baseURL:@"read/mother_tongue"
                                            successBlock:^(id response, NSError *error) {
                                                [self showPickerWithDataSource:response];
                                            } failureBlock:^(id response, NSError *error) {
                                                [self showFailureAlert];
                                                
                                            }];
}

-(IBAction)getSpecificationList:(id)sender
{
    
    
    if(nil == self.famliyID || [self.famliyID isEqualToString:@""])
    {
        NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"Please Select Family Origin"];
        [message addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"comfortaa" size:15]
                        range:NSMakeRange(0, message.length)];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController setValue:message forKey:@"attributedTitle"];
        
        [alertController addAction:({
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }];
            action;
        })];
        
        
        if(nil != self.parentVC)
            [self.navigationController presentViewController:alertController  animated:YES completion:nil];
        else
            [self.prefVC.navigationController presentViewController:alertController  animated:YES completion:nil];
        
    }
    else
    {
        self.heritageList = eSpecificationList;
        NSString *baseUrl = [NSString stringWithFormat:@"read/specification/family_origin_id/%@",self.famliyID];
        [self.parentVC startActivityIndicator:YES];
        [[BUWebServicesManager sharedManager] getqueryServer:nil baseURL:baseUrl
                                                successBlock:^(id response, NSError *error) {
                                                    [self showPickerWithDataSource:response];
                                                    
                                                } failureBlock:^(id response, NSError *error) {
                                                    [self showFailureAlert];
                                                    
                                                }];
    }
}

-(IBAction)getFamilyOrigin:(id)sender
{
    if(nil == self.religionID || [self.religionID isEqualToString:@""])
    {
        NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"Please Select Relegion"];
        [message addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"comfortaa" size:15]
                        range:NSMakeRange(0, message.length)];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController setValue:message forKey:@"attributedTitle"];
        
        [alertController addAction:({
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }];
            action;
        })];
        
        if(nil != self.parentVC)
            [self.navigationController presentViewController:alertController  animated:YES completion:nil];
        else
            [self.prefVC.navigationController presentViewController:alertController  animated:YES completion:nil];
        
    }
    else
    {
        self.heritageList = eFamilyOriginList;
        [self startActivityIndicator:YES];
        NSString *baseUrl = [NSString stringWithFormat:@"read/family_origin/religion_id/%@",self.religionID];
        
        [[BUWebServicesManager sharedManager] getqueryServer:nil baseURL:baseUrl
                                                successBlock:^(id response, NSError *error) {
                                                    [self showPickerWithDataSource:response];
                                                } failureBlock:^(id response, NSError *error) {
                                                    [self showFailureAlert];
                                                    
                                                }];
    }
}


- (void)didItemSelected:(NSMutableDictionary *)inSelectedRow
{
    
    /*
     
     self.religionTF.text = [self.heritageDict valueForKey:@"religion_name"];
     self.motherToungueTF.text = [self.heritageDict valueForKey:@"mother_tongue"];
     self.familyOriginTF.text = [self.heritageDict valueForKey:@"family_origin_name"];
     self.specificationTF.text = [self.heritageDict valueForKey:@"specification_name"];
     self.gothraTF.text = [self.heritageDict valueForKey:@"gothra"];
     
     */
    
    switch (self.heritageList)
    {
        case eReligionList:
        {
            self.religionTF.text = [inSelectedRow valueForKey:@"religion_name"];
            self.religionID = [inSelectedRow valueForKey:@"religion_id"];
            
            [self.heritageDict setValue:[inSelectedRow valueForKey:@"religion_name"] forKey:@"religion_name"];
            [self.heritageDict setValue:[inSelectedRow valueForKey:@"religion_id"] forKey:@"religion_id"];
            
            
            self.familyOriginTF.text = @"";
            self.specificationTF.text = @"";
            self.gothraTF.text = @"";
            self.famliyID = @"";
            self.specificationID = @"";
            
            [self.heritageDict setObject:@"" forKey:@"family_origin_name"];
            [self.heritageDict setObject:@"" forKey:@"specification_name"];
            [self.heritageDict setObject:@"" forKey:@"gothra"];
            [self.heritageDict setObject:@"" forKey:@"family_origin_id"];
            [self.heritageDict setObject:@"" forKey:@"specification_id"];
            
            break;
        }
        case eMotherToungueList:
        {
            self.motherToungueTF.text = [inSelectedRow valueForKey:@"mother_tongue"];
            self.motherToungueID = [inSelectedRow valueForKey:@"mother_tongue_id"];
            [self.heritageDict setValue:[inSelectedRow valueForKey:@"mother_tongue"] forKey:@"mother_tongue"];
            [self.heritageDict setValue:[inSelectedRow valueForKey:@"mother_tongue_id"] forKey:@"mother_tongue_id"];
            
            break;
        }
        case eFamilyOriginList:
        {
            
            self.familyOriginTF.text = [inSelectedRow valueForKey:@"family_origin_name"];
            self.famliyID = [inSelectedRow valueForKey:@"family_origin_id"];
            [self.heritageDict setValue:[inSelectedRow valueForKey:@"family_origin_name"] forKey:@"family_origin_name"];
            [self.heritageDict setValue:[inSelectedRow valueForKey:@"family_origin_id"] forKey:@"family_origin_id"];
            
            
            [self.heritageDict setObject:@"" forKey:@"specification_name"];
            [self.heritageDict setObject:@"" forKey:@"gothra"];
            
            [self.heritageDict setObject:@"" forKey:@"specification_id"];
            
            self.specificationTF.text = @"";
            self.specificationID = @"";
            self.gothraTF.text = @"";
            
            break;
        }
        case eSpecificationList:
        {
            self.specificationTF.text = [inSelectedRow valueForKey:@"specification_name"];
            self.specificationID = [inSelectedRow valueForKey:@"specification_id"];
            [self.heritageDict setValue:[inSelectedRow valueForKey:@"specification_name"] forKey:@"specification_name"];
            [self.heritageDict setValue:[inSelectedRow valueForKey:@"specification_id"] forKey:@"specification_id"];
            
            [self.heritageDict setValue:@"" forKey:@"gothra"];
            
            self.gothraTF.text = @"";
            break;
        }
        case eGothraList:
        {
            
            break;
        }
            
        default:
            break;
    }
    
    
    NSDictionary *prefDict1 = [[NSUserDefaults standardUserDefaults] valueForKey:@"Preferences"];
    NSMutableDictionary *preferenceDict = [[NSMutableDictionary alloc]initWithDictionary:prefDict1];
    
    [preferenceDict setValue:self.religionID forKey:@"religion_id"];
    [preferenceDict setValue:self.motherToungueID forKey:@"mother_tongue_id"];
    [preferenceDict setValue:self.famliyID forKey:@"family_origin_id"];
    
    [[NSUserDefaults standardUserDefaults] setValue:preferenceDict forKey:@"Preferences"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self endEditing:YES];
//}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.heritageDict setValue:textField.text forKey:@"gothra"];
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.heritageDict setValue:textField.text forKey:@"gothra"];
}


-(void)setPreference:(NSMutableDictionary *)inBasicInfoDict
{
    self.heritageDict = inBasicInfoDict;
    self.religionTF.text = [self.heritageDict valueForKey:@"religion_name"];
    self.motherToungueTF.text = [self.heritageDict valueForKey:@"mother_tongue"];
    self.familyOriginTF.text = [self.heritageDict valueForKey:@"family_origin_name"];
    
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
