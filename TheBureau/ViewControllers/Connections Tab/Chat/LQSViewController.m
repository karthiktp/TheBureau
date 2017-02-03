//
//  ViewController.m
//  QuickStart
//
//  Created by Abir Majumdar on 12/3/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import "LQSViewController.h"
#import "LQSChatMessageCell.h"
#import "LQSAnnouncementsTableViewController.h"
#import "Inputbar.h"
#import "DAKeyboardControl.h"
#import "MessageCell.h"
#import "Message.h"
#import "BULayerHelper.h"
#import "BUImagePreviewVC.h"
#import "BUHomeViewController.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ImagePicketView.h"
#import "GKImagePicker.h"
// Defined in LQSAppDelegate.m
//extern NSString *const LQSCurrentUserID;
//extern NSString *const LQSParticipantUserID;
//extern NSString *const LQSParticipant2UserID;
//extern NSString *const LQSInitialMessageText;
//extern NSString *const LQSCategoryIdentifier;

// Metadata keys related to navbar color
static NSString *const LQSBackgroundColorMetadataKey = @"backgroundColor";
static NSString *const LQSRedBackgroundColorMetadataKeyPath = @"backgroundColor.red";
static NSString *const LQSBlueBackgroundColorMetadataKeyPath = @"backgroundColor.blue";
static NSString *const LQSGreenBackgroundColorMetadataKeyPath = @"backgroundColor.green";
static NSString *const LQSRedBackgroundColor = @"red";
static NSString *const LQSBlueBackgroundColor = @"blue";
static NSString *const LQSGreenBackgroundColor = @"green";

// Message State Images
static NSString *const LQSMessageSentImageName = @"message-sent";
static NSString *const LQSMessageDeliveredImageName =@"message-delivered";
static NSString *const LQSMessageReadImageName =@"message-read";

static NSString *const LQSChatMessageCellReuseIdentifier = @"ChatMessageCell";

static NSString *const LQSLogoImageName = @"Logo";
static CGFloat const LQSKeyboardHeight = 255.0f;

static NSInteger const LQSMaxCharacterLimit = 66;

static NSString *const MIMETypeImagePNG = @"image/png";

static NSDateFormatter *LQSDateFormatter()
{
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"HH:mm";
    }
    return dateFormatter;
}

static UIColor *LSRandomColor(void)
{
    CGFloat redFloat = arc4random() % 100 / 100.0f;
    CGFloat greenFloat = arc4random() % 100 / 100.0f;
    CGFloat blueFloat = arc4random() % 100 / 100.0f;
    
    return [UIColor colorWithRed:redFloat
                           green:greenFloat
                            blue:blueFloat
                           alpha:1.0f];
}

@interface LQSViewController () <UITextViewDelegate,GKImagePickerDelegate, LYRQueryControllerDelegate, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,InputbarDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) GKImagePicker *imagePicker;

@property (nonatomic) LYRConversation *conversation;
@property (nonatomic) LYRQueryController *queryController;
@property (nonatomic) BOOL sendingImage, isDone;
@property (nonatomic) UIImage *photo; // This is where the selected photo will be stored
@property (nonatomic) LYRMessage *selectedMessage;
//@property BOOL update;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *topSubView;
@property (strong, nonatomic) IBOutlet UILabel *relationshipLabel;
@property (weak, nonatomic) IBOutlet Inputbar *inputbar;
@property(weak, nonatomic) BUImagePreviewVC *imagePreviewVC;
@property (nonatomic) ImagePicketView *pickerImageView;
@end

@implementation LQSViewController

