//
//  BURematchCollectionViewCell.h
//  TheBureau
//
//  Created by Accion Labs on 26/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"


@interface BURematchCollectionViewCell : UICollectionViewCell
@property(nonatomic,weak) IBOutlet UIImageView *userImageView;
@property(nonatomic,weak) IBOutlet UIImageView *userMatchImageView;
@property(nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicatorView;

-(void)setImageURL:(NSString *)inImageURL;

@end
