//
//  BUHomeTabbarController.m
//  TheBureau
//
//  Created by Manjunath on 08/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUHomeTabbarController.h"
#import "AirshipLib.h"
#import "AirshipKit.h"
#import "AirshipCore.h"
#import "BUWebServicesManager.h"
#import "AppDelegate.h"
#import "BUChatContact.h"
#import <CRToast/CRToast.h>
#import "LQSViewController.h"
#import "BUConstants.h"
#import <Smooch/Smooch.h>
#import "BUHomeConnectionsVC.h"
#import "BUCustomerServiceChatVC.h"
@interface BUHomeTabbarController ()<UAPushNotificationDelegate>

@property(nonatomic, strong) NSTimer *urbanAirshipTimer;
@property(nonatomic)BOOL didLoad;
@property(nonatomic, assign) BOOL isSmoochEnabled;
@end

@implementation BUHomeTabbarController

//+ (void)initialize
//{
//    [MPNotificationView registerNibNameOrClass:@"CustomNotificationView"
//                        forNotificationsOfType:@"Custom"];
//    [MPNotificationView registerNibNameOrClass:[MyNotificationView class]
//                        forNotificationsOfType:@"Blinking"];
//}
//- (void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
//- (void)didTapOnNotificationView:(MPNotificationView *)notificationView
//{
//    NSLog( @"Received touch for notification with text: %@", notificationView.textLabel.text );
//}
//
//- (void)tapReceivedNotificationHandler:(NSNotification *)notice
//{
//    MPNotificationView *notificationView = (MPNotificationView *)notice.object;
//    if ([notificationView isKindOfClass:[MPNotificationView class]])
//    {
//        NSLog( @"Received touch for notification with text: %@", ((MPNotificationView *)notice.object).textLabel.text );
//    }
//}
//
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // self.isSmoochEnabled = NO;
    //    MPNotificationView *notification = [MPNotificationView notifyWithText:@"Hello World!" andDetail:@"This is a test"];
    //    notification.delegate = self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(smoochConversationViewControllerPresented) name:@"BUSmoochConversationViewControllerPresentedNotification" object:nil];
    //open source
    // [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(tapReceivedNotificationHandler:)
    //                                                 name:kMPNotificationViewTapReceivedNotification
    //                                               object:nil];
    //
    
    
    
    
    
    
    
    
    
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"TheBureau";
    NSLog(@"********** is ");
    self.navigationItem.hidesBackButton = YES;
    // Call takeOff (which creates the UAirship singleton)
    [UAirship takeOff];
    
    // User notifications will not be enabled until userPushNotificationsEnabled is
    // set YES on UAPush. Once enabled, the setting will be persisted and the user
    // will be prompted to allow notifications. Normally, you should wait for a more
    // appropriate time to enable push to increase the likelihood that the user will
    // accept notifications.
    [UAirship push].userPushNotificationsEnabled = YES;
    
    [UAirship push].pushNotificationDelegate = self;
    _didLoad = YES;
    
    [self getChatNotif];
    [self getAccountStatus];
    [self getContactDetails];
    
    self.urbanAirshipTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(setUrbanAirshipChannel) userInfo:nil repeats:YES];
    
    NSArray *xibViews = [[NSBundle mainBundle] loadNibNamed:@"rightButtonView" owner:nil options:nil];
    self.rightBtnView = [xibViews lastObject];
    
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtnView];
    
    [[self navigationItem] setRightBarButtonItem:rightBtnItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatecnIndex:) name:@"updateBadge" object:nil];
    
}

#pragma Smooch from
// Notification Selector
-(void)smoochConversationViewControllerPresented{
    self.isSmoochEnabled = YES;
}

-(void)showFailureAlert:(NSString *)toast
{
    NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:toast];
    [message addAttribute:NSFontAttributeName
                    value:[UIFont fontWithName:@"comfortaa" size:15]
                    range:NSMakeRange(0, message.length)];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController setValue:message forKey:@"attributedTitle"];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)updatecnIndex:(NSNotification *)notification {
    
    NSLog(@"Badge Increment");
    
    
    if (_didLoad == YES) {
        
        return;
    }
    NSLog(@"Badge Increment else ");
    
    [self getContactDetails];
}

