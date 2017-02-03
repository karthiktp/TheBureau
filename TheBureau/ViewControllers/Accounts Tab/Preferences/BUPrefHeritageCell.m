//
//  BUPrefHeritageCell.m
//  TheBureau
//
//  Created by Manjunath on 18/03/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUPrefHeritageCell.h"
#import "UIView+FLKAutoLayout.h"
#import "PWHeritageObj.h"


@implementation BUPrefHeritageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



#pragma mark - Picker View Data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    
    if(pickerView.tag == 0)
        return [self.religionList count];
    else if(pickerView.tag == 1)
        return [self.motherToungueList count];
    else
    return [self.famliyList count];
    
}

#pragma mark- Picker View Delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView.tag == 0)
        return [self.religionList objectAtIndex:row];
    else if(pickerView.tag == 1)
        return [self.motherToungueList objectAtIndex:row];
    else
    return [self.famliyList objectAtIndex:row];
}




-(IBAction)showReligionList:(id)inSender
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Selected Relegion\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.tag = 0;
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
        }];
        action;
    })];
    [self.prefVC presentViewController:alertController  animated:YES completion:nil];
    
}

-(IBAction)showMotherToungueList:(id)inSender
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Selected Mother toungue\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.tag = 1;
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
        }];
        action;
    })];
    [self.prefVC presentViewController:alertController  animated:YES completion:nil];
    
}

-(IBAction)showFamilyOriginList:(id)inSender
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Selected Family origin\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.tag = 2;
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
        }];
        action;
    })];
    [self.prefVC presentViewController:alertController  animated:YES completion:nil];
    
}

-(void)showPickerWithDataSource:(id)inResult withTitle:(NSString*)title
{
    [self.prefVC stopActivityIndicator];
    
    UIStoryboard *sb =[UIStoryboard storyboardWithName:@"CustomPicker" bundle:nil];
    self.customPickerView = [sb instantiateViewControllerWithIdentifier:@"BUCustomPickerView"];
    
    self.customPickerView.pickerDataSource = inResult;
    self.customPickerView.allowMultipleSelection = YES;
    self.customPickerView.selectedHeritage = self.heritageList;
    [self.customPickerView showCusptomPickeWithDelegate:self];
    self.customPickerView.titleLabel.text = title;
}

-(void)showFailureAlert
{
    [self.prefVC stopActivityIndicator];
    NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"Connectivity Error"];
    [message addAttribute:NSFontAttributeName
                    value:[UIFont fontWithName:@"comfortaa" size:15]
                    range:NSMakeRange(0, message.length)];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController setValue:message forKey:@"attributedTitle"];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self.prefVC presentViewController:alertController animated:YES completion:nil];
}

-(IBAction)getReligion:(id)sender
{
//    NSDictionary *parameters = nil;
//    [self.prefVC startActivityIndicator:YES];
    self.heritageList = eReligionList;
//    [[BUWebServicesManager sharedManager] getReligionListwithParameters:parameters successBlock:^(id response, NSError *error)
//     {
//         {
//             self.relList = [[NSMutableArray alloc] init];
//             for (NSDictionary *dict in response)
//             {
//                 PWHeritageObj *heritageObj = [[PWHeritageObj alloc] init];
//                 heritageObj.name = [dict valueForKey:@"religion_name"];
//                 heritageObj.hId = [dict valueForKey:@"religion_id"];
//                 heritageObj.isSelected = NO;
//                 
//                 for (NSString *idStr in self.religionIDList)
//                 {
//                     if([heritageObj.hId isEqualToString:idStr])
//                         heritageObj.isSelected = YES;
//                     
//                 }
//                 [self.relList addObject:heritageObj];
//             }
    
             [self showPickerWithDataSource:self.relList withTitle:@"Religion"];
             
//         }
    
         self.familyOriginTF.text = @"";
         [self.famliyIDList removeAllObjects];
         [self.famliyList removeAllObjects];

         
         [self.heritageDict setValue:self.religionIDList forKey:@"religion_id"];
         [self.heritageDict setValue:self.famliyIDList forKey:@"family_origin_id"];

         
//    } failureBlock:^(id response, NSError *error) {
//        [self showFailureAlert];
//        
//    }];
}


