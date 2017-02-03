//
//  AppDelegate.m
//  TheBureau
//
//  Created by Manjunath on 26/11/15.
//  Copyright © 2015 Bureau. All rights reserved.
//

#import "AppDelegate.h"
#import "FBController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <DigitsKit/DigitsKit.h>
#import <LayerKit/LayerKit.h>
//#import <Smooch/Smooch.h>
#import "BULayerHelper.h"
#import "AirshipLib.h"
#import "AirshipKit.h"
#import "AirshipCore.h"
#import "BUWebServicesManager.h"
#import "Localytics.h"
#import "BUHomeConnectionsVC.h"
#import "BUHomeTabbarController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "BUProfileMatchChatVC.h"
#import "BUChatContact.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
//#import <FBSDKShareKit/FBSDKShareKit.h>

// "${PODS_ROOT}/Fabric/run" 8761ef7408ba35916fe36c49067b96d6b6efb3ba a327e5abd4f5eebc33831c77535043bb03e26f8a22e86e08f33a9440a1b2f33a // Live

//"${PODS_ROOT}/Fabric/run" 02925ef542d587b0d078678a1e73a90a8291f618 1f3d35b463ef914033b7676eccd517ecebfb6ea559b9fae5e56abbdcba66dbce //Mahiti

@interface AppDelegate ()<UAPushNotificationDelegate>

@end

@implementation AppDelegate
@synthesize notificationDict;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    
//    
//    
//    // Call takeOff (which creates the UAirship singleton)
//    [UAirship takeOff];
//    
//    // User notifications will not be enabled until userPushNotificationsEnabled is
//    // set YES on UAPush. Once enabled, the setting will be persisted and the user
//    // will be prompted to allow notifications. Normally, you should wait for a more
//    // appropriate time to enable push to increase the likelihood that the user will
//    // accept notifications.
//    [UAirship push].userPushNotificationsEnabled = YES;
//    
//    [UAirship push].pushNotificationDelegate = self;
//
    
//    [Fabric with:@[[Digits class], [Twitter class], [Crashlytics class]]];
    
    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"localHistory"];
    
    self.historyList = [[NSMutableArray alloc] init];
   
    
    NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSLog(@"UniqueIdentifier:%@",uniqueIdentifier);
    
     [Localytics integrate:@"dbe88822c4782953d1e04b3-d2c983b2-18c7-11e6-842c-0086bc74ca0f"];
    
//    self.loginManager = [[FBSDKLoginManager alloc] init];

    if(nil != [[NSUserDefaults standardUserDefaults] valueForKey:@"userid"])
    {
        [BUWebServicesManager sharedManager].userID = [[NSUserDefaults standardUserDefaults] valueForKey:@"userid"];
        [BUWebServicesManager sharedManager].referalCode = [[NSUserDefaults standardUserDefaults] valueForKey:@"refCode"];
    }
    else
    {
        [BUWebServicesManager sharedManager].userID =  nil;
        [BUWebServicesManager sharedManager].referalCode = nil;
    }
    
    self.historyList = [[NSMutableArray alloc] init];
    
    [Fabric with:@[[Crashlytics class],[DigitsKit class]]];
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];

 // Checking if app is running iOS 8
//    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        // Register device for iOS8
        UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:notificationSettings];
        [application registerForRemoteNotifications];
    
//    } else {
//        // Register device for iOS7
//        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge];
//    }
    
//    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
//    {
//        // iOS 8 Notifications
//        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
//        
//        [application registerForRemoteNotifications];
//    }
//    else
//    {
//        // iOS < 8 Notifications
//        //        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
//    }
    application.applicationIconBadgeNumber = 0;
    [self setAppearence];
       
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    const unsigned *tokenBytes = [deviceToken bytes];
    
    //[[UAPush shared] registerDeviceToken:deviceToken];
    
    [Localytics setPushToken:deviceToken];
       NSError *error;
    BOOL success = [[BULayerHelper sharedHelper].layerClient updateRemoteNotificationDeviceToken:deviceToken
                                                                                           error:&error];
    if (success) {
        NSLog(@"Layer Application did register for remote notifications");
    } else {
        NSLog(@"Error updating Layer device token for push:%@", error);
    }

    
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    NSLog(@"Token is < %@ >",hexToken);
    //deviceId=hexToken;
    [[NSUserDefaults standardUserDefaults] setObject:hexToken forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"%@",error.userInfo);
}
- (void)setAppearence {
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -6000)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:213.0f/255.0f
                                                                  green:15.0f/255.0f
                                                                   blue:17.0f/255.0f
                                                                  alpha:1.0f]];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    
    // [[UIWindow appearance] setTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName : [UIFont fontWithName:@"Comfortaa" size:20]}];
    [UINavigationBar appearance].translucent = NO;
       
}

