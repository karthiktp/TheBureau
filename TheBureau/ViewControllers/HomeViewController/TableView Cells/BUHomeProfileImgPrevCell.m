//
//  BUHomeProfileImgPrevCell.m
//  TheBureau
//
//  Created by Manjunath on 08/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUHomeProfileImgPrevCell.h"
#import "BUConstants.h"

@interface BUHomeProfileImgPrevCell ()
@property (nonatomic) UILabel *label;
@end

@implementation BUHomeProfileImgPrevCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    UIStoryboard *sb =[UIStoryboard storyboardWithName:@"HomeView" bundle:nil];
    self.imgCollectionVC = [sb instantiateViewControllerWithIdentifier:@"BUHomeCollectionVC"];
    [self addSubview:self.imgCollectionVC.view];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.imgCollectionVC.collectionView.dataSource = self.imgCollectionVC;
    self.imgCollectionVC.collectionView.delegate = self.imgCollectionVC;
    
}

-(void)setParentView:(BUHomeViewController*)parentVc {
    self.imgCollectionVC.parentVc = parentVc;
    [self.imgCollectionVC.matchButton addTarget:parentVc action:@selector(match:) forControlEvents:UIControlEventTouchUpInside];
     [self.imgCollectionVC.passButton addTarget:parentVc action:@selector(pass:) forControlEvents:UIControlEventTouchUpInside];
    parentVc.matchBtn = self.imgCollectionVC.matchButton;
    parentVc.passBtn = self.imgCollectionVC.passButton;
    parentVc.profileStatusImgView = self.imgCollectionVC.profileStatusImage;
    NSMutableDictionary *dictionary = [parentVc getDataInfoDictionary];
    [self hideMatchandPayButton:[dictionary objectForKey:@"UserAction"]];
    self.imgCollectionVC.rematchButton.hidden = YES;
}
-(void)setHomeView:(BUHomeViewController *)parentVc withBool:(BOOL)isChat{
    self.imgCollectionVC.parentVc = parentVc;
    [self.imgCollectionVC.matchButton addTarget:parentVc action:@selector(match:) forControlEvents:UIControlEventTouchUpInside];
    [self.imgCollectionVC.passButton addTarget:parentVc action:@selector(pass:) forControlEvents:UIControlEventTouchUpInside];
    parentVc.matchBtn = self.imgCollectionVC.matchButton;
    parentVc.passBtn = self.imgCollectionVC.passButton;
    parentVc.profileStatusImgView = self.imgCollectionVC.profileStatusImage;
    NSMutableDictionary *dictionary = [parentVc getDataInfoDictionary];
    [self hideMatchandPayButton:[dictionary objectForKey:@"UserAction"]];
    self.imgCollectionVC.rematchButton.hidden = YES;
    if (isChat) {
        self.imgCollectionVC.matchButton.hidden = YES;
        self.imgCollectionVC.passButton.hidden = YES;
        self.imgCollectionVC.profileStatusImage.hidden = YES;
        self.imgCollectionVC.payButton.hidden = YES;
    }
    

}

-(void)setRematchView:(BURematchProfileDetailsVC *)parentVc {
    
    self.imgCollectionVC.rematchVc = parentVc;
    [self.imgCollectionVC.rematchButton addTarget:parentVc action:@selector(match:) forControlEvents:UIControlEventTouchUpInside];
    [self.imgCollectionVC.payButton addTarget:parentVc action:@selector(payAndMatch:) forControlEvents:UIControlEventTouchUpInside];
    parentVc.matchBtn = self.imgCollectionVC.rematchButton;
    parentVc.payBtn = self.imgCollectionVC.payButton;
    self.imgCollectionVC.matchButton.hidden = YES;
    self.imgCollectionVC.passButton.hidden = YES;
    self.imgCollectionVC.profileStatusImage.hidden = YES;
    self.imgCollectionVC.payButton.hidden = YES;
    self.imgCollectionVC.rematchButton.hidden = NO;

}

-(void)layoutSubviews
{
    self.imgCollectionVC.view.frame = self.contentView.bounds;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


-(void)setImagesListToScroll:(NSMutableArray *)inImageList
{
    self.imgCollectionVC.imagesList = inImageList;
    [self.imgCollectionVC.collectionView reloadData];
}
-(void)hideMatchandPayButton:(NSString *)string{
  
    if([string isKindOfClass:[NSNull class]])
    {
        self.imgCollectionVC.matchButton.hidden = NO;
        self.imgCollectionVC.passButton.hidden = NO;
        self.imgCollectionVC.profileStatusImage.hidden = YES;
        self.imgCollectionVC.rematchButton.hidden = YES;
        self.imgCollectionVC.payButton.hidden = YES;
    }
    else if([string isEqualToString:@"Passed"])
    {
        self.imgCollectionVC.matchButton.hidden = YES;
        self.imgCollectionVC.passButton.hidden = YES;
        self.imgCollectionVC.profileStatusImage.hidden = NO;

        self.imgCollectionVC.profileStatusImage.image = [UIImage imageNamed:@"btn_passed"];
        
        self.imgCollectionVC.rematchButton.hidden = YES;
        self.imgCollectionVC.payButton.hidden = YES;

    }
    else if([string isEqualToString:@"Liked"])
    {
        self.imgCollectionVC.matchButton.hidden = YES;
        self.imgCollectionVC.passButton.hidden = YES;
        self.imgCollectionVC.profileStatusImage.hidden = NO;
        
        self.imgCollectionVC.profileStatusImage.image = [UIImage imageNamed:@"btn_liked"];
        
        self.imgCollectionVC.rematchButton.hidden = YES;
        self.imgCollectionVC.payButton.hidden = YES;

    }
    else if([string isEqualToString:@"Connected"])
    {
        self.imgCollectionVC.matchButton.hidden = YES;
        self.imgCollectionVC.passButton.hidden = YES;
        self.imgCollectionVC.profileStatusImage.hidden = NO;
        
        self.imgCollectionVC.profileStatusImage.image = [UIImage imageNamed:@"btn_connected"];
        
        self.imgCollectionVC.rematchButton.hidden = YES;
        self.imgCollectionVC.payButton.hidden = YES;

    }
}

@end
