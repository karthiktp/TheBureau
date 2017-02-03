
//
//  BUProfileHeritageVC.m
//  TheBureau
//
//  Created by Manjunath on 25/01/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUProfileHeritageVC.h"
#import "BUProfileOccupationVC.h"
#import "BUProfileDietVC.h"

@interface BUProfileHeritageVC ()
@property(nonatomic, strong) PWCustomPickerView *customPickerView;
@property(nonatomic, strong) NSString *religionID,*famliyID,*specificationID,*motherToungueID;

@property(nonatomic, strong) IBOutlet UITextField *religionTF,*motherToungueTF,*specificationTF,*gothraTF,*familyOriginTF;

@property(nonatomic) eHeritageList heritageList;
@property(nonatomic, assign) BOOL isUpdatingProfile;
@end

@implementation BUProfileHeritageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isDirect == YES) {
        self.navigationController.navigationBarHidden = NO;
        //self.navigationItem.hidesBackButton = YES;
    }
//    else {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(viewPopOnBackButton)];
        self.navigationItem.leftBarButtonItem = backButton;
//    }
    
    self.title = [NSString stringWithFormat:@"%@'s Heritage",[[NSUserDefaults standardUserDefaults]objectForKey:@"uName"]];
    
    
    
    self.gothraTF.enabled = YES;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%0.0f",self.scrollBottomConstraint.constant);
    
    if (self.isDirect == YES) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"profileDetails"]) {
            
            NSDictionary *profDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"profileDetails"];
            
            self.religionTF.text = [profDict objectForKey:@"religion_name"];
            self.religionID = [NSString stringWithFormat:@"%@",[profDict objectForKey:@"religion_id"]];
            
            self.motherToungueTF.text = [profDict objectForKey:@"mother_tongue"];
            self.motherToungueID = [[profDict objectForKey:@"mother_tongue_id"] isEqualToString:@""] ? nil : [NSString stringWithFormat:@"%@",[profDict objectForKey:@"mother_tongue_id"]];
            
            self.familyOriginTF.text = [profDict objectForKey:@"family_origin_name"];
            self.famliyID = [[profDict objectForKey:@"family_origin_id"] isEqualToString:@""] ? nil : [NSString stringWithFormat:@"%@",[profDict objectForKey:@"family_origin_id"]];
            
            self.specificationTF.text = [profDict objectForKey:@"specification_name"];
            self.specificationID = [[profDict objectForKey:@"specification_id"] isEqualToString:@""] ? nil : [NSString stringWithFormat:@"%@",[profDict objectForKey:@"specification_id"]];
            
            self.gothraTF.text = [profDict objectForKey:@"gothra"];
            
        }
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)showPickerWithDataSource:(id)inResult withTitle:(NSString*)title
{
    [self stopActivityIndicator];
    
    UIStoryboard *sb =[UIStoryboard storyboardWithName:@"CustomPicker" bundle:nil];
    self.customPickerView = [sb instantiateViewControllerWithIdentifier:@"PWCustomPickerView"];
    self.customPickerView.allowMultipleSelection = NO;
    self.customPickerView.pickerDataSource = inResult;
    self.customPickerView.selectedHeritage = self.heritageList;
    [self.customPickerView showCusptomPickeWithDelegate:self];
    self.customPickerView.titleLabel.text = title;
}



-(IBAction)getReligion:(id)sender
{
    [self startActivityIndicator:YES];
    self.heritageList = eReligionList;
    [[BUWebServicesManager sharedManager] getqueryServer:nil
                                                 baseURL:@"read/religion"
                                            successBlock:^(id response, NSError *error) {
        [self showPickerWithDataSource:response withTitle:@"Select Religion"];
    } failureBlock:^(id response, NSError *error) {
        [self stopActivityIndicator];
        
        if (error.code == NSURLErrorTimedOut) {
            
            [self timeoutError:@"Connection timed out, please try again later"];
        }
        else
        {
        [self showFailureAlert];
        }

    }];
}


