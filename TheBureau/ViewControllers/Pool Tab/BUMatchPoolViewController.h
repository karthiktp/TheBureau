//
//  BUMatchPoolViewController.h
//  TheBureau
//
//  Created by Manjunath on 22/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUBaseViewController.h"
#import "BUWebServicesManager.h"
#import "BUHomeTabbarController.h"
#import "BUHomeTabbarController.h"
@interface BUMatchPoolViewController : BUBaseViewController<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,UICollisionBehaviorDelegate>

@property(nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong) IBOutlet UIButton *tapToContinueBtn;


-(void)getMatchPoolFortheDay;
@end