#pragma mark - VC Lifecycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //    self.update = NO;
    self.isDone = YES;
    
    self.layerClient = [[BULayerHelper sharedHelper] layerClient];
    self.queryController.delegate = self;
    
    [self setupLayerNotificationObservers];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fetchLayerConversation];
    });
    
    [self setInputbar];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"logo44"] style:UIBarButtonItemStylePlain target:nil action:nil];
    
    if (![self.relationShip isEqualToString:@"Self"]) {
        
        self.relationshipLabel.text = [NSString stringWithFormat:@"You are chatting with %@'s %@",self.recipientName,self.relationShip];
        self.topSubView.layer.cornerRadius = 4.0;
        self.topSubView.clipsToBounds = YES;
        [self.tableView setTableHeaderView:self.topView];
    }
    
    // Setup for Shake
    [self becomeFirstResponder];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(titleAction)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:self.recipientName forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:20.0];
    button.frame = CGRectMake(0, 0, 160.0, 40.0);
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = self.recipientName;
    titleLabel.font = [UIFont systemFontOfSize:20.0];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    titleLabel.userInteractionEnabled = YES;
    self.navigationItem.titleView =titleLabel;

    
    UIImageView* v = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    v.image = self.profileImage;
    v.layer.masksToBounds = YES;
    v.layer.cornerRadius = v.frame.size.width/2;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    UIBarButtonItem *imageButton = [[UIBarButtonItem alloc] initWithCustomView:v];
    [self.navigationItem setLeftBarButtonItems:@[backButton, imageButton]];

    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleAction)];
    tapGesture.numberOfTapsRequired = 1;
    [titleLabel addGestureRecognizer:tapGesture];
    
    self.inputTextView.delegate = self;
    self.inputTextView.text = @"";
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setColorForText:(NSString*) textToFind withColor:(UIColor*) color withString:(NSMutableAttributedString*)string{
    
    NSRange range = [string.mutableString rangeOfString:textToFind options:NSCaseInsensitiveSearch];
    
    if (range.location != NSNotFound) {
        [string addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
}

-(void)titleAction {
    
    UIStoryboard *sb =[UIStoryboard storyboardWithName:@"HomeView" bundle:nil];
    BUHomeViewController *vc = [sb instantiateViewControllerWithIdentifier:@"BUHomeViewController"];
    vc.isChat = YES;
    
    vc.participant = self.participantId;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)setHeight {
    
    self.heightArray = [[NSMutableArray alloc]init];
    
    NSInteger rows = [self.queryController numberOfObjectsInSection:0];
    
    for (int g=0; g < rows; g++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:g inSection:0];
        
        float height;
        
        LYRMessage *message = [self.queryController objectAtIndexPath:indexPath];
        LYRMessagePart *messagePart = message.parts[0];
        //        NSLog(@"%@", message.parts[0]);
        //        NSLog(@"%@",messagePart.data);
        
        Message *mes = [[Message alloc]init];
        
        //MessageSender *sender;
        
        mes.text = [[NSString alloc]initWithData:messagePart.data encoding:NSUTF8StringEncoding];
        
        if ([messagePart.MIMEType isEqualToString:@"image/png"]) {
            height = 160;
        } else {
            height = [self heightCalculation:mes];
        }
        
        
        [_heightArray addObject: [NSString stringWithFormat:@"%f",height]];
    }
    
    [self setTableView];
    
}

-(float)heightCalculation:(Message *)mes {
    
    
    CGFloat max_witdh = 0.7*self.view.frame.size.width;
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, max_witdh, MAXFLOAT)];
    //[self.view addSubview:textView];
    textView.font = [UIFont fontWithName:@"Helvetica" size:17.0];
    textView.backgroundColor = [UIColor clearColor];
    textView.userInteractionEnabled = NO;
    
    textView.text = mes.text;
    [textView sizeToFit];
    
    CGFloat textView_x;
    CGFloat textView_y;
    CGFloat textView_w = textView.frame.size.width;
    CGFloat textView_h = textView.frame.size.height;
    UIViewAutoresizing autoresizing;
    
    textView_x = self.view.frame.size.width - textView_w - 20;
    textView_y = -3;
    autoresizing = UIViewAutoresizingFlexibleLeftMargin;
    
    
    CGFloat delta_x = mes.sender == MessageSenderMyself?65.0:44.0;
    
    CGFloat textView_height = textView.frame.size.height;
    CGFloat textView_width = textView.frame.size.width;
    CGFloat view_width = self.view.frame.size.width;
    
    //Single Line Case
    BOOL y = (textView_height <= 45 && textView_width + delta_x <= 0.8*view_width)?YES:NO;
    
    if (mes.sender == MessageSenderMyself)
    {
        
        
        textView_x -= y == YES?65.0:0.0;
        
        textView_x -= mes.status == MessageStatusFailed?(60-15):0.0;
    }
    else
    {
        textView_x = 20;
        textView_y = -1;
        autoresizing = UIViewAutoresizingFlexibleRightMargin;
    }
    
    textView.autoresizingMask = autoresizing;
    textView.frame = CGRectMake(textView_x, textView_y, textView_w, textView_h);
    
    if (y == NO) {
        
    }
    
    //    NSLog(@"%d",y);
    //    NSLog(@"%f",textView_h);
    
    
    
   // CGRect textRect = [mes.text boundingRectWithSize:CGSizeMake(max_witdh, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:17.0]} context:nil];
    
    //    NSLog(@"Height : %@ %f",mes.text,textRect.size.height);
    
    
    //[mes.text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:17.0] constrainedToSize:CGSizeMake(max_witdh, CGFLOAT_MAX) // - 40 For cell padding
    // lineBreakMode:NSLineBreakByWordWrapping];//[mes.text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:17.0] constrainedToSize:CGSizeMake(max_witdh, 20000) lineBreakMode: UILineBreakModeWordWrap];
    
    return y == YES ? 40 : (textView_h + 10);
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    __weak Inputbar *inputbar = _inputbar;
    __weak UITableView *tableView = _tableView;
    //__weak MessageController *controller = self;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration = 0.5;
    [_tableView addGestureRecognizer:longPress];
    
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageAction:)];
    tapGesture.numberOfTapsRequired = 1;
    [_tableView addGestureRecognizer:tapGesture];
    self.view.keyboardTriggerOffset = inputbar.frame.size.height;
    [self.view addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView, BOOL opening, BOOL closing) {
        /*
         Try not to call "self" inside this block (retain cycle).
         But if you do, make sure to remove DAKeyboardControl
         when you are done with the view controller by calling:
         [self.view removeKeyboardControl];
         */
        
        CGRect toolBarFrame = inputbar.frame;
        toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
        inputbar.frame = toolBarFrame;
        
        CGRect tableViewFrame = tableView.frame;
        tableViewFrame.size.height = toolBarFrame.origin.y - 24;
        tableView.frame = tableViewFrame;
        
        //[controller tableViewScrollToBottomAnimated:NO];
    }];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)setInputbar
{
    self.inputbar.placeholder = nil;
    self.inputbar.delegate = self;
    self.inputbar.leftButtonImage = [UIImage imageNamed:@"share"];
    self.inputbar.rightButtonText = @"Send";
    self.inputbar.rightButtonTextColor = [UIColor colorWithRed:0 green:124/255.0 blue:1 alpha:1];
}

-(void)setTableView
{
    //self.tableArray = [[TableArray alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,self.view.frame.size.width, 10.0f)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[MessageCell class] forCellReuseIdentifier: @"MessageCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.queryController) {
        [self scrollToBottom];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupLayerNotificationObservers
{
    // Register for Layer object change notifications
    // For more information about Synchronization, check out https://developer.layer.com/docs/integration/ios#synchronization
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveLayerObjectsDidChangeNotification:)
                                                 name:LYRClientObjectsDidChangeNotification
                                               object:nil];
    
    // Register for typing indicator notifications
    // For more information about Typing Indicators, check out https://developer.layer.com/docs/integration/ios#typing-indicator
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveTypingIndicator:)
                                                 name:LYRConversationDidReceiveTypingIndicatorNotification
                                               object:self.conversation];
    
    // Register for synchronization notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveLayerClientWillBeginSynchronizationNotification:)
                                                 name:LYRClientWillBeginSynchronizationNotification
                                               object:self.layerClient];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveLayerClientDidFinishSynchronizationNotification:)
                                                 name:LYRClientDidFinishSynchronizationNotification
                                               object:self.layerClient];
}

#pragma mark - Fetching Layer Content

- (void)fetchLayerConversation
{
    // Fetches all conversations between the authenticated user and the supplied participant
    // For more information about Querying, check out https://developer.layer.com/docs/integration/ios#querying
    if (!self.conversation) {
        NSError *error;
        // Trying creating a new distinct conversation between all 3 participants
        self.conversation = [self.layerClient newConversationWithParticipants:[NSSet setWithArray:@[[NSString stringWithFormat:@"%@",[BUWebServicesManager sharedManager].userID], [NSString stringWithFormat:@"%@",_participantId]  ]] options:nil error:&error];
        if (!self.conversation) {
            // If a conversation already exists, use that one
            if (error.code == LYRErrorDistinctConversationExists) {
                self.conversation = error.userInfo[LYRExistingDistinctConversationKey];
                NSLog(@"Conversation already exists between participants. Using existing");
            }
        }
    }
    NSLog(@"Conversation identifier: %@",self.conversation.identifier);
    
    // setup query controller with messages from last conversation
    if (!self.queryController) {
        [self setupQueryController];
    }
    
    //[self setHeight];
}

