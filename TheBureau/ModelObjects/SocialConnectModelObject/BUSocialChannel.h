//
//  BUSocialChannel.h
//  PingPay
//
//  Created by Vikas Kumar on 05/10/15.
//  Copyright © 2015 fastacash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BUProfileDetails.h"

typedef enum BUSocialChannel
{
    BUSocialChannelFacebook,
}BUSocialChannelType;





@interface BUSocialChannel : NSObject<NSCopying>{
    
}

@property (nonatomic,strong)NSString *channelName;
@property (nonatomic,strong)NSString *emailID;
@property (nonatomic,strong)NSString *mobileNumber;
@property (nonatomic,assign)BOOL isAssociated;

@property (nonatomic, assign) BOOL isPreferred;
@property (nonatomic,strong)NSString *channelIconName;
@property (nonatomic, assign) BUSocialChannelType socialType;
@property (nonatomic, strong) NSDictionary *profile; // {name, ...}
@property (nonatomic, strong) BUProfileDetails *profileDetails;
@property (nonatomic, strong) NSDictionary *credentials; // {token, refreshtoken,otp}
@property (nonatomic, strong) NSString *profileId;

- (id)copyWithZone:(NSZone *)zone;
- (id) initWithSocialType:(BUSocialChannelType)type;
- (id) initWithJSON:(id)json;
- (id) initWithJSON:(id)json isAssociated:(BOOL)isAssociated;

+ (NSString *) displayChannelNameForSocialType:(BUSocialChannelType)socialType;
+ (BUSocialChannelType) channelTypeForSocialChannelId:(NSString *)channelId;
+ (NSString *) channelIdForSocialType:(BUSocialChannelType)socialType;
+ (NSString *) imageNameForSocialType:(BUSocialChannelType)socialType isAssociated:(BOOL)isAssociated;
+ (NSString *) imageNameForSocialChannelType:(BUSocialChannelType)socialType;
+ (NSString *) imageNameForAvatarWithSocialType:(BUSocialChannelType)socialType;
+ (NSString *)selectedImageNameForSocialChannel:(BUSocialChannelType)socialType;

@end
