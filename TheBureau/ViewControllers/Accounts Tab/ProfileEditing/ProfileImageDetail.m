//
//  ProfileImageDetail.m
//  TheBureau
//
//  Created by Ama1's iMac on 29/07/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "ProfileImageDetail.h"
#import "BUWebServicesManager.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "BUConstants.h"

@interface ProfileImageDetail ()

@end

@implementation ProfileImageDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Profile Image";
    
    self.collectionView.layer.cornerRadius = 10.0;
    self.collectionView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.collectionView.layer.borderWidth = 1.0;
    
    [self setProfileImageList:[self.imagesDict valueForKey:@"img_url"]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveAction)];
}

-(void)saveAction {
    /*
     
     userid= user id
     order = order is a key and value  should be in json format eg
     ([{"image_name":"1468581971_4592.jpg","order_id":"2"},{"image_name":"1468581975_9087.jpg","order_id":"3"},{"image_name":"1468581979_7815.jpg","order_id":"1"},{"image_name":"1468581982_4033.jpg","order_id":"4"}])
     
     Response on success:
     {"msg":"Success","response":"Profile picture updated successfully"}
     
     */
    
    NSMutableArray *mutArray = [[NSMutableArray alloc]init];
    
    for (int i=0; i<[self.imagesList count]; i++) {
        
        NSString *imageUrl = [self.imagesList objectAtIndex:i];
        
        NSString *imageName = [[imageUrl componentsSeparatedByString:@"/"] lastObject];
        
        NSMutableDictionary *mutDict = [[NSMutableDictionary alloc]init];
        
        [mutDict setValue:imageName forKey:@"image_name"];
        [mutDict setValue:[NSString stringWithFormat:@"%d",i+1] forKey:@"order_id"];
        
        [mutArray addObject:mutDict];
    }
    /*
     
     "http://app.thebureauapp.com/uploads/213/4626/1470825056_4626.jpg",
     "http://app.thebureauapp.com/uploads/213/9625/1470825066_9625.jpg",
     "http://app.thebureauapp.com/uploads/213/5423/1470825092_5423.jpg",
     "http://app.thebureauapp.com/uploads/213/4033/1470826525_4033.jpg"
     
     */
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mutArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",mutArray);
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    
    [parameters setValue:[BUWebServicesManager sharedManager].userID forKey:@"userid"];
    [parameters setValue:jsonString forKey:@"order"];
    
    [self startActivityIndicator:YES];
    
    [[BUWebServicesManager sharedManager] queryServer:parameters baseURL:@"profile/updateImageOrder" successBlock:^(id response, NSError *error) {
        
        [self stopActivityIndicator];
        
        [self.imagesDict setValue:self.imagesList forKey:@"img_url"];
        
        NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[response objectForKey:@"response"]]];
        [message addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"comfortaa" size:15]
                        range:NSMakeRange(0, message.length)];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController setValue:message forKey:@"attributedTitle"];
        
        [alertController addAction:({
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSLog(@"OK");
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            action;
        })];
        
        [self presentViewController:alertController  animated:YES completion:nil];
        
    }
                                         failureBlock:^(id response, NSError *error)
     {
         [self stopActivityIndicator];
         if (error.code == NSURLErrorTimedOut) {
             
             [self showAlert:@"Connection timed out, please try again later"];
         }
         else
         {
             [self showAlert:@"Connectivity Error"];
         }
     }];
    
}

-(void)updateProfile
{
    
    //    [self.profileImageCell saveProfileImages];
    
    
}

- (IBAction)capturePhoto:(id)sender
{
    if(self.imagesList.count < 4)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Photo Library",@"Cancel", nil];
        actionSheet.tag = 1000;
        [actionSheet showInView:self.view];
    }
}
#pragma mark - ActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 2)
    {
        return;
    }
    else
    {
        __block UIImagePickerController *weakImagePicker = [[UIImagePickerController alloc] init];
        __weak UIViewController *weakself = self;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            weakImagePicker.allowsEditing = YES;
            weakImagePicker.delegate = self;
            if ( [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]&& buttonIndex == 0){
                weakImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            }
            else{
                weakImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                
            }
            weakImagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
            [weakself presentViewController:weakImagePicker animated:YES completion:nil];
        }];
    }
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    NSString *path = [self imageFilePath];
    [imageData writeToFile:path atomically:YES];
    
    if(nil == self.imagesList)
        self.imagesList = [[NSMutableArray alloc] init];
    //[info objectForKey:UIImagePickerControllerEditedImage]
    [self.imagesList addObject:[info objectForKey:UIImagePickerControllerEditedImage]];
    
    [self.imagesDict setValue:self.imagesList forKey:@"img_url"];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self.collectionView reloadData];
    
    //    if(self.isProfileCreation)
    //    {
    //[self saveProfileImages];
    
    self.activityCounter = 0;
    [self startActivityIndicator:YES];
    self.activityCounter ++;
    [self uploadProfilePicture:[info objectForKey:UIImagePickerControllerEditedImage]];
    
    
    //    }
    
}

