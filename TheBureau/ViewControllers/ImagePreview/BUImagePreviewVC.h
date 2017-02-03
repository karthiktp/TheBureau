//
//  BUImagePreviewVC.h
//  TheBureau
//
//  Created by Manjunath on 01/04/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUBaseViewController.h"
#import "BUHomeViewController.h"

@interface BUImagePreviewVC : BUBaseViewController<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,UICollisionBehaviorDelegate>

@property(nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *imagesList;
@property(nonatomic, strong) NSIndexPath *indexPathToScroll;
@property (nonatomic, strong) BUHomeViewController *parentVc;
@property (strong, nonatomic) IBOutlet UIButton *saveIcon;
@property(nonatomic,strong)NSString *hidenString;
@end