-(IBAction)getMotherToungue:(id)sender
{
//    NSDictionary *parameters = nil;
//    [self.prefVC startActivityIndicator:YES];
    self.heritageList = eMotherToungueList;
//    [[BUWebServicesManager sharedManager] getMotherTongueListwithParameters:parameters successBlock:^(id response, NSError *error)
//    {
//        {
//            self.mToungList = [[NSMutableArray alloc] init];
//            for (NSDictionary *dict in response)
//            {
//                PWHeritageObj *heritageObj = [[PWHeritageObj alloc] init];
//                heritageObj.name = [dict valueForKey:@"mother_tongue"];
//                heritageObj.hId = [dict valueForKey:@"mother_tongue_id"];
//                heritageObj.isSelected = NO;
//                
//                for (NSString *idStr in self.motherToungueIDList)
//                {
//                    if([heritageObj.hId isEqualToString:idStr])
//                        heritageObj.isSelected = YES;
//                    
//                }
//
//                [self.mToungList addObject:heritageObj];
//            }
    
            [self showPickerWithDataSource:self.mToungList withTitle:@"Mother Tongue"];
            
            
            
            
//        }
    
        [self.heritageDict setValue:self.famliyIDList forKey:@"family_origin_id"];
//    } failureBlock:^(id response, NSError *error) {
//        [self showFailureAlert];
//        
//    }];
}


-(IBAction)getFamilyOrigin:(id)sender
{
    if(nil == self.religionIDList || self.religionIDList.count == 0)
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
        [self.prefVC.navigationController presentViewController:alertController  animated:YES completion:nil];
    }
    else
    {
        self.heritageList = eFamilyOriginList;
        NSDictionary *parameters = nil;
        parameters = @{@"religionids": self.religionIDList};
        [self.prefVC startActivityIndicator:YES];
        [[BUWebServicesManager sharedManager] queryServer:parameters baseURL:@"read/family_origin_multiple_religions"
                                             successBlock:^(id response, NSError *error)
         {
             self.famList = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in response)
            {
                PWHeritageObj *heritageObj = [[PWHeritageObj alloc] init];
                heritageObj.name = [dict valueForKey:@"family_origin_name"];
                heritageObj.hId = [dict valueForKey:@"family_origin_id"];
                heritageObj.isSelected = NO;

                for (NSString *idStr in self.famliyIDList)
                {
                    if([heritageObj.hId isEqualToString:idStr])
                        heritageObj.isSelected = YES;
                    
                }
                [self.famList addObject:heritageObj];
            }
            
            [self showPickerWithDataSource:self.famList withTitle:@"Family Origin"];
            
        } failureBlock:^(id response, NSError *error) {
            [self showFailureAlert];
            
        }];
    }
}

