//
//  BUMyProfile.h
//  TheBureau
//
//  Created by Manjunath on 09/03/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
{
    college = "MCE ashkjsd";
    company = asjhdjksdd;
    "country_residing" = India;
    "created_by" = Mother;
    "current_zip_code" = 7323437126;
    diet = "Non Vegetarian";
    dob = "2016-01-27";
    drinking = Socially;
    email = "test@test.com";
    "employment_status" = Employed;
    "family_origin_id" = 3;
    "first_name" = aa;
    gender = Male;
    gothra = "gothra tested again";
    "graduated_year" = "<null>";
    "height_feet" = "<null>";
    "height_inch" = "<null>";
    "highest_education" = "<null>";
    honors = "<null>";
    id = 54;
    "last_name" = vv;
    latitude = "22.3159047";
    "legal_status" = "<null>";
    longitude = "-97.8549341";
    major = "<null>";
    "maritial_status" = "<null>";
    "mother_tongue_id" = 0;
    "other_legal_status" = "<null>";
    "phone_number" = 0009898765;
    "position_title" = "<null>";
    "profile_dob" = "1969-12-31";
    "profile_first_name" = "<null>";
    "profile_for" = "<null>";
    "profile_gender" = "";
    "profile_last_name" = "<null>";
    "religion_id" = 0;
    smoking = "";
    "specification_id" = 0;
    "user_status" = "";
    userid = 8;
    "years_in_usa" = "<null>";
}

*/

@interface BUMyProfile : NSObject
@property(nonatomic, strong) NSString *yearsInUSA,*userStatus,*specID,*smoking,*drinking,*religionID;
@property(nonatomic, strong) NSString *profile_last_name,*profile_gender,*profile_for,*profile_first_name,*profile_dob,*position_title;
@property(nonatomic, strong) NSString *phone_number,*other_legal_status,*mother_tongue_id,*maritial_status,*major,*longitude;
@property(nonatomic, strong) NSString *legal_status,*latitude,*last_name,*honors,*highest_education,*height_inch;
@property(nonatomic, strong) NSString *height_feet,*graduated_year,*gothra,*gender,*first_name,*family_origin_id;
@property(nonatomic, strong) NSString *employment_status,*email,*dob,*diet,*current_zip_code,*created_by;
@property(nonatomic, strong) NSString *country_residing,*company,*college;
@end