-(void)getAccountStatus {
    NSString *baseURl = [NSString stringWithFormat:@"profile/accountStatus/userid/%@",[BUWebServicesManager sharedManager].userID];
    __weak typeof(self) weakSelf = self;
    
    [[BUWebServicesManager sharedManager] getqueryServer:nil
                                                 baseURL:baseURl
                                            successBlock:^(id response, NSError *error)
     {
         bool status = NO;
         
         if([[response valueForKey:@"status"] isEqualToString:@"active"])
         {
             status = YES;
         }
         
         [[NSUserDefaults standardUserDefaults] setBool:status forKey:@"accountStatus"];
     }
                                            failureBlock:^(id response, NSError *error)
     {
         
         NSLog(@"getAccountStatus-error= %@",error);
         
         if (error.code == NSURLErrorTimedOut) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [weakSelf showFailureAlert:@"Connection timed out, please try again later"];
             });
         }
         else {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [weakSelf showFailureAlert:@"Connectivity Error"];
             });
         }
     }];
}



-(void)getChatNotif {
    
    NSString *baseURl = [NSString stringWithFormat:@"configuration/view/userid/%@",[BUWebServicesManager sharedManager].userID];
    __weak typeof(self) weakSelf = self;
    [[BUWebServicesManager sharedManager] getqueryServer:nil baseURL:baseURl successBlock:^(id response, NSError *error) {
        if([response valueForKey:@"msg"] != nil && [[response valueForKey:@"msg"] isEqualToString:@"Error"])
        {
            if ([response objectForKey:@"notification"] != nil) {
                NSDictionary *notif = [[response objectForKey:@"notification"] objectAtIndex:0];
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"BUAppNotificationCellTypeDailyMatch"];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"BUAppNotificationCellTypeChatNotifications"];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"BUAppNotificationCellTypeCustomerService"];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"BUAppNotificationCellTypeBlogRelease"];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"BUAppNotificationCellTypeSounds"];
                
                
                [[NSUserDefaults standardUserDefaults] setBool:[[notif objectForKey:@"daily_match"] isEqualToString:@"Enable"] ? YES : NO forKey:@"BUAppNotificationCellTypeDailyMatch1"];
                [[NSUserDefaults standardUserDefaults] setBool:[[notif objectForKey:@"chat_notification"] isEqualToString:@"Enable"] ? YES : NO forKey:@"BUAppNotificationCellTypeChatNotifications1"];
                [[NSUserDefaults standardUserDefaults] setBool:[[notif objectForKey:@"customer_service"] isEqualToString:@"Enable"] ? YES : NO forKey:@"BUAppNotificationCellTypeCustomerService1"];
                [[NSUserDefaults standardUserDefaults] setBool:[[notif objectForKey:@"blog_release"] isEqualToString:@"Enable"] ? YES : NO forKey:@"BUAppNotificationCellTypeBlogRelease1"];
                [[NSUserDefaults standardUserDefaults] setBool:[[notif objectForKey:@"sound"] isEqualToString:@"Enable"] ? YES : NO forKey:@"BUAppNotificationCellTypeSounds1"];
                
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
        }
        else
        {
            //             {"configuration":[{"notification_id":"142","userid":"144","daily_match":"YES","chat_notification":"YES","customer_service":"YES","blog_release":"YES","sound":"YES"}],"notification":[{"customer_service":"Disable","blog_release":"Disable","daily_match":"Enable","chat_notification":"Enable","sound":"Enable"}]}
            
            NSDictionary *config = [[response objectForKey:@"configuration"] objectAtIndex:0];
            
            NSDictionary *notif = [[response objectForKey:@"notification"] objectAtIndex:0];
            
            [[NSUserDefaults standardUserDefaults] setBool:[[config objectForKey:@"daily_match"] isEqualToString:@"YES"] ? YES : NO forKey:@"BUAppNotificationCellTypeDailyMatch"];
            [[NSUserDefaults standardUserDefaults] setBool:[[config objectForKey:@"chat_notification"] isEqualToString:@"YES"] ? YES : NO forKey:@"BUAppNotificationCellTypeChatNotifications"];
            [[NSUserDefaults standardUserDefaults] setBool:[[config objectForKey:@"customer_service"] isEqualToString:@"YES"] ? YES : NO forKey:@"BUAppNotificationCellTypeCustomerService"];
            [[NSUserDefaults standardUserDefaults] setBool:[[config objectForKey:@"blog_release"] isEqualToString:@"YES"] ? YES : NO forKey:@"BUAppNotificationCellTypeBlogRelease"];
            [[NSUserDefaults standardUserDefaults] setBool:[[config objectForKey:@"sound"] isEqualToString:@"YES"] ? YES : NO forKey:@"BUAppNotificationCellTypeSounds"];
            
            [[NSUserDefaults standardUserDefaults] setBool:[[notif objectForKey:@"daily_match"] isEqualToString:@"Enable"] ? YES : NO forKey:@"BUAppNotificationCellTypeDailyMatch1"];
            [[NSUserDefaults standardUserDefaults] setBool:[[notif objectForKey:@"chat_notification"] isEqualToString:@"Enable"] ? YES : NO forKey:@"BUAppNotificationCellTypeChatNotifications1"];
            [[NSUserDefaults standardUserDefaults] setBool:[[notif objectForKey:@"customer_service"] isEqualToString:@"Enable"] ? YES : NO forKey:@"BUAppNotificationCellTypeCustomerService1"];
            [[NSUserDefaults standardUserDefaults] setBool:[[notif objectForKey:@"blog_release"] isEqualToString:@"Enable"] ? YES : NO forKey:@"BUAppNotificationCellTypeBlogRelease1"];
            [[NSUserDefaults standardUserDefaults] setBool:[[notif objectForKey:@"sound"] isEqualToString:@"Enable"] ? YES : NO forKey:@"BUAppNotificationCellTypeSounds1"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
    } failureBlock:^(id response, NSError *error) {
        NSLog(@"getChatNotif-error= %@",error);
        if (error.code == NSURLErrorTimedOut) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf showFailureAlert:@"Connection timed out, please try again later"];
                
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf showFailureAlert:@"Connection timed out, please try again later"];
                
            });
        }
    }];
}


