//
//  BUSplashViewController.m
//  TheBureau
//
//  Created by Accion Labs on 18/01/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUSplashViewController.h"
#import "UIImage+animatedGIF.h"
#import "BUProfileOccupationVC.h"
#import "BUProfileSelectionVC.h"
#import "BUProfileDetailsVC.h"
#import "BUAccountCreationVC.h"
#import "BUHomeTabbarController.h"
#import "BUProfileLegalStatusVC.h"
#import "BUProfileDietVC.h"
#import "BUProfileHeritageVC.h"
#import "BUProfileRematchVC.h"
#import "BUContactListViewController.h"
#import "Localytics.h"
#import "BULayerHelper.h"
#import "BURootViewController.h"
#import "AppDelegate.h"
#import "UINavigationController+CompletionHandler.h"
#import <SDWebImage/UIImage+GIF.h>

@interface BUSplashViewController () {
    NSTimer *splashTimer;
    
}
@property (strong, nonatomic) IBOutlet UIImageView *dataImageView;
@end

@implementation BUSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"splash_new_iPhone" withExtension:@"gif"];
    self.dataImageView.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];
        // self.dataImageView.image = [UIImage sd_animatedGIFNamed:@"splash_new_iPhone.gif"];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    splashTimer  = [NSTimer scheduledTimerWithTimeInterval:6.2 target:self selector:@selector(setSplashTimer) userInfo:nil repeats:NO];
}

-(void)getProfileDetails:(NSDictionary*)response {
    
    [self startActivityIndicator:YES];
    NSString *baseURl = [NSString stringWithFormat:@"profile/readprofiledetails/userid/%@",[BUWebServicesManager sharedManager].userID];
    __weak typeof(self) weakSelf = self;
    [[BUWebServicesManager sharedManager] getqueryServer:nil
                                              baseURL:baseURl
                                         successBlock:^(id response1, NSError *error)
     {
         [weakSelf stopActivityIndicator];
         [weakSelf stopActivityIndicator];
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
         [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action) {
                                         if ([[response valueForKey:@"profile_status"] isEqualToString:@"create_account_ws"]) {
                                             vc.isDirect = NO;
                                             [weakSelf.navigationController pushViewController:vc animated:YES];
                                             return ;
                                         }
                                         else if ([[response valueForKey:@"profile_status"] isEqualToString:@"update_profile_step2"]) {
                                             [weakSelf.navigationController completionhandler_pushViewController:vc animated:NO completion:^(void){
                                                 [vc.navigationController pushViewController:vc1 animated:NO];
                                             }];
                                             return ;
                                         }
                                         else if ([[response valueForKey:@"profile_status"] isEqualToString:@"update_profile_step3"]) {
                                             
                                             [weakSelf.navigationController completionhandler_pushViewController:vc animated:NO completion:^(void){
                                                 [weakSelf.navigationController completionhandler_pushViewController:vc1 animated:NO completion:^(void){
                                                     [vc1.navigationController pushViewController:vc2 animated:NO];
                                                 }];
                                             }];
                                             
                                             return ;
                                         }
                                         else if ([[response valueForKey:@"profile_status"] isEqualToString:@"update_profile_step4"]) {
                                             
                                             
                                             [weakSelf.navigationController completionhandler_pushViewController:vc animated:NO completion:^(void){
                                                 [weakSelf.navigationController completionhandler_pushViewController:vc1 animated:NO completion:^(void){
                                                     [weakSelf.navigationController completionhandler_pushViewController:vc2 animated:NO completion:^(void){
                                                         [vc2.navigationController pushViewController:vc3 animated:NO];
                                                     }];
                                                 }];
                                             }];
                                             return ;
                                         }
                                         else if ([[response valueForKey:@"profile_status"] isEqualToString:@"update_profile_step5"]) {
                                             [weakSelf.navigationController completionhandler_pushViewController:vc animated:NO completion:^(void){
                                                 [weakSelf.navigationController completionhandler_pushViewController:vc1 animated:NO completion:^(void){
                                                     [weakSelf.navigationController completionhandler_pushViewController:vc2 animated:NO completion:^(void){
                                                         [weakSelf.navigationController completionhandler_pushViewController:vc3 animated:NO completion:^(void){
                                                             [vc3.navigationController pushViewController:vc4 animated:NO];
                                                         }];
                                                     }];
                                                 }];
                                             }];
                                             return ;
                                         }
                                         else if ([[response valueForKey:@"profile_status"] isEqualToString:@"update_profile_step6"]) {
                                             [weakSelf.navigationController completionhandler_pushViewController:vc animated:NO completion:^(void){
                                                 [weakSelf.navigationController completionhandler_pushViewController:vc1 animated:NO completion:^(void){
                                                     [weakSelf.navigationController completionhandler_pushViewController:vc2 animated:NO completion:^(void){
                                                         [weakSelf.navigationController completionhandler_pushViewController:vc3 animated:NO completion:^(void){
                                                             [weakSelf.navigationController completionhandler_pushViewController:vc4 animated:NO completion:^(void){
                                                                 [vc4.navigationController pushViewController:vc5 animated:NO];
                                                             }];
                                                         }];
                                                     }];
                                                 }];
                                             }];
                                             return ;
                                         }
                                                                   //        [NSCache
                                         weakSelf.dataImageView.image = nil;
                                     }]];
         [weakSelf presentViewController:alertController animated:YES completion:nil];
     }
                                         failureBlock:^(id response, NSError *error)
     {
         [weakSelf stopActivityIndicator];
     }
     ];
    
}


