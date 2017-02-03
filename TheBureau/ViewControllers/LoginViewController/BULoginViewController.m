//
//  BULoginViewController.m
//  TheBureau
//
//  Created by Manjunath on 26/11/15.
//  Copyright © 2015 Bureau. All rights reserved.
//

#import "BULoginViewController.h"
#import "FBController.h"
#import "BUSocialChannel.h"
#import "BUConstants.h"
#import "BUAuthButton.h"
#import <DigitsKit/DigitsKit.h>
#import "BUAccountCreationVC.h"
#import "BUHomeTabbarController.h"
#import <LayerKit/LayerKit.h>
#import "BUWebServicesManager.h"
#import "BULayerHelper.h"
#import "Localytics.h"
#import "NSObject+FCKeyPathHelper.h"

#import "BUProfileDetailsVC.h"
#import "BUProfileHeritageVC.h"
#import "BUProfileDietVC.h"
#import "BUProfileOccupationVC.h"
#import "BUProfileLegalStatusVC.h"
#import "UINavigationController+CompletionHandler.h"

//#import <FBSDKShareKit/FBSDKShareKit.h>
@interface BULoginViewController ()//<LYRClientDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *overLayViewTapConstraint;
@property (assign, nonatomic) CGFloat layoutConstant;

@property (weak, nonatomic) IBOutlet UITextField *emailTF,*passwordTF;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageview;
@property (weak, nonatomic) IBOutlet BUAuthButton *loginBtn;
@property (strong, nonatomic) DGTAppearance *theme;
@property (strong, nonatomic) DGTAuthenticationConfiguration *configuration;

@property (strong, nonatomic) IBOutlet FBSDKLoginButton *fbLoginButton;

@property (nonatomic) LYRClient *layerClient;

-(IBAction)loginUsingFacebook:(id)sender;
-(IBAction)loginUsingEmail:(id)sender;

@end

@implementation BULoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // _configuration = [[DGTAuthenticationConfiguration alloc] initWithAccountFields:dgt];
    self.title = @"login";
    _configuration = [[DGTAuthenticationConfiguration alloc] initWithAccountFields:DGTAccountFieldsDefaultOptionMask];
    _configuration.appearance = [self makeTheme];
    
    //    self.fbLoginButton.readPermissions = @[@"public_profile",@"user_friends", @"user_about_me",@"email"];
    //    self.fbLoginButton.publishPermissions = [NSArray arrayWithObjects: @"publish_actions", nil];
    //    self.fbLoginButton.delegate = self;
}

- (DGTAppearance *)makeTheme {
    DGTAppearance *theme = [[DGTAppearance alloc] init];
    theme.bodyFont = [UIFont fontWithName:@"Comfortaa-Bold" size:16];
    theme.labelFont = [UIFont fontWithName:@"Comfortaa-Bold" size:17];
    theme.accentColor = [UIColor colorWithRed:(213.0/255.0) green:(15/255.0) blue:(37/255.0) alpha:1];
    theme.backgroundColor = [UIColor whiteColor];
    theme.logoImage = [UIImage imageNamed:@"logo_splash"];
    return theme;
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //  [self.loginBtn setupButtonThemeWithTitle:@"Login Using Phonenumber"];
    self.layoutConstant = self.overLayViewTapConstraint.constant;
}

#pragma mark - FACEBOOK -
-(void)associateFacebook{
    [[FBController sharedInstance]clearSession];
    [[FBController sharedInstance] authenticateWithCompletionHandler:^(BUSocialChannel *socialChannel, NSError *error, BOOL whetherAlreadyAuthenticated) {
        if (!error) {
            self.socialChannel = socialChannel;
            [self fbLogin];
        }else{
            [[FBController sharedInstance]clearSession];
        }
    }];
}

