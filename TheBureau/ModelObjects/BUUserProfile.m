//
//  BUUserProfile.m
//  TheBureau
//
//  Created by Accion Labs on 29/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUUserProfile.h"

@implementation BUUserProfile

/*
 college = test3;
 company = test;
 "country_residing" = India;
 "created_by" = Mother;
 "current_zip_code" = 1234;
 diet = Eggetarian;
 dob = "1988-01-14";
 drinking = Never;
 email = "siddharth@zolipe.com";
 "employment_status" = Employed;
 "family_origin_id" = 2;
 "first_name" = Dipika;
 gender = Female;
 gothra = test;
 "graduated_year" = 2011;
 "height_feet" = 5;
 "height_inch" = 5;
 "highest_education" = Doctorate;
 honors = test1;
 id = 1;
 "img_names" = "img2.jpg,img3.jpg,img4.jpg,img5.jpg,img1.jpg";
 "img_url" =         {
 1 = "http://app.thebureauapp.com/uploads/1/9403/img2.jpg";
 2 = "http://app.thebureauapp.com/uploads/1/8608/img3.jpg";
 3 = "http://app.thebureauapp.com/uploads/1/9931/img4.jpg";
 4 = "http://app.thebureauapp.com/uploads/1/1644/img5.jpg";
 5 = "http://app.thebureauapp.com/uploads/1/6862/img1.jpg";
 };
 "last_name" = Padukone;
 latitude = "-31.4488192";
 "legal_status" = "H1 Visa";
 longitude = "-64.5048649";
 major = test2;
 "maritial_status" = Divorced;
 "mother_tongue_id" = 2;
 "other_legal_status" = "";
 "phone_number" = 555;
 "position_title" = test;
 "profile_dob" = "1988-01-14";
 "profile_first_name" = Dipika;
 "profile_for" = Son;
 "profile_gender" = Female;
 "profile_last_name" = Padukone;
 "religion_id" = 1;
 smoking = Yes;
 "specification_id" = 3;
 "uniq_ids" = "9403,8608,9931,1644,6862";
 "user_status" = Active;
 userid = 1;
 "years_in_usa" = "2 - 6";
 */


- (instancetype)initWithUserProfile:(NSDictionary *)inUserProfileDict;
{
    
    self = [super init];
    if (self) {
        
        self.firstName = inUserProfileDict[@"First Name"];
        self.gender   = inUserProfileDict[@"Gender"];
        self.lastName  = inUserProfileDict[@"Last Name"];
        self.userID = inUserProfileDict[@"userid"];
        self.motherTongue = inUserProfileDict[@"Mother Tongue"];
        self.DOB = inUserProfileDict[@"Date of Birth"];
        self.postionTitle = inUserProfileDict[@"Position Title"];
        self.heightInch = inUserProfileDict[@"height_inch"];
        self.heightFeet = inUserProfileDict[@"height_feet"];
        self.yearsInUSA = inUserProfileDict[@"Years in USA"];
        self.yearOfPassing = inUserProfileDict[@"Year of Passing"];
        self.religionName = inUserProfileDict[@"Religion Name"];
        self.maritalStatus = inUserProfileDict[@"Marital Status"];
        self.companyName = inUserProfileDict[@"Company Name"];
        self.legalStatus = inUserProfileDict[@"Legal Status"];
        NSLog(@"%@",inUserProfileDict[@"Legal Status"]);
        self.honors = inUserProfileDict[@"Honors"];
        self.major = inUserProfileDict[@"Major"];
        self.dietPreference = inUserProfileDict[@"Diet Preference"];
        self.education = inUserProfileDict[@"Education"];
        self.countryResiding = inUserProfileDict[@"Country Residing"];
        self.college = inUserProfileDict[@"College"];
        self.imageListArray = inUserProfileDict[@"img_url"];
        self.userAction = inUserProfileDict[@"user_action"];
        
        self.userAction = inUserProfileDict[@"user_action"];
        self.userAction = inUserProfileDict[@"user_action"];
        self.userAction = inUserProfileDict[@"user_action"];
        self.userAction = inUserProfileDict[@"user_action"];
        self.userAction = inUserProfileDict[@"user_action"];
        self.userAction = inUserProfileDict[@"user_action"];
        self.userAction = inUserProfileDict[@"user_action"];


        
    }
    return self;
    
    
    
    
}
@end