-(void)setUrbanAirshipChannel
{
    
    //    NSString *udid = [[NSUUID UUID] UUIDString];
    //
    //    NSString* uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString]; // IOS 6+
    //    NSLog(@"UDID:: %@ %@", uniqueIdentifier,udid);
    
    if(nil != [UAirship push].channelID)
    {
        
        NSLog(@"ChannelID Printed : %@",[UAirship push].channelID);
        
        
        [self setiOSChannel:[UAirship push].channelID];
        [self.urbanAirshipTimer invalidate];
    }
}
-(void)setiOSChannel:(NSString *)inChannel
{
    NSString *udid = [[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"];
    NSDictionary *parameters = nil;
    parameters = @{@"userid": [BUWebServicesManager sharedManager].userID,
                   @"device_id" : udid,
                   @"device_type" : @"ios"
                   };
    NSString *baseURl = @"notification/register_device";
    
    [[BUWebServicesManager sharedManager] queryServer:parameters
                                              baseURL:baseURl
                                         successBlock:^(id response, NSError *error) {
                                             NSLog(@"Success Block %@",response);
                                         }
                                         failureBlock:^(id response, NSError *error) {
                                             NSLog(@"failureBlock  %@",[error description]);
                                         }];
    
}

- (void)displayNotificationAlert:(NSString *)alertMessage
{
    
    
    NSLog(@"displayNotificationAlert ==> %@",alertMessage);
    //    [UIApplication sharedApplication].windows rootViewController).visibleViewController
    if ([self.navigationController.topViewController isKindOfClass:[LQSViewController class]]) {
        
        return;
    }
    
    if ([self.selectedViewController isKindOfClass:[BUHomeConnectionsVC class]]) {
        BUHomeConnectionsVC *vc = (BUHomeConnectionsVC*) self.selectedViewController;
        if (vc.csChatBtn.isSelected && [UIAppDelegate.notificationDict valueForKey:@"SmoochNotification"]) {
            return;
        }
    }
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"BUAppNotificationCellTypeSounds"]== YES) {
        
        NSLog(@"inside of the loop");
        
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                             pathForResource:@"NOTE"
                                             ofType:@"mp3"]];
        
        NSError *error;
        if (!_audioPlayer) {
            _audioPlayer =  [[AVAudioPlayer alloc]
                             initWithContentsOfURL:url
                             error:&error];
        }
        if (error)
        {
            NSLog(@"Error in audioPlayer: %@",
                  [error localizedDescription]);
        } else {
            
            [_audioPlayer play];
            NSLog(@"Sound Plays");
        }
    }
    else
    {
        NSLog(@"outside the of the loop");
    }
    
    
    
    [CRToastManager showNotificationWithOptions:[self options:alertMessage]
                                 apperanceBlock:^(void) {
                                     NSLog(@"Appeared");
                                 }
                                completionBlock:^(void) {
                                    NSLog(@"Completed");
                                }];

}

