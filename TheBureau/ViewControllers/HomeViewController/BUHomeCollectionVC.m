//
//  BUHomeCollectionVC.m
//  TheBureau
//
//  Created by Manjunath on 09/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUHomeCollectionVC.h"
#import "BUHomeImagePreviewCell.h"
#import "BUImagePreviewVC.h"
@interface BUHomeCollectionVC ()
@property(nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property(nonatomic, strong) NSDictionary *datasourceDict;
@property (nonatomic) UIImageView *statusImage;
@end

@implementation BUHomeCollectionVC

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.collectionView.layer.borderColor = [[UIColor redColor] CGColor];
//    self.collectionView.layer.borderWidth = 1.0;
//    self.collectionView.layer.cornerRadius = 5.0;
    self.pageControl.transform = CGAffineTransformMakeScale(2.0, 2.0);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    NSLog(@"colection size ==> %@",NSStringFromCGSize(self.collectionView.frame.size));
    
    return self.collectionView.frame.size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    self.pageControl.numberOfPages = self.imagesList.count;
    
    (self.pageControl.numberOfPages < 2) ? (self.pageControl.hidden = YES) : (self.pageControl.hidden = NO);
    return self.imagesList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BUHomeImagePreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BUHomeImagePreviewCell"
                                                                        forIndexPath:indexPath];
    [cell setFrameRect:self.collectionView.frame];
    [cell setImageURL:[self.imagesList objectAtIndex:indexPath.row]];
    NSLog(@"%ld",(long)indexPath.row);

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.parentVc) {
        self.parentVc.imagePreview = YES;
        UIStoryboard *sb =[UIStoryboard storyboardWithName:@"HomeView" bundle:nil];
        BUImagePreviewVC *imagePreviewVC = [sb instantiateViewControllerWithIdentifier:@"BUImagePreviewVC"];
        imagePreviewVC.parentVc = self.parentVc;
        imagePreviewVC.imagesList = self.imagesList;//[self.imagesList objectAtIndex:indexPath.row];
        imagePreviewVC.indexPathToScroll = indexPath;
        imagePreviewVC.hidenString = _parentVc.isChat == YES ? @"NO" : @"YES" ;
        [self.parentVc presentViewController:imagePreviewVC animated:NO completion:nil];
    }
    
}

#pragma mark <UICollectionViewDelegate>
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    __weak UIPageControl *weakPageControl = self.pageControl;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        weakPageControl.currentPage = indexPath.row;
    }];
}



@end