-(IBAction)getMotherToungue:(id)sender
{
    [self startActivityIndicator:YES];
    self.heritageList = eMotherToungueList;
    [[BUWebServicesManager sharedManager] getqueryServer:nil
                                                 baseURL:@"read/mother_tongue"
                                            successBlock:^(id response, NSError *error) {
        [self showPickerWithDataSource:response withTitle:@"Select Mother Tongue"];
    } failureBlock:^(id response, NSError *error) {
        [self stopActivityIndicator];
        if (error.code == NSURLErrorTimedOut) {
            
            [self timeoutError:@"Connection timed out, please try again later"];
        }
        else{
       [self showFailureAlert];
        }
    }];
}

-(IBAction)getSpecificationList:(id)sender
{
    
    
    if(nil == self.famliyID)
    {
        [self showAlert:@"Please Select Family Origin"];
    }
    else
    {
        self.heritageList = eSpecificationList;
        NSDictionary *parameters = nil;
        parameters = @{@"family_origin_id": self.famliyID};
        NSString *urlString = [NSString stringWithFormat:@"read/specification/family_origin_id/%@",self.religionID];
        [self startActivityIndicator:YES];
        [[BUWebServicesManager sharedManager] getqueryServer:nil
                                                     baseURL:urlString
                                                successBlock:^(id response, NSError *error) {
                                                    NSArray *specification = response;
                                                    if (specification.count != 0) {
                                                        [self showPickerWithDataSource:response withTitle:@"Select Specification"];
                                                    }else{
                                                        [self showAlert:@"No specifications found."];
                                                    }
        } failureBlock:^(id response, NSError *error) {
            [self stopActivityIndicator];
            if (error.code == NSURLErrorTimedOut)
            {
                [self timeoutError:@"Connection timed out, please try again later"];
            }
             else
             {
              [self showFailureAlert];
             }

        }];
    }
}

-(IBAction)getFamilyOrigin:(id)sender
{
    if(nil == self.religionID)
    {
        [self showAlert:@"Please Select Relegion"];
    }
    else
    {
        self.heritageList = eFamilyOriginList;
        NSString *urlString = [NSString stringWithFormat:@"read/family_origin/religion_id/%@",self.religionID];
        [self startActivityIndicator:YES];
        [[BUWebServicesManager sharedManager] getqueryServer:nil
                                                     baseURL:urlString
                                                successBlock:^(id response, NSError *error) {
            [self showPickerWithDataSource:response withTitle:@"Select Family Origin"];

        } failureBlock:^(id response, NSError *error) {
            [self stopActivityIndicator];
            if (error.code == NSURLErrorTimedOut) {
                
                [self timeoutError:@"Connection timed out, please try again later"];
            }
            else
            {
            [self showFailureAlert];
            }
        }];
    }
}

