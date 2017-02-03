//
//  BULoginViewController.h
//  TheBureau
//
//  Created by Manjunath on 26/11/15.
//  Copyright © 2015 Bureau. All rights reserved.
//

#import "BUBaseViewController.h"
#import "BUWebServicesManager.h"
#import "BUSocialChannel.h"

#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface BULoginViewController : BUBaseViewController<FBSDKLoginButtonDelegate>

@property(nonatomic, strong) BUSocialChannel *socialChannel;
@property(nonatomic, assign) eLoginType loginType;
-(void)loginWithDigit;
-(void)fbLogin;
-(void)associateFacebook;
@end
