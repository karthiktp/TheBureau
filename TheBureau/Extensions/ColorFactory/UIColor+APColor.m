//
//  UIColor+APColor.m
//  DanielPlayground
//
//  Created by Fastacash on 4/3/15.
//  Copyright (c) 2015 Fastacash. All rights reserved.
//

#import "UIColor+APColor.h"

@implementation UIColor(APColor)


+ (UIColor *)moneyBtnLightColor
{
    return [UIColor colorWithRed:255.0f/255.0f green:214.0f/255.0f blue:185.0f/255.0f alpha:1.0f];
}
+ (UIColor *)moneyBtnDarkColor
{
    return [UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:132.0f/255.0f alpha:1.0f];
}
+ (NSArray *)moneyBtnGradients {
    return [NSArray arrayWithObjects:[UIColor moneyBtnLightColor], [UIColor moneyBtnDarkColor], nil];
}



+ (UIColor *)airtimeBtnLightColor
{
    return [UIColor colorWithRed:212.0f/255.0f green:250.0f/255.0f blue:208.0f/255.0f alpha:1.0f];
}
+ (UIColor *)airtimeBtnDarkColor
{
    return [UIColor colorWithRed:23.0f/255.0f green:188.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
}
+ (NSArray *)airtimeBtnGradients {
    return [NSArray arrayWithObjects:[UIColor airtimeBtnLightColor], [UIColor airtimeBtnDarkColor], nil];
}





+ (UIColor *)giftBtnLightColor
{
    return [UIColor colorWithRed:255.0f/255.0f green:214.0f/255.0f blue:185.0f/255.0f alpha:1.0f];
}
+ (UIColor *)giftBtnDarkColor
{
    return [UIColor colorWithRed:252.0f/255.0f green:0.0f/255.0f blue:132.0f/255.0f alpha:1.0f];
}
+ (NSArray *)giftBtnGradients {
    return [NSArray arrayWithObjects:[UIColor giftBtnLightColor], [UIColor giftBtnDarkColor], nil];
}



+ (NSArray *)dashboardBtnGradients {
    
    NSArray *colorsArray = [NSArray arrayWithObjects:
                            [UIColor moneyBtnGradients],
                            [UIColor airtimeBtnGradients],
                            [UIColor giftBtnGradients],
                            nil];
    return colorsArray;
}





+ (UIColor *)menuBtnOutlineColor
{
   return [UIColor colorWithRed:165.0f/255.0f green:30.0f/255.0f blue:80.0f/255.0f alpha:1.0f];
}



+(UIColor *)successColor{
    return [UIColor colorWithRed:54.0f/255.0f green:214.0f/255.0f blue:72.0f/255.0f alpha:1.0f];
}
+(UIColor *)failedColor{
    return [UIColor colorWithRed:249.0f/255.0f green:0.0f/255.0f blue:24.0f/255.0f alpha:1.0f];
}
+(UIColor *)expiredColor{
    return [UIColor colorWithRed:249.0f/255.0f green:125.0f/255.0f blue:143.0f/255.0f alpha:1.0f];
}
+(UIColor *)declinedColor{
    return [UIColor colorWithRed:249.0f/255.0f green:0.0f/255.0f blue:24.0f/255.0f alpha:1.0f];
}
+(UIColor *)pendingColor{
    return [UIColor colorWithRed:129.0f/255.0f green:197.0f/255.0f blue:252.0f/255.0f alpha:1.0f];
}



+ (UIColor *)redIndicatorColor {
    return [UIColor colorWithRed:181.0f/255.0f green:33.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
}



+ (UIColor *)APPurpleColor {
    return [UIColor colorWithRed:181.0f/255.0f green:33.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
}

+ (UIColor *)XMApplicationColor {
    return [UIColor colorWithRed:0.95 green:0.43 blue:0.12 alpha:1.0];
}


@end
