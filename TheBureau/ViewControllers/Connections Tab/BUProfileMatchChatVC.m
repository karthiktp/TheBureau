//
//  BUProfileMatchChatVC.m
//  TheBureau
//
//  Created by Accion Labs on 16/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUProfileMatchChatVC.h"
#import "BUContactListTableViewCell.h"
#import "BUWebServicesManager.h"
#import "BULayerHelper.h"
#import "LQSViewController.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "BUContactListViewController.h"

static NSDateFormatter *LQSDateFormatter()
{
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"dd-MMM";
    }
    return dateFormatter;
}

@interface BUProfileMatchChatVC ()<LYRQueryControllerDelegate>

@property (nonatomic) LYRQueryController *queryController;
@property (nonatomic) LYRClient *layerClient;
@property (nonatomic) IBOutlet UITableView *conversationListTableView;
@property (nonatomic) IBOutlet UIButton *conversationButton;
@property bool addPage, notInsert, isDone,didLoad;
@property (strong, nonatomic) LYRConversation *selectedMessage;
@property (strong, nonatomic) IBOutlet UILabel *notifLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property(strong,nonatomic)NSArray * actualChatList;
@end

@implementation BUProfileMatchChatVC
@synthesize spinner;
@synthesize actualChatList;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"ClassssssssssLoad");
    
    if (UIAppDelegate.chatNotification == YES) {
        [self customSpinner];
    }
    UIAppDelegate.historyList = [[NSMutableArray alloc] init];
    actualChatList =  [[NSArray alloc]init];
    self.layerClient = [BULayerHelper sharedHelper].layerClient;
    self.title = @"Chat History";
    _addPage = NO;
    _isDone = YES;
    self.didLoad = YES;
    self.conversationButton.layer.cornerRadius = 20;
    self.conversationButton.clipsToBounds = YES;
    [self setupConversationDataSource];
}

-(void)customSpinner

{
    self.activityView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.activityView.backgroundColor = [UIColor clearColor];
    self.activityView.alpha = 0.0f;
    [self.view addSubview:_activityView];
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:self.activityView.bounds];
    bgView.alpha = 0.0f;
    
    [bgView setBackgroundColor:[UIColor colorWithRed:0.95 green:0.43 blue:0.12 alpha:1.0]];
    [UIView animateWithDuration:0.2 animations:^{
        bgView.alpha = 0.5f;
        self.activityView.alpha = 1;
    }];
    [self.activityView addSubview:bgView];
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = self.view.center;
    spinner.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    
    [self.view addSubview:spinner];
    [spinner startAnimating];
    [[UIApplication sharedApplication].keyWindow addSubview:self.activityView];
    
}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.didLoad == YES) {
        self.didLoad = NO;
        return;
    }
    if (UIAppDelegate.chatNotification == YES) {
        [self customSpinner];
        [self setupConversationDataSource];
    }
    else {
        //        [self getContactList];
        [self getContactDetails];
    }
    
    if ([spinner isAnimating]== YES) {
        [spinner stopAnimating];
    }
    [self.conversationListTableView reloadData];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //     if (self.didLoad == YES) {
    //        self.didLoad = NO;
    //        return;
    //    }
    //
    //
    //    if (UIAppDelegate.chatNotification == YES) {
    //        [self customSpinner];
    //        [self setupConversationDataSource];
    //
    //    }
    //    else
    //    {
    //
    ////        [self getContactList];
    //        [self getContactDetails];
    //    }
    //
    //    if ([spinner isAnimating]== YES) {
    //
    ////        [UIView animateWithDuration:0.2 animations:^{
    ////            self.activityView.alpha = 0;
    ////        } completion:^(BOOL finished) {
    ////            [self.activityView removeFromSuperview];
    ////        }];
    //
    //        [spinner stopAnimating];
    //
    //     }
    //
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupConversationDataSource {
    
    LYRQuery *query = [LYRQuery queryWithQueryableClass:[LYRConversation class]];
    query.predicate = [LYRPredicate predicateWithProperty:@"participants" predicateOperator:LYRPredicateOperatorIsIn value:self.layerClient.authenticatedUserID];
    query.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lastMessage.receivedAt" ascending:NO]];
    
    NSError *error;
    //yogish
    self.queryController = [self.layerClient queryControllerWithQuery:query error:&error];
    if (!self.queryController) {
        NSLog(@"LayerKit failed to create a query controller with error: %@", error);
        return;
    }
    self.queryController.delegate = self;
    BOOL success = [self.queryController execute:&error];
    if (!success) {
        NSLog(@"LayerKit failed to execute query with error: %@", error);
        return;
    }
    [self getContactDetails];
}

