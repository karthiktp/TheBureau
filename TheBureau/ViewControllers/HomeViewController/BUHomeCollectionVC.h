//
//  BUHomeCollectionVC.h
//  TheBureau
//
//  Created by Manjunath on 09/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BUHomeViewController.h"
#import "BURematchProfileDetailsVC.h"



@interface BUHomeCollectionVC : UIViewController<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,UICollisionBehaviorDelegate>

@property (weak, nonatomic) IBOutlet UIButton *matchButton;
@property (weak, nonatomic) IBOutlet UIButton *passButton;
@property (weak, nonatomic) IBOutlet UIImageView *profileStatusImage;

@property (weak, nonatomic) IBOutlet UIButton *rematchButton;
@property (weak, nonatomic) IBOutlet UIButton *payButton;

@property(nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *imagesList;
@property (strong, nonatomic) BUHomeViewController *parentVc;
@property (strong, nonatomic) BURematchProfileDetailsVC *rematchVc;

@end
