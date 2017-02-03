//
//  BUSocialChannel.m
//  PingPay
//
//  Created by Vikas Kumar on 05/10/15.
//  Copyright © 2015 fastacash. All rights reserved.
//

#import "BUSocialChannel.h"
#import "NSObject+FCKeyPathHelper.h"

NSString *const XPMFCSocialChannelIdFacebook = @"fb";


@implementation BUSocialChannel

-(id)copyWithZone:(NSZone *)zone
{
    BUSocialChannel *socialChannel = [[BUSocialChannel alloc] init];
    socialChannel.socialType = _socialType;
    socialChannel.isAssociated = _isAssociated;
    socialChannel.profile = _profile;
    socialChannel.credentials = _credentials;
    return socialChannel;
}

- (id) initWithSocialType:(BUSocialChannelType)type
{
    if ((self = [super init])) {
        self.socialType = type;
    }
    
    return self;
}



- (id) initWithJSON:(id)json
{
    return [self initWithJSON:json isAssociated:false];
}

- (id) initWithJSON:(id)json isAssociated:(BOOL)isAssociated
{
    if ((self=[super init])) {
        
        if ([json isKindOfClass:[NSDictionary class]]) {
            NSString *socialNetworkId = [json objectForKey:@"socialNetworkId"];
            
            if (!socialNetworkId) {
                socialNetworkId =[json objectForKey:@"id"];
            }
            if (socialNetworkId) {
                _socialType = [BUSocialChannel channelTypeForSocialChannelId:socialNetworkId];
                _isAssociated = isAssociated;
                _profileId = [json valueForKeyPathFC:@"socialId"];
            }
            
            _credentials = json;
        }
    }
    
    return self;
}




#pragma mark static methods

+ (NSString *) displayChannelNameForSocialType:(BUSocialChannelType)socialType
{
             return @"Facebook";
}

+ (NSString *) channelIdForSocialType:(BUSocialChannelType)socialType;
{
    return XPMFCSocialChannelIdFacebook;
}

+ (BUSocialChannelType) channelTypeForSocialChannelId:(NSString *)channelId
{
        return BUSocialChannelFacebook;
}

+ (NSString *) imageNameForSocialType:(BUSocialChannelType)socialType isAssociated:(BOOL)isAssociated
{
    if ( isAssociated)
    {
        return @"friend_fb";
    }else{
        return @"friend_fb_off";
    }
    return nil;
}

+ (NSString *)imageNameForAvatarWithSocialType:(BUSocialChannelType)socialType
{
            return @"social_circle_facebook";
}


+ (NSString *) imageNameForSocialChannelType:(BUSocialChannelType)socialType
{
            return @"channel_fb";
 }

+ (NSString *)selectedImageNameForSocialChannel:(BUSocialChannelType)socialType {
            return @"Facebook_Selected";
 
}
@end