-(IBAction)newChatAction:(id)sender {
    
    _addPage = YES;
    UIStoryboard *sb =[UIStoryboard storyboardWithName:@"HomeView" bundle:nil];
    BUContactListViewController *vc = [sb instantiateViewControllerWithIdentifier:@"BUContactListViewController"];
    vc.queryController = self.queryController;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    @try {
        NSLog(@"Crashhhhhhh");
        NSLog(@"%lu",(unsigned long)[self.queryController numberOfObjectsInSection:0]);
        return  [self.queryController numberOfObjectsInSection:0];
    } @catch (NSException *exception) {
        NSLog(@"Error is %@",[exception description]);
        
    } @finally {
        
        NSLog(@"Finally");
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //BUChatContact *contact = [self.queryController objectAtIndexPath:indexPath];//[[self historyList] objectAtIndex:indexPath.row];
    NSLog(@"CheckingCellForgo");
    
    @try {
        
        LYRConversation *conversation = [self.queryController objectAtIndexPath:indexPath];//contact.conversation;
        
        
        NSLog(@"CheckingCellFor%@",conversation);
        
        
        LYRMessage * lastMessage = conversation.lastMessage;
        
        LYRMessagePart *messagePart;
        
        if ([lastMessage.parts count] > 0) {
            
            messagePart = lastMessage.parts[0];
        }
        
        //If it is type image
        
        BUContactListTableViewCell *cell = (BUContactListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"BUContactListTableViewCell" ];
        
        cell.conversation = conversation;
        
        //conversation.participants aaaa
        
        
        for (NSString *participant in conversation.participants) {
            if (![participant isEqualToString:[BULayerHelper sharedHelper].currentUserID])
            {
                
                BUChatContact *cont = [self getContact:participant];
                
                [cell setContactListDataSource:cont];
                
                //             }
            }
            
        }
        
        NSString *timestampText = @"";
        
        NSString *youString = @"";
        
        // If the message was sent by current user, show Receipent Status Indicator
        if ([lastMessage.sender.userID isEqualToString:[[BULayerHelper sharedHelper] currentUserID]]) {
            
            NSDate *date = lastMessage.sentAt;
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            df.dateStyle = kCFDateFormatterShortStyle;
            df.doesRelativeDateFormatting = YES;
            timestampText = [df stringFromDate:date];
            youString = @"you : ";
            
        } else
        {
            
            NSDate *date = lastMessage.receivedAt;
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            df.dateStyle = kCFDateFormatterShortStyle;
            df.doesRelativeDateFormatting = YES;
            timestampText = [df stringFromDate:date];
            youString = @"";
        }
        
        if ([messagePart.MIMEType isEqualToString:@"image/png"]) {
            cell.lastmessageLbl.text = [NSString stringWithFormat:@"%@image",youString]; //
            
        } else {
            cell.lastmessageLbl.text =[NSString stringWithFormat:@"%@%@",youString,[[NSString alloc]initWithData:messagePart.data
                                                                                                        encoding:NSUTF8StringEncoding]];
        }
        
        cell.timeLbl.text = timestampText ? [NSString stringWithFormat:@"%@",timestampText] : @"";
        
        if (conversation.hasUnreadMessages) {
            cell.unreadMessageIndicator.hidden = NO;
        } else {
            cell.unreadMessageIndicator.hidden = YES;
        }
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        longPress.minimumPressDuration = 1.0;
        [cell addGestureRecognizer:longPress];
        
        return cell;
        
        
    } @catch (NSException *exception) {
        NSLog(@"Can I get Reason * %@ ",[exception description]);
        
    } @finally {
        NSLog(@"CheckFinally");
        
    }
    
}

- (void)longPress:(UILongPressGestureRecognizer*)gesture
{
    //    if ( gesture.state == UIGestureRecognizerStateEnded) {
    if (_isDone == YES) {
        
        BUContactListTableViewCell *cellLongPressed = (BUContactListTableViewCell *) gesture.view;
        
        //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(gesture.view.tag - 1) inSection:0];
        
        self.selectedMessage = cellLongPressed.conversation;//[self.queryController objectAtIndexPath:indexPath];
        //LYRMessagePart *messagePart = self.selectedMessage.parts[0];
        
        NSString *participantName, *participantID;
        
        for (NSString *participant in cellLongPressed.conversation.participants) {
            if (![participant isEqualToString:self.layerClient.authenticatedUserID] )
            {
                BUChatContact *cont = [self getContact:participant];
                participantName = cont.fName;
                participantID = participant;
                
                //            }
            }
            
        }
        
        UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:@"Delete"  message:[NSString stringWithFormat:@"Are you sure to delete %@'s Conversation",participantName]  preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [self startActivityIndicator:YES];
            
            NSDictionary *parameter = nil;
            parameter = @{@"userid1": [BUWebServicesManager sharedManager].userID,
                          @"userid2":participantID};
            [[BUWebServicesManager sharedManager]queryServer:parameter
                                                     baseURL:@"chat/deletechat"
                                                successBlock:^(id response, NSError *error)
             {
                 [self stopActivityIndicator];
                 _isDone = YES;
                 NSError *error1;
                 bool success = [self.selectedMessage delete:LYRDeletionModeAllParticipants error:&error1];
                 if (success) {
                     NSLog(@"The message has been deleted");
                 } else {
                     NSLog(@"Failed deletion of message: %@", error);
                 }
                 
                 [[self.tabBarController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = [NSString stringWithFormat:@"%d",(int)[actualChatList count]-1];
                 NSLog(@"Count is  %@",[NSString stringWithFormat:@"%d",(int)[actualChatList count]-1]);
                 
             }
                                                failureBlock:^(id response, NSError *error)
             {
                 [self stopActivityIndicator];
                 
                 if (error.code == NSURLErrorTimedOut) {
                     
                     [self showAlert:@"Connection timed out, please try again later"];
                     return ;
                 }
                 _isDone = YES;
                 [self showAlert:@"Connectivity Error"];
             }];
            
            
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            _isDone = YES;
        }]];
        
        _isDone = NO;
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete messages?" message: [NSString stringWithFormat:@"This action will delete \"%@\" message. Are you sure you want to do this?",[[NSString alloc]initWithData:messagePart.data encoding:NSUTF8StringEncoding]] delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Yes",nil];
        //        alert.tag = 999;
        
        //        [alert show];
    }
    //    }
}


