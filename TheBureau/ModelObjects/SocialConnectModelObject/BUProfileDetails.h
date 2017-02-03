//
//  BUProfileDetails.h
//  TheBureau
//
//  Created by Accion Labs on 20/01/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 {
 "first_name" = Vinay;
 gender = male;
 id = 999680990054616;
 "last_name" = Kumar;
 locale = "en_GB";
 name = "Vinay Kumar";
 timezone = "5.5";
 "updated_time" = "2016-01-18T04:13:38+0000";
 }
 
 */


@interface BUProfileDetails : NSObject
@property(nonatomic, strong) NSString *firstName,*fullName,*gender,*lastName,*fbID,*locale,*timeZone,*dob,*updatedTime;
- (instancetype)initWithProfileDetails:(NSDictionary *)inProdileDetailsDict;

@end
