//
//  Message.h
//  Whatsapp
//
//  Created by Rafael Castro on 6/16/15.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LayerKit/LayerKit.h>

typedef NS_ENUM(NSInteger, MessageStatus)
{
    MessageStatusSending,
    MessageStatusSent,
    MessageStatusReceived,
    MessageStatusRead,
    MessageStatusFailed
};

typedef NS_ENUM(NSInteger, MessageSender)
{
    MessageSenderMyself,
    MessageSenderSomeone
};

typedef NS_ENUM(NSInteger, MessageWhat) {
    MessageText,
    MessageImage
};

//
// This class is the message object itself
//
@interface Message : NSObject

@property (assign, nonatomic) MessageWhat what;
@property (assign, nonatomic) MessageSender sender;
@property (assign, nonatomic) MessageStatus status;
@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *chat_id;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSDate *date;
@property (assign, nonatomic) CGFloat heigh;
@property (strong, nonatomic) LYRMessage *detail;

+(Message *)messageFromDictionary:(NSDictionary *)dictionary;

@end