-(void)receiveTestNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"matchNotification"])
        NSLog (@"Successfully received the test notification!");
}

- (NSDictionary*)options:(NSString *)alertMessage {
    
    NSMutableDictionary *options = [@{
                                      kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar) ,
                                      kCRToastNotificationPresentationTypeKey : @(CRToastPresentationTypeCover),
                                      kCRToastTextAlignmentKey                : @(NSTextAlignmentLeft),
                                      kCRToastTextKey :alertMessage,
                                      kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                      kCRToastBackgroundColorKey : [[UIColor blackColor] colorWithAlphaComponent:0.8f],
                                      kCRToastAnimationInDirectionKey : @(CRToastAccessoryViewAlignmentLeft),
                                      kCRToastAnimationOutDirectionKey : @(CRToastAccessoryViewAlignmentLeft),
                                      }mutableCopy];
    
    options[kCRToastImageKey] = [UIImage imageNamed:@"notification.png"];
    
    options[kCRToastInteractionRespondersKey] = @[[CRToastInteractionResponder interactionResponderWithInteractionType:CRToastInteractionTypeTap
                                                                                                  automaticallyDismiss:YES
                                                                                                                 block:^(CRToastInteractionType interactionType)
                                                   {
                                                       
                                                       
                                                       if (UIAppDelegate.notificationDict[@"layer"])
                                                       {
                                                           [[NSNotificationCenter defaultCenter] postNotificationName:@"InAppNotification" object:self userInfo:UIAppDelegate.notificationDict];
                                                           //DLog(@"UIAppDelegate.chatNotification = YES");
                                                           UIAppDelegate.chatNotification = YES;
                                                           //yogish
                                                           UIViewController *topViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
                                                           
                                                           while (true)
                                                           {
                                                               if (topViewController.presentedViewController) {
                                                                   topViewController = topViewController.presentedViewController;
                                                                   
                                                               } else if ([topViewController isKindOfClass:[UINavigationController class]]) {
                                                                   UINavigationController *nav = (UINavigationController *)topViewController;
                                                                   topViewController = nav.topViewController;
                                                                   if ([topViewController isKindOfClass:[self class]]) {
                                                                       
                                                                       self.selectedViewController = [self.viewControllers objectAtIndex:2];
                                                                       BUHomeConnectionsVC *vc = (BUHomeConnectionsVC*) self.selectedViewController;
                                                                       [vc tabChanges:vc.chatBtn];
                                                                   }else{
                                                                       [nav popToViewController:self animated:YES];
                                                                       self.selectedViewController = [self.viewControllers objectAtIndex:2];
                                                                   }
                                                               }  else {
                                                                   break;
                                                               }
                                                           }
                                                       }else if ([UIAppDelegate.notificationDict objectForKey:@"SmoochNotification"]){
                                                           
                                                           //DLog(@"UIAppDelegate.chatNotification = YES");
                                                           //  UIAppDelegate.chatNotification = YES;
                                                           //yogish
                                                           UIViewController *topViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
                                                           
                                                           while (true)
                                                           {
                                                               if (topViewController.presentedViewController) {
                                                                   topViewController = topViewController.presentedViewController;
                                                                   
                                                               } else if ([topViewController isKindOfClass:[UINavigationController class]]) {
                                                                   UINavigationController *nav = (UINavigationController *)topViewController;
                                                                   topViewController = nav.topViewController;
                                                                   if ([topViewController isKindOfClass:[self class]]) {
                                                                       
                                                                       self.selectedViewController = [self.viewControllers objectAtIndex:2];
                                                                       [[NSNotificationCenter defaultCenter] postNotificationName:@"InAppNotification" object:self userInfo:UIAppDelegate.notificationDict];
                                                                       //                                                                       BUHomeConnectionsVC *vc = (BUHomeConnectionsVC*) self.selectedViewController;
                                                                       //  [vc tabChanges];
                                                                   }else{
                                                                       [nav popToViewController:self animated:YES];
                                                                       self.selectedViewController = [self.viewControllers objectAtIndex:2];
                                                                       [[NSNotificationCenter defaultCenter] postNotificationName:@"InAppNotification" object:self userInfo:UIAppDelegate.notificationDict];
                                                                   }
                                                               }  else {
                                                                   break;
                                                               }
                                                           }
                                                       }
                                                       else {
                                                           
                                                           NSString *notfString = [UIAppDelegate.notificationDict objectForKey:@"extra"];
                                                           NSArray *items = @[@"match",@"direct",@"bonus",@"connected",@"gold"];
                                                           NSInteger item = [items indexOfObject:notfString];
                                                           UIViewController *topViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
                                                           UINavigationController *nav = (UINavigationController *)topViewController;
                                                           topViewController = nav.topViewController;
                                                           if ([topViewController isKindOfClass:[self class]]) {
                                                               [self loadTabBarItemsonGivenIndex:item];
                                                           }else{
                                                               [nav popToViewController:self animated:YES];
                                                               [self loadTabBarItemsonGivenIndex:item];
                                                           }
                                                       }
                                                   }]];
    return [NSDictionary dictionaryWithDictionary:options];
    
}

