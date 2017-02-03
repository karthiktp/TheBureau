//
//  BUContactListTableViewCell.m
//  TheBureau
//
//  Created by Accion Labs on 26/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUContactListTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation BUContactListTableViewCell

-(void)setContactListDataSource:(BUChatContact *)inContact
{
    
    @try {
        
        self.userName.text = [NSString stringWithFormat:@"%@ %@",inContact.fName,inContact.lName];
        if (inContact.imgURL == (NSString *)[NSNull null]) {
        }
        else{
            [self.userImageView sd_setImageWithURL:[NSURL URLWithString:inContact.imgURL]
                                  placeholderImage:[UIImage imageNamed:@"logo44"]
                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {
                 
             }];
            
            
        }

    } @catch (NSException *exception) {
        
        NSLog(@"Reason For crash is %@",exception.description);
        
    } @finally {
        
        NSLog(@"Sucessssss");
    }
   
    
}

@end