-(IBAction)continueClicked:(id)sender
{
    NSDictionary *parameters = nil;
    /*
     
     3. API for screen 4b_profile_setup2
     
     API  to  Call
     http://app.thebureauapp.com/admin/update_profile_step3
     
     Parameter
     userid => user id of user
     religion_id =>religion id
     mother_tongue_id => mother tongue id
     family_origin_id => family origin id
     specification_id => specification id
     gothra => gothra(text) 
     
     */
    
    if(self.religionID == nil ||
       self.motherToungueID == nil ||
       self.famliyID == nil)
    {
        [self showAlert:@"Please fill the mandatory fields"];
        return;
    }

    
//    if(nil != self.specificationID)
//    {
        parameters = @{@"userid": [BUWebServicesManager sharedManager].userID,
                       @"religion_id":self.religionID,
                       @"mother_tongue_id":self.motherToungueID,
                       @"family_origin_id":self.famliyID,
                       @"specification_id":self.specificationID != nil ? self.specificationID : @"",
                       @"gothra":self.gothraTF.text
                       };
//    }
//    else
//    {
//        parameters = @{@"userid": [BUWebServicesManager sharedManager].userID,
//                       @"religion_id":self.religionID,
//                       @"mother_tongue_id":self.motherToungueID,
//                       @"family_origin_id":self.famliyID,
//                       @"gothra":self.gothraTF.text
//                       };
//    }
    
    [self startActivityIndicator:YES];
    self.isUpdatingProfile = YES;
    [[BUWebServicesManager sharedManager] queryServer:parameters baseURL:@"profile/update_profile_step3"
                                         successBlock:^(id inResult, NSError *error)
     {
         [self stopActivityIndicator];

         self.isUpdatingProfile = NO;
         if(YES == [[inResult valueForKey:@"msg"] isEqualToString:@"Success"])
         {
             UIStoryboard *sb =[UIStoryboard storyboardWithName:@"ProfileCreation" bundle:nil];
             BUProfileDietVC *vc = [sb instantiateViewControllerWithIdentifier:@"BUProfileDietVC"];
             vc.isDirect = self.isDirect;
             
             if (self.isDirect == YES) {
                 NSMutableDictionary *profDict = [[[NSUserDefaults standardUserDefaults] objectForKey:@"profileDetails"] mutableCopy];
                 
                 [profDict setValue:self.religionID forKey:@"religion_id"];
                 [profDict setValue:self.motherToungueID forKey:@"mother_tongue_id"];
                 [profDict setValue:self.famliyID forKey:@"family_origin_id"];
                 [profDict setValue:self.specificationID forKey:@"specification_id"];
                 
                 [profDict setValue:self.religionTF.text forKey:@"religion_name"];
                 [profDict setValue:self.motherToungueTF.text forKey:@"mother_tongue"];
                 [profDict setValue:self.familyOriginTF.text forKey:@"family_origin_name"];
                 [profDict setValue:self.specificationTF.text forKey:@"specification_name"];
                 [profDict setValue:self.gothraTF.text forKey:@"gothra"];
                 
                 [[NSUserDefaults standardUserDefaults]setObject:profDict forKey:@"profileDetails"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 
             }
             
             [self.navigationController pushViewController:vc animated:YES];
         }
         else
         {
             [self showAlert:@"Connectivity Error"];
         }
     }
                                                                 failureBlock:^(id response, NSError *error) {
                                                                     [self stopActivityIndicator];
                                                                     if (error.code == NSURLErrorTimedOut) {
                                                                         
                                                                         [self timeoutError:@"Connection timed out, please try again later"];
                                                                     }
                                                                     else
                                                                     {
                                                                     [self showFailureAlert];
                                                                     }
                                                                     
    }];
}


- (void)didItemSelected:(NSMutableDictionary *)inSelectedRow
{
    switch (self.heritageList)
    {
        case eReligionList:
        {
            self.religionTF.text = [inSelectedRow valueForKey:@"religion_name"];
            self.religionID = [inSelectedRow valueForKey:@"religion_id"];
            
            self.familyOriginTF.text = @"";
            self.specificationTF.text = @"";
            self.gothraTF.text = @"";
            self.famliyID = nil;
            self.specificationID = nil;
            break;
        }
        case eMotherToungueList:
        {
            self.motherToungueTF.text = [inSelectedRow valueForKey:@"mother_tongue"];
            self.motherToungueID = [inSelectedRow valueForKey:@"mother_tongue_id"];
            break;
        }
        case eFamilyOriginList:
        {
            
            self.familyOriginTF.text = [inSelectedRow valueForKey:@"family_origin_name"];
            self.famliyID = [inSelectedRow valueForKey:@"family_origin_id"];
            
            self.specificationTF.text = @"";
            self.specificationID = nil;
            self.gothraTF.text = @"";

            break;
        }
        case eSpecificationList:
        {
            self.specificationTF.text = [inSelectedRow valueForKey:@"specification_name"];
            self.specificationID = [inSelectedRow valueForKey:@"specification_id"];
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
}


-(void)viewPopOnBackButton {
    
    NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"Are you sure, you want to go back? Your Information has not been saved"];
    [message addAttribute:NSFontAttributeName
                    value:[UIFont fontWithName:@"comfortaa" size:15]
                    range:NSMakeRange(0, message.length)];
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController setValue:message forKey:@"attributedTitle"];
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"OK");
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        
        action;
    })];
    
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"Cancel");
            //NSLog(@"%@",picker.date);
            
        }];
        
        action;
    })];
    
    [self presentViewController:alertController  animated:YES completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.scrollBottomConstraint.constant = -50;
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.scrollBottomConstraint.constant = 44;
    [textField resignFirstResponder];
}

@end