-(void)loadTabBarItemsonGivenIndex:(NSInteger) inIndex{
    if (self.isSmoochEnabled) {
        self.isSmoochEnabled = NO;
        [Smooch close];
    }
    switch (inIndex) {
        case 0: case 1: case 2:
            
            self.selectedViewController = [self.viewControllers objectAtIndex:0];
            
            break;
            
        case 3:
            
            self.selectedViewController = [self.viewControllers objectAtIndex:2];
            
            break;
            
        case 4:
            
            self.selectedViewController = [self.viewControllers objectAtIndex:3];
            
            break;
            
        default:
            
            break;
    }
}

-(void)getContactDetails
{
    
    //    LYRConversation *conversation = [self.layerClient newConversationWithParticipants:[NSSet setWithObjects:@"USER-IDENTIFIER", nil] options:nil error:nil];
    //
    //[UIAppDelegate.historyList removeAllObjects];
    
    //    NSArray *actualChatList = [[NSArray alloc] init];
    _didLoad = NO;
    NSString *baseURl = [NSString stringWithFormat:@"chat/view/userid/%@",[BUWebServicesManager sharedManager].userID];
    __weak typeof(self) weakSelf = self;
    [[BUWebServicesManager sharedManager] getqueryServer:nil
                                                 baseURL:baseURl
                                            successBlock:^(id response, NSError *error)
     {
         //[self stopActivityIndicator];
         
         NSMutableArray *dArray = [[NSMutableArray alloc]init];
         for (int j=0; j<[response count]; j++) {
             [dArray addObject:[response objectAtIndex:j]];
         }
         
         NSArray *actualChatList = [[NSOrderedSet orderedSetWithArray:dArray] array];
         
         [[weakSelf.viewControllers objectAtIndex:2] tabBarItem].badgeValue = [NSString stringWithFormat:@"%d",(int)[actualChatList count]];
     }
                                            failureBlock:^(id response, NSError *error)
     {
         //[self stopActivityIndicator];
         NSLog(@"getContactDetails-error= %@",error);
         
         if (error.code == NSURLErrorTimedOut) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [weakSelf showFailureAlert:@"Connection timed out, please try again later"];
             });
         }
         else
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [weakSelf showFailureAlert:@"Connectivity Error"];
             });
         }
     }];
}