//-(void)setProfileImageDict:(NSMutableDictionary *)imageDict;
//{
//    self.imagesDict = imageDict;
//    [self setProfileImageList:[self.imagesDict valueForKey:@"img_url"]];
//}


-(void)setProfileImageList:(NSArray *)imageListArray
{
    self.imagesList = [[NSMutableArray alloc] initWithArray:imageListArray];
    
    NSLog(@"%@",self.imagesList);
    
    [self.collectionView reloadData];
}

-(NSString *)imageFilePath
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [dirPaths objectAtIndex:0];
    NSString *docsDir = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[[NSDate date] description]]];
    if(![[NSFileManager defaultManager] fileExistsAtPath:docsDir])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:docsDir withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return [docsDir stringByAppendingPathComponent:@"tmp.png"];
}




#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(80, 100);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if((self.isEditing) || ([self.imagesList count]>=4))
    {
        return self.imagesList.count;
    }
    else
    {
        return self.imagesList.count + 1;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row < self.imagesList.count)
    {
        BUHomeImagePreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BUHomeImagePreviewCell"
                                                                                 forIndexPath:indexPath];
        
        if([[self.imagesList objectAtIndex:indexPath.row] isKindOfClass:[NSString class]])
        {
            [cell setImageURL:[self.imagesList objectAtIndex:indexPath.row]];
        }
        else
        {
            [cell.profileImgView setImage:[self.imagesList objectAtIndex:indexPath.row]];
            cell.activityIndicatorView.hidden = YES;
        }
        cell.deleteBtn.tag = indexPath.row;
        
        if(self.isEditing)
        {
            cell.deleteBtn.hidden = NO;
        }
        else
        {
            cell.deleteBtn.hidden = YES;
        }
        return cell;
    }
    else
    {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddImageCell"
                                                                               forIndexPath:indexPath];
        return cell;
    }
}

#pragma mark <UICollectionViewDelegate>


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"collectionView willDisplayCell: %ld",indexPath.row);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    UIStoryboard *sb =[UIStoryboard storyboardWithName:@"HomeView" bundle:nil];
    self.imagePreviewVC = [sb instantiateViewControllerWithIdentifier:@"BUImagePreviewVC"];
    self.imagePreviewVC.imagesList = self.imagesList;
    self.imagePreviewVC.indexPathToScroll = indexPath;
    [self presentViewController:self.imagePreviewVC animated:NO completion:nil];
}