- (void)setupQueryController
{
    // For more information about the Query Controller, check out https://developer.layer.com/docs/integration/ios#querying
    
    // Query for all the messages in conversation sorted by position
    LYRQuery *query = [LYRQuery queryWithQueryableClass:[LYRMessage class]];
    query.predicate = [LYRPredicate predicateWithProperty:@"conversation" predicateOperator:LYRPredicateOperatorIsEqualTo value:self.conversation];
    query.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES]];
    
    // Set up query controller
    NSError *error;
    self.queryController = [self.layerClient queryControllerWithQuery:query error:&error];
    if (self.queryController) {
        self.queryController.delegate = self;
        BOOL success = [self.queryController execute:&error];
        if (success) {
            NSLog(@"Query fetched %tu message objects", [self.queryController numberOfObjectsInSection:0]);
        } else {
            NSLog(@"Query failed with error: %@", error);
        }
        
        [self.tableView reloadData];
        [self.conversation markAllMessagesAsRead:nil];
    } else {
        NSLog(@"Query Controller initialization failed with error: %@", error);
    }
}

#pragma - mark Table View Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return number of objects in queryController
    NSInteger rows = [self.queryController numberOfObjectsInSection:0];
    NSLog(@"%ld",(long)rows);
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LYRMessage *message = [self.queryController objectAtIndexPath:indexPath];
    LYRMessagePart *messagePart = message.parts[0];
    //    NSLog(@"%@", message.parts[0]);
    //    NSLog(@"%@",messagePart.data);
    
    Message *mes = [[Message alloc]init];
    
    //MessageSender *sender;
    
    mes.text = [[NSString alloc]initWithData:messagePart.data encoding:NSUTF8StringEncoding];
    
    if ([messagePart.MIMEType isEqualToString:@"image/png"]) {
        return 160;
    } else {
        
        CGFloat max_witdh = 0.7*self.view.frame.size.width;
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, max_witdh, MAXFLOAT)];
        //[self.view addSubview:textView];
        textView.font = [UIFont fontWithName:@"Helvetica" size:17.0];
        textView.backgroundColor = [UIColor clearColor];
        textView.userInteractionEnabled = NO;
        
        textView.text = mes.text;
        [textView sizeToFit];
        
        CGFloat textView_x;
        CGFloat textView_y;
        CGFloat textView_w = textView.frame.size.width;
        CGFloat textView_h = textView.frame.size.height;
        UIViewAutoresizing autoresizing;
        
        textView_x = self.view.frame.size.width - textView_w - 20;
        textView_y = -3;
        autoresizing = UIViewAutoresizingFlexibleLeftMargin;
        
        
        CGFloat delta_x = mes.sender == MessageSenderMyself?65.0:44.0;
        
        CGFloat textView_height = textView.frame.size.height;
        CGFloat textView_width = textView.frame.size.width;
        CGFloat view_width = self.view.frame.size.width;
        
        //Single Line Case
        BOOL y = (textView_height <= 45 && textView_width + delta_x <= 0.8*view_width)?YES:NO;
        
        if (mes.sender == MessageSenderMyself)
        {
            
            
            textView_x -= y == YES?65.0:0.0;
            
            textView_x -= mes.status == MessageStatusFailed?(60-15):0.0;
        }
        else
        {
            textView_x = 20;
            textView_y = -1;
            autoresizing = UIViewAutoresizingFlexibleRightMargin;
        }
        
        textView.autoresizingMask = autoresizing;
        textView.frame = CGRectMake(textView_x, textView_y, textView_w, textView_h);
        
        if (y == NO) {
            
        }
        
        //        NSLog(@"%d",y);
        //        NSLog(@"%f",textView_h);
        
        
        
        //        CGRect textRect = [mes.text boundingRectWithSize:CGSizeMake(max_witdh, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:17.0]} context:nil];
        
        //        NSLog(@"Height : %@ %f",mes.text,textRect.size.height);
        
        
        //[mes.text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:17.0] constrainedToSize:CGSizeMake(max_witdh, CGFLOAT_MAX) // - 40 For cell padding
        // lineBreakMode:NSLineBreakByWordWrapping];//[mes.text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:17.0] constrainedToSize:CGSizeMake(max_witdh, 20000) lineBreakMode: UILineBreakModeWordWrap];
        
        return y == YES ? 40 : (textView_h + 10);
    }
    //return y == YES ? 40 : (textView_h + 10);//[[self.heightArray objectAtIndex:indexPath.row] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set up custom ChatMessageCell for displaying message
    //LQSPictureMessageCell
    
    /*  LQSChatMessageCell *cell1 = [tableView dequeueReusableCellWithIdentifier:LQSChatMessageCellReuseIdentifier forIndexPath:indexPath];
     if (!cell1) {
     cell1 = [[LQSChatMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LQSChatMessageCellReuseIdentifier];
     }
     */
    // [self configureCell:cell1 forRowAtIndexPath:indexPath];
    
    
    LYRMessage *message = [self.queryController objectAtIndexPath:indexPath];
    LYRMessagePart *messagePart = message.parts.firstObject;
    
    Message *mes = [[Message alloc]init];
    mes.detail = message;
    
    //MessageSender *sender;
    
    if ([messagePart.MIMEType isEqualToString:@"image/png"]) {
        
        // cell1.messageLabel.text = @""; //
        
        //[cell1 updateWithImage:[[UIImage alloc]initWithData:messagePart.data]];
        
        mes.what = MessageImage;
        
        // mes.image = [[UIImage alloc]initWithData:messagePart.data];
        
        // NSLog(@"Size of Image(bytes):%d",[messagePart.data length]);
        NSLog(@"ImageVIew  %@  ",mes.image);
        NSLog(@"Size of image = %lu KB",(messagePart.data.length/1024));
        
        
    } else {
        
        // [cell1 removeImage]; //just a safegaurd to ensure  that no image is present
        // [cell1 assignText:[[NSString alloc]initWithData:messagePart.data
        //   encoding:NSUTF8StringEncoding]];
        mes.what = MessageText;
        
        mes.text = [[NSString alloc]initWithData:messagePart.data encoding:NSUTF8StringEncoding];
        
    }
    
    
    mes.identifier = [BULayerHelper sharedHelper].currentUserID;
    
    mes.date = [NSDate date];
    
    if ([message.sender.userID isEqualToString:[BULayerHelper sharedHelper].currentUserID]) {
        
        
        mes.sender = MessageSenderMyself;
        
        switch ([message recipientStatusForUserID:_participantId]) {
                
            case LYRRecipientStatusSent:
                
                mes.status = MessageStatusSent;
                
                break;
                
            case LYRRecipientStatusDelivered:
                
                mes.status = MessageStatusReceived;
                
                break;
                
            case LYRRecipientStatusRead:
                
                mes.status = MessageStatusRead;
                break;
                
            case LYRRecipientStatusPending:
                mes.status = MessageStatusSending;
                break;
                
            case LYRRecipientStatusInvalid:
                NSLog(@"Participant: Invalid");
                
                mes.status = MessageStatusFailed;
                
                break;
                
            default:
                break;
        }
    }
    else {
        
        mes.sender = MessageSenderSomeone;
    }
    
    
    
    mes.date = message.sentAt;
    
    static NSString *CellIdentifier = @"MessageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.tag = indexPath.row;
    
    if (!cell)
    {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    cell.tag = indexPath.row + 1;
    
    
    
    
    [cell.chatImage setImage:[UIImage imageWithData:messagePart.data]];
    cell.message = mes;
    
    
    return cell;
}

