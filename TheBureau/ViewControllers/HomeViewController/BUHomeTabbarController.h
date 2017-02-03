//
//  BUHomeTabbarController.h
//  TheBureau
//
//  Created by Manjunath on 08/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BURightBtnView.h"
#import <AVFoundation/AVFoundation.h>
#import "BUProfileMatchChatVC.h"
@interface BUHomeTabbarController : UITabBarController

@property(nonatomic,strong) BURightBtnView *rightBtnView;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

-(void)updateGoldValue:(NSInteger)inGoldValue;
@end
