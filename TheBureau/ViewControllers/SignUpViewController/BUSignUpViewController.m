//
//  BUSignUpViewController.m
//  TheBureau
//
//  Created by Apple on 27/11/15.
//  Copyright © 2015 Bureau. All rights reserved.
//

#import "BUSignUpViewController.h"
#import "BULoginViewController.h"
#import "FBController.h"
#import "BUSocialChannel.h"
#import "BUConstants.h"
#import "BUAccountCreationVC.h"
#import <DigitsKit/DigitsKit.h>
#import "BULayerHelper.h"
#include "Localytics.h"


@interface BUSignUpViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *overLayViewTapConstraint;
@property (assign, nonatomic) CGFloat layoutConstant;


@property (weak, nonatomic) IBOutlet UITextField *emailTF,*passwordTF,*confirmPaswordTF;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageview;
@property (strong, nonatomic) DGTAuthenticationConfiguration *configuration;
@property(nonatomic) eNavigatedFrom navFrom;



-(IBAction)signupUsingFacebook:(id)sender;
-(IBAction)signupUsingEmail:(id)sender;

@end

@implementation BUSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"Sign Up";
    
    _configuration = [[DGTAuthenticationConfiguration alloc] initWithAccountFields:DGTAccountFieldsEmail];
    _configuration.appearance = [self makeTheme];
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

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.layoutConstant = self.overLayViewTapConstraint.constant;
}

#pragma mark - FACEBOOK -
-(void)associateFacebook {
    
    [[FBController sharedInstance]clearSession];
    [[FBController sharedInstance] authenticateWithCompletionHandler:^(BUSocialChannel *socialChannel, NSError *error, BOOL whetherAlreadyAuthenticated) {
        if (!error) {
            self.navFrom = eNavFromFb;
            self.socialChannel = socialChannel;
            NSDictionary *parameters = @{@"fb_id":socialChannel.profileId};
            [self startActivityIndicator:YES];
            NSString *baseUrl = [NSString stringWithFormat:@"login/check_fb_id/fb_id/%@",socialChannel.profileId];
            [[BUWebServicesManager sharedManager] getqueryServer:nil baseURL:baseUrl successBlock:^(id response, NSError *error) {
                if ([[response objectForKey:@"msg"] isEqualToString:@"Success"]) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Do you want to login?" message:[response valueForKey:@"response"] preferredStyle:UIAlertControllerStyleAlert];
                    [BUWebServicesManager sharedManager].userID = [response valueForKey:@"userid"];
                    //  [alertController setValue:message forKey:@"attributedTitle"];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                        [[Digits sharedInstance] logOut];
                    }]];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
                        BULoginViewController *buloginViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"BULoginViewController"];
                        [buloginViewController associateFacebook];
                        [self stopActivityIndicator];
                        [self.navigationController pushViewController:buloginViewController animated:YES];
                    }]];
                    [self presentViewController:alertController animated:YES completion:nil];
                    [self stopActivityIndicator];
                }else{
                    [self regiserWithDigits];
                    [self stopActivityIndicator];
                }
            } failureBlock:^(id response, NSError *error) {
                
                if (error.code == NSURLErrorTimedOut) {
                    [self timeoutError:@"Connection timed out, please try again later"];
                    return ;
                }
                [self showAlert:@"Registration Failed"];
                [self stopActivityIndicator];
            }];
        }else{
            [[FBController sharedInstance]clearSession];
        }
    }];
}
#pragma mark - TextField Delegates
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.overLayViewTapConstraint.constant = self.layoutConstant-kSignupTopLayoutOffset;
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

-(IBAction)signupUsingFacebook:(id)sender
{
    self.registrationType = eRegistrationFromFB;
    [self associateFacebook];
}

-(IBAction)signUpUsingPhonenum:(id)sender{
    
    self.registrationType = eRegistrationFromDigit;
    [self regiserWithDigits];
}