- (void)imageAction:(UITapGestureRecognizer*)gesture {
    [self.view endEditing:YES];
    CGPoint p = [gesture locationInView:_tableView];
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:p];
    MessageCell *cellLongPressed = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (cellLongPressed.message.what == 1) {
        [self openImage:cellLongPressed];
    }else return;
    if (self.inputbar.isFirstResponder) {
        [self.inputbar resignFirstResponder];
        //[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(openImageTimer:) userInfo:gesture.view.superview.superview repeats:NO];
        return;
    }
    
}

-(void)openImage:(MessageCell*)cellLongPressed {

    if (cellLongPressed.message.what == MessageImage) {
        LYRMessage *message = cellLongPressed.message.detail;
        LYRMessagePart *messagePart = message.parts[0];
        
        if (messagePart.data !=nil) {
            UIStoryboard *sb =[UIStoryboard storyboardWithName:@"HomeView" bundle:nil];
            self.imagePreviewVC = [sb instantiateViewControllerWithIdentifier:@"BUImagePreviewVC"];
            self.imagePreviewVC.imagesList = [[NSMutableArray alloc] initWithObjects:[[UIImage alloc]initWithData:messagePart.data], nil];
            self.imagePreviewVC.indexPathToScroll = [NSIndexPath indexPathForRow:0 inSection:0];
            [self presentViewController:self.imagePreviewVC animated:NO completion:nil];
        }
        
    }
}

-(void)openImageTimer:(NSTimer*)timer {
    
    MessageCell *cellLongPressed = (MessageCell *) timer.userInfo;
    if (!cellLongPressed)  return;
    if (cellLongPressed.message.what == MessageImage) {
        LYRMessage *message = cellLongPressed.message.detail;
        LYRMessagePart *messagePart = message.parts[0];
        if (messagePart.data !=nil) {
            UIStoryboard *sb =[UIStoryboard storyboardWithName:@"HomeView" bundle:nil];
            self.imagePreviewVC = [sb instantiateViewControllerWithIdentifier:@"BUImagePreviewVC"];
            self.imagePreviewVC.imagesList = [[NSMutableArray alloc] initWithObjects:[[UIImage alloc]initWithData:messagePart.data], nil];
            self.imagePreviewVC.indexPathToScroll = [NSIndexPath indexPathForRow:0 inSection:0];
            [self presentViewController:self.imagePreviewVC animated:NO completion:nil];
        }
    }
}

- (void)longPress:(UILongPressGestureRecognizer*)gesture
{
    //    if ( gesture.state == UIGestureRecognizerStateEnded) {
    if (_isDone == YES) {
        CGPoint p = [gesture locationInView:_tableView];
        NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:p];
        MessageCell *cellLongPressed = [self.tableView cellForRowAtIndexPath:indexPath];
        
        //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(gesture.view.tag - 1) inSection:0];
        
        self.selectedMessage = cellLongPressed.message.detail;//[self.queryController objectAtIndexPath:indexPath];
        LYRMessagePart *messagePart = self.selectedMessage.parts[0];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete message?" message: [NSString stringWithFormat:@"This action will delete \"%@\" message. Are you sure you want to do this?",[[NSString alloc]initWithData:messagePart.data encoding:NSUTF8StringEncoding]] delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Yes",nil];
        alert.tag = 999;
        _isDone = NO;
        [alert show];
    }
    
    //    }
}


- (void)configureCell:(LQSChatMessageCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get Message Object from queryController
    
    
    //    NSLog(@"%@",[self.queryController objectAtIndexPath:indexPath]);
    
    
    
    LYRMessage *message = [self.queryController objectAtIndexPath:indexPath];
    LYRMessagePart *messagePart = message.parts[0];
    //    NSLog(@"%@", message.parts[0]);
    //    NSLog(@"%@",messagePart.data);
    //
    //    NSLog(@"%ld",(long)[message recipientStatusForUserID:LQSParticipantUserID]);
    
    //If it is type image
    if ([messagePart.MIMEType isEqualToString:@"image/png"]) {
        cell.messageLabel.text = @""; //
        [cell updateWithImage:[[UIImage alloc]initWithData:messagePart.data]];
        
    } else {
        [cell removeImage]; //just a safegaurd to ensure  that no image is present
        [cell assignText:[[NSString alloc]initWithData:messagePart.data
                                              encoding:NSUTF8StringEncoding]];
    }
    NSString *timestampText = @"";
    
    
    // If the message was sent by current user, show Receipent Status Indicator
    if ([message.sender.userID isEqualToString:[BUWebServicesManager sharedManager].userID]) {
        switch ([message recipientStatusForUserID:_participantId]) {
            case LYRRecipientStatusSent:
                [cell.messageStatus setImage:[UIImage imageNamed:LQSMessageSentImageName]];
                timestampText = [NSString stringWithFormat:@"Sent: %@",[LQSDateFormatter() stringFromDate:message.sentAt]];
                break;
                
            case LYRRecipientStatusDelivered:
                [cell.messageStatus setImage:[UIImage imageNamed:LQSMessageDeliveredImageName]];
                timestampText = [NSString stringWithFormat:@"Delivered: %@",[LQSDateFormatter() stringFromDate:message.sentAt]];
                break;
                
            case LYRRecipientStatusRead:
                [cell.messageStatus setImage:[UIImage imageNamed:LQSMessageReadImageName]];
                timestampText = [NSString stringWithFormat:@"Read: %@",[LQSDateFormatter() stringFromDate:message.receivedAt]];
                break;
                
            case LYRRecipientStatusInvalid:
                NSLog(@"Participant: Invalid");
                break;
                
            default:
                break;
        }
    } else {
        [message markAsRead:nil];
        timestampText = [NSString stringWithFormat:@"Received: %@",[LQSDateFormatter() stringFromDate:message.sentAt]];
    }
    
    if (message.sender.userID != Nil) {
        cell.deviceLabel.text = [NSString stringWithFormat:@"%@ @ %@", message.sender.userID, timestampText];
    }else {
        cell.deviceLabel.text = [NSString stringWithFormat:@"Platform @ %@",timestampText];
    }
    
    NSLog(@"%@\n\n\n",[NSString stringWithFormat:@"%@ @ %@", message.sender.userID, timestampText]);
}

