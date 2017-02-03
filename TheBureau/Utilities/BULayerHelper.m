//
//  BULayerHelper.m
//  TheBureau
//
//  Created by Manjunath on 10/03/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BULayerHelper.h"
@interface BULayerHelper () <LYRClientDelegate>


@end

@implementation BULayerHelper

+(instancetype)sharedHelper
{
    static dispatch_once_t pred;
    static BULayerHelper* sharedBUWebServicesManager = nil;
    dispatch_once(&pred, ^{
        sharedBUWebServicesManager = [[BULayerHelper alloc] init];
        
    });
    return sharedBUWebServicesManager;
}


-(void)authenticateLayerWithsuccessBlock:(SuccessBlock) successCallBack failureBlock:(FailureBlock) failureCallBack
{
    // Initializes a LYRClient object
    NSURL *appID = [NSURL URLWithString:LQSLayerAppIDString];
    if(nil == self.layerClient)
        self.layerClient = [LYRClient clientWithAppID:appID];
    
    self.layerClient.delegate = self;
    self.layerClient.autodownloadMIMETypes = [NSSet setWithObjects:@"image/png", nil];
    // Connect to Layer
    // See "Quick Start - Connect" for more details
    // https://developer.layer.com/docs/quick-start/ios#connect
    [self.layerClient connectWithCompletion:^(BOOL success, NSError *error) {
        if (!success)
        {
            NSLog(@"Failed to connect to Layer: %@", error);
            failureCallBack(nil, nil);
        }
        else
        {
            [self authenticateLayerWithUserID:[BUWebServicesManager sharedManager].userID completion:^(BOOL success, NSError *error) {
                if (!success)
                {
                    NSLog(@"Failed Authenticating Layer Client with error:%@", error);
                    
                    failureCallBack(nil, nil);
                }
                else
                {
                    successCallBack(nil, nil);
                }
            }];
        }
    }];
}


#pragma mark - Layer Authentication Methods

- (void)deauthenticateWithCompletion:(nullable void (^)(BOOL success, NSError * _Nullable error))completion;
{
    if (self.layerClient.authenticatedUserID)
    {
        [self.layerClient deauthenticateWithCompletion:^(BOOL success, NSError * _Nullable error) {
            if (completion) completion(YES, nil);
        }];
    }
}

- (void)authenticateLayerWithUserID:(NSString *)userID completion:(void (^)(BOOL success, NSError * error))completion
{
    if (self.layerClient.authenticatedUserID) {
        NSLog(@"Layer Authenticated as User %@", self.layerClient.authenticatedUserID);
        if (completion) completion(YES, nil);
        return;
    }
    
    // Authenticate with Layer
    // See "Quick Start - Authenticate" for more details
    // https://developer.layer.com/docs/quick-start/ios#authenticate
    
    /*
     * 1. Request an authentication Nonce from Layer
     */
    [self.layerClient requestAuthenticationNonceWithCompletion:^(NSString *nonce, NSError *error) {
        if (!nonce) {
            if (completion) {
                completion(NO, error);
            }
            return;
        }
        
        /*
         * 2. Acquire identity Token from Layer Identity Service
         */
        
        NSDictionary *parameters = nil;
        parameters = @{@"userid": [[BULayerHelper sharedHelper] currentUserID]
                       ,@"nonce": nonce};
        
        [self getLayerAuthTokenwithParameters:parameters
                                   completion:^(NSString *identityToken, NSError *error) {
                                       if (!identityToken) {
                                           if (completion) {
                                               completion(NO, error);
                                           }
                                           return;
                                       }
                                       
                                       /*
                                        * 3. Submit identity token to Layer for validation
                                        */
                                       [self.layerClient authenticateWithIdentityToken:identityToken completion:^(NSString *authenticatedUserID, NSError *error) {
                                           if (authenticatedUserID) {
                                               if (completion) {
                                                   completion(YES, nil);
                                               }
                                               NSLog(@"Layer Authenticated as User: %@", authenticatedUserID);
                                           } else {
                                               completion(NO, error);
                                           }
                                       }];
                                   }];
    }];
}



