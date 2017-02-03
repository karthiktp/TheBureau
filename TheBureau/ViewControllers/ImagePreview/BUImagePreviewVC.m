//
//  BUImagePreviewVC.m
//  TheBureau
//
//  Created by Manjunath on 01/04/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUImagePreviewVC.h"
#import "BUHomeImagePreviewCell.h"

@interface BUImagePreviewVC ()

@property(nonatomic, strong) IBOutlet UIPageControl *pageControl;
-(IBAction)closePreview:(id)sender;
@end

@implementation BUImagePreviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageControl.transform = CGAffineTransformMakeScale(2.0, 2.0);

    // Do any additional setup after loading the view.
    //self.view.backgroundColor = [UIColor whiteColor];
    
    if ([self.hidenString isEqualToString:@"NO"]) {
        
        
        NSString *string = [self.imagesList objectAtIndex:0];
//        if ([string rangeOfString:@"user_horoscope"].location == NSNotFound) {
//          
//        } else {
//            
//        }
        
        if ([string containsString:@"user_horoscope"]) {
            self.saveIcon.hidden= NO;
            NSLog(@"string contains user_horoscope!");
           // self.view.backgroundColor = [UIColor blackColor];
        }
        else
        {
            NSLog(@"user_horoscope");
            self.saveIcon.hidden= YES;
        }

    }
    else
    {
        self.saveIcon.hidden= YES;
    }

}

- (BOOL) prefersStatusBarHidden {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self setNeedsStatusBarAppearanceUpdate];
    
}


- (void)viewWillDisappear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self setNeedsStatusBarAppearanceUpdate];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    
    self.pageControl.numberOfPages = self.imagesList.count;
    [super viewDidAppear:animated];
    [self.collectionView reloadData];
    [self performSelector:@selector(moveToCurrentPage) withObject:nil afterDelay:0.2];
}

-(void)moveToCurrentPage
{
    [self.collectionView scrollToItemAtIndexPath:self.indexPathToScroll atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.collectionView.frame.size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.imagesList.count < 2) {
        self.pageControl.hidden = YES;
    }
    return self.imagesList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BUHomeImagePreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BUHomeImagePreviewCell"
                                                                             forIndexPath:indexPath];
    
    [cell setFrameRect:self.collectionView.frame];

    if([[self.imagesList objectAtIndex:indexPath.row] isKindOfClass:[NSString class]])
    {
        [cell setImageURL:[self.imagesList objectAtIndex:indexPath.row]];
    }
    else
    {
        [cell.profileImgView setImage:[self.imagesList objectAtIndex:indexPath.row]];
        cell.activityIndicatorView.hidden = YES;
    }

    return cell;
}

#pragma mark <UICollectionViewDelegate>


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    __weak UIPageControl *weakPageControl = self.pageControl;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        weakPageControl.currentPage = indexPath.row;
    }];
    
    NSLog(@"collectionView willDisplayCell: %ld",(long)indexPath.row);
}

-(IBAction)closePreview:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
//    if (self.parentVc) {
//        self.parentVc.imagePreview = NO;
//    }
}
- (IBAction)saveImage:(id)sender {
    
    [self startActivityIndicator:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.imagesList objectAtIndex:0]]]], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
        [self performSelectorOnMainThread:@selector(imageDownloaded) withObject:nil waitUntilDone:NO ];
        
        
    });
    
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo

{
     [self stopActivityIndicator];
    
    if (error != NULL)
    {
        // handle error
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sorry unable to download, please try again." message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.saveIcon setHidden:NO];
            [alertController dismissViewControllerAnimated:YES completion:nil];
            
        });
        
    }
    else
    {
        // handle ok status
    }
    
}
-(void)imageDownloaded
{
   
    [self stopActivityIndicator];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Horoscope saved successfully." message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        [alertController dismissViewControllerAnimated:YES completion:nil];
        
    });
}



@end
