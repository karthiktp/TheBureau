//
//  BULayerHelper.h
//  TheBureau
//
//  Created by Manjunath on 10/03/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BUUtilities.h"
#import <LayerKit/LayerKit.h>
#import "LQSViewController.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "BUConstants.h"

@interface BULayerHelper : NSObject
@property (nonatomic) LYRClient *layerClient;


@property (nonatomic) NSString *currentUserID,*participantUserID;



+(instancetype)sharedHelper;
-(void)authenticateLayerWithsuccessBlock:(SuccessBlock) successCallBack failureBlock:(FailureBlock) failureCallBack;
- (void)deauthenticateWithCompletion:(nullable void (^)(BOOL success, NSError * _Nullable error))completion;
@end

