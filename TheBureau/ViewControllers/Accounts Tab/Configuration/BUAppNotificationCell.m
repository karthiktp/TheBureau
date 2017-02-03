//
//  BUAppNotificationCell.m
//  TheBureau
//
//  Created by Manjunath on 01/03/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUAppNotificationCell.h"
#import <DigitsKit/DigitsKit.h>
#import "BULayerHelper.h"
#import "BUWebServicesManager.h"

#import <FBSDKLoginKit/FBSDKLoginKit.h>

@implementation BUAppNotificationCell

/*
 
 Logout API
 
 URL: http://app.thebureauapp.com/admin/logout_ws
 Parameter:
 userid => id of a user
 
 Deactivate account API
 
 URL: http://app.thebureauapp.com/admin/deactivate_account_ws
 Parameter:
 userid => id of a user
 
 */

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)updateBtnStatus
{
    
    if (self.appNotificationCellType == BUAppNotificationCellTypeActiveOrInActive)
    {
        NSString *title = [[NSUserDefaults standardUserDefaults] boolForKey:@"accountStatus"] ? @"ACTIVE" : @"IN ACTIVE";
        
        [self.switchBtn setTitle:title forState:UIControlStateNormal];
        
        return;
    }
    
    
    BOOL status = YES;
    BOOL enableStatus = YES;
    NSUserDefaults *usDef = [NSUserDefaults standardUserDefaults];
    switch (self.appNotificationCellType)
    {
        case BUAppNotificationCellTypeDailyMatch:
        {
            status =   [usDef boolForKey:@"BUAppNotificationCellTypeDailyMatch"];
            enableStatus =   [usDef boolForKey:@"BUAppNotificationCellTypeDailyMatch1"];
            break;
        }
        case BUAppNotificationCellTypeChatNotifications:
        {
            status =[usDef boolForKey:@"BUAppNotificationCellTypeChatNotifications"];
            enableStatus =[usDef boolForKey:@"BUAppNotificationCellTypeChatNotifications1"];
            break;
        }
        case BUAppNotificationCellTypeCustomerService:
        {
            status =[usDef boolForKey:@"BUAppNotificationCellTypeCustomerService"];
            enableStatus =[usDef boolForKey:@"BUAppNotificationCellTypeCustomerService1"];
            break;
        }
        case BUAppNotificationCellTypeBlogRelease:
        {
            status =[usDef boolForKey:@"BUAppNotificationCellTypeBlogRelease"];
            enableStatus =[usDef boolForKey:@"BUAppNotificationCellTypeBlogRelease1"];
            break;
        }
        case BUAppNotificationCellTypeSounds:
        {
            status =[usDef boolForKey:@"BUAppNotificationCellTypeSounds"];
            enableStatus =[usDef boolForKey:@"BUAppNotificationCellTypeSounds1"];
            break;
        }
        case BUAppNotificationCellTypeAccountStatus:
        {
            enableStatus = YES;
            status = [[NSUserDefaults standardUserDefaults] objectForKey:@"accountStatus"] != nil ? ![[NSUserDefaults standardUserDefaults] boolForKey:@"accountStatus"] : YES;
        }
        default:
            break;
    }
    
    
    if(NO == status)
    {
        self.switchBtn.tag = 0;
        [self.switchBtn setImage:[UIImage imageNamed:@"switch_disable"]
                        forState:UIControlStateNormal];
    }
    else
    {
        [self.switchBtn setImage:[UIImage imageNamed:@"switch_ON"]
                        forState:UIControlStateNormal];
        self.switchBtn.tag = 1;
    }
    
    if (enableStatus == YES) {
        self.switchBtn.userInteractionEnabled = YES;
    }
    else {
        self.switchBtn.userInteractionEnabled = NO;
        
        //        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 0);
        //
        ////        [self layoutSubviews];
        ////        [self layoutIfNeeded];
        //
        //        [self setNeedsLayout];
        
        [self setHidden:YES];
        
        
    }
    
    
}