-(void)getLayerAuthTokenwithParameters:(NSDictionary *)inParams completion:(void(^)(NSString *identityToken, NSError *error))completion
{
    [[BUWebServicesManager sharedManager] getAuthenticateFromLayer:inParams
                                                           baseURL:nil
                                                      successBlock:^(id responseObject, NSError *error) {
        NSLog(@"Success: %@", responseObject);
        // Deserialize the response
        if(![responseObject valueForKey:@"error"])
        {
            NSString *identityToken = responseObject[@"identity_token"];
            completion(identityToken, nil);
        }
        else
        {
            NSString *domain = @"layer-identity-provider.herokuapp.com";
            NSInteger code = [responseObject[@"status"] integerValue];
            NSDictionary *userInfo =
            @{
              NSLocalizedDescriptionKey: @"Layer Identity Provider Returned an Error.",
              NSLocalizedRecoverySuggestionErrorKey: @"There may be a problem with your APPID."
              };
            
            NSError *error = [[NSError alloc] initWithDomain:domain code:code userInfo:userInfo];
            completion(nil, error);
        }
        
    } failureBlock:^(id response, NSError *error) {
        completion(nil, error);
        NSLog(@"Error: %@", error);
    }];
}

- (void)requestIdentityTokenForUserID:(NSString *)userID appID:(NSString *)appID nonce:(NSString *)nonce completion:(void(^)(NSString *identityToken, NSError *error))completion
{
    NSParameterAssert(userID);
    NSParameterAssert(appID);
    NSParameterAssert(nonce);
    NSParameterAssert(completion);
    
    NSURL *identityTokenURL = [NSURL URLWithString:@"https://layer-identity-provider.herokuapp.com/identity_tokens"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:identityTokenURL];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSDictionary *parameters = @{ @"app_id": appID, @"user_id": userID, @"nonce": nonce };
    NSData *requestBody = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    request.HTTPBody = requestBody;
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
        
        // Deserialize the response
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if(![responseObject valueForKey:@"error"])
        {
            NSString *identityToken = responseObject[@"identity_token"];
            completion(identityToken, nil);
        }
        else
        {
            NSString *domain = @"layer-identity-provider.herokuapp.com";
            NSInteger code = [responseObject[@"status"] integerValue];
            NSDictionary *userInfo =
            @{
              NSLocalizedDescriptionKey: @"Layer Identity Provider Returned an Error.",
              NSLocalizedRecoverySuggestionErrorKey: @"There may be a problem with your APPID."
              };
            
            NSError *error = [[NSError alloc] initWithDomain:domain code:code userInfo:userInfo];
            completion(nil, error);
        }
        
    }] resume];
}


#pragma - mark LYRClientDelegate Delegate Methods

- (void)layerClient:(LYRClient *)client didReceiveAuthenticationChallengeWithNonce:(NSString *)nonce
{
    NSLog(@"Layer Client did recieve authentication challenge with nonce: %@", nonce);
}

- (void)layerClient:(LYRClient *)client didAuthenticateAsUserID:(NSString *)userID
{
    NSLog(@"Layer Client did recieve authentication nonce");
}

- (void)layerClientDidDeauthenticate:(LYRClient *)client
{
    NSLog(@"Layer Client did deauthenticate");
}

- (void)layerClient:(LYRClient *)client didFinishSynchronizationWithChanges:(NSArray *)changes
{
    NSLog(@"Layer Client did finish synchronization");
}

- (void)layerClient:(LYRClient *)client didFailSynchronizationWithError:(NSError *)error
{
    NSLog(@"Layer Client did fail synchronization with error: %@", error);
}

- (void)layerClient:(LYRClient *)client willAttemptToConnect:(NSUInteger)attemptNumber afterDelay:(NSTimeInterval)delayInterval maximumNumberOfAttempts:(NSUInteger)attemptLimit
{
    NSLog(@"Layer Client will attempt to connect");
}

- (void)layerClientDidConnect:(LYRClient *)client
{
    NSLog(@"Layer Client did connect");
}

- (void)layerClient:(LYRClient *)client didLoseConnectionWithError:(NSError *)error
{
    NSLog(@"Layer Client did lose connection with error: %@", error);
}

- (void)layerClientDidDisconnect:(LYRClient *)client
{
    NSLog(@"Layer Client did disconnect");
}

@end
