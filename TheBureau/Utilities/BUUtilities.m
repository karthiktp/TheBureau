//
//  BUUtilities.m
//  TheBureau
//
//  Created by Manjunath on 26/11/15.
//  Copyright © 2015 Bureau. All rights reserved.
//

#import "BUUtilities.h"
#import "logoImageView.h"
@implementation BUUtilities


+(void)testFontFamily
{
    NSArray *fontFamilies = [UIFont familyNames];
    for (int i = 0; i < [fontFamilies count]; i++)
    {
        NSString *fontFamily = [fontFamilies objectAtIndex:i];
        NSArray *fontNames = [UIFont fontNamesForFamilyName:[fontFamilies objectAtIndex:i]];
        NSLog (@"%@: %@", fontFamily, fontNames);
    }

}

+(void)removeLogo:(UINavigationController *)innavContrlr
{
    for (id subView in     [innavContrlr.navigationBar subviews])
    {
        if([subView isKindOfClass:[logoImageView class]])
            [subView removeFromSuperview];
    }
}

+(void)setNavBarLogo:(UINavigationController *)innavContrlr image:(UIImage *)inImage
{
    [innavContrlr.topViewController setNeedsStatusBarAppearanceUpdate];
    
    CGRect myImageS = CGRectMake(0, 0, 44, 44);
    logoImageView *logo = [[logoImageView alloc] initWithFrame:myImageS];
    [logo setImage:inImage];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    logo.center = CGPointMake(innavContrlr.navigationBar.frame.size.width - logo.frame.size.width, innavContrlr.navigationBar.frame.size.height / 2.0);
    logo.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [innavContrlr.navigationBar addSubview:logo];
}


@end