- (void)didItemDeselectedSelected:(PWHeritageObj *)inSelectedRow;
{
    
    switch (self.heritageList)
    {
        case eReligionList:
        {
            
            [self.religionIDList removeObject:inSelectedRow.hId];
            [self.religionList removeObject:inSelectedRow.name];
            
            for (int b=0; b<[self.relgSelList count]; b++) {
                if ([[self.relgSelList objectAtIndex:b] objectForKey:@"religion_id"] == inSelectedRow.hId) {
                    [self.relgSelList removeObjectAtIndex:b];
                }
            }
            
            
            
            self.religionTF.text = @"";
            
            for(NSString *religinStr in self.religionList)
            {
                
                if([self.religionTF.text isEqualToString:@""])
                {
                    self.religionTF.text = religinStr;
                }
                else
                {
                    self.religionTF.text = [self.religionTF.text stringByAppendingFormat:@", %@",religinStr];
                }
            }
            

            break;
        }
        case eMotherToungueList:
        {
            [self.motherToungueIDList removeObject:inSelectedRow.hId];
            [self.motherToungueList removeObject:inSelectedRow.name];
            
            for (int b=0; b<[self.mTongSelList count]; b++) {
                if ([[self.mTongSelList objectAtIndex:b] objectForKey:@"mother_tongue_id"] == inSelectedRow.hId) {
                    [self.mTongSelList removeObjectAtIndex:b];
                }
            }
            
            
            self.motherToungueTF.text = @"";
            
            for(NSString *religinStr in self.motherToungueList)
            {
                
                if([self.motherToungueTF.text isEqualToString:@""])
                {
                    self.motherToungueTF.text = religinStr;
                }
                else
                {
                    self.motherToungueTF.text = [self.motherToungueTF.text stringByAppendingFormat:@", %@",religinStr];
                }
            }
            break;
        }
        case eFamilyOriginList:
        {
            
            self.familyOriginTF.text = [NSString stringWithFormat:@"%@",[self.familyOriginTF.text stringByReplacingOccurrencesOfString:inSelectedRow.name withString:@""]];
            
            [self.famliyIDList removeObject:inSelectedRow.hId];
            [self.famliyList removeObject:inSelectedRow.name];
            break;
        }
        default:
            break;
    }
    
    [self.heritageDict setValue:self.religionIDList forKey:@"religion_id"];
    [self.heritageDict setValue:self.motherToungueIDList forKey:@"mother_tongue_id"];
    [self.heritageDict setValue:self.famliyIDList forKey:@"family_origin_id"];
    [self.heritageDict setValue:self.mTongSelList forKey:@"mother_tongue_data"];
    [self.heritageDict setValue:self.relgSelList forKey:@"religion_data"];
    
}

- (void)didItemSelected:(PWHeritageObj *)inSelectedRow
{
    
    switch (self.heritageList)
    {
        case eReligionList:
        {
            if(nil == self.religionIDList)
                self.religionIDList = [[NSMutableArray alloc] init];
            
            if(nil == self.religionList)
                self.religionList = [[NSMutableArray alloc] init];

            [self.religionIDList addObject:inSelectedRow.hId];
            [self.religionList addObject:inSelectedRow.name];
            
            NSMutableDictionary *relMutDict = [[NSMutableDictionary alloc]init];
            
            [relMutDict setObject:inSelectedRow.hId forKey:@"religion_id"];
            [relMutDict setObject:inSelectedRow.name forKey:@"religion_name"];
            
            [self.relgSelList addObject:relMutDict];
            
            self.religionTF.text = @"";
            
            for(NSString *religinStr in self.religionList)
            {
                
                if([self.religionTF.text isEqualToString:@""])
                {
                    self.religionTF.text = religinStr;
                }
                else
                {
                    self.religionTF.text = [self.religionTF.text stringByAppendingFormat:@", %@",religinStr];
                }
            }

            
            break;
        }
        case eMotherToungueList:
        {
            
            if(nil == self.motherToungueIDList)
                self.motherToungueIDList = [[NSMutableArray alloc] init];

            if(nil == self.motherToungueList)
                self.motherToungueList = [[NSMutableArray alloc] init];

            
            [self.motherToungueIDList addObject:inSelectedRow.hId];
            [self.motherToungueList addObject:inSelectedRow.name];
            
            NSMutableDictionary *relMutDict = [[NSMutableDictionary alloc]init];
            
            [relMutDict setObject:inSelectedRow.hId forKey:@"mother_tongue_id"];
            [relMutDict setObject:inSelectedRow.name forKey:@"mother_tongue"];
            
            [self.mTongSelList addObject:relMutDict];
            
            self.motherToungueTF.text = @"";
            
            for(NSString *religinStr in self.motherToungueList)
            {
                
                if([self.motherToungueTF.text isEqualToString:@""])
                {
                    self.motherToungueTF.text = religinStr;
                }
                else
                {
                    self.motherToungueTF.text = [self.motherToungueTF.text stringByAppendingFormat:@", %@",religinStr];
                }
            }

            break;
        }
        case eFamilyOriginList:
        {
            
            if(nil == self.famliyIDList)
                self.famliyIDList = [[NSMutableArray alloc] init];
            
            if(nil == self.famliyList)
                self.famliyList = [[NSMutableArray alloc] init];

            
            
            self.familyOriginTF.text = [NSString stringWithFormat:@"%@   %@",self.familyOriginTF.text,inSelectedRow.name];
            [self.famliyIDList addObject:inSelectedRow.hId];
            [self.famliyList addObject:inSelectedRow.name];
            break;
        }
        default:
            break;
    }
    
    
    
    
    [self.heritageDict setValue:self.religionIDList forKey:@"religion_id"];
    [self.heritageDict setValue:self.motherToungueIDList forKey:@"mother_tongue_id"];
    [self.heritageDict setValue:self.famliyIDList forKey:@"family_origin_id"];
    [self.heritageDict setValue:self.mTongSelList forKey:@"mother_tongue_data"];
    [self.heritageDict setValue:self.relgSelList forKey:@"religion_data"];
    
}



