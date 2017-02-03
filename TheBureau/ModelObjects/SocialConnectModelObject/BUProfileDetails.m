//
//  BUProfileDetails.m
//  TheBureau
//
//  Created by Accion Labs on 20/01/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUProfileDetails.h"

@implementation BUProfileDetails


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
- (instancetype)initWithProfileDetails:(NSDictionary *)inProdileDetailsDict
{
    self = [super init];
    if (self) {
        
        self.firstName = inProdileDetailsDict[@"first_name"];
        self.fullName  = inProdileDetailsDict[@"name"];
        self.gender   = inProdileDetailsDict[@"gender"];
        self.lastName  = inProdileDetailsDict[@"last_name"];
        self.fbID = inProdileDetailsDict[@"id"];
        self.locale = inProdileDetailsDict[@"locale"];
        self.timeZone = [NSString stringWithFormat:@"%0.2f",[(NSNumber *)inProdileDetailsDict[@"timezone"] doubleValue]];
        self.dob = inProdileDetailsDict[@"dob"];
        self.updatedTime = inProdileDetailsDict[@"updated_time"];
    }
    return self;
}
@end
