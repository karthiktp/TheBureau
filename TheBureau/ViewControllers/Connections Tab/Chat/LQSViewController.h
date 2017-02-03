//
//  ViewController.h
//  QuickStart
//
//  Created by Abir Majumdar on 12/3/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LayerKit/LayerKit.h>
#import "BUWebServicesManager.h"
#import "BUChatContact.h"
 
@interface LQSViewController : UIViewController<UIActionSheetDelegate>

@property (nonatomic) LYRClient *layerClient;

@property (nonatomic) UIImage *profileImage;
@property (nonatomic, weak) IBOutlet UIButton *sendButton;
@property (nonatomic, weak) IBOutlet UITextView *inputTextView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *typingIndicatorLabel;
@property (nonatomic, weak) IBOutlet UIImageView *messageImageView;
@property (strong, nonatomic) NSMutableArray *heightArray;


@property (strong, nonatomic) NSString *participantId,*recipientName,*relationShip;
@property bool configuration;

- (IBAction)clearButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)cameraButtonPressed:(UIButton *)sender;

@end