-(void)setPreference:(NSMutableDictionary *)inBasicInfoDict
{
    /*
     family_origin_data":[{"family_origin_id":"1","family_origin_name":"Brahmin"}],
     "religion_data":[{"religion_id":"1","religion_name":"Hinduism"}],
     "mother_tongue_data":[{"mother_tongue_id":"4","mother_tongue":"Kannada"}]
     */
    

    
    self.heritageDict = inBasicInfoDict;
    self.famliyIDList = [[NSMutableArray alloc] init];
    self.famliyList = [[NSMutableArray alloc] init];
    
    if([[self.heritageDict valueForKey:@"family_origin_data"] count] > 0)
    {
        
        for(NSDictionary *originDict in [self.heritageDict valueForKey:@"family_origin_data"])
        {
            
            if([self.familyOriginTF.text isEqualToString:@""])
            {
                self.familyOriginTF.text = [originDict valueForKey:@"family_origin_name"];
            }
            else
            {
                self.familyOriginTF.text = [self.familyOriginTF.text stringByAppendingFormat:@", %@",[originDict valueForKey:@"family_origin_name"]];
            }
        }
    }

    
    for (NSDictionary *familyOriginDict in [self.heritageDict valueForKey:@"family_origin_data"])
    {
        [self.famliyIDList addObject:[familyOriginDict valueForKey:@"family_origin_id"]];
        [self.famliyList addObject:[familyOriginDict valueForKey:@"family_origin_name"]];
    }
    
    
    self.religionIDList = [[NSMutableArray alloc] init];
    self.religionList = [[NSMutableArray alloc] init];
    
    self.relgSelList = [[NSMutableArray alloc] init];
    /*
     
     "mother_tongue_data" =     (
     {
     "mother_tongue" = "No Preference";
     "mother_tongue_id" = 21;
     }
     );
     "religion_data" =     (
     {
     "religion_id" = 11;
     "religion_name" = "No Preference";
     }
     );

     
     */
    
    self.relgSelList = [[self.heritageDict valueForKey:@"religion_data"] mutableCopy];
    
    NSArray *relAr = [self.heritageDict valueForKey:@"religion_data"];
    
    if ([relAr count]==1) {
        NSDictionary *dict = [relAr objectAtIndex:0];
        if ([[dict objectForKey:@"religion_name"] isEqualToString:@"No Preference"]) {
            relAr = [[self.heritageDict valueForKey:@"religion"] mutableCopy];
        }
    }
    
    NSLog(@"%@",relAr);
    
    for (int k=0; k<[relAr count]; k++) {
        NSDictionary *dict = [relAr objectAtIndex:k];
        [self.religionIDList addObject:[dict valueForKey:@"religion_id"]];
        [self.religionList addObject:[dict valueForKey:@"religion_name"]];
    }
    
    NSLog(@"%@",self.religionIDList);
    
    self.relList = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in [self.heritageDict valueForKey:@"religion"])
    {
        PWHeritageObj *heritageObj = [[PWHeritageObj alloc] init];
        heritageObj.name = [dict valueForKey:@"religion_name"];
        heritageObj.hId = [dict valueForKey:@"religion_id"];
        heritageObj.isSelected = NO;
        
        for (NSString *idStr in self.religionIDList)
        {
            if([heritageObj.hId isEqualToString:idStr])
                heritageObj.isSelected = YES;
            
        }
        [self.relList addObject:heritageObj];
    }
    
    NSLog(@"%@",self.relList);
    
    if([[self.heritageDict valueForKey:@"religion_data"] count] > 0)
    {
        
        for(NSDictionary *originDict in relAr)
        {
            
            if([self.religionTF.text isEqualToString:@""])
            {
                self.religionTF.text = [originDict valueForKey:@"religion_name"];
            }
            else
            {
                self.religionTF.text = [self.religionTF.text stringByAppendingFormat:@", %@",[originDict valueForKey:@"religion_name"]];
            }
        }
    }
    