-(void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    /*
     
     let request = FBSDKGraphRequest(graphPath:"me", parameters: ["fields":"email,first_name,gender,last_name,picture.type(large)"]);
     
     request.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
     if error == nil {
     self.view.makeToastActivity()
     print("The information requested is : \(result)")
     let strFirstName: String = (result.objectForKey("first_name") as? String)!
     let strLastName: String = (result.objectForKey("last_name") as? String)!
     
     let emailID: String = (result.objectForKey("email") as? String)!
     let strPictureURL: String = (result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
     print("First name is\(strFirstName)")
     print("Last name is\(strLastName)")
     print("Image url is \(strPictureURL)")
     print("Email Id is \(emailID)")
     
     
     let proPicUrl:NSURL = NSURL(string: strPictureURL)!
     
     print("User DP is \(proPicUrl)")
     
     let fullName = NSString(format: "%@%@", strFirstName,strLastName)as String
     
     self.appDelegate.userArray.replaceObjectAtIndex(0, withObject: fullName)
     self.appDelegate.userArray.replaceObjectAtIndex(1, withObject: emailID)
     self.appDelegate.userArray.replaceObjectAtIndex(4, withObject:(result.objectForKey("id") as? String)!)
     CommonUtilities().saveUserDefaults("uName", savedText: self.appDelegate.userArray.objectAtIndex(0) as! String)
     CommonUtilities().saveUserDefaults("uEmail", savedText: self.appDelegate.userArray.objectAtIndex(1) as! String)
     print("User Array \(self.appDelegate.userArray)")
     
     self.google = false
     self.checkEmail(emailID)
     
     } else {
     print("Error getting information \(error)");
     }
     }
     
     */
    
    
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"email,first_name,gender,last_name,picture.type(large)"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 // Success! Include your code to handle the results here
                 
                 BUSocialChannel *socialChannel = [[BUSocialChannel alloc] init];
                 socialChannel.profileId = [result valueForKeyPathFC:@"id"];
                 socialChannel.profile = result;
                 socialChannel.profileDetails = [[BUProfileDetails alloc] initWithProfileDetails:result];
                 socialChannel.credentials = @{@"accessToken":[FBSDKAccessToken currentAccessToken]};
                 socialChannel.socialType = BUSocialChannelFacebook;
                 //completion(socialChannel, error, whetherAlreadyAuthenticated);
                 //            //[self loginWithDigit];
                 [self fbLogin];
                 
                 NSLog(@"user info: %@", result);
             }
         }];
    }
}

#pragma mark - TextField Delegates
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.overLayViewTapConstraint.constant = self.layoutConstant-kLoginTopLayoutOffset;
    } completion:^(BOOL finished) {
    }];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.overLayViewTapConstraint.constant = self.layoutConstant;
    } completion:^(BOOL finished) {
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.overLayViewTapConstraint.constant = self.layoutConstant;
    } completion:^(BOOL finished) {
    }];
    return YES;
}

#pragma mark - Action Methods

-(IBAction)loginUsingFacebook:(id)sender
{
    self.loginType = eLoginFromFB;
    [self associateFacebook];
}

-(IBAction)loginUsingEmail:(id)sender
{
    [self performSegueWithIdentifier:@"account creation" sender:self];
}

-(IBAction)loginUsingPhonenum:(id)sender
{
    self.loginType = eLoginFromDigit;
    [self loginWithDigit];
}