//#pragma Remote  Notification Delegates 
//
//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
//{
//    if(nil == deviceToken)
//        return;
//    
//    [Localytics setPushToken:deviceToken];
//
//    NSError *error;
//    BOOL success = [[BULayerHelper sharedHelper].layerClient updateRemoteNotificationDeviceToken:deviceToken
//                                                                                           error:&error];
//    if (success) {
//        NSLog(@"Application did register for remote notifications");
//    } else {
//        NSLog(@"Error updating Layer device token for push:%@", error);
//    }
//}



- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    NSLog(@"%@",[NSString stringWithFormat:@"%@,%@,%@",url,sourceApplication,annotation]);
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [Localytics dismissCurrentInAppMessage];
    [Localytics closeSession];
    [Localytics upload];
    
    

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [Localytics openSession];
    [Localytics upload];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [application setApplicationIconBadgeNumber:0];
    [FBSDKAppEvents activateApp];
    [Localytics openSession];
    [Localytics upload];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    
    [[Digits sharedInstance]logOut]; // Force fully making session to expire 
    [[NSUserDefaults standardUserDefaults] setObject:[BUWebServicesManager sharedManager].userName forKey:@"setUserName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self saveContext];
}


-(void)application:(UIApplication* )application didReceiveRemoteNotification:(NSDictionary* )userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"Notification contains %@",userInfo);
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"setUserName"]) {
        [BUWebServicesManager sharedManager].userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"setUserName"];
    }
    if(nil != [[NSUserDefaults standardUserDefaults] valueForKey:@"userid"])
    {
        [BUWebServicesManager sharedManager].userID = [[NSUserDefaults standardUserDefaults] valueForKey:@"userid"];
        [BUWebServicesManager sharedManager].referalCode = [[NSUserDefaults standardUserDefaults] valueForKey:@"refCode"];
    }
    else
    {
        [BUWebServicesManager sharedManager].userID =  nil;
        [BUWebServicesManager sharedManager].referalCode = nil;
    }
    
    
    // NSLog(@"Received Remote notification : %@",[[userInfo objectForKey:@"layer"]objectForKey:@"conversation_identifier"]);
    
    if (nil==[BULayerHelper sharedHelper].currentUserID){
        
        NSLog(@"UseriDissss %@",[BULayerHelper sharedHelper].currentUserID);
        [[BULayerHelper sharedHelper] setCurrentUserID:[NSString stringWithFormat:@"%@",[BUWebServicesManager sharedManager].userID]];
        
        [[BULayerHelper sharedHelper] authenticateLayerWithsuccessBlock:^(id response, NSError *error)
         {
             NSLog(@"Successfully connected to layer:%@", response);
         }
                                                           failureBlock:^(id response, NSError *error)
         {
             NSLog(@"Failed Authenticating Layer Client with error1:%@", error);
         }];
        
        
    }
    //// handle local notification
    //    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    //    localNotif.fireDate = [NSDate date]; // date after 10 sec from now
    //    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    //
    //    // Notification details
    //
    //    localNotif.userInfo =  userInfo; // text of you that you have fetched
    //    // Set the action button
    //    localNotif.alertAction = @"View";
    //
    //    localNotif.soundName = UILocalNotificationDefaultSoundName;
    ////    localNotif.applicationIconBadgeNumber = 1;
    //    // Schedule the notification
    [[UIApplication sharedApplication] scheduleLocalNotification:[self customizeLocalNotification:userInfo]];
    
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    if (state == UIApplicationStateBackground || state ==  UIApplicationStateInactive)
    {
        //Do checking here.
        
        @try {
            
            if (userInfo[@"layer"])
            {
                
                UIViewController *currentControllerName = ((UINavigationController*)self.window.rootViewController).visibleViewController;
                NSLog(@"CcurrentControllerName %@",currentControllerName);
                
//                if ([currentControllerName isKindOfClass:[LQSViewController class]]) {
//                    
//                    NSLog(@"okkk %@",currentControllerName);
//                    return;
//                }
                self.notificationDict = [[NSDictionary alloc]init];
                self.notificationDict = userInfo;
                NSLog(@"NotificationDict contains %@",self.notificationDict);
                self.chatNotification = YES;
                UIStoryboard *sb =[UIStoryboard storyboardWithName:@"HomeView" bundle:nil];
                BUHomeTabbarController *vc = [sb instantiateViewControllerWithIdentifier:@"BUHomeTabbarController"];
                if (state == UIApplicationStateInactive) {
                    // vc.selectedViewController = [vc.viewControllers objectAtIndex:2];
                    //yogish
                    vc.selectedViewController = [vc.viewControllers objectAtIndex:2];
                    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
                    self.window.rootViewController = nav;
                    NSLog(@"Viewcpontfoller*** %@",vc.viewControllers);
                }
                //            else
                //            {
                //
                //                vc.selectedViewController = [vc.viewControllers objectAtIndex:2];
                //                UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
                //                self.window.rootViewController = nav;
                //                NSLog(@"Viewcpontfoller*** %@",vc.viewControllers);
                //
                //            }
            }else if (userInfo[@"SmoochNotification"])
            {
                
                UIViewController *currentControllerName = ((UINavigationController*)self.window.rootViewController).visibleViewController;
                NSLog(@"CcurrentControllerName %@",currentControllerName);
                
                //                if ([currentControllerName isKindOfClass:[LQSViewController class]]) {
                //
                //                    NSLog(@"okkk %@",currentControllerName);
                //                    return;
                //                }
                self.notificationDict = [[NSDictionary alloc]init];
                self.notificationDict = userInfo;
                NSLog(@"NotificationDict contains %@",self.notificationDict);
                self.chatNotification = YES;
                UIStoryboard *sb =[UIStoryboard storyboardWithName:@"HomeView" bundle:nil];
                BUHomeTabbarController *vc = [sb instantiateViewControllerWithIdentifier:@"BUHomeTabbarController"];
                if (state == UIApplicationStateInactive) {
                    // vc.selectedViewController = [vc.viewControllers objectAtIndex:2];
                    //yogish
                    vc.selectedViewController = [vc.viewControllers objectAtIndex:2];
                    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
                    self.window.rootViewController = nav;
                    BUHomeConnectionsVC *vc2 = (BUHomeConnectionsVC *)vc.selectedViewController;
                    [vc2 tabChanges:vc2.csChatBtn];
                    NSLog(@"Viewcpontfoller*** %@",vc.viewControllers);
                }
                //            else
                //            {
                //
                //                vc.selectedViewController = [vc.viewControllers objectAtIndex:2];
                //                UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
                //                self.window.rootViewController = nav;
                //                NSLog(@"Viewcpontfoller*** %@",vc.viewControllers);
                //
                //            }
            }

            else
            {
                UIStoryboard *sb =[UIStoryboard storyboardWithName:@"HomeView" bundle:nil];
                BUHomeTabbarController *vc = [sb instantiateViewControllerWithIdentifier:@"BUHomeTabbarController"];
                NSString *notfString = [userInfo objectForKey:@"extra"];
                NSLog(@"Sting is contains %@",notfString);
                NSArray *items = @[@"match",@"direct",@"bonus",@"connected",@"gold"];
                NSInteger item = [items indexOfObject:notfString];
                switch (item) {
                    case 0: case 1: case 2:
                        if (state == UIApplicationStateBackground) {
                            vc.selectedViewController = [vc.viewControllers objectAtIndex:0];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateRoot" object:nil];
                        }
                        else
                        {
                            vc.selectedViewController = [vc.viewControllers objectAtIndex:0];
                            UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
                            self.window.rootViewController = nav;
                        }
                        break;
                    case 3:
                        
                        if (state == UIApplicationStateBackground) {
                            vc.selectedViewController = [vc.viewControllers objectAtIndex:2];
                        }
                        else
                        {
                            vc.selectedViewController = [vc.viewControllers objectAtIndex:2];
                            UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
                            self.window.rootViewController = nav;
                        }
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBadge" object:nil];
                        break;
                    case 4:
                        if (state == UIApplicationStateBackground) {
                            vc.selectedViewController = [vc.viewControllers objectAtIndex:3];
                        }
                        else
                        {
                            vc.selectedViewController = [vc.viewControllers objectAtIndex:3];
                            UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
                            self.window.rootViewController = nav;
                        }
                        break;
                    default:
                        break;
                }
            }
            
            
            
        } @catch (NSException *exception) {
            
            NSLog(@"Crashhhhhhhhhhhhh reason %@",[exception description]);
            
        } @finally {
            
            NSLog(@"Userinfo Success");
        }
        
    }
}

-(UILocalNotification *)customizeLocalNotification:(NSDictionary*)inDict{
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    //    localNotif.fireDate = [NSDate date]; // date after 10 sec from now
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    // Notification details
    localNotif.userInfo =  inDict; // text of you that you have fetched
    // Set the action button
    localNotif.alertAction = @"View";
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    //    localNotif.applicationIconBadgeNumber = 1;
    
    [localNotif setApplicationIconBadgeNumber:1];
    return localNotif;
}
#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.Bureau.TheBureau" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TheBureau" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TheBureau.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:nil
                                                           error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN"
                                    code:9999
                                userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


 @end
