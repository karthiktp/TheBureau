//
//  BUHomeProfileImgPrevCell.h
//  TheBureau
//
//  Created by Manjunath on 08/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BUHomeViewController.h"
#import "BUHomeCollectionVC.h"
#import "BURematchProfileDetailsVC.h"

@interface BUHomeProfileImgPrevCell : UITableViewCell

@property(nonatomic, strong) IBOutlet BUHomeCollectionVC *imgCollectionVC;
-(void)setImagesListToScroll:(NSMutableArray *)inImageList;
-(void)setParentView:(BUHomeViewController*)parentVc;
-(void)setHomeView:(BUHomeViewController *)parentVc withBool:(BOOL)isChat;
@property (weak, nonatomic) IBOutlet UIButton *reMatchButton;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
//@property (nonatomic) Boolean isChat;
-(void)setRematchView:(BURematchProfileDetailsVC *)parentVc;

@end