#pragma mark - Receiving Typing Indicator

- (void)didReceiveTypingIndicator:(NSNotification *)notification
{
    // For more information about Typing Indicators, check out https://developer.layer.com/docs/integration/ios#typing-indicator
    
    //    NSString *participantID = notification.userInfo[LYRTypingIndicatorParticipantUserInfoKey];
    //    LYRTypingIndicator typingIndicator = [notification.userInfo[LYRTypingIndicatorValueUserInfoKey] unsignedIntegerValue];
    //
    //    if (typingIndicator == LYRTypingDidBegin) {
    //        self.typingIndicatorLabel.alpha = 1;
    //        self.typingIndicatorLabel.text = [NSString stringWithFormat:@"%@ is typing...",participantID];
    //    } else {
    //        self.typingIndicatorLabel.alpha = 0;
    //        self.typingIndicatorLabel.text = @"";
    //    }
}

#pragma - IBActions

- (IBAction)sendMessageAction:(id)sender
{
    // Send Message
    [self sendMessage:self.inputTextView.text];
    
    // Lower the keyboard
//    [self moveViewUpToShowKeyboard:NO];
    [self.inputTextView resignFirstResponder];
}

- (void)sendMessage:(NSString *)messageText
{
    // Send a Message
    // See "Quick Start - Send a Message" for more details
    // https://developer.layer.com/docs/quick-start/ios#send-a-message
    
    LYRMessagePart *messagePart;
    self.messageImageView.image = nil;
    //    // If no conversations exist, create a new conversation object with a single participant
    //    if (!self.conversation) {
    //        [self fetchLayerConversation];
    //    }
    
    //if we are sending an image
    if (self.sendingImage) {
        UIImage *image = self.photo; //get photo
        NSData *imageData = UIImagePNGRepresentation(image);
        messagePart = [LYRMessagePart messagePartWithMIMEType:MIMETypeImagePNG data:imageData];
        self.sendingImage = NO;
    } else {
        //Creates a message part with text/plain MIME Type
        messagePart = [LYRMessagePart messagePartWithText:messageText];
    }
    
    //    NSLog(@"%@",messagePart);
    
    // Creates and returns a new message object with the given conversation and array of message parts
    //    NSString *pushMessage= [NSString stringWithFormat:@"%@ says %@",self.layerClient.authenticatedUser.userID ,messageText];
    //
    //    LYRPushNotificationConfiguration *defaultConfiguration = [LYRPushNotificationConfiguration new];
    //    defaultConfiguration.alert = pushMessage;
    //    defaultConfiguration.category = LQSCategoryIdentifier;
    //    // The following dictionary will appear in push payload
    //    defaultConfiguration.data = @{ @"test_key": @"test_value"};
    //    NSDictionary *pushOptions = @{ LYRMessageOptionsPushNotificationConfigurationKey: defaultConfiguration };
    
    LYRMessage *message = [self.layerClient newMessageWithParts:@[messagePart] options:nil error:nil];
    
    // Sends the specified message
    NSError *error;
    BOOL success = [self.conversation sendMessage:message error:&error];
    if (success) {
        // If the message was sent by the participant, show the sentAt time and mark the message as read
        NSLog(@"Message queued to be sent: %@", messageText);
        self.inputTextView.text = @"";
        
    } else {
        NSLog(@"Message send failed: %@", error);
    }
    self.photo = nil;
    if (!self.queryController) {
        [self setupQueryController];
    }
}

- (IBAction)userDidTapScreen:(id)sender
{
   // [_inputbar resignFirstResponder];
}

#pragma - mark Set up for Shake

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    // If user shakes the phone, change the navbar color and set metadata
    //    if (motion == UIEventSubtypeMotionShake) {
    //        UIColor *newNavBarBackgroundColor = LSRandomColor();
    //        self.navigationController.navigationBar.barTintColor = newNavBarBackgroundColor;
    //
    //        CGFloat redFloat = 0.0, greenFloat = 0.0, blueFloat = 0.0, alpha = 0.0;
    //        [newNavBarBackgroundColor getRed:&redFloat green:&greenFloat blue:&blueFloat alpha:&alpha];
    //
    //        // For more information about Metadata, check out https://developer.layer.com/docs/integration/ios#metadata
    //        NSDictionary *metadata = @{ LQSBackgroundColorMetadataKey : @{
    //                                            LQSRedBackgroundColor : [[NSNumber numberWithFloat:redFloat] stringValue],
    //                                            LQSGreenBackgroundColor : [[NSNumber numberWithFloat:greenFloat] stringValue],
    //                                            LQSBlueBackgroundColor : [[NSNumber numberWithFloat:blueFloat] stringValue]}
    //                                    };
    //        [self.conversation setValuesForMetadataKeyPathsWithDictionary:metadata merge:YES];
    //    }
}

#pragma - mark TextView Delegate Methods

// Move up the view when the keyboard is shown
- (void)keyboardShown:(NSNotification *)notification
{
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self.tableView setContentOffset:CGPointMake(0, (keyboardSize.height)) animated:YES];
    int lastRowNumber = [self.tableView numberOfRowsInSection:0] - 1;
    if(lastRowNumber <= 0) return;
    NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