-(void)getProfileDetails:(NSDictionary*)response {
    NSString *urlString = [NSString stringWithFormat:@"profile/readprofiledetails/userid/%@",[BUWebServicesManager sharedManager].userID];
    [self startActivityIndicator:YES];
    
    [[BUWebServicesManager sharedManager] getqueryServer:nil
                                                 baseURL:urlString
                                            successBlock:^(id response1, NSError *error)
     {
         [self stopActivityIndicator];
         [self stopActivityIndicator];
         NSLog(@"%@",response1);
         
         [[NSUserDefaults standardUserDefaults]setObject:[response1 objectForKey:@"first_name"] forKey:@"uName"];
         [[NSUserDefaults standardUserDefaults]setObject:response1 forKey:@"profileDetails"];
         [[NSUserDefaults standardUserDefaults] synchronize];
         
         UIStoryboard *sb1 =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
         
         UIStoryboard *sb =[UIStoryboard storyboardWithName:@"ProfileCreation" bundle:nil];
         
         BUAccountCreationVC *vc = [sb1 instantiateViewControllerWithIdentifier:@"AccountCreationVC"];
         vc.socialChannel = nil;
         vc.isDirect = YES;
         
         BUProfileDetailsVC *vc1 = [sb instantiateViewControllerWithIdentifier:@"BUProfileDetailsVC"];
         if ([[response1 objectForKey:@"created_by"] isEqualToString:@"Self"]) {
             if ([[response1 objectForKey:@"gender"] isEqualToString:@"Male"]) {
                 vc1.genStr = @"1";
             }
             else {
                 vc1.genStr = @"0";
             }
             vc1.dobStr = [response1 objectForKey:@"dob"];
         }
         vc1.isDirect = YES;
         
         BUProfileHeritageVC *vc2 = [sb instantiateViewControllerWithIdentifier:@"BUProfileHeritageVC"];
         vc2.isDirect = YES;
         
         BUProfileDietVC *vc3 = [sb instantiateViewControllerWithIdentifier:@"BUProfileDietVC"];
         vc3.isDirect = YES;
         
         BUProfileOccupationVC *vc4 = [sb instantiateViewControllerWithIdentifier:@"BUProfileOccupationVC"];
         vc4.isDirect = YES;
         
         BUProfileLegalStatusVC *vc5 = [sb instantiateViewControllerWithIdentifier:@"BUProfileLegalStatusVC"];
         vc5.isDirect = YES;
         
         NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"Your profile is incomplete, please complete the profile to continue with this app !!!"];
         [message addAttribute:NSFontAttributeName
                         value:[UIFont fontWithName:@"comfortaa" size:15]
                         range:NSMakeRange(0, message.length)];
         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
         [alertController setValue:message forKey:@"attributedTitle"];
         [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                     {
                                         if ([[response valueForKey:@"profile_status"] isEqualToString:@"create_account_ws"]) {
                                             vc.isDirect = NO;
                                             [self.navigationController pushViewController:vc animated:YES];
                                             return ;
                                         }
                                         else if ([[response valueForKey:@"profile_status"] isEqualToString:@"update_profile_step2"]) {
                                             [self.navigationController completionhandler_pushViewController:vc animated:NO completion:^(void){
                                                 [vc.navigationController pushViewController:vc1 animated:NO];
                                             }];
                                             return ;
                                         }
                                         else if ([[response valueForKey:@"profile_status"] isEqualToString:@"update_profile_step3"]) {
                                             
                                             [self.navigationController completionhandler_pushViewController:vc animated:NO completion:^(void){
                                                 [self.navigationController completionhandler_pushViewController:vc1 animated:NO completion:^(void){
                                                     [vc1.navigationController pushViewController:vc2 animated:NO];
                                                 }];
                                             }];
                                             
                                             return ;
                                         }
                                         else if ([[response valueForKey:@"profile_status"] isEqualToString:@"update_profile_step4"]) {
                                             
                                             
                                             [self.navigationController completionhandler_pushViewController:vc animated:NO completion:^(void){
                                                 [self.navigationController completionhandler_pushViewController:vc1 animated:NO completion:^(void){
                                                     [self.navigationController completionhandler_pushViewController:vc2 animated:NO completion:^(void){
                                                         [vc2.navigationController pushViewController:vc3 animated:NO];
                                                     }];
                                                 }];
                                             }];
                                             return ;
                                         }
                                         else if ([[response valueForKey:@"profile_status"] isEqualToString:@"update_profile_step5"]) {
                                             [self.navigationController completionhandler_pushViewController:vc animated:NO completion:^(void){
                                                 [self.navigationController completionhandler_pushViewController:vc1 animated:NO completion:^(void){
                                                     [self.navigationController completionhandler_pushViewController:vc2 animated:NO completion:^(void){
                                                         [self.navigationController completionhandler_pushViewController:vc3 animated:NO completion:^(void){
                                                             [vc3.navigationController pushViewController:vc4 animated:NO];
                                                         }];
                                                     }];
                                                 }];
                                             }];
                                             return ;
                                         }
                                         else if ([[response valueForKey:@"profile_status"] isEqualToString:@"update_profile_step6"]) {
                                             [self.navigationController completionhandler_pushViewController:vc animated:NO completion:^(void){
                                                 [self.navigationController completionhandler_pushViewController:vc1 animated:NO completion:^(void){
                                                     [self.navigationController completionhandler_pushViewController:vc2 animated:NO completion:^(void){
                                                         [self.navigationController completionhandler_pushViewController:vc3 animated:NO completion:^(void){
                                                             [self.navigationController completionhandler_pushViewController:vc4 animated:NO completion:^(void){
                                                                 [vc4.navigationController pushViewController:vc5 animated:NO];
                                                             }];
                                                         }];
                                                     }];
                                                 }];
                                             }];
                                             return ;
                                         }
                                     }]];
         [self presentViewController:alertController animated:YES completion:nil];
         
     }
                                            failureBlock:^(id response, NSError *error)
     {
         [self stopActivityIndicator];
         
         if (error.code == NSURLErrorTimedOut) {
             
             [self timeoutError:@"Connection timed out, please try again later"];
         }
         else
         {
             [self showFailureAlert];
         }
     }
     ];
    
}

