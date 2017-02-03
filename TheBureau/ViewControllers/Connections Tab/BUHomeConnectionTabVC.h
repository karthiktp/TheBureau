//
//  BUHomeConnectionTabVC.h
//  TheBureau
//
//  Created by Accion Labs on 16/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BUHomeTabbarController.h"
@protocol BUHomeConnectionTabVCDelegate <NSObject>

@optional
-(void)upDateButtons:(NSInteger)segment;
@end
@interface BUHomeConnectionTabVC : UIViewController

- (void)showViewControllerFromIndex:(NSInteger)index;

@property(nonatomic, assign) BOOL isInAppChatNotification;
@property(nonatomic, weak) id<BUHomeConnectionTabVCDelegate> delegate;
@end