- (void)keyboardHide:(NSNotification *)notification
{
    // Get the size of the keyboard.
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
    int lastRowNumber = [self.tableView numberOfRowsInSection:0] - 1;
    if(lastRowNumber <= 0) return;
    NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

//- (void)moveViewUpToShowKeyboard:(BOOL)movedUp{
//    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.3];
//    
//    CGRect rect = self.view.frame;
//    if (movedUp) {
//        if (rect.origin.y == 0) {
//            rect.origin.y = self.view.frame.origin.y - LQSKeyboardHeight;
//        }
//    } else {
//        if (rect.origin.y < 0) {
//            rect.origin.y = self.view.frame.origin.y + LQSKeyboardHeight;
//        }
//    }
//    self.view.frame = rect;
//    [UIView commitAnimations];
//}

// If the user hits Return then dismiss the keyboard and move the view back down
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [self.inputTextView resignFirstResponder];
        //[self moveViewUpToShowKeyboard:NO];
        return NO;
    }
    
    NSUInteger limit = LQSMaxCharacterLimit;
    return !([self.inputTextView.text length] > limit && [text length] > range.length);
}

#pragma mark - Query Controller Delegate Methods

- (void)queryControllerWillChangeContent:(LYRQueryController *)queryController{
    
    NSInteger rows = [self.queryController numberOfObjectsInSection:0];
    NSLog(@"%ld",(long)rows);
    if (rows > 0) {
        [self.tableView beginUpdates];
        //        self.update = YES;
    }
}

- (void)queryController:(LYRQueryController *)controller
        didChangeObject:(id)object
            atIndexPath:(NSIndexPath *)indexPath
          forChangeType:(LYRQueryControllerChangeType)type
           newIndexPath:(NSIndexPath *)newIndexPath{
    // Automatically update tableview when there are change events
    //    aaaa
    
    NSLog(@"%ld",(long)indexPath.row);
    
    //    if (self.update == YES) {
    switch (type) {
        case LYRQueryControllerChangeTypeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case LYRQueryControllerChangeTypeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case LYRQueryControllerChangeTypeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case LYRQueryControllerChangeTypeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        default:
            break;
    }
    //    }
    
    
}

- (void)queryControllerDidChangeContent:(LYRQueryController *)queryController
{
    NSInteger rows = [self.queryController numberOfObjectsInSection:0];
    NSLog(@"%ld",(long)rows);
    //    if (self.update == YES) {
    if ((int)rows > 0) {
        [self.tableView endUpdates];
        [self scrollToBottom];
    }
}

#pragma mark - Layer Sync Notification Handler

- (void)didReceiveLayerClientWillBeginSynchronizationNotification:(NSNotification *)notification
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didReceiveLayerClientDidFinishSynchronizationNotification:(NSNotification *)notification
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - Layer Object Change Notification Handler

- (void)didReceiveLayerObjectsDidChangeNotification:(NSNotification *)notification;
{
    // Get nav bar colors from conversation metadata
    //[self setNavbarColorFromConversationMetadata:self.conversation.metadata];
    [self fetchLayerConversation];
}

#pragma - mark General Helper Methods

- (void)scrollToBottom
{
    NSUInteger messageCount = [self numberOfMessages];
    if (self.conversation && messageCount > 0) {
        NSIndexPath* ip = [NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:0] - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)setNavbarColorFromConversationMetadata:(NSDictionary *)metadata
{
    // For more information about Metadata, check out https://developer.layer.com/docs/integration/ios#metadata
    //    if (![metadata valueForKey:LQSBackgroundColorMetadataKey]) {
    //        return;
    //    }
    //    CGFloat redColor = (CGFloat)[[metadata valueForKeyPath:LQSRedBackgroundColorMetadataKeyPath] floatValue];
    //    CGFloat blueColor = (CGFloat)[[metadata valueForKeyPath:LQSBlueBackgroundColorMetadataKeyPath] floatValue];
    //    CGFloat greenColor = (CGFloat)[[metadata valueForKeyPath:LQSGreenBackgroundColorMetadataKeyPath] floatValue];
    //    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:redColor
    //                                                                           green:greenColor
    //                                                                            blue:blueColor
    //                                                                           alpha:1.0f];
}

- (IBAction)CameraButtonSelected:(UIBarButtonItem *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    [self presentViewController:picker animated:YES completion:nil];
}

- (NSUInteger)numberOfMessages
{
    return [self.queryController numberOfObjectsInSection:0];
}


- (IBAction)clearButtonPressed:(UIBarButtonItem *)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete messages?"
                                                    message:@"This action will clear all your current messages. Are you sure you want to do this?"
                                                   delegate:self
                                          cancelButtonTitle:@"NO"
                                          otherButtonTitles:@"Yes",nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 999) {
        _isDone = YES;
        if (buttonIndex == 1) {
            NSLog(@"deleted");
            NSError *error;
            BOOL success = [self.selectedMessage delete:LYRDeletionModeMyDevices error:&error];
            if (success) {
                NSLog(@"The message has been deleted");
            } else {
                NSLog(@"Failed deletion of message: %@", error);
            }
        }
        return;
    }
    if (buttonIndex == 1) {
        [self clearMessages];
    }
}

- (void)clearMessages
{
    LYRQuery *message = [LYRQuery queryWithQueryableClass:[LYRMessage class]];
    
    NSError *error;
    NSOrderedSet *messageList = [self.layerClient executeQuery:message error:&error];
    
    if (messageList) {
        for (LYRMessage *message in messageList) {
            BOOL success = [message delete:LYRDeletionModeMyDevices error:&error];
            NSLog(@"Message is: %@", message.parts);
            if (success) {
                NSLog(@"The message has been deleted");
            } else {
                NSLog(@"Failed deletion of message: %@", error);
            }
        }
    } else {
        NSLog(@"Failed querying for messages: %@", error);
    }
}

