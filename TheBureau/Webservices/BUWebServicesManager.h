//
//  BUWebServicesManager.h
//  TheBureau
//
//  Created by Manjunath on 25/01/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LayerKit/LayerKit.h>
#import "BUUtilities.h"




@interface BUWebServicesManager : NSObject
@property (nonatomic, strong) NSString *userID,*userName,*referalCode;
@property (nonatomic, strong) NSString *participantUserID;

@property (nonatomic) LYRClient *layerClient;

+(instancetype)sharedManager;
#pragma mark - Generic Server query API
-(void)queryServer:(NSDictionary *)inParams baseURL:(NSString *)inBaseURL  successBlock:(SuccessBlock) successCallBack failureBlock:(FailureBlock) failureCallBack;
-(void)getqueryServer:(NSDictionary *)inParams baseURL:(NSString *)inBaseURL  successBlock:(SuccessBlock) successCallBack failureBlock:(FailureBlock) failureCallBack;

-(void)uploadHoroscope:(UIImage *)inImage  successBlock:(SuccessBlock) successCallBack failureBlock:(FailureBlock) failureCallBack;

-(void)uploadProfilePicture:(UIImage *)inImage  successBlock:(SuccessBlock) successCallBack failureBlock:(FailureBlock) failureCallBack;
-(void)getAuthenticateFromLayer:(NSDictionary *)inParams baseURL:(NSString *)inBaseURL  successBlock:(SuccessBlock) successCallBack failureBlock:(FailureBlock) failureCallBack;

@end
