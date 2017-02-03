//
//  BURematchCollectionViewCell.m
//  TheBureau
//
//  Created by Accion Labs on 26/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BURematchCollectionViewCell.h"

@implementation BURematchCollectionViewCell

-(void)setImageURL:(NSString *)inImageURL;
{
    [self.activityIndicatorView startAnimating];
    self.activityIndicatorView.hidden = NO;
    
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:inImageURL]
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                      [self.activityIndicatorView stopAnimating];
                                      self.activityIndicatorView.hidden = YES;
                                  }];
}
@end