- (IBAction)cameraButtonPressed:(UIButton *)sender
{
    self.inputTextView.text = @"";
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.sendingImage = YES;
    UIImage *image;
    image = info[UIImagePickerControllerEditedImage];
    self.photo = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self imageMessageSend:image];
}
-(void)imageMessageSend:(UIImage *)image{
    UIImage *image1 = self.photo; //get photo
    NSData *imageData = UIImagePNGRepresentation(image1);
    
    NSLog(@"Size of image before conversion = %lu KB",(imageData.length/1024));
    CGSize size=CGSizeMake(250,250);
    image = [self resizeImage:image newSize:size];
    CGFloat compression = 0.9f;
    NSData *imageData1 = UIImageJPEGRepresentation(image, compression);
    NSLog(@"Size of image after conversion = %lu KB",(imageData1.length/1024));
    self.messageImageView.image = [UIImage imageWithData:imageData1];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Are you sure to send this image?\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 70, 250, 250)];
    imageView.image = [UIImage imageWithData:imageData1];
    
    imageView.contentMode = UIViewContentModeScaleAspectFill;
        // imageView.clipsToBounds = YES;
    
    [alertController.view addSubview:imageView];
    
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"OK");
            
                //BOOL check = [[NSUserDefaults standardUserDefaults] boolForKey:@"BUAppNotificationCellTypeChatNotifications"];
            
            
                //    NSString *baseURl = @"http://app.thebureauapp.com/admin/view_notification_ws";
            
            NSDictionary *parameters = nil;
            parameters = @{@"userid": _participantId};
            NSString *baseUrl = [NSString stringWithFormat:@"configuration/view/userid/%@",_participantId];
            [[BUWebServicesManager sharedManager] getqueryServer:parameters
                                                         baseURL:baseUrl
                                                    successBlock:^(id response, NSError *error)
             {
                 
                 
                 if([response valueForKey:@"msg"] != nil && [[response valueForKey:@"msg"] isEqualToString:@"Error"]) {
                     if ([response objectForKey:@"notification"] != nil) {
                     }
                 }
                 else {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         NSString *pushMessage= [NSString stringWithFormat:@"%@ : image",[BUWebServicesManager sharedManager].userName];
                         LYRPushNotificationConfiguration *defaultConfiguration = [LYRPushNotificationConfiguration new];
                         defaultConfiguration.data = @{@"userid":[NSString stringWithFormat:@"%@",[BUWebServicesManager sharedManager].userID]};
                             //    NSString *title = [[NSUserDefaults standardUserDefaults] boolForKey:@"BUAppNotificationCellTypeSounds"] is
                         NSDictionary *notif = [[response objectForKey:@"configuration"] objectAtIndex:0];
                         if ([[notif objectForKey:@"sound"] isEqualToString:@"YES"]) {
                             defaultConfiguration.sound = @"yourOutput.caf";
                         }
                         else {
                             defaultConfiguration.sound = @"";
                         }
                         self.configuration =  [[notif objectForKey:@"chat_notification"] isEqualToString: @"YES"] ? YES : NO;
                         defaultConfiguration.alert = pushMessage;
                             //    defaultConfiguration.category = LQSCategoryIdentifier;
                         NSDictionary *pushOptions = @{ LYRMessageOptionsPushNotificationConfigurationKey: defaultConfiguration };
                         
                         
                         LYRMessagePart *messagePart = [LYRMessagePart messagePartWithMIMEType:MIMETypeImagePNG data:imageData1];
                         self.sendingImage = NO;
                         
                         LYRMessage *message = [self.layerClient newMessageWithParts:@[messagePart] options: self.configuration == YES ? pushOptions : nil error:nil];
                         
                             // Sends the specified message
                         NSError *error;
                         BOOL success = [self.conversation sendMessage:message error:&error];
                         
                         if (success) {
                                 // If the message was sent by the participant, show the sentAt time and mark the message as read
                                 // NSLog(@"Message queued to be sent: %@", messageText);
                             self.inputTextView.text = @"";
                             
                         } else {
                             NSLog(@"Message send failed: %@", error);
                         }
                         self.photo = nil;
                         if (!self.queryController) {
                             [self setupQueryController];
                         }
                     });
                 }
             }
                                                    failureBlock:^(id response, NSError *error)
             {
                 
             }
             ];
            
        }];
        action;
    })];
    
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"Cancel");
        }];
        action;
    })];
    [self presentViewController:alertController  animated:YES completion:nil];

}
- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"Cancel");
    [self dismissViewControllerAnimated:YES completion:nil];
    self.sendingImage = FALSE;
}

#pragma mark - Segue method

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]]) {
        if ([segue.destinationViewController isKindOfClass:[LQSAnnouncementsTableViewController class]]) {
            LQSAnnouncementsTableViewController *anncementsController = segue.destinationViewController;
            anncementsController.layerClient = self.layerClient;
        }
    }
}




#pragma mark - InputbarDelegate