- (IBAction)changeNotificationSettings:(UIButton *)sender
{
    NSString *baseURL = @"configuration/update";
    NSDictionary *parameters = nil;
    NSUserDefaults *usDef = [NSUserDefaults standardUserDefaults];
    switch (self.appNotificationCellType)
    {
        case BUAppNotificationCellTypeDailyMatch:
        {
            // baseURL = @"http://app.thebureauapp.com/admin/conf_dailyMatch";
            if(0 == [sender tag])
            {
                sender.tag = 1;
                [sender setImage:[UIImage imageNamed:@"switch_ON"]
                        forState:UIControlStateNormal];
                
                [usDef setBool:YES forKey:@"BUAppNotificationCellTypeDailyMatch"];
                
                parameters = @{@"userid": [BUWebServicesManager sharedManager].userID,
                               @"daily_match": @"YES"
                               };
            }
            else
            {
                [sender setImage:[UIImage imageNamed:@"switch_disable"]
                        forState:UIControlStateNormal];
                
                sender.tag = 0;
                [usDef setBool:NO forKey:@"BUAppNotificationCellTypeDailyMatch"];
                parameters = @{@"userid": [BUWebServicesManager sharedManager].userID,
                               @"daily_match": @"NO"
                               };
            }
            
            break;
        }
        case BUAppNotificationCellTypeChatNotifications:
        {
            //  baseURL = @"http://app.thebureauapp.com/admin/conf_chatNotifications";
            if(0 == [sender tag])
            {
                sender.tag = 1;
                [sender setImage:[UIImage imageNamed:@"switch_ON"]
                        forState:UIControlStateNormal];
                [usDef setBool:YES forKey:@"BUAppNotificationCellTypeChatNotifications"];
                parameters = @{@"userid": [BUWebServicesManager sharedManager].userID,
                               @"chat_notification": @"YES"
                               };
            }
            else
            {
                [sender setImage:[UIImage imageNamed:@"switch_disable"]
                        forState:UIControlStateNormal];
                sender.tag = 0;
                [usDef setBool:NO forKey:@"BUAppNotificationCellTypeChatNotifications"];
                parameters = @{@"userid": [BUWebServicesManager sharedManager].userID,
                               @"chat_notification": @"NO"
                               };
            }
            
            break;
        }
        case BUAppNotificationCellTypeCustomerService:
        {
            // baseURL = @"http://app.thebureauapp.com/admin/conf_customerService";
            if(0 == [sender tag])
            {
                sender.tag = 1;
                [sender setImage:[UIImage imageNamed:@"switch_ON"]
                        forState:UIControlStateNormal];
                [usDef setBool:YES forKey:@"BUAppNotificationCellTypeCustomerService"];
                parameters = @{@"userid": [BUWebServicesManager sharedManager].userID,
                               @"customer_service": @"YES"
                               };
            }
            else
            {
                [sender setImage:[UIImage imageNamed:@"switch_disable"]
                        forState:UIControlStateNormal];
                sender.tag = 0;
                [usDef setBool:NO forKey:@"BUAppNotificationCellTypeCustomerService"];
                parameters = @{@"userid": [BUWebServicesManager sharedManager].userID,
                               @"customer_service": @"NO"
                               };
            }
            
            break;
        }
        case BUAppNotificationCellTypeBlogRelease:
        {
            //  baseURL = @"http://app.thebureauapp.com/admin/conf_blogRelease";
            if(0 == [sender tag])
            {
                sender.tag = 1;
                [sender setImage:[UIImage imageNamed:@"switch_ON"]
                        forState:UIControlStateNormal];
                [usDef setBool:YES forKey:@"BUAppNotificationCellTypeBlogRelease"];
                parameters = @{@"userid": [BUWebServicesManager sharedManager].userID,
                               @"blog_release": @"YES"
                               };
            }
            else
            {
                [sender setImage:[UIImage imageNamed:@"switch_disable"]
                        forState:UIControlStateNormal];
                sender.tag = 0;
                [usDef setBool:NO forKey:@"BUAppNotificationCellTypeBlogRelease"];
                parameters = @{@"userid": [BUWebServicesManager sharedManager].userID,
                               @"blog_release": @"NO"
                               };
            }
            
            break;
        }
        case BUAppNotificationCellTypeSounds:
        {
            //  baseURL = @"http://app.thebureauapp.com/admin/conf_sound";
            if(0 == [sender tag])
            {
                sender.tag = 1;
                [sender setImage:[UIImage imageNamed:@"switch_ON"]
                        forState:UIControlStateNormal];
                [usDef setBool:YES forKey:@"BUAppNotificationCellTypeSounds"];
                parameters = @{@"userid": [BUWebServicesManager sharedManager].userID,
                               @"sound": @"YES"
                               };
                
                
            }
            else
            {
                [sender setImage:[UIImage imageNamed:@"switch_disable"]
                        forState:UIControlStateNormal];
                sender.tag = 0;
                [usDef setBool:NO forKey:@"BUAppNotificationCellTypeSounds"];
                parameters = @{@"userid": [BUWebServicesManager sharedManager].userID,
                               @"sound": @"NO"
                               };
                
                
                
                
                
            }
            
            break;
        }
            
        default:
            break;
    }
    
    [usDef synchronize];
    
    
    
    [self.parentVC startActivityIndicator:YES];
    
    [[BUWebServicesManager sharedManager] queryServer:parameters
                                              baseURL:baseURL
                                         successBlock:^(id response, NSError *error)
     
     {
         [self.parentVC stopActivityIndicator];
     } failureBlock:^(id response, NSError *error)
     {
         [self.parentVC stopActivityIndicator];
         
         if (error.code == NSURLErrorTimedOut) {
             
             [self.parentVC showFailureAlert:@"Connection timed out, please try again later"];
         }
         else
         {
             [self.parentVC showFailureAlert:@"Connectivity Error"];
         }
         
         
         
         
     }];
    
    
}

