//
//  ProfileImageDetail.h
//  TheBureau
//
//  Created by Ama1's iMac on 29/07/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUBaseViewController.h"
#import "BUProfileEditingVC.h"
#import "BUHomeImagePreviewCell.h"
#import "BUImagePreviewVC.h"
#import "LXReorderableCollectionViewFlowLayout.h"

@interface ProfileImageDetail : BUBaseViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,UICollectionViewDataSource,UICollectionViewDelegate,LXReorderableCollectionViewDataSource, LXReorderableCollectionViewDelegateFlowLayout>
@property(weak, nonatomic) IBOutlet BUBaseViewController *parentVC;

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
//-(void)setProfileImageDict:(NSMutableDictionary *)imageDict;
-(void)saveProfileImages;
@property(weak, nonatomic) BUImagePreviewVC *imagePreviewVC;
@end