-(void)inputbarDidPressRightButton:(Inputbar *)inputbar
{
    
    NSString *inputBarText = inputbar.text;
  //  NSString *baseURl = @"http://app.thebureauapp.com/admin/view_notification_ws";
    NSString *baseUrl = [NSString stringWithFormat:@"configuration/view/userid/%@",_participantId];

    NSDictionary *parameters = nil;
    parameters = @{@"userid": _participantId};
    
    [[BUWebServicesManager sharedManager] getqueryServer:parameters
                                              baseURL:baseUrl
                                         successBlock:^(id response, NSError *error)
     {
         
         NSLog(@"resPnse is %@",response);
         // NSLog(@"sound Response  is %@",[[response objectForKey:@"notification"]objectForKey:@"sound"]);
         
         if([response valueForKey:@"msg"] != nil && [[response valueForKey:@"msg"] isEqualToString:@"Error"])
         {
             
             
         }
         else
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 Message *mes = [[Message alloc] init];
                 mes.date = [NSDate date];
                 LYRMessagePart *messagePart;
                 self.messageImageView.image = nil;
                 // If no conversations exist, create a new conversation object with a single participant
                 if (!self.conversation) {
                     [self fetchLayerConversation];
                 }
                 
                 //if we are sending an image
                 if (self.sendingImage) {
                     UIImage *image = self.photo; //get photo
                     NSData *imageData = UIImagePNGRepresentation(image);
                     messagePart = [LYRMessagePart messagePartWithMIMEType:MIMETypeImagePNG data:imageData];
                     mes.image = [UIImage imageWithData:imageData];
                     mes.what = MessageImage;
                     self.sendingImage = NO;
                 } else {
                     //Creates a message part with text/plain MIME Type
                     messagePart = [LYRMessagePart messagePartWithText:inputBarText];
                     mes.text = inputBarText;
                     mes.what = MessageText;
                 }
                 
                 mes.sender = MessageSenderMyself;
                 
                 mes.chat_id = [BUWebServicesManager sharedManager].userID;
                 
                 //BOOL check = [[NSUserDefaults standardUserDefaults] boolForKey:@"BUAppNotificationCellTypeChatNotifications"];
                 
                 // Creates and returns a new message object with the given conversation and array of message parts
                 NSString *pushMessage= [NSString stringWithFormat:@"%@ : %@",[BUWebServicesManager sharedManager].userName ,inputBarText];
                 
                 LYRPushNotificationConfiguration *defaultConfiguration = [LYRPushNotificationConfiguration new];
                 defaultConfiguration.data = @{@"userid":[NSString stringWithFormat:@"%@",[BUWebServicesManager sharedManager].userID]};
                 
                 NSDictionary *notif = [[response objectForKey:@"configuration"] objectAtIndex:0];
                 
                 if ([[notif objectForKey:@"sound"] isEqualToString:@"YES"]) {
                     
                     defaultConfiguration.sound = @"yourOutput.caf";//@"layerbell.caff";
                     
                 }
                 else
                 {
                     defaultConfiguration.sound = @"";//@"layerbell.caff";
                 }
                 
                 self.configuration =  [[notif objectForKey:@"chat_notification"] isEqualToString: @"YES"] ? YES : NO;
                 
                 defaultConfiguration.alert = pushMessage;
                 
                 //    defaultConfiguration.category = LQSCategoryIdentifier;
                 NSDictionary *pushOptions = @{ LYRMessageOptionsPushNotificationConfigurationKey: defaultConfiguration };
                 
                 [self.heightArray addObject:[NSString stringWithFormat:@"%f",[self heightCalculation:mes]]];
                 
                 NSLog(@"%@",self.configuration == YES ? pushOptions : nil);
                 
                 LYRMessage *message = [self.layerClient newMessageWithParts:@[messagePart] options: self.configuration == YES ? pushOptions : nil error:nil];
                 //  message.sender = [BULayerHelper sharedHelper].currentUserID;
                 
                 // Sends the specified message
                 NSError *error;
                 BOOL success = [self.conversation sendMessage:message error:&error];
                 if (success) {
                     // If the message was sent by the participant, show the sentAt time and mark the message as read
                     NSLog(@"Message queued to be sent: %@", inputBarText);
                     self.inputTextView.text = @"";
                     
                 } else {
                     NSLog(@"Message send failed: %@", error);
                 }
                 self.photo = nil;
                 if (!self.queryController) {
                     [self setupQueryController];
                 }
             });
         }
     }
                                         failureBlock:^(id response, NSError *error)
     {
         NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"Connectivity Error"];
         [message addAttribute:NSFontAttributeName
                         value:[UIFont fontWithName:@"comfortaa" size:15]
                         range:NSMakeRange(0, message.length)];
         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
         [alertController setValue:message forKey:@"attributedTitle"];
         [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
         [self presentViewController:alertController animated:YES completion:nil];
     }];
}
-(void)inputbarDidPressLeftButton:(Inputbar *)inputbar
{
    //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Left Button Pressed"
    //                                                        message:nil
    //                                                       delegate:nil
    //                                              cancelButtonTitle:@"Ok"
    //                                              otherButtonTitles:nil, nil];
    //    [alertView show];
    
    if (self.inputbar.isFirstResponder) {
        [self.inputbar resignFirstResponder];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(imageActionSheet) userInfo:nil repeats:NO];
        return;
    }
    
    
    //[self openCam];
    [self imageActionSheet];
    
}

-(void)imageActionSheet {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil
                                               destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Photo Library",@"Cancel", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - ActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex; {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (buttonIndex == 2) {
            return;
        }
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.allowsEditing = YES;
        imagePicker.delegate = self;
        if ( [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]&& buttonIndex == 0) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
            return;
        }
        else {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                self.imagePicker = [[GKImagePicker alloc] init];
                self.imagePicker.cropSize = CGSizeMake(250, 250);
                self.imagePicker.delegate = self;
                [self presentViewController:self.imagePicker.imagePickerController animated:YES completion:nil];
                    return;
            }else{
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    });
}


-(void)inputbarDidChangeHeight:(CGFloat)new_height
{
    //Update DAKeyboardControl
    self.view.keyboardTriggerOffset = new_height;
}
//-(void)addPicketImageView:(UIImage *)image{
//    _pickerImageView = [[[NSBundle mainBundle] loadNibNamed:@"ImagePickerView" owner:self options:nil] objectAtIndex:0];
//    [self.pickerImageView.chooseButton addTarget:self action:@selector(chooseImage) forControlEvents:UIControlEventTouchUpInside];
//    [self.pickerImageView.chooseButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
//    self.pickerImageView.selectedImage.image = image;
//    _pickerImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    _pickerImageView.imageScrollView.delegate = self;
//    _pickerImageView.imageScrollView.userInteractionEnabled = YES;
//    
//    [self.view addSubview:_pickerImageView];
//}
//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
//        return _pickerImageView.selectedImage;
//}
//-(void)chooseImage{
//    UIImage* image = nil;
//    
//    UIGraphicsBeginImageContext(_pickerImageView.imageScrollView.contentSize);
//    {
//        CGPoint savedContentOffset = _pickerImageView.imageScrollView.contentOffset;
//        CGRect savedFrame = _pickerImageView.imageScrollView.frame;
//        
//        _pickerImageView.imageScrollView.contentOffset = CGPointZero;
//        _pickerImageView.imageScrollView.frame = CGRectMake(0, 0, _pickerImageView.imageScrollView.contentSize.width, _pickerImageView.imageScrollView.contentSize.height);
//        
//        [_pickerImageView.imageScrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
//        image = UIGraphicsGetImageFromCurrentImageContext();
//        
//        _pickerImageView.imageScrollView.contentOffset = savedContentOffset;
//        _pickerImageView.imageScrollView.frame = savedFrame;
//    }
//    UIGraphicsEndImageContext();
//    [self imageMessageSend:image];
//    [_pickerImageView removeFromSuperview];
//}
//-(void)cancelAction{
//    [_pickerImageView removeFromSuperview];
//}
# pragma mark -
# pragma mark GKImagePicker Delegate Methods

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.photo = image;
        [self hideImagePicker];
        [self imageMessageSend:image];
    }
}

- (void)hideImagePicker{
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    }
}

# pragma mark -
# pragma mark UIImagePickerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.photo = image;
        [self imageMessageSend:image];
        [self hideImagePicker];
    }
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        
        [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
}

@end