-(void)regiserWithDigits
{
    __weak typeof(self) weakSelf = self;
    __weak BULayerHelper *weakLayer = [BULayerHelper sharedHelper];
    [[Digits sharedInstance] authenticateWithViewController:weakSelf configuration:_configuration completion:^(DGTSession *session, NSError *error) {
        if (session) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // TODO: associate the session userID with your user model
                
                if(nil == weakSelf.socialChannel) weakSelf.socialChannel = [[BUSocialChannel alloc] init];
                
                weakSelf.socialChannel.mobileNumber = session.phoneNumber;
                weakSelf.socialChannel.emailID = session.emailAddress;
                
                NSDictionary *parameters = nil;
                
                if(nil == weakSelf.socialChannel.profileDetails.fbID)
                {
                    weakSelf.registrationType = eRegistrationFromDigit;
                }
                
                if(weakSelf.registrationType == eRegistrationFromFB)
                {
                    parameters =  @{@"reg_type": @"fb",
                                    @"digits":session.phoneNumber,
                                    @"fb_id":weakSelf.socialChannel.profileDetails.fbID};
                }
                else
                {
                    parameters =  @{@"reg_type": @"digits",
                                    @"digits":session.phoneNumber};
                }
                [self startActivityIndicator:YES];
                [[BUWebServicesManager sharedManager] queryServer:parameters
                                                          baseURL:@"register"
                                                     successBlock:^(id inResult, NSError *error)
                 {
                     if(YES == [[inResult valueForKey:@"msg"] isEqualToString:@"Success"])
                     {
                        [[NSUserDefaults standardUserDefaults] setValue:[inResult valueForKey:@"userid"] forKey:@"userid"];
                        [[NSUserDefaults standardUserDefaults] setValue:[inResult valueForKey:@"referral_code"] forKey:@"referral_code"];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                         
                         [BUWebServicesManager sharedManager].userID = [inResult valueForKey:@"userid"];
                         [BUWebServicesManager sharedManager].referalCode = [inResult valueForKey:@"referral_code"];
                         NSLog(@"%@",[inResult valueForKey:@"userid"]);
                         
                         [weakLayer setCurrentUserID:[BUWebServicesManager sharedManager].userID];
                         
                         [weakLayer authenticateLayerWithsuccessBlock:^(id response, NSError *error) {
                             
                             UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                             BUAccountCreationVC *vc = [sb instantiateViewControllerWithIdentifier:@"AccountCreationVC"];
                             vc.socialChannel = self.socialChannel;
                             vc.isDirect = NO;
                             [weakSelf.navigationController pushViewController:vc animated:YES];
                             [weakSelf stopActivityIndicator];
                         } failureBlock:^(id response, NSError *error) {
                             {
                                 
                                 UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                 BUAccountCreationVC *vc = [sb instantiateViewControllerWithIdentifier:@"AccountCreationVC"];
                                 vc.isDirect = NO;
                                 vc.socialChannel = weakSelf.socialChannel;
                                 [weakSelf.navigationController pushViewController:vc animated:YES];
                                 [weakSelf stopActivityIndicator];
                                 return ;
                             }
                         }];
                     }
                     else
                     {
                         if ([[inResult valueForKey:@"profile_status"] isEqualToString:@"create_account_ws"]) {
                             UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                             BUAccountCreationVC *vc = [sb instantiateViewControllerWithIdentifier:@"AccountCreationVC"];
                             vc.isDirect = NO;
                             vc.socialChannel = weakSelf.socialChannel;
                             [weakSelf stopActivityIndicator];

                             [weakSelf.navigationController pushViewController:vc animated:YES];
                         }else{
                             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Do you want to login?" message:[inResult valueForKey:@"response"] preferredStyle:UIAlertControllerStyleAlert];
                             [BUWebServicesManager sharedManager].userID = [inResult valueForKey:@"userid"];
                             [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                                 [[Digits sharedInstance] logOut];
                             }]];
                             [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
                                 BULoginViewController *buloginViewController = [[weakSelf storyboard] instantiateViewControllerWithIdentifier:@"BULoginViewController"];
                                 [weakSelf.navigationController pushViewController:buloginViewController animated:YES];
                             }]];
                             [weakSelf stopActivityIndicator];

                             [weakSelf presentViewController:alertController animated:YES completion:nil];
                             
                         }
                     }
                 } failureBlock:^(id response, NSError *error) {
                     if (error.code == NSURLErrorTimedOut) {
                         [weakSelf timeoutError:@"Connection timed out, please try again later"];
                         return ;
                     }
                     
                     [weakSelf showAlert:@"Registration Failed"];
                     [weakSelf stopActivityIndicator];
                     [[Digits sharedInstance]logOut];
                 }];
            });
        } else {
            NSLog(@"Authentication error: %@", error.localizedDescription);
        }
    }];
}

-(void)didSuccess:(id)inResult;
{
    
    if(YES == [[inResult valueForKey:@"msg"] isEqualToString:@"Success"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:[inResult valueForKey:@"userid"] forKey:@"userid"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [BUWebServicesManager sharedManager].userID = [inResult valueForKey:@"userid"];
        
        
        [Localytics tagEvent:@"Registration Successful"];
        [Localytics setCustomerId:[inResult valueForKey:@"userid"]];;
        
        NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"Registration Successful"];
        [message addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"comfortaa" size:15]
                        range:NSMakeRange(0, message.length)];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController setValue:message forKey:@"attributedTitle"];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action)
                                   {
                                       UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                       BUAccountCreationVC *vc = [sb instantiateViewControllerWithIdentifier:@"AccountCreationVC"];
                                       vc.isDirect = NO;
                                       vc.socialChannel = self.socialChannel;
                                       [self.navigationController pushViewController:vc animated:YES];
                                   }];
        
        [alertController addAction:okAction];
        [self stopActivityIndicator];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else
    {
        [self showAlert:@"Registration Failed"];
    }
    
}
@end
