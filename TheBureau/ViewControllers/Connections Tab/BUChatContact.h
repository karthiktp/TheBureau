//
//  BUChatContact.h
//  TheBureau
//
//  Created by Manjunath on 12/03/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LQSViewController.h"

@interface BUChatContact : NSObject
/*
 
 {
 "First Name" = test;
 "Last Name" = test;
 "img_url" = "http://app.thebureauapp.com/uploads/8/3314/images_2.jpg";
 userid = 7;
 },
 
 */

@property(nonatomic, strong) LYRConversation *conversation;
@property(nonatomic, strong) NSString *fName,*lName,*imgURL,*userID,*lastmessageLbl,*relationShip;
@property BOOL isNewmessage, configuration;
- (instancetype)initWithDict:(NSDictionary *)inDictionary;
@end
