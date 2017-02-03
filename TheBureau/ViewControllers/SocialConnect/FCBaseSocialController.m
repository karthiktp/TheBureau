//
//  FBBaseSocialController.m
//  SkrillPayments
//
//  Created by Vikas Kumar on 05/10/15.
//  Copyright © 2015 fastacash. All rights reserved.
//

#import "FCBaseSocialController.h"

@implementation FCBaseSocialController

-(id)init
{
    self = [super init];
    if ( self ){
        
    }
    return self;
}

-(void)authenticateWithCompletionHandler:(void(^)(BUSocialChannel *socialChannel, NSError *error, BOOL whetherAlreadyAuthenticated))completion shouldClearPreviousToken:(BOOL)shouldClearPreviousToken;
{
    [self authenticateWithCompletionHandler:completion shouldClearPreviousToken:false];
}

-(void)authenticateWithCompletionHandler:(void(^)(BUSocialChannel *socialChannel, NSError *error, BOOL whetherAlreadyAuthenticated))completion
{
    
}


- (void) fetchDetailsWithCompletionHandler:(void(^)(BUSocialChannel *socialChannel, NSError *error, BOOL whetherAlreadyAuthenticated))completion whetherAlreadyAuthenticated:(BOOL)whetherAlreadyAuthenticated
{
    
}

-(void)clearSession
{
    
}

-(void)sendMessage:(NSString *)message withFriendId:(NSString *)friendId withHandler:(void(^)(NSError *error,BOOL isSendMessageDone))completion
{
    
}
@end
