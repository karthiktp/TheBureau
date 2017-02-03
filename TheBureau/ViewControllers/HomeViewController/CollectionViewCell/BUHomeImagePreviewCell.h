//
//  BUHomeImagePreviewCell.h
//  TheBureau
//
//  Created by Manjunath on 08/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
@class BUHomeImagePreviewCell;


@interface BUHomeImagePreviewCell : UICollectionViewCell

@property(nonatomic, strong) IBOutlet UIImageView *profileImgView,*overLayView;
@property(nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property(nonatomic, strong) IBOutlet UIButton *deleteBtn;
@property (strong, nonatomic) IBOutlet UIScrollView *zoomScroll;


@property (weak, nonatomic) IBOutlet UIButton *matchButton;
@property (weak, nonatomic) IBOutlet UIButton *passButton;
@property (weak, nonatomic) IBOutlet UIView *matchView;
@property(nonatomic, strong) IBOutlet UIImageView *statusImage;

@property(nonatomic, assign) CGRect contentFrame;

-(void)setImageURL:(NSString *)inImageURL;
-(void)setFrameRect:(CGRect)inRect;
@end
