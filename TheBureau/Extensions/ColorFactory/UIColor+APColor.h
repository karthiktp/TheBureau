//
//  UIColor+APColor.h
//  DanielPlayground
//
//  Created by Fastacash on 4/3/15.
//  Copyright (c) 2015 Fastacash. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIColor (APColor)


+ (UIColor *)moneyBtnLightColor;
+ (UIColor *)moneyBtnDarkColor;
+ (NSArray *)moneyBtnGradients;


+ (UIColor *)airtimeBtnLightColor;
+ (UIColor *)airtimeBtnDarkColor;
+ (NSArray *)airtimeBtnGradients;


+ (UIColor *)giftBtnLightColor;
+ (UIColor *)giftBtnDarkColor;
+ (NSArray *)giftBtnGradients;

+ (NSArray *)dashboardBtnGradients;

+ (UIColor *)successColor;
+ (UIColor *)failedColor;
+ (UIColor *)expiredColor;
+ (UIColor *)declinedColor;
+ (UIColor *)pendingColor;



+ (UIColor *)menuBtnOutlineColor;
+ (UIColor *)redIndicatorColor;

+ (UIColor *)APPurpleColor;
+ (UIColor *)XMApplicationColor;


@end