-(void)fbLogin {
    
    //NSString *deviceToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"];
    
    //  NSString *udid = [[NSUUID UUID] UUIDString];
    
    NSString *udid = [[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"];
    
    if(nil == self.socialChannel)
        self.socialChannel = [[BUSocialChannel alloc] init];
    NSDictionary *parameters = nil;
    parameters = @{@"login_type": @"fb",
                   @"fb_id":self.socialChannel.profileDetails.fbID,
                   @"device_id":udid != nil ? udid : @"",
                   @"device_type" : @"ios"
                   };
    
    NSLog(@"%@",parameters);
    
    [self startActivityIndicator:YES];
    [[BUWebServicesManager sharedManager] queryServer:parameters baseURL:@"login" successBlock:^(id inResult, NSError *error) {
        //[self stopActivityIndicator];
        
        NSLog(@"%@",inResult);
        
        if(YES == [[inResult valueForKey:@"msg"] isEqualToString:@"Success"])
        {
            
            
            [BUWebServicesManager sharedManager].userID = [inResult valueForKey:@"userid"];
            [BUWebServicesManager sharedManager].userName = [[[inResult valueForKey:@"profile_details"] valueForKey:@"first_name"] lastObject];
            [BUWebServicesManager sharedManager].referalCode = [inResult valueForKey:@"referral_code"];
            
            [[NSUserDefaults standardUserDefaults] setValue:[inResult valueForKey:@"referral_code"] forKey:@"refCode"];
            [[NSUserDefaults standardUserDefaults] setValue:[inResult valueForKey:@"userid"] forKey:@"userid"];
            
            bool refered = [([[inResult valueForKey:@"referral_code_applied"] isKindOfClass:[NSNull class]] ? @"n" : [inResult valueForKey:@"referral_code_applied"]) isEqualToString:@"y"] ? YES : NO;
            
            [[NSUserDefaults standardUserDefaults] setBool:refered forKey:@"referred"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setValue:[BUWebServicesManager sharedManager].userName forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //    [inResult valueForKey:@"userid"];
            
            [[BULayerHelper sharedHelper] setCurrentUserID:[inResult valueForKey:@"userid"]];
            
            
            if (![[inResult valueForKey:@"profile_status"] isEqualToString:@"completed"]) {
                
                
                [self getProfileDetails:inResult];
                
                
                return ;
            }
            
            //             else if ([[inResult valueForKey:@"profile_status"] isEqualToString:@"create_account_ws"]) {
            //                 <#statements#>
            //             }
            //             NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"Login Successful"];
            //             [message addAttribute:NSFontAttributeName
            //                             value:[UIFont fontWithName:@"comfortaa" size:15]
            //                             range:NSMakeRange(0, message.length)];
            //             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
            //             [alertController setValue:message forKey:@"attributedTitle"];
            //
            //             UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
            //                                                                style:UIAlertActionStyleDefault
            //                                                              handler:^(UIAlertAction *action)
            //                                        {
            //[self startActivityIndicator:YES];
            
            [[BULayerHelper sharedHelper] authenticateLayerWithsuccessBlock:^(id response, NSError *error)
             {
                 [self checkForAccountCreation];
             } failureBlock:^(id response, NSError *error)
             {
                 
                 if (error.code == NSURLErrorTimedOut) {
                     
                     [self timeoutError:@"Connection timed out, please try again later"];
                     return ;
                 }
                 
                 
                 [self checkForAccountCreation];
                 return ;
                 //                                                 NSLog(@"Failed Authenticating Layer Client with error:%@", error);
                 //                                                 [self stopActivityIndicator];
                 //                                                 NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Failed Authenticating Layer Client with error:%@", error]];
                 //                                                 [message addAttribute:NSFontAttributeName
                 //                                                                 value:[UIFont fontWithName:@"comfortaa" size:15]
                 //                                                                 range:NSMakeRange(0, message.length)];
                 //                                                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
                 //                                                 [alertController setValue:message forKey:@"attributedTitle"];
                 //                                                 [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
                 //                                                 [self presentViewController:alertController animated:YES completion:nil];
                 
             }];
            //                                        }];
            //
            //             [alertController addAction:okAction];
            //             [self presentViewController:alertController animated:YES completion:nil];
            
        }
        else
        {
            [self stopActivityIndicator];
            [self showAlert:[inResult objectForKey:@"response"]];
        }
        
    } failureBlock:^(id response, NSError *error) {
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

-(void)loginWithDigit {
    //NSString *deviceToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"];
    
    // NSString *udid = [[NSUUID UUID] UUIDString];
    NSString *udid = [[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"];
    __weak typeof(self) weakSelf = self;
    [[Digits sharedInstance] authenticateWithViewController:weakSelf configuration:_configuration completion:^(DGTSession *session, NSError *error) {
        if (session) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                if(nil == weakSelf.socialChannel)
                    weakSelf.socialChannel = [[BUSocialChannel alloc] init];
                
                weakSelf.socialChannel.mobileNumber = session.phoneNumber;
                weakSelf.socialChannel.emailID = session.emailAddress;
                
                NSDictionary *parameters = nil;
                
                if(nil == weakSelf.socialChannel.profileDetails.fbID)
                {
                    weakSelf.loginType = eLoginFromDigit;
                }
                if(weakSelf.loginType == eLoginFromFB)
                {
                    parameters = @{@"login_type": @"fb",
                                   @"fb_id":self.socialChannel.profileDetails.fbID,
                                   @"digits":session.phoneNumber,
                                   @"device_id":udid != nil ? udid : @"",
                                   @"device_type" : @"ios"
                                   };
                }
                else
                {
                    parameters = @{@"login_type": @"digits",
                                   @"digits":session.phoneNumber,
                                   @"device_id":udid != nil ? udid : @"",
                                   @"device_type" : @"ios"
                                   };
                }
                
                NSLog(@"%@",parameters);
                
                [weakSelf startActivityIndicator:YES];
                NSString *urlString = [NSString stringWithFormat:@"login/check_login/userid/%@/device_id/%@",[BUWebServicesManager sharedManager].userID,udid];
                //  login/check_login/userid/123/device_id/12345
                [[BUWebServicesManager sharedManager] queryServer:parameters
                                                             baseURL:@"login"
                                                        successBlock:^(id inResult, NSError *error)
                 {
                     //[self stopActivityIndicator];
                     
                     if(YES == [[inResult valueForKey:@"msg"] isEqualToString:@"Success"])
                     {
                         
                         
                         [BUWebServicesManager sharedManager].userID = [inResult valueForKey:@"userid"];
                         [BUWebServicesManager sharedManager].userName = [[[inResult valueForKey:@"profile_details"] valueForKey:@"first_name"] lastObject];
                         [BUWebServicesManager sharedManager].referalCode = [inResult valueForKey:@"referral_code"];
                         NSLog(@"Referral code is %@:",[BUWebServicesManager sharedManager].referalCode);
                         
                         [[NSUserDefaults standardUserDefaults] setValue:[inResult valueForKey:@"referral_code"] forKey:@"refCode"];
                         [[NSUserDefaults standardUserDefaults] setValue:[inResult valueForKey:@"userid"] forKey:@"userid"];
                         bool refered = [([[inResult valueForKey:@"referral_code_applied"] isKindOfClass:[NSNull class]] ? @"n" : [inResult valueForKey:@"referral_code_applied"]) isEqualToString:@"y"] ? YES : NO;
                         
                         [[NSUserDefaults standardUserDefaults] setBool:refered forKey:@"referred"];
                         
                         [[NSUserDefaults standardUserDefaults] setValue:[BUWebServicesManager sharedManager].userName forKey:@"username"];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                         
                         //    [inResult valueForKey:@"userid"];
                         
                         [[BULayerHelper sharedHelper] setCurrentUserID:[inResult valueForKey:@"userid"]];
                         
                         if (![[inResult valueForKey:@"profile_status"] isEqualToString:@"completed"]) {
                             
                             
                             [weakSelf getProfileDetails:inResult];
                             
                             return ;
                         }
                         [[BULayerHelper sharedHelper] authenticateLayerWithsuccessBlock:^(id response, NSError *error)
                          {
                              [weakSelf checkForAccountCreation];
                          } failureBlock:^(id response, NSError *error)
                          {
                              
                              if (error.code == NSURLErrorTimedOut) {
                                  
                                  [weakSelf timeoutError:@"Connection timed out, please try again later"];
                                  return ;
                              }
                              
                              [weakSelf checkForAccountCreation];
                              return ;
                              //                                                             NSLog(@"Failed Authenticating Layer Client with error:%@", error);
                              //                                                             [self stopActivityIndicator];
                              //                                                             NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Failed Authenticating Layer Client with error:%@", error]];
                              //                                                             [message addAttribute:NSFontAttributeName
                              //                                                                             value:[UIFont fontWithName:@"comfortaa" size:15]
                              //                                                                             range:NSMakeRange(0, message.length)];
                              //                                                             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
                              //                                                             [alertController setValue:message forKey:@"attributedTitle"];
                              //                                                             [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
                              //                                                             [self presentViewController:alertController animated:YES completion:nil];
                              
                          }];
                         //                                                    }];
                         //
                         //                         [alertController addAction:okAction];
                         //                         [self presentViewController:alertController animated:YES completion:nil];
                         
                     }
                     else
                     {
                         [weakSelf stopActivityIndicator];
                         [weakSelf showAlert:[inResult objectForKey:@"response"]];
                     }
                     
                 }
                                                        failureBlock:^(id response, NSError *error)
                 {
                     [self stopActivityIndicator];
                     if (error.code == NSURLErrorTimedOut) {
                         
                         [weakSelf showAlert:@"Connection timed out, please try again later"];
                         return ;
                     }
                     [weakSelf showAlert:@"Connectivity Error"];
                     [[Digits sharedInstance] logOut];
                 }];
            });
        } else {
            NSLog(@"Authentication error: %@", error.localizedDescription);
        }
    }];
}

-(void)checkForAccountCreation
{
    NSString *urlString = [NSString stringWithFormat:@"login/validateUserAccount/userid/%@",[BUWebServicesManager sharedManager].userID];
    [self startActivityIndicator:YES];
    [[BUWebServicesManager sharedManager] getqueryServer:nil
                                                 baseURL:urlString
                                            successBlock:^(id response, NSError *error)
     {
         [self stopActivityIndicator];
         [self stopActivityIndicator];
         [self stopActivityIndicator];
         [self stopActivityIndicator];
         if(YES == [[response valueForKey:@"msg"] isEqualToString:@"Success"])
         {
             if (![[response valueForKey:@"profile_status"] isEqualToString:@"completed"]) {
                 [self getProfileDetails:response];
                 return ;
             }
             
             UIStoryboard *sb =[UIStoryboard storyboardWithName:@"HomeView" bundle:nil];
             BUHomeTabbarController *vc = [sb instantiateViewControllerWithIdentifier:@"BUHomeTabbarController"];
             [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                 if (self.navigationController.topViewController == self) {
                     [self.navigationController pushViewController:vc animated:YES];
                 }else{
                     [self.navigationController pushViewController:vc animated:YES];
                 }
             }];
         }
         else {
             if (![[response valueForKey:@"profile_status"] isEqualToString:@"completed"]) {
                 [self getProfileDetails:response];
                 return;
             }
             UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
             BUAccountCreationVC *vc = [sb instantiateViewControllerWithIdentifier:@"AccountCreationVC"];
             vc.socialChannel = self.socialChannel;
             [self.navigationController pushViewController:vc animated:YES];
         }
     }
                                            failureBlock:^(id response, NSError *error)
     {
         [self stopActivityIndicator];
         if (error.code == NSURLErrorTimedOut) {
             
             [self showAlert:@"Connection timed out, please try again later"];
         }
         else {
             [self showAlert:@"Connectivity Error"];
         }
     }];
}

-(IBAction)logout:(id)sender {
    [[Digits sharedInstance]logOut];
}


@end
