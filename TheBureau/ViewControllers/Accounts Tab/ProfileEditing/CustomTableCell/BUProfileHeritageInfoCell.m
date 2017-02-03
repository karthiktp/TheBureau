//
//  BUProfileHeritageInfoCell.m
//  TheBureau
//
//  Created by Manjunath on 25/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUProfileHeritageInfoCell.h"

@implementation BUProfileHeritageInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDatasource:(NSMutableDictionary *)inBasicInfoDict
{
    self.heritageDict = inBasicInfoDict;
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


-(void)showPickerWithDataSource:(id)inResult
{
    [self.parentVC stopActivityIndicator];
    
    UIStoryboard *sb =[UIStoryboard storyboardWithName:@"CustomPicker" bundle:nil];
    self.customPickerView = [sb instantiateViewControllerWithIdentifier:@"PWCustomPickerView"];
    self.customPickerView.allowMultipleSelection = NO;
    self.customPickerView.pickerDataSource = inResult;
    self.customPickerView.selectedHeritage = self.heritageList;
    [self.customPickerView showCusptomPickeWithDelegate:self];
    self.customPickerView.titleLabel.text = @"Heritage";
}

-(void)showFailureAlert {
    [self.parentVC stopActivityIndicator];
    [self.parentVC showAlert:@"Connectivity Error"];
}

-(IBAction)getReligion:(id)sender
{
    [self.parentVC startActivityIndicator:YES];
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
    [self.parentVC startActivityIndicator:YES];
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
            [self.parentVC.navigationController presentViewController:alertController  animated:YES completion:nil];
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
        NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"Please Select Religion"];
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
            [self.parentVC.navigationController presentViewController:alertController  animated:YES completion:nil];
        else
            [self.prefVC.navigationController presentViewController:alertController  animated:YES completion:nil];

    }
    else
    {
        self.heritageList = eFamilyOriginList;
        [self.parentVC startActivityIndicator:YES];
       
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
            
            self.specificationTF.text = @"";
            self.specificationID = @"";

            break;
        }
        case eSpecificationList:
        {
            self.specificationTF.text = [inSelectedRow valueForKey:@"specification_name"];
            self.specificationID = [inSelectedRow valueForKey:@"specification_id"];
            [self.heritageDict setValue:[inSelectedRow valueForKey:@"specification_name"] forKey:@"specification_name"];
            [self.heritageDict setValue:[inSelectedRow valueForKey:@"specification_id"] forKey:@"specification_id"];
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
@end
