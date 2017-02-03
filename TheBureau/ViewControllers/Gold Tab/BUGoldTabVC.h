//
//  BUGoldTabVC.h
//  TheBureau
//
//  Created by Manjunath on 07/03/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUBaseViewController.h"
#import "BUWebServicesManager.h"
#import "BUHomeTabbarController.h"
#import "BUDocumentViewVC.h"
#import <AVFoundation/AVFoundation.h>
@interface BUGoldTabVC : BUBaseViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextViewDelegate>

@property(nonatomic,strong) NSIndexPath *selectedIndexPath;
@property bool fbLikeDone, instagramFollowDone;

@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;

-(void)showSuccessMessageWithGold:(NSInteger)purchasedGold;
-(void)updateGold:(NSInteger)purchasedGold did:(NSString*)status;
@end