- (IBAction)deactivateAccount:(id)sender
{
    
    if(1 == [sender tag])
    {
        
        NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"Are you sure want to Activate?"];
        [message addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"comfortaa" size:15]
                        range:NSMakeRange(0, message.length)];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController setValue:message forKey:@"attributedTitle"];
        
        [alertController addAction:({
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSLog(@"OK");
                
                {
                    
                    [self.parentVC startActivityIndicator:YES];
                    // NSString *baseURl = @"http://app.thebureauapp.com/admin/activateAccount";
                    
                    NSDictionary *parameters = nil;
                    parameters = @{@"userid": [BUWebServicesManager sharedManager].userID};
                    
                    [[BUWebServicesManager sharedManager] queryServer:parameters
                                                              baseURL:@"profile/activate"
                                                         successBlock:^(id response, NSError *error)
                     {
                         //                         NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:[response objectForKey:@"response"]];
                         //                         [message addAttribute:NSFontAttributeName
                         //                                         value:[UIFont fontWithName:@"comfortaa" size:15]
                         //                                         range:NSMakeRange(0, message.length)];
                         //                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
                         //                         [alertController setValue:message forKey:@"attributedTitle"];
                         //
                         //                         [alertController addAction:({
                         //                             UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                         
                         if ([[response objectForKey:@"msg"] isEqualToString:@"Success"]) {
                             
                             [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"accountStatus"];
                             [[NSUserDefaults standardUserDefaults] synchronize];
                             
                             [self updateBtnStatus];
                             [self.parentVC.cell7 updateBtnStatus];
                             
                         }
                         
                         //                             }];action;})];
                         //
                         //                         [self.parentVC presentViewController:alertController  animated:YES completion:nil];
                         
                         // msg : Success
                         
                         [self.parentVC stopActivityIndicator];
                         
                     }
                                                         failureBlock:^(id response, NSError *error)
                     {
                         
                         if (error.code == NSURLErrorTimedOut) {
                             
                             [self.parentVC showFailureAlert:@"Connection timed out, please try again later"];
                             return ;
                         }
                         [self.parentVC showFailureAlert:@"Connectivity Error"];
                         [self.parentVC stopActivityIndicator];
                     }];
                }}];
            
            action;
        })];
        
        [alertController addAction:({
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSLog(@"OK");
                
            }];
            
            action;
        })];
        [self.parentVC presentViewController:alertController  animated:YES completion:nil];
        
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Deactivate Account" message:@"We're sorry to see you go! Please provide a reason for leaving." preferredStyle:UIAlertControllerStyleAlert];
    //[alertController setValue:message forKey:@"attributedTitle"];
    
    // [alertController addAction:({
    __block UITextField *verifyTextField;
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"OK");
        {
            if (verifyTextField.text.length < 1) {
                NSMutableAttributedString *message1 = [[NSMutableAttributedString alloc] initWithString:@"Please Enter your valid reson"];
                [message1 addAttribute:NSFontAttributeName
                                 value:[UIFont fontWithName:@"comfortaa" size:15]
                                 range:NSMakeRange(0, message1.length)];
                UIAlertController *alertController2 = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
                [alertController2 setValue:message1 forKey:@"attributedTitle"];
                [alertController2 addAction:({
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        [self.parentVC presentViewController:alertController animated:YES completion:nil];
                    }];
                    action;
                })];
                [self.parentVC presentViewController:alertController2  animated:YES completion:nil];
                
            }
            NSMutableAttributedString *message1 = [[NSMutableAttributedString alloc] initWithString:@"Are you sure you wish to leave?"];
            [message1 addAttribute:NSFontAttributeName
                             value:[UIFont fontWithName:@"comfortaa" size:15]
                             range:NSMakeRange(0, message1.length)];
            UIAlertController *alertController1 = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertController1 setValue:message1 forKey:@"attributedTitle"];
            [alertController1 addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
                
                [self.parentVC startActivityIndicator:YES];
                
                NSString *text = ((UITextField *)[alertController.textFields firstObject]).text;
                
                //    NSString *baseURl = @"http://app.thebureauapp.com/admin/deactivateUsers";
                
                NSDictionary *parameters = nil;
                parameters = @{@"userid": [BUWebServicesManager sharedManager].userID,
                               @"reason": text};
                
                [[BUWebServicesManager sharedManager] queryServer:parameters
                                                          baseURL:@"profile/deactivate"
                                                     successBlock:^(id response, NSError *error)
                 {
                     
                     NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"Deactivation Successfull"];
                     [message addAttribute:NSFontAttributeName
                                     value:[UIFont fontWithName:@"comfortaa" size:15]
                                     range:NSMakeRange(0, message.length)];
                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
                     [alertController setValue:message forKey:@"attributedTitle"];
                     
                     [alertController addAction:({
                         UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                             if ([[response objectForKey:@"msg"] isEqualToString:@"Success"]) {
                                 [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"accountStatus"];
                                 [[NSUserDefaults standardUserDefaults] synchronize];
                                 [self logout];
                                 [self.parentVC stopActivityIndicator];
                                 
                             }
                             
                         }];action;})];
                     
                     
                     [self.parentVC presentViewController:alertController  animated:YES completion:nil];
                     
                     
                     // msg : Success
                     
                 }
                                                     failureBlock:^(id response, NSError *error) {
                                                         [self.parentVC stopActivityIndicator];
                                                         
                                                         if (error.code == NSURLErrorTimedOut) {
                                                             
                                                             [self.parentVC showFailureAlert:@"Connection timed out, please try again later"];
                                                             return ;
                                                         }
                                                         [self.parentVC showFailureAlert:@"Connectivity Error"];
                                                     }
                 ];
            }]];
            [alertController1 addAction:({
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    NSLog(@"OK");
                    
                }];
                
                action;
            })];
            [self.parentVC presentViewController:alertController1 animated:YES completion:nil];
        }
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *K2TextField)
     {
         K2TextField.placeholder = NSLocalizedString(@"Please provide reason", @"Please provide reason");
         K2TextField.delegate = self;
         verifyTextField = K2TextField;
     }];
    [alertController addAction:action];
    self.okAction = action;
    action.enabled = NO;
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"Cancel pressed");
        }];
        action;
    })];
    [self.parentVC presentViewController:alertController  animated:YES completion:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self.okAction setEnabled:(finalString.length >= 1)];
    return YES;
}

