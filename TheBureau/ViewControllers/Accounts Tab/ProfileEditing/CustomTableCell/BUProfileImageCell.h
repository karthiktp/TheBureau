//
//  BUProfileImageCell.h
//  TheBureau
//
//  Created by Manjunath on 01/04/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BUProfileEditingVC.h"
#import "BUHomeImagePreviewCell.h"
#import "BUImagePreviewVC.h"
#import "BUProfileDetailsVC.h"


@interface BUProfileImageCell : UITableViewCell<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(weak, nonatomic) IBOutlet BUProfileDetailsVC *parentVC;

@property(nonatomic, strong) NSMutableArray *imagesList;
@property(nonatomic, assign) BOOL isEditing,isProfileCreation;
@property(nonatomic, assign) int activityCounter;
@property (strong, nonatomic) IBOutlet UIButton *headerBtn;


@property(nonatomic, strong) NSMutableDictionary *imagesDict;
//img_url

@property(nonatomic, strong) IBOutlet UICollectionView *collectionView;

-(IBAction)deletePicture:(id)sender;


-(IBAction)editProfilePic:(id)sender;

-(void)setProfileImageList:(NSArray *)imageListArray;
-(void)setProfileImageDict:(NSMutableDictionary *)imageDict;
-(void)saveProfileImages;
@property(weak, nonatomic) BUImagePreviewVC *imagePreviewVC;
@end
