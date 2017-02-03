//
//  BUUserProfile.h
//  TheBureau
//
//  Created by Accion Labs on 29/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
College = "test test test ";
"Company Name" = "test test ";
"Country Residing" = India;
"Date of Birth" = "31-January-1921";
"Diet Preference" = "Non Vegetarian";
Education = Bachelors;
"First Name" = Lionel;
Gender = Male;
Honors = "test test test test ";
"Last Name" = Messi;
"Legal Status" = "Citizen/Green Card";
Major = "test test test test ";
"Marital Status" = "Never Married";
"Mother Tongue" = English;
"Position Title" = "test test test test test ";
"Religion Name" = Hinduism;
"Year of Passing" = 1988;
"Years in USA" = "0 - 2";
"height_feet" = 5;
"height_inch" = 7;
userid = 16;
 */

@interface BUUserProfile : NSObject

@property(nonatomic,strong)NSString *college,*companyName,*countryResiding,*DOB,*dietPreference,*education,*firstName,*gender,*honors,*lastName,*legalStatus,*major,*maritalStatus,*motherTongue,*postionTitle,*religionName,*yearOfPassing,*yearsInUSA,*heightFeet,*heightInch,*userID,*imageUrl,*userAction;

@property(nonatomic,strong) NSArray *imageListArray;


- (instancetype)initWithUserProfile:(NSDictionary *)inUserProfileDict;


@end