- (IBAction)deleteAccount:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Delete Account" message:@"We're sorry to see you go! Please provide a reason for leaving." preferredStyle:UIAlertControllerStyleAlert];
    //[alertController setValue:message forKey:@"attributedTitle"];
    
    // [alertController addAction:({
    __block UITextField *verifyTextField;
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"OK");
        {
            NSMutableAttributedString *message1 = [[NSMutableAttributedString alloc] initWithString:@"Are you sure you want to delete your account?"];
            [message1 addAttribute:NSFontAttributeName
                             value:[UIFont fontWithName:@"comfortaa" size:15]
                             range:NSMakeRange(0, message1.length)];
            UIAlertController *alertController1 = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertController1 setValue:message1 forKey:@"attributedTitle"];
            [alertController1 addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
                NSLog(@"OK");{
                    NSString *text = ((UITextField *)[alertController.textFields firstObject]).text;
                    [self.parentVC startActivityIndicator:YES];
                    //  NSString *baseURl = @"http://app.thebureauapp.com/admin/delete_account_ws";
                    
                    NSDictionary *parameters = nil;
                    parameters = @{@"userid": [BUWebServicesManager sharedManager].userID,
                                   @"reason":text};
                    
                    [[BUWebServicesManager sharedManager] queryServer:parameters
                                                              baseURL:@"profile/delete_account"
                                                         successBlock:^(id response, NSError *error)
                     {
                         //                     [[Digits sharedInstance]logOut];
                         //                     [[BULayerHelper sharedHelper]deauthenticateWithCompletion:^(BOOL success, NSError * _Nullable error) {
                         //                         [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"localHistory"];
                         //                         [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"userid"];
                         //                         [[NSUserDefaults standardUserDefaults] synchronize];
                         //
                         //                         [BUWebServicesManager sharedManager].userID = nil;
                         //                         [self.parentVC stopActivityIndicator];
                         //                         [self.parentVC.navigationController popToRootViewControllerAnimated:YES];
                         //                     }];
                         [self logout];
                         [self.parentVC stopActivityIndicator];
                     }
                     
                                                         failureBlock:^(id response, NSError *error)
                     {
                         //                     [[Digits sharedInstance]logOut];
                         //                     [[BULayerHelper sharedHelper]deauthenticateWithCompletion:^(BOOL success, NSError * _Nullable error) {
                         //                         [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"localHistory"];
                         //                         [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"userid"];
                         //                         [[NSUserDefaults standardUserDefaults] synchronize];
                         //
                         //                         [BUWebServicesManager sharedManager].userID = nil;
                         //                         [self.parentVC stopActivityIndicator];
                         //                         [self.parentVC.navigationController popToRootViewControllerAnimated:YES];
                         //                     }];
                         
                         
                         if (error.code == NSURLErrorTimedOut) {
                             
                             [self.parentVC showFailureAlert:@"Connection timed out, please try again later"];
                             return ;
                         }
                         [self.parentVC showFailureAlert:@"Connectivity Error"];
                         [self.parentVC stopActivityIndicator];
                     }];
                }
            }]];
            [alertController1 addAction:({
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    NSLog(@"OK");
                }];
                action;
            })];
            [self.parentVC presentViewController:alertController1 animated:YES completion:nil];
        }
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *K2TextField) {
        K2TextField.placeholder = NSLocalizedString(@"Please provide reason", @"Please provide reason");
        K2TextField.delegate = self;
        verifyTextField = K2TextField;
    }];
    [alertController addAction:action];
    self.okAction = action;
    action.enabled = NO;
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"Cancel pressed");
        }];
        action;
    })];
    [self.parentVC presentViewController:alertController  animated:YES completion:nil];
}