-(BUChatContact*)getContact:(NSString*)participant {
    
    NSLog(@"USRRRRRRR is%lu,%@",(unsigned long)UIAppDelegate.historyList.count,participant);
    
    for (int g=0; g<[UIAppDelegate.historyList count]; g++) {
        BUChatContact *contact = [UIAppDelegate.historyList objectAtIndex:g];
        if ([participant isEqualToString:contact.userID]) {
            NSLog(@"Contacttttttttt");
            return contact;
        }
        
    }
    
    
    
    return [self getContactFromLocal:participant];
    
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@", participant];
    //    NSArray *filtered = [UIAppDelegate.historyList filteredArrayUsingPredicate:predicate];
    //    if ([filtered count]==0) {
    //
    //        return [self getContact:participant];
    //    }
    //    return [filtered objectAtIndex:0];
}

-(BUChatContact*)getContactFromLocal:(NSString*)participant {
    
    NSLog(@"ContactttttttttElse");
    
    
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"localHistory"];
    
    NSArray *localArray = data ? [NSKeyedUnarchiver unarchiveObjectWithData:data] : @[];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userid == %@", participant];
    NSArray *filtered = [localArray filteredArrayUsingPredicate:predicate];
    
    if ([filtered count]>0)
    {
        NSDictionary *d = [filtered objectAtIndex:0];
        BUChatContact *contact = [[BUChatContact alloc] init];
        contact.userID = [d objectForKey:@"userid"];
        contact.relationShip = [d objectForKey:@"relation"];
        contact.fName = [d objectForKey:@"First Name"];
        contact.imgURL = [d objectForKey:@"img_url"];
        contact.lName = @"";
        contact.configuration = [[d objectForKey:@"chat_notification"] isEqualToString: @"YES"] ? YES : NO;
        contact.isNewmessage = false;
        return contact;
    }
    
    return  nil;
    
    
    
    
    
    
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    LYRConversation *conversation = [self.queryController objectAtIndexPath:indexPath];
    //    for (NSString *participant in conversation.participants) {
    //        if (![participant isEqualToString:self.layerClient.authenticatedUserID] ) {
    //            [[BULayerHelper sharedHelper] setParticipantUserID:participant];
    //
    //        }
    //    }
    [self startActivityIndicator:YES];
    //NSString * identifier = conversation.identifier.absoluteString;
    
    LYRConversation *conversation = [self.queryController objectAtIndexPath:indexPath];
    
    for (NSString *participant in conversation.participants) {
        if (![participant isEqualToString:[BULayerHelper sharedHelper].currentUserID])
        {
            
            BUChatContact *contact = [self getContact:participant];
            UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Connections" bundle:nil];
            LQSViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LQSViewController"];
            vc.recipientName =  contact.fName;//[contact.relationShip isEqualToString:@"Self"] ? contact.fName : [NSString stringWithFormat:@"%@'s %@",contact.fName,contact.relationShip];nii
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView sd_setImageWithURL:[NSURL URLWithString:contact.imgURL]
                         placeholderImage:[UIImage imageNamed:@"logo44"]
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {
                 
             }];
            vc.profileImage = imageView.image;
            vc.relationShip = contact.relationShip;
            vc.configuration = contact.configuration;
            vc.participantId = contact.userID;//[(BUChatContact *)[UIAppDelegate.historyList objectAtIndex:indexPath.row] userID];
            [self stopActivityIndicator];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
    }
}


