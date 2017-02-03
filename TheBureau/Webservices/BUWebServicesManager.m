//  BUWebServicesManager.m
//  TheBureau
//
//  Created by Manjunath on 25/01/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUWebServicesManager.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "BUConstants.h"

@interface BUWebServicesManager()
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) AFJSONRequestSerializer *serializer;
@end

@implementation BUWebServicesManager

+(instancetype)sharedManager
{
    static dispatch_once_t pred;
    static BUWebServicesManager* sharedBUWebServices;
    dispatch_once(&pred, ^{
        sharedBUWebServices = [[BUWebServicesManager alloc] init];
        
        
        //        sharedBUWebServicesManager.userID = @"400";
    });
    return sharedBUWebServices;
}


- (id)init {
    NSLog(@"========== Only Once ============");
    if (self = [super init]) {
    }
    return self;
}

-(AFHTTPSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return _sessionManager;
}
-(AFJSONRequestSerializer *)serializer{
    if (!_serializer) {
        _serializer = [AFJSONRequestSerializer serializer];
    }
    [_serializer setValue:@"KLSS36qOp36Ps6e0LBt97Dw4QJz47084" forHTTPHeaderField:@"x-api-key"];
    return _serializer;
}

#pragma mark - Generic Server query API
-(void)queryServer:(NSDictionary *)inParams baseURL:(NSString *)inBaseURL  successBlock:(SuccessBlock) successCallBack failureBlock:(FailureBlock) failureCallBack {
    
    NSString *baseURL = [NSString stringWithFormat:@"%@%@",kBaseURL,inBaseURL];
    NSLog(@"usl :%@", baseURL);
    self.sessionManager.requestSerializer = self.serializer;
    [self.sessionManager POST:baseURL
                   parameters:inParams
    constructingBodyWithBlock:nil
                     progress:nil
                      success:^(NSURLSessionDataTask *operation, id responseObject){
                          // successBlock(responseObject,nil);
                          successCallBack(responseObject, nil);
                          NSLog(@"Success: %@", responseObject);
                      }
                      failure:^(NSURLSessionDataTask *operation, NSError *error) {
                          failureCallBack(nil,error);
                          NSLog(@"Error: %@", error.description);
                      }];
}
-(void)getqueryServer:(NSDictionary *)inParams baseURL:(NSString *)inBaseURL  successBlock:(SuccessBlock) successCallBack failureBlock:(FailureBlock) failureCallBack {
    
    NSString *baseURL = [NSString stringWithFormat:@"%@%@",kBaseURL,inBaseURL];
    NSLog(@"usl :%@", baseURL);
    self.sessionManager.requestSerializer = self.serializer;
    [self.sessionManager GET:baseURL
                  parameters:inParams
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         successCallBack(responseObject, nil);
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"%@",error.description);
         
         failureCallBack(nil, error);
     }];
}


-(void)deleteProfilePicture:(NSString *)inImageURLStr  successBlock:(SuccessBlock) successCallBack failureBlock:(FailureBlock) failureCallBack
{
    NSDictionary *parameters = @{@"img_url": inImageURLStr};
    
    // AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    ////[manager.requestSerializer setTimeoutInterval:20];
    [[BUWebServicesManager sharedManager] queryServer:parameters baseURL:@"profile/deleteImage"
                                         successBlock:^(id responseObject, NSError *error) {
                                             successCallBack(responseObject,nil);
                                             ;
                                             NSLog(@"Success: %@", responseObject);
                                         } failureBlock:^(id response, NSError *error) {
                                             failureCallBack(nil,error);
                                             NSLog(@"Error: %@", error);
                                         }];
}

-(void)uploadProfilePicture:(UIImage *)inImage  successBlock:(SuccessBlock) successCallBack failureBlock:(FailureBlock) failureCallBack{
    NSData *imageData = UIImageJPEGRepresentation(inImage, 0.8);
    NSDictionary *parameters = @{@"userid": self.userID};
    
    NSString *baseURL = [NSString stringWithFormat:@"%@profile/multi_upload",kBaseURL];

    [self.sessionManager POST:baseURL
                   parameters:parameters
    constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         [formData appendPartWithFileData:imageData name:@"userfile" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
     }
                     progress:nil
                      success:^(NSURLSessionDataTask *operation, id responseObject)
     {
         successCallBack(responseObject,nil);
         NSLog(@"Success: %@", responseObject);
         
         
     }
                      failure:^(NSURLSessionDataTask *operation, NSError *error)
     {
         failureCallBack(nil,error);
         NSLog(@"Error: %@", error);
     }];

    
}


-(void)uploadHoroscope:(UIImage *)inImage  successBlock:(SuccessBlock) successCallBack failureBlock:(FailureBlock) failureCallBack
{
    NSData *imageData = UIImageJPEGRepresentation(inImage, 0.8);
    NSDictionary *parameters = @{@"userid": self.userID};
    
    [self.sessionManager POST:@"http://dev.thebureauapp.com/api/profile/uploadHoroscope"
                   parameters:parameters
    constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         [formData appendPartWithFileData:imageData name:@"userfile" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
     }
                     progress:nil
                      success:^(NSURLSessionDataTask *operation, id responseObject)
     {
         successCallBack(responseObject,nil);
         NSLog(@"Success: %@", responseObject);
         
         
     }
                      failure:^(NSURLSessionDataTask *operation, NSError *error)
     {
         failureCallBack(nil,error);
         NSLog(@"Error: %@", error);
         
         
     }];
}
-(void)getAuthenticateFromLayer:(NSDictionary *)inParams baseURL:(NSString *)inBaseURL  successBlock:(SuccessBlock) successCallBack failureBlock:(FailureBlock) failureCallBack{
        // self.sessionManager.requestSerializer = self.serializer;
    [self.sessionManager POST:@"http://dev.thebureauapp.com/layer/public/authenticate.php"
                       parameters:inParams
        constructingBodyWithBlock:nil
                         progress:nil
                          success:^(NSURLSessionDataTask *operation, id responseObject){
                              // successBlock(responseObject,nil);
                              successCallBack(responseObject, nil);
                              NSLog(@"Success: %@", responseObject);
                          }
                          failure:^(NSURLSessionDataTask *operation, NSError *error) {
                              failureCallBack(nil,error);
                              NSLog(@"Error: %@", error.description);
                          }];
    }

@end
