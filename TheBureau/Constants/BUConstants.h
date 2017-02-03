//
//  BUConstants.h
//  TheBureau
//
//  Created by Manjunath on 26/11/15.
//  Copyright © 2015 Bureau. All rights reserved.
//

#import <Foundation/Foundation.h>

//#ifdef DEBUG 
//#define DLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
//#else
//#define DLog( s, ... )
//#endif

#define kLoginTopLayoutOffset 130

#define kSignupTopLayoutOffset 80

#define kAnimationDuration 0.5
//#define kBaseURL @"http://app.thebureauapp.com/admin/"
#define kBaseURL @"http://dev.thebureauapp.com/api/"

typedef NS_ENUM(NSInteger,ButtonType){
    ButtonTypeVegetarian,
    ButtonTypeEegetarian,
    ButtonTypeNonvegetarian,
    ButtonTypeVegan
};


typedef NS_ENUM (NSInteger, EmployementStatus)
{
    EmployementStatusEmployed,
    EmployementStatusUnEmployed,
    EmployementStatusStudent,
    EmployementStatusOthers
};



//#if TARGET_IPHONE_SIMULATOR
//// If on simulator set the user ID to Simulator and participant to Device
#define LQSCurrentUserID  @"1"
#define LQSInitialMessageText @" "
//#else
//// If on device set the user ID to Device and participant to Simulator
//#define LQSCurrentUserID  @"1"
//#define LQSParticipantUserID @"2"
//#define LQSInitialMessageText @"Hey Simulator! This is your friend, Device."
//#endif
//

//static NSString *LQSCurrentUserID = @"2";
//static NSString *LQSParticipantUserID = @"1";
//static NSString *LQSInitialMessageText = @"Hey Device! This is your friend, Simulator.";

        static NSString *const LQSLayerAppIDString = @"layer:///apps/production/23853704-995f-11e5-9c2e-6ac9d8033a8c";
//static NSString *const LQSLayerAppIDString = @"layer:///apps/staging/238530d8-995f-11e5-9461-6ac9d8033a8c";
static NSString *LQSCategoryIdentifier = @"category_lqs";
static NSString *LQSAcceptIdentifier = @"ACCEPT_IDENTIFIER";
static NSString *LQSIgnoreIdentifier = @"IGNORE_IDENTIFIER";

//typedef NS_ENUM(NSInteger, MessageStatus)
//{
//    MessageStatusSending,
//    MessageStatusSent,
//    MessageStatusNotified,
//    MessageStatusRead,
//    MessageStatusFailed
//};
//
//typedef NS_ENUM(NSInteger, MessageSender)
//{
//    MessageSenderMyself,
//    MessageSenderSomeone
//};