#pragma mark - LXReorderableCollectionViewDataSource methods

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath {
    
    if([[self.imagesList objectAtIndex:toIndexPath.item] isKindOfClass:[NSString class]])
    {
        NSString *playingCard = self.imagesList[fromIndexPath.item];
        [self.imagesList removeObjectAtIndex:fromIndexPath.item];
        [self.imagesList insertObject:playingCard atIndex:toIndexPath.item];
    }
    else if([[self.imagesList objectAtIndex:toIndexPath.item] isKindOfClass:[UIImage class]])
    {
        UIImage *playingCard = self.imagesList[fromIndexPath.item];
        
        [self.imagesList removeObjectAtIndex:fromIndexPath.item];
        [self.imagesList insertObject:playingCard atIndex:toIndexPath.item];
    }
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    //#if LX_LIMITED_MOVEMENT == 1
    //    PlayingCard *playingCard = self.deck[indexPath.item];
    //
    //    switch (playingCard.suit) {
    //        case PlayingCardSuitSpade:
    //        case PlayingCardSuitClub: {
    //            return YES;
    //        } break;
    //        default: {
    //            return NO;
    //        } break;
    //    }
    //#else
    //    return YES;
    //#endif
    if (indexPath.item > [self.imagesList count]-1) {
        return NO;
    }
    
    if (([[self.imagesList objectAtIndex:indexPath.item] isKindOfClass:[NSString class]])||([[self.imagesList objectAtIndex:indexPath.item] isKindOfClass:[UIImage class]])) {
        return YES;
    }
    else {
        return NO;
    }
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath {
    //#if LX_LIMITED_MOVEMENT == 1
    //    PlayingCard *fromPlayingCard = self.deck[fromIndexPath.item];
    //    PlayingCard *toPlayingCard = self.deck[toIndexPath.item];
    //
    //    switch (toPlayingCard.suit) {
    //        case PlayingCardSuitSpade:
    //        case PlayingCardSuitClub: {
    //            return fromPlayingCard.rank == toPlayingCard.rank;
    //        } break;
    //        default: {
    //            return NO;
    //        } break;
    //    }
    //#else
    //    return YES;
    //#endif
    
    if ((fromIndexPath.item > [self.imagesList count]-1) || (toIndexPath.item > [self.imagesList count]-1)) {
        return NO;
    }
    
    if (([[self.imagesList objectAtIndex:toIndexPath.item] isKindOfClass:[NSString class]])||([[self.imagesList objectAtIndex:toIndexPath.item] isKindOfClass:[UIImage class]])) {
        return YES;
    }
    else {
        return NO;
    }
}

#pragma mark - LXReorderableCollectionViewDelegateFlowLayout methods

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"will begin drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did begin drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"will end drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did end drag");
}

-(IBAction)deletePicture:(id)sender
{
    // UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:[sender tag] inSection:0]];
    
    
    if([[self.imagesList objectAtIndex:[sender tag]] isKindOfClass:[NSString class]])
    {
        [self startActivityIndicator:YES];
        NSDictionary *parameters = @{@"img_url":[self.imagesList objectAtIndex:[sender tag]]};
        [[BUWebServicesManager sharedManager] queryServer:parameters
                                                  baseURL:@"profile/deleteImage"
                                             successBlock:^(id response, NSError *error)
         {
             [self stopActivityIndicator];
         } failureBlock:^(id response, NSError *error) {
             [self stopActivityIndicator];
         }];
    }
    [self.imagesList removeObjectAtIndex:[sender tag]];
    [self.imagesDict setValue:self.imagesList forKey:@"img_url"];
    [self.collectionView reloadData];   
}

-(IBAction)editProfilePic:(id)sender
{
    if ([sender tag] == 0)
    {
        self.isEditing = YES;
        [sender setTag:1];
        [(UIButton *)sender setImage:[UIImage imageNamed:@"done"] forState:UIControlStateNormal];
    }
    else
    {
        self.isEditing = NO;
        [sender setTag:0];
        [(UIButton *)sender setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    }
    
    [self.collectionView reloadData];
    
}


-(void)saveProfileImages
{
    self.activityCounter = 0;
    for (id pic in self.imagesList)
    {
        if(NO == [pic isKindOfClass:[NSString class]])
        {
            [self startActivityIndicator:YES];
            self.activityCounter ++;
            [self uploadProfilePicture:pic];
        }
    }
}


-(void)uploadProfilePicture:(UIImage *)inImage {
    
    [[BUWebServicesManager sharedManager] uploadProfilePicture:inImage
                                                  successBlock:^(id responseObject, NSError *error) {
                                                      self.activityCounter --;
                                                      //         if(0 == self.activityCounter)
                                                    [self stopActivityIndicator];
                                                    [self.imagesList removeLastObject];
                                                    [self.imagesList addObject:[responseObject objectForKey:@"img_url"]];
                                                    [self.imagesDict setValue:self.imagesList forKey:@"img_url"];
                                                    [self.collectionView reloadData];
                                                    NSLog(@"Success: %@", responseObject);
                                                  } failureBlock:^(id response, NSError *error) {
                                                      self.activityCounter --;
                                                      //         if(0 == self.activityCounter)
                                                          [self stopActivityIndicator];
                                                      NSLog(@"Error: %@", error);
                                                      if (error.code == NSURLErrorTimedOut) {
                                                          [self timeoutError:@"Connection timed out, please try again later"];
                                                      }}];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
