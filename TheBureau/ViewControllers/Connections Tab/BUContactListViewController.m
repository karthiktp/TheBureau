//
//  BUContactListViewController.m
//  TheBureau
//
//  Created by Accion Labs on 26/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUContactListViewController.h"
#import "BUCOntactListTableViewCell.h"
#import "BUWebServicesManager.h"
#import "LQSViewController.h"
#import "BUConstants.h"
#import <SDWebImage/UIImageView+WebCache.h>


#import "AppDelegate.h"

@interface BUContactListViewController ()

@property(nonatomic) NSArray * imageArray;

@property(nonatomic, weak) IBOutlet UITableView *contactsTableView;
@property (strong, nonatomic) NSMutableArray *ChatArray;



@end


@implementation BUContactListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // self.title = @"Connections";
    [self navigationTitle];
    
    self.ChatArray = [[NSMutableArray alloc] init];
    
   // [self setup];
    
}
-(void)navigationTitle

{
    UILabel* lbNavTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,40,320,40)];
    lbNavTitle.textAlignment = NSTextAlignmentLeft;
    lbNavTitle.textColor = [UIColor whiteColor];
    lbNavTitle.font = [UIFont systemFontOfSize:20];
    lbNavTitle.text = NSLocalizedString(@"New Connections",@"");
    self.navigationItem.titleView = lbNavTitle;
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"ic_back"]  ;
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, backBtnImage.size.width, backBtnImage.size.height);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
}

-(void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self getContactsList];
}

-(void)setup{
    
    LYRQuery *query = [LYRQuery queryWithQueryableClass:[LYRConversation class]];
    query.predicate = [LYRPredicate predicateWithProperty:@"participants" predicateOperator:LYRPredicateOperatorIsIn value:self.layerClient.authenticatedUserID];
    query.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lastMessage.receivedAt" ascending:NO]];
    
    
    NSError *error;
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

}

-(void)getContactsList
{
    NSString *baseUrl = [NSString stringWithFormat:@"chat/view/userid/%@",[BUWebServicesManager sharedManager].userID];
    [self startActivityIndicator:YES];
    [[BUWebServicesManager sharedManager] getqueryServer:nil
                                                 baseURL:baseUrl
                                            successBlock:^(id inResult, NSError *error)
     {
         [self stopActivityIndicator];
         if(nil != inResult)
         {
             
             [self.ChatArray removeAllObjects];
             //self.contactList = [[NSMutableArray alloc] init];
             for (NSDictionary *dict in inResult)
             {
                 //BUChatContact *contact = [[BUChatContact alloc] initWithDict:dict];
                 
                 
                 //NSDictionary *d = [dict objectAtIndex:y];
                 BUChatContact *contact = [[BUChatContact alloc] init];
                 contact.userID = [dict objectForKey:@"userid"];
                 contact.relationShip = [dict objectForKey:@"relation"];
                 contact.fName = [dict objectForKey:@"First Name"];
                 contact.imgURL = [dict objectForKey:@"img_url"];
                 contact.lName = @"";
                 contact.configuration = [[dict objectForKey:@"chat_notification"] isEqualToString: @"YES"] ? YES : NO;
                 contact.isNewmessage = false;
                 
                 NSLog(@"%d",contact.configuration);
                 int c = 0;
//                 for (BUChatContact* contact1 in chattingArray) {
//                     
//                     NSLog(@"%@",contact1.conversation.lastMessage);
//                     
//                     if (contact1.userID == contact.userID) {
//                         c++;
//                     }
//                 }
                 
                 NSLog(@"%@,%@",contact.fName,contact.userID);
                 
                 for (int j = 0; j<[self.queryController numberOfObjectsInSection:0]; j++) {
                     LYRConversation *conversation = [self.queryController objectAtIndexPath:[NSIndexPath indexPathForRow:j inSection:0]];
                     for (NSString *participant in conversation.participants) {
                         if (![participant isEqualToString:[BUWebServicesManager sharedManager].userID] )
                         {
                             NSLog(@"%@,%@",participant,contact.userID);
                             if ([[NSString stringWithFormat:@"%@",participant] isEqualToString:[NSString stringWithFormat:@"%@",contact.userID]]) {
                                 c++;
                             }
                         }
                     }
                 }
                 
                 if (c == 0) {
                     [self.ChatArray addObject:contact];
                 }
                 
             }
             
             [self.contactsTableView reloadData];
         }
         else
         {
             [self showAlert:@"Connectivity Error"];
        }
     }
                                                   failureBlock:^(id response, NSError *error)
     {
         [self stopActivityIndicator];
         [self showAlert:@"Connectivity Error"];
     }];
}



#pragma TableView DataSource & Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
    return self.ChatArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    BUContactListTableViewCell *cell = (BUContactListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"BUContactListTableViewCell" ];//forIndexPath:indexPath];
    [cell setContactListDataSource:[self.ChatArray objectAtIndex:indexPath.row]];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    [[BULayerHelper sharedHelper] setParticipantUserID:[(BUChatContact *)[self.ChatArray objectAtIndex:indexPath.row] userID]];
    UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Connections" bundle:nil];
    LQSViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LQSViewController"];
    BUChatContact *contact = [self.ChatArray objectAtIndex:indexPath.row];
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:contact.imgURL]
                 placeholderImage:[UIImage imageNamed:@"logo44"]
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         
     }];
    vc.profileImage = imageView.image;
    vc.recipientName = [NSString stringWithFormat:@"%@",contact.fName];
    vc.relationShip = contact.relationShip;
    vc.participantId = [(BUChatContact *)[self.ChatArray objectAtIndex:indexPath.row] userID];
    vc.configuration = contact.configuration;
    NSLog(@"%d",contact.configuration);
    [self.navigationController pushViewController:vc animated:YES];
    
}



@end