//    for (NSDictionary *familyOriginDict in [self.heritageDict valueForKey:@"religion_data"])
//    {
//        [self.religionIDList addObject:[familyOriginDict valueForKey:@"religion_id"]];
//        [self.religionList addObject:[familyOriginDict valueForKey:@"religion_name"]];
//    }


    self.motherToungueIDList = [[NSMutableArray alloc] init];
    self.motherToungueList = [[NSMutableArray alloc] init];
    self.mToungList = [[NSMutableArray alloc]init];
    self.mTongSelList = [[NSMutableArray alloc] init];
    
    NSArray *mothtonAr = [self.heritageDict valueForKey:@"mother_tongue_data"];
    
    if ([mothtonAr count]==1) {
        NSDictionary *dict = [mothtonAr objectAtIndex:0];
        if ([[dict objectForKey:@"mother_tongue"] isEqualToString:@"No Preference"]) {
            mothtonAr = [[self.heritageDict valueForKey:@"mother_tongue"] mutableCopy];
        }
    }
    
    NSLog(@"%@",mothtonAr);
    
    self.mTongSelList = [[self.heritageDict valueForKey:@"mother_tongue_data"] mutableCopy];
    
    for (int k=0; k<[mothtonAr count]; k++) {
        NSDictionary *dict = [mothtonAr objectAtIndex:k];
        [self.motherToungueIDList addObject:[dict valueForKey:@"mother_tongue_id"]];
        [self.motherToungueList addObject:[dict valueForKey:@"mother_tongue"]];
    }
    
    NSLog(@"%@",self.motherToungueIDList);
    
    for (NSDictionary *dict in [self.heritageDict objectForKey:@"mother_tongue"])
    {
        PWHeritageObj *heritageObj = [[PWHeritageObj alloc] init];
        heritageObj.name = [dict valueForKey:@"mother_tongue"];
        heritageObj.hId = [dict valueForKey:@"mother_tongue_id"];
        heritageObj.isSelected = NO;
        
        for (NSString *idStr in self.motherToungueIDList)
        {
            if([heritageObj.hId isEqualToString:idStr])
                heritageObj.isSelected = YES;
            
        }
        
        [self.mToungList addObject:heritageObj];
    }
    
    
    NSLog(@"%@",self.mToungList);
    
    if([[self.heritageDict valueForKey:@"mother_tongue_data"] count] > 0)
    {
        for(NSDictionary *originDict in mothtonAr)
        {
            if([self.motherToungueTF.text isEqualToString:@""])
            {
                self.motherToungueTF.text = [originDict valueForKey:@"mother_tongue"];
            }
            else
            {
                self.motherToungueTF.text = [self.motherToungueTF.text stringByAppendingFormat:@", %@",[originDict valueForKey:@"mother_tongue"]];
            }
        }
    }
    
    
//    for (NSDictionary *familyOriginDict in [self.heritageDict valueForKey:@"mother_tongue_data"])
//    {
//        [self.motherToungueIDList addObject:[familyOriginDict valueForKey:@"mother_tongue_id"]];
//        [self.motherToungueList addObject:[familyOriginDict valueForKey:@"mother_tongue"]];
//    }

    [self.heritageDict setValue:self.religionIDList forKey:@"religion_id"];
    [self.heritageDict setValue:self.motherToungueIDList forKey:@"mother_tongue_id"];
    [self.heritageDict setValue:self.famliyIDList forKey:@"family_origin_id"];
    [self.heritageDict setValue:self.mTongSelList forKey:@"mother_tongue_data"];
    [self.heritageDict setValue:self.relgSelList forKey:@"religion_data"];
}
@end