-(void)checkForAccountCreation
{
    
    NSString *urlString = [NSString stringWithFormat:@"login/validateUserAccount/userid/%@",[BUWebServicesManager sharedManager].userID];
    [self startActivityIndicator:YES];
    __weak typeof(self) welkSelf = self;
    [[BUWebServicesManager sharedManager] getqueryServer:nil
                                                 baseURL:urlString
                                            successBlock:^(id response, NSError *error)
     {
         [welkSelf stopActivityIndicator];
         [welkSelf stopActivityIndicator];
         [welkSelf stopActivityIndicator];
         [welkSelf stopActivityIndicator];
         
         if(YES == [[response valueForKey:@"msg"] isEqualToString:@"Success"]) {
             
             if (![[response valueForKey:@"profile_status"] isEqualToString:@"completed"]) {
                 [welkSelf getProfileDetails:response];
                 return;
             }
             
             UIStoryboard *sb =[UIStoryboard storyboardWithName:@"HomeView" bundle:nil];
             BUHomeTabbarController *vc = [sb instantiateViewControllerWithIdentifier:@"BUHomeTabbarController"];
            
             [welkSelf.navigationController pushViewController:vc animated:YES];
             
             [[BULayerHelper sharedHelper] setCurrentUserID:[NSString stringWithFormat:@"%@",[BUWebServicesManager sharedManager].userID]];
             
             [welkSelf startActivityIndicator:YES];
             
             [[BULayerHelper sharedHelper] authenticateLayerWithsuccessBlock:^(id response, NSError *error)
              {
                  [welkSelf stopActivityIndicator];
              }
                                                                failureBlock:^(id response, NSError *error)
              {
                  NSLog(@"Failed Authenticating Layer Client with error:%@", error);
                  [welkSelf stopActivityIndicator];
                  //return ;
                  [welkSelf showAlert:[NSString stringWithFormat:@"Failed Authenticating Layer Client with error: %@", error]];
              }];
             welkSelf.dataImageView.image = nil;
         }
         else
         {
             UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
             BURootViewController *vc = [sb instantiateViewControllerWithIdentifier:@"RootViewController"];
             //vc.socialChannel = nil;
             [welkSelf.navigationController pushViewController:vc animated:YES];
             welkSelf.dataImageView.image = nil;
         }
     }
                                         failureBlock:^(id response, NSError *error)
     {
         [welkSelf stopActivityIndicator];
         UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
         BURootViewController *vc = [sb instantiateViewControllerWithIdentifier:@"RootViewController"];
         //vc.socialChannel = nil;
         [welkSelf.navigationController pushViewController:vc animated:YES];
         [welkSelf showAlert:@"Connectivity Error"];
         welkSelf.dataImageView.image = nil;
     }];
}
-(void)setSplashTimer {
    
    [splashTimer invalidate];
    if(nil != [BUWebServicesManager sharedManager].userID) {
        [BUWebServicesManager sharedManager].userName =  [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
        [self checkForAccountCreation];
    }
    else {
        [self performSegueWithIdentifier:@"main" sender:self];
        self.dataImageView.image = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