- (IBAction)logout:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure want to logout ?" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"OK");
            {
                [self logout];
            }
        }];
        
        action;
    })];
    
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"OK");
            
        }];
        
        action;
    })];
    // [self.parentVC stopActivityIndicator];
    [self.parentVC presentViewController:alertController  animated:YES completion:nil];
}
-(void)logout {
    
    NSString *udid = [[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"];
    
    NSDictionary *parameters = nil;
    parameters = @{@"userid": [BUWebServicesManager sharedManager].userID ,
                   @"device_id":udid
                   };
    NSLog(@"deviceToken :%@",parameters);
    [self.parentVC startActivityIndicator:YES];
    
    [[BUWebServicesManager sharedManager] queryServer:parameters
                                              baseURL:@"logout"
                                         successBlock:^(id response, NSError *error)
     {
         FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
         [loginManager logOut];
         
         //[FBSDKAccessToken setCurrentAccessToken:nil];
         
         [[Digits sharedInstance]logOut];
         [[BULayerHelper sharedHelper]deauthenticateWithCompletion:^(BOOL success, NSError * _Nullable error) {
             //             [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"localHistory"];
             //             [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"userid"];
             //             [[NSUserDefaults standardUserDefaults] synchronize];
         }];
         
         NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
         [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
         [[NSUserDefaults standardUserDefaults] synchronize];
         
         [BUWebServicesManager sharedManager].userID = nil;
         [BUWebServicesManager sharedManager].referalCode = nil;
         [BUWebServicesManager sharedManager].userName = nil;
         
         [self.parentVC stopActivityIndicator];
         [self.parentVC.navigationController popToRootViewControllerAnimated:YES];
     }
     
                                         failureBlock:^(id response, NSError *error)
     {
         if (error.code == NSURLErrorTimedOut) {
             
             [self.parentVC showFailureAlert:@"Connection timed out, please try again later"];
             return ;
         }
         [self.parentVC showFailureAlert:@"Connectivity Error"];
         [self.parentVC stopActivityIndicator];
     }
     ];
}

@end