- (void)receivedForegroundNotification:(NSDictionary *)notification {
    
    NSLog(@"Notification received is : %@",notification);
    
    UIAppDelegate.notificationDict = [[NSDictionary alloc]init];
    
    UIAppDelegate.notificationDict = notification;
    //     if (notification[@"layer"])
    //     {
    //         UIAppDelegate.notificationDict = notification;
    //         NSLog(@"yesNotif");
    //         NSLog(@"Notification contains %@",UIAppDelegate.notificationDict);
    //
    //     }
    NSLog(@"haiiiiii %@",UIAppDelegate.notificationDict);
    
    NSString *notfString = [UIAppDelegate.notificationDict objectForKey:@"extra"];
    
    NSLog(@"Sting is contains %@",notfString);
    
    NSArray *items = @[@"match",@"direct",@"bonus", @"connected",@"gold"];
    NSInteger item = [items indexOfObject:notfString];
    switch (item) {
        case 0: case 1: case 2:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateRoot" object:nil];
            break;
        case 3:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBadge" object:nil];
            break;
        case 4:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateGold" object:nil];
            break;
        default:
            break;
    }
    
    NSDictionary *dict = [notification objectForKey:@"data"];
    NSString *userID = [dict objectForKey:@"userid"];
    NSDictionary *aps = [notification objectForKey:@"aps"];
    NSString *alert = [aps objectForKey:@"alert"];
    
    if (alert) {
        if ([self.navigationController.topViewController isKindOfClass:[LQSViewController class]]){
            LQSViewController *controller = (LQSViewController*)self.navigationController.topViewController;
            NSString *currentUserID = controller.participantId;
            if (![currentUserID isEqualToString:userID]) {
                if ([[NSUserDefaults standardUserDefaults]boolForKey:@"BUAppNotificationCellTypeSounds"]== YES) {
                    
                    NSLog(@"inside of the loop");
                    
                    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                         pathForResource:@"NOTE"
                                                         ofType:@"mp3"]];
                    NSError *error;
                    if (!_audioPlayer) {
                        _audioPlayer = [[AVAudioPlayer alloc]  initWithContentsOfURL:url   error:&error];
                    }
                    if (error) {
                        NSLog(@"Error in audioPlayer: %@",
                              [error localizedDescription]);
                    } else {
                        
                        [_audioPlayer play];
                        NSLog(@"Sound Plays");
                    }
                }
                else
                {
                    NSLog(@"outside of the loop");
                }
                
                [CRToastManager showNotificationWithOptions:[self options:alert]
                                             apperanceBlock:^(void) {
                                                 NSLog(@"Appeared");
                                             }
                                            completionBlock:^(void) {
                                                NSLog(@"Completed");
                                            }];
                
                
                //NSDictionary* userInfo = @{@"userID": userID, @"currentUserID":currentUserID};
                // [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadChatForDifferentUser" object:nil userInfo:userInfo];
            }
        }
    }else{
        return;
    }
}

- (void)launchedFromNotification:(NSDictionary *)notification actionIdentifier:(NSString *)identifier completionHandler:(void (^)())completionHandler {
    NSLog(@"notif1");
}


/**
 * Called when the app is started from a user notification action button with background activation mode.
 *
 * @param notification The notification dictionary.
 * @param identifier The user notification action identifier.
 * @param completionHandler Should be called as soon as possible.
 */
- (void)receivedBackgroundNotification:(NSDictionary *)notification actionIdentifier:(NSString *)identifier completionHandler:(void (^)())completionHandler {
    NSLog(@"notif2");
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

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return YES;
}

-(void)updateGoldValue:(NSInteger)inGoldValue {
    if (inGoldValue == [self.rightBtnView.goldLabel.text integerValue]) {
        return;
    }
    [UIView transitionWithView:self.rightBtnView
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionFlipFromLeft|UIViewAnimationCurveEaseOut
                    animations:^{
                        self.rightBtnView.goldLabel.text = [NSString stringWithFormat:@"%ld",(long)inGoldValue];
                    }completion:nil];
}

@end
