//
//  BUPoolProfileDetailsVC.h
//  TheBureau
//
//  Created by Manjunath on 22/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUBaseViewController.h"
#import "BUWebServicesManager.h"
@interface BUPoolProfileDetailsVC : BUBaseViewController<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,UICollisionBehaviorDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableDictionary *datasourceList;
@property(nonatomic,strong)  NSDictionary *goldDict;
-(void)cookupDataSource;
@end
