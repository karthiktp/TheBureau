//
//  FBBaseSocialController.h
//  SkrillPayments
//
//  Created by Vikas Kumar on 05/10/15.
//  Copyright © 2015 fastacash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BUSocialChannel.h"

@interface FCBaseSocialController : NSObject{
    
}

// init
-(id)init;

// authenticate to social channel
-(void)authenticateWithCompletionHandler:(void(^)(BUSocialChannel *socialChannel, NSError *error, BOOL whetherAlreadyAuthenticated))completion;
-(void)authenticateWithCompletionHandler:(void(^)(BUSocialChannel *socialChannel, NSError *error, BOOL whetherAlreadyAuthenticated))completion shouldClearPreviousToken:(BOOL)shouldClearPreviousToken;

// fetch the profile details after authentication
- (void) fetchDetailsWithCompletionHandler:(void(^)(BUSocialChannel *socialChannel, NSError *error, BOOL whetherAlreadyAuthenticated))completion whetherAlreadyAuthenticated:(BOOL)whetherAlreadyAuthenticated;
// clear session
-(void)clearSession;
// send message
-(void)sendMessage:(NSString *)message withFriendId:(NSString *)friendId withHandler:(void(^)(NSError *error,BOOL isSendMessageDone))completion;
@end