- (void)queryControllerWillChangeContent:(LYRQueryController *)queryController
{
    NSLog(@"OMMMMMMMMMMMMMMMM Strat");
    [self.conversationListTableView beginUpdates];
}

- (void)queryController:(LYRQueryController *)controller
        didChangeObject:(id)object
            atIndexPath:(NSIndexPath *)indexPath
          forChangeType:(LYRQueryControllerChangeType)type
           newIndexPath:(NSIndexPath *)newIndexPath
{
    
    NSLog(@"OMMMMMMMMMMMMMMMM happed");
    
    [self.conversationListTableView beginUpdates];
    @try {
        self.notInsert = YES;
        
        switch (type) {
            case LYRQueryControllerChangeTypeInsert: {
                self.notInsert = NO;
                [self.conversationListTableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self showNoListAvailable];
            }
                break;
            case LYRQueryControllerChangeTypeUpdate:
                [self.conversationListTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self showNoListAvailable];

                break;
            case LYRQueryControllerChangeTypeMove:
                
                
                [self.conversationListTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                
                [self.conversationListTableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self showNoListAvailable];

                break;
            case LYRQueryControllerChangeTypeDelete:
                [self.conversationListTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self showNoListAvailable];

                break;
            default:
                break;
        }
    } @catch (NSException *exception) {
        NSLog(@"reasondamit is    %@",exception.description);
    } @finally {
    }
    
    [self.conversationListTableView endUpdates];
    
    
}

- (void)queryControllerDidChangeContent:(LYRQueryController *)queryController
{
    NSLog(@"OMMMMMMMMMMMMMMMM finished");
    
    if(([self.queryController numberOfObjectsInSection:0] < 1) && self.notInsert == NO)
    {
        [self.conversationListTableView reloadData];
        return;
    }
    [self.conversationListTableView endUpdates];
}

-(void)getContactList {
    
    [UIAppDelegate.historyList removeAllObjects];
    NSDictionary *parameter = nil;
    parameter = @{@"userid": [BUWebServicesManager sharedManager].userID};
    
    [self startActivityIndicator:YES];
    NSString *baseUrl = [NSString stringWithFormat:@"api/chat/view/userid/%@",[BUWebServicesManager sharedManager].userID];
    [[BUWebServicesManager sharedManager] getqueryServer:parameter
                                                 baseURL:baseUrl
                                            successBlock:^(id response, NSError *error)
     {
         [self stopActivityIndicator];
         
         
         if ([response count]>0) {
             NSLog(@"Updated UserContacts are %@",response);
             NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:response];
             [[NSUserDefaults standardUserDefaults] setObject:data1 forKey:@"localHistory"];
             [[NSUserDefaults standardUserDefaults] synchronize];
         }
         
         NSMutableArray *dArray = [[NSMutableArray alloc]init];
         for (int j=0; j<[response count]; j++) {
             [dArray addObject:[response objectAtIndex:j]];
         }
         
         actualChatList = [[NSOrderedSet orderedSetWithArray:dArray] array];
         
         NSInteger count = [self.queryController numberOfObjectsInSection:0];
         
         NSInteger newConnectCount = (int)[actualChatList count]-count;
         
         self.notifLabel.text =  newConnectCount >=0 ? [NSString stringWithFormat:@"%d",(int)[actualChatList count] - (int)count] : @"0";
         
         if (![self.notifLabel.text isEqualToString:@"0"]) {
             self.notifLabel.hidden = NO;
         }
         
         NSInteger actlCount = [actualChatList count];
         
         [[self.tabBarController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = actlCount >=0 ?   [NSString stringWithFormat:@"%d",(int)[actualChatList count]] : @"0";
         //yogish
         [UIAppDelegate.historyList removeAllObjects];
         for (int o=0; o<[actualChatList count]; o++) {
             NSDictionary *d = [actualChatList objectAtIndex:o];
             BUChatContact *contact = [[BUChatContact alloc] init];
             contact.userID = [d objectForKey:@"userid"];
             contact.relationShip = [d objectForKey:@"relation"];
             contact.fName = [d objectForKey:@"First Name"];
             contact.imgURL = [d objectForKey:@"img_url"];
             contact.lName = @"";
             contact.configuration = [[d objectForKey:@"chat_notification"] isEqualToString: @"YES"] ? YES : NO;
             contact.isNewmessage = false;
             
             [UIAppDelegate.historyList addObject:contact];
             // [self notificationPush];
         }
         
         [self.conversationListTableView reloadData];
     }
                                            failureBlock:^(id response, NSError *error)
     {
         [self stopActivityIndicator];
         
         
         if (error.code == NSURLErrorTimedOut) {
             
             [self showAlert:@"Connection timed out, please try again later"];
         }
         else
         {
             [self showAlert:@"Connectivity Error"];
         }
     }];
    
    
}


#pragma TableView DataSource & Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;

{
    return 1;
}


-(IBAction)compose:(id)sender{
    
    
}


-(void)getContactDetails {
    //    LYRConversation *conversation = [self.layerClient newConversationWithParticipants:[NSSet setWithObjects:@"USER-IDENTIFIER", nil] options:nil error:nil];
    @try {
        LYRQuery *query = [LYRQuery queryWithQueryableClass:[LYRConversation class]];
        NSOrderedSet *conversations = [self.layerClient executeQuery:query error:nil];
        if (conversations) {
            NSLog(@"%tu conversations", conversations.count);
        } else {
            NSLog(@"Query failed with error");
        }
        NSMutableArray *useridsArray = [[NSMutableArray alloc] init];
        [UIAppDelegate.historyList removeAllObjects];
        //    NSArray *actualChatList = [[NSArray alloc] init];
        
        NSString *baseUrl = [NSString stringWithFormat:@"chat/view/userid/%@",[BUWebServicesManager sharedManager].userID];
        [self startActivityIndicator:YES];
        [[BUWebServicesManager sharedManager] getqueryServer:nil
                                                     baseURL:baseUrl
                                                successBlock:^(id response, NSError *error)
         {
             [self stopActivityIndicator];
             if ([response count]>0) {
                 NSLog(@"Updated UserContacts are %@",response);
                 NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:response];
                 [[NSUserDefaults standardUserDefaults] setObject:data1 forKey:@"localHistory"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 
                 
             }
             
             NSMutableArray *dArray = [[NSMutableArray alloc]init];
             for (int j=0; j<[response count]; j++) {
                 [dArray addObject:[response objectAtIndex:j]];
             }
             
             actualChatList = [[NSOrderedSet orderedSetWithArray:dArray] array];
             
             // [[self.tabBarController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = [NSString stringWithFormat:@"%d",(int)[actualChatList count]];
             NSInteger actlCount = [actualChatList count];
             
             [[self.tabBarController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = actlCount >=0 ?   [NSString stringWithFormat:@"%d",(int)[actualChatList count]] : @"0";
             
             //         self.historyList = [[[NSOrderedSet orderedSetWithArray:dArray] array] mutableCopy];
             
             
             //         NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:dArray];
             //         actualChatList = orderedSet.array;
             
             NSInteger row = 0;
             NSInteger count = [self.queryController numberOfObjectsInSection:row];
             if (count == 0) {
                 self.messageLabel.text = @"Connect with one of your matches to chat with them here.";
                 self.messageLabel.hidden = NO;
                 [self.conversationListTableView setHidden:YES];
             }else{
                 self.messageLabel.text = @"";
                 self.messageLabel.hidden = YES;
                 [self.conversationListTableView setHidden:NO];
             }
             // self.notifLabel.text = [NSString stringWithFormat:@"%d",(int)[actualChatList count] - (int)count];
             NSInteger newConnectCount = (int)[actualChatList count]-count;
             self.notifLabel.text =  newConnectCount >=0 ? [NSString stringWithFormat:@"%d",(int)[actualChatList count] - (int)count] : @"0";
             if (![self.notifLabel.text isEqualToString:@"0"]) {
                 self.notifLabel.hidden = NO;
             }
             
             //self.historyList = [[NSMutableArray alloc] init];
             
             for (row =0 ; row < count; row++)
             {
                 LYRConversation *conversation = [self.queryController objectAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
                 for (NSString *participant in conversation.participants) {
                     if (![participant isEqualToString:self.layerClient.authenticatedUserID] )
                     {
                         
                         NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userid == %@", participant];
                         NSArray *filtered = [actualChatList filteredArrayUsingPredicate:predicate];
                         
                         NSLog(@"%@,%@",actualChatList,participant);
                         
                         if ([filtered count]==0) {
                             bool success = [conversation delete:LYRDeletionModeAllParticipants error:nil];
                             if (!success) {
                                 NSLog(@"Not deleted");
                             }
                         }
                         else {
                             NSDictionary *d = [filtered objectAtIndex:0];
                             BUChatContact *contact = [[BUChatContact alloc] init];
                             contact.userID = participant;
                             contact.relationShip = [d objectForKey:@"relation"];
                             contact.fName = [d objectForKey:@"First Name"];
                             contact.imgURL = [d objectForKey:@"img_url"];
                             contact.lName = @"";
                             contact.isNewmessage = false;
                             contact.conversation = conversation;
                             contact.configuration = [[d objectForKey:@"chat_notification"] isEqualToString: @"YES"] ? YES : NO;
                             [UIAppDelegate.historyList addObject:contact];
                             [useridsArray addObject:participant];
                         }
                     }
                 }
             }
             
             LYRQuery *query = [LYRQuery queryWithQueryableClass:[LYRConversation class]];
             query.predicate = [LYRPredicate predicateWithProperty:@"participants" predicateOperator:LYRPredicateOperatorIsIn value:self.layerClient.authenticatedUserID];
             query.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lastMessage.receivedAt" ascending:NO]];
             
             NSError *error5;
             self.queryController = [self.layerClient queryControllerWithQuery:query error:&error5];
             if (!self.queryController) {
                 NSLog(@"LayerKit failed to create a query controller with error: %@", error5);
                 return;
             }
             self.queryController.delegate = self;
             BOOL success = [self.queryController execute:&error5];
             if (!success) {
                 NSLog(@"LayerKit failed to execute query with error: %@", error5);
                 return;
             }
             
             // NSLog(@"%lu",(unsigned long)[self.queryController numberOfObjectsInSection:0]);
             
             //self.conversationListTableView.dataSource = self;
             // self.conversationListTableView.delegate = self;
             //              dispatch_async(dispatch_get_main_queue(), ^{
             //             [self.conversationListTableView reloadData];
             //                   });
             //
             //             [self notificationPush];
             //
             //
             //
             //         }
             __weak BUProfileMatchChatVC *weakaself = self;
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 if (weakaself){
                     if (UIAppDelegate.chatNotification == YES) {
                         UIAppDelegate.chatNotification = NO;
                         [weakaself notificationPush];
                         
                     }
                     [weakaself.conversationListTableView reloadData];
                 }
             });
         }
         
                                                failureBlock:^(id response, NSError *error)
         {
             [self stopActivityIndicator];
             
             if (error.code == NSURLErrorTimedOut) {
                 
                 [self showAlert:@"Connection timed out, please try again later"];
             }
             else
             {
                 [self showAlert:@"Connectivity Error"];
             }
             
         }];
        
        
    } @catch (NSException *exception) {
        
        NSLog(@"Crashed reason is %@",[exception description]);
        
    } @finally {
        
    }
    //
    
    
}
-(void)showNoListAvailable{
    NSInteger row = 0;
    NSInteger count = [self.queryController numberOfObjectsInSection:row];
    if (count == 0) {
        self.messageLabel.text = @"Connect with one of your matches to chat with them here.";
        self.messageLabel.hidden = NO;
        [self.conversationListTableView setHidden:YES];
    }else{
        self.messageLabel.text = @"";
        self.messageLabel.hidden = YES;
        [self.conversationListTableView setHidden:NO];
    }
}
//-(void)notificationPush
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//        // [self startActivityIndicator:YES];
//         NSLog(@"Notification received isssss : %@",UIAppDelegate.notificationDict);
//
//
//         [spinner stopAnimating];
//
//        if (UIAppDelegate.chatNotification == YES) {
//
//            UIAppDelegate.chatNotification = NO;
//            UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Connections" bundle:nil];
//            LQSViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LQSViewController"];
//
//            NSLog(@"HMMMM");
//               NSLog(@"check:%@",[[UIAppDelegate.notificationDict objectForKey:@"data"] objectForKey:@"userid"]);
//
//            if ([[UIAppDelegate.notificationDict objectForKey:@"data"] objectForKey:@"userid"]) {
//                BUChatContact *contact = [self getContact:[[UIAppDelegate.notificationDict objectForKey:@"data"] objectForKey:@"userid"]];
//                vc.recipientName =  contact.fName;//[contact.relationShip isEqualToString:@"Self"] ? contact.fName : [NSString stringWithFormat:@"%@'s %@",contact.fName,contact.relationShip];
//                vc.relationShip = contact.relationShip;
//                vc.configuration = contact.configuration;
//                vc.participantId = [[UIAppDelegate.notificationDict objectForKey:@"data"] objectForKey:@"userid"];//[(BUChatContact *)[UIAppDelegate.historyList objectAtIndex:indexPath.row] userID];
//                //[self.navigationController pushViewController:vc animated:YES];
//                NSLog(@"user name is %@",vc.recipientName);
//                NSLog(@"Getting me");
//              //  UIAppDelegate.notificationDict = nil;
//                [self.navigationController pushViewController:vc animated:true];
//
//            }
//            else {
//
//                 NSLog(@"Contact does not exist");
//                // UIAppDelegate.notificationDict = nil;
//            }
//
//            // [self stopActivityIndicator];
//
//
//
//        }
//
//    });
//
//}
-(void)notificationPush {
    //  dispatch_async(dispatch_get_main_queue(), ^{
    // [self startActivityIndicator:YES];
    NSLog(@"Notification received isssss : %@",UIAppDelegate.notificationDict);
    [spinner stopAnimating];
    NSLog(@"UIAppDelegate.chatNotification=%d",UIAppDelegate.chatNotification);
    //yogish
    // if (UIAppDelegate.chatNotification == YES) {
    
    UIAppDelegate.chatNotification = NO;
    UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Connections" bundle:nil];
    LQSViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LQSViewController"];
    
    NSLog(@"HMMMM");
    NSLog(@"check:%@",[[UIAppDelegate.notificationDict objectForKey:@"data"] objectForKey:@"userid"]);
    
    if ([[UIAppDelegate.notificationDict objectForKey:@"data"] objectForKey:@"userid"]) {
        BUChatContact *contact = [self getContact:[[UIAppDelegate.notificationDict objectForKey:@"data"] objectForKey:@"userid"]];
        vc.recipientName =  contact.fName;//[contact.relationShip isEqualToString:@"Self"] ? contact.fName : [NSString stringWithFormat:@"%@'s %@",contact.fName,contact.relationShip];
        vc.relationShip = contact.relationShip;
        vc.configuration = contact.configuration;
        vc.participantId = [[UIAppDelegate.notificationDict objectForKey:@"data"] objectForKey:@"userid"];//[(BUChatContact *)[UIAppDelegate.historyList objectAtIndex:indexPath.row] userID];
        //[self.navigationController pushViewController:vc animated:YES];
        NSLog(@"user name is %@",vc.recipientName);
        NSLog(@"Getting me");
        [self.navigationController pushViewController:vc animated:true];
    }
    else {
        NSLog(@"Contact does not exist");
    }
    //        }
    
    // });
    
}






@end
