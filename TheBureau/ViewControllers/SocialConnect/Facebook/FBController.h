//
//  FbController.h
//  FastacashSDK
//
//  Created by Vikas Kumar on 05/10/15.
//  Copyright © 2015 fastacash. All rights reserved.
//


#import "FCBaseSocialController.h"

@import Foundation;

@interface FBController : FCBaseSocialController{
    
}

@property (nonatomic, strong) NSArray *permissionsRequired;

+(FBController *)sharedInstance;
-(void)authenticateWithCompletionHandler:(void(^)(BUSocialChannel *socialChannel, NSError *error, BOOL whetherAlreadyAuthenticated))completion;
-(void)authenticateWithCompletionHandler:(void(^)(BUSocialChannel *socialChannel, NSError *error, BOOL whetherAlreadyAuthenticated))completion shouldClearPreviousToken:(BOOL)shouldClearPreviousToken;
-(void)authenticateWithCompletionHandler1:(void(^)(BUSocialChannel *socialChannel, NSError *error, BOOL whetherAlreadyAuthenticated))completion;
-(void)authenticateWithCompletionHandler1:(void(^)(BUSocialChannel *socialChannel, NSError *error, BOOL whetherAlreadyAuthenticated))completion shouldClearPreviousToken:(BOOL)shouldClearPreviousToken;
-(BOOL)isAuthenticated;
- (void) fetchDetailsWithCompletionHandler:(void(^)(BUSocialChannel *socialChannel, NSError *error, BOOL whetherAlreadyAuthenticated))completion whetherAlreadyAuthenticated:(BOOL)whetherAlreadyAuthenticated;
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;
- (void) requestFriendPermission:(void(^)(BOOL whetherPermissionGiven, NSError *error))completion;
@end
