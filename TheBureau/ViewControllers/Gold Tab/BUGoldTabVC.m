//
//  BUGoldTabVC.m
//  TheBureau
//
//  Created by Manjunath on 07/ /16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUGoldTabVC.h"
#import "BUGoldTabCell.h"
#import "PWInAppHelper.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "InstagramMedia.h"
#import "InstagramKit.h"
#import "IKLoginViewController.h"


#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import "FBController.h"
#import "AppDelegate.h"

#import <MessageUI/MessageUI.h>

@interface BUGoldTabVC ()<FBSDKAppInviteDialogDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>

@property(nonatomic, weak) IBOutlet UICollectionView *goldCollectionView;
@property(nonatomic, weak) IBOutlet UILabel *totalGoldLabel;
@property(nonatomic, strong) NSArray *products ;
@property(nonatomic,strong)NSMutableArray *dupProducts;
@property(nonatomic, weak) IBOutlet UIButton *inviteFriendButton,*followFriendButton;
@property(nonatomic, weak) IBOutlet FBSDKLikeButton *likeUsOnFBButton;
@property (strong, nonatomic) IBOutlet UILabel *bottomTextLabel;
@property (strong, nonatomic) IBOutlet UITextView *bottomTextLabel1;

@property (nonatomic, strong)   InstagramPaginationInfo *currentPaginationInfo;
@property (nonatomic, weak)     InstagramEngine *instagramEngine;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *referalCodeHeightConstraint;
@property (strong, nonatomic) IBOutlet UILabel *referalLeftView;
@property (strong, nonatomic) IBOutlet UITextField *referalField;

-(IBAction)inviteFriend:(id)sender;
-(IBAction)likeUsOnFB:(id)sender;
-(IBAction)followUsInInstagram:(id)sender;
@end

@implementation BUGoldTabVC


//https://www.instagram.com/itsthebureau/



-(void)resetGoldTable
{
    
    //    NSString *titleStr = @"";
    //    UIImage *statusImg = [UIImage imageNamed:@""];
    //    titleStr = [NSString stringWithFormat:@"     Invite a Friend"];
    //    NSMutableAttributedString *statusString = [[NSMutableAttributedString alloc] init];
    //    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:titleStr];
    //    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    //    textAttachment.image = statusImg;
    //    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    //
    //    [statusString appendAttributedString:attrStringWithImage];
    //    [statusString appendAttributedString:attributedString];
    
    //    [followFriendButton setAttributedTitle:<#(nullable NSAttributedString *)#> forState:<#(UIControlState)#>]
    
    //[self.goldCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    //    FBSDKLikeControl *likeButton = [[FBSDKLikeControl alloc] initWithFrame:self.likeUsOnFBButton.frame];
    //    likeButton.objectID = @"https://www.facebook.com/thebureauapp";
    //    //likeButton.center = self.view.center;
    //    [self.view addSubview:likeButton];
    
    //    self.likeUsOnFBButton.objectID = @"https://www.facebook.com/thebureauapp/";
    //
    //    self.likeUsOnFBButton.backgroundColor = [UIColor clearColor];
    //
    //    self.likeUsOnFBButton.objectType = FBSDKLikeObjectTypePage;
    
    //[self.goldCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    
    //[self performSelector:@selector(resetGoldTable) withObject:nil afterDelay:0.6];
    
    [self getGoldDetails];
    
    //[self fbLikePermission];
    
}
- (IBAction)hidekeybord:(id)sender {
    
    [self.referalField resignFirstResponder];
}


- (IBAction)referSubmitAction:(id)sender {
    
    
    if (![self.referalField.text length]) {
        [self showAlert:@"Please enter Referal Code"];
        return;
    }
    
    //if (self.referalField.isFirstResponder) {
    [self.referalField resignFirstResponder];
    //}
    
    NSDictionary *parameters = nil;
    parameters = @{@"userid": [BUWebServicesManager sharedManager].userID,
                   @"referral_code":self.referalField.text};
    
    [self startActivityIndicator:YES];
    [[BUWebServicesManager sharedManager]queryServer:parameters
                                             baseURL:@"gold/checkReferralCode"
                                        successBlock:^(id response, NSError *error) {
                                            
                                            [self stopActivityIndicator];
                                            
                                            self.referalField.text = @"";
                                            [self showAlert:[response objectForKey:@"response"]];
                                            if ([[response objectForKey:@"msg"] isEqualToString:@"Success"]) {
                                                
                                                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"referred"];
                                                self.referalCodeHeightConstraint.constant = 0;
                                                [self.view updateConstraints];
                                                
                                                NSInteger gold = [[NSUserDefaults standardUserDefaults] integerForKey:@"purchasedGold"];
                                                
                                                [[NSUserDefaults standardUserDefaults] setInteger:gold + 150 forKey:@"purchasedGold"];
                                                [[NSUserDefaults standardUserDefaults] synchronize];
                                                
                                                self.totalGoldLabel.text = [NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"purchasedGold"]];
                                                
                                                [(BUHomeTabbarController *)[self tabBarController] updateGoldValue:[[NSUserDefaults standardUserDefaults] integerForKey:@"purchasedGold"]];
                                                
                                            }
                                            
                                        }
                                        failureBlock:^(id response, NSError *error)
     {
         [self stopActivityIndicator];
         
         
         if (error.code == NSURLErrorTimedOut) {
             
             [self timeoutError:@"Connection timed out, please try again later"];
         }
         else
         {
             
             [self showFailureAlert];
             
         }
         
     }];
    
}


-(void)fbLikePermission {
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
        // TODO: publish content.
    } else {
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        UIViewController *root = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        [loginManager logInWithPublishPermissions:@[@"publish_actions"] fromViewController:root handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            //TODO: process error or result.
            NSLog(@"%@",result.grantedPermissions);
            NSLog(@"%@",result);
        }];
    }
}

- (void)reload {
    
    _products = nil;
    _dupProducts = nil;
    [PWInAppHelper sharedInstance].parentCtrllr = self;
    [[PWInAppHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _products = products;
            [self sortArray];
            [self.goldCollectionView reloadData];
        }
        [self stopActivityIndicator];
    }];
}

-(void)sortArray
{
    
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"price" ascending:YES];
    
    NSArray *sorters = [[NSArray alloc] initWithObjects:sorter, nil];
    
    NSArray *sortedArray = [_products sortedArrayUsingDescriptors:sorters];
    _dupProducts = [[NSMutableArray alloc]init];
    
    [_dupProducts addObjectsFromArray:sortedArray];
    
    NSLog(@"sortArray : %lu",(unsigned long)_dupProducts.count);
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    self.referalField.inputAccessoryView = _toolBar;
    
    
    
    // Do any additional setup after loading the view.
    //    FBSDKLikeControl *likeButton = [[FBSDKLikeControl alloc]initWithFrame:CGRectMake(20, 294, 560, 40)];
    //    likeButton.objectID = @"https://www.facebook.com/thebureauapp/";
    //
    //    [self.view addSubview:likeButton];
    //
    //    likeButton.hidden = YES;
    
    _fbLikeDone = NO;
    _instagramFollowDone = NO;
    //  _dupProducts = [[NSMutableArray alloc]init];
    
    self.totalGoldLabel.text = [NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"purchasedGold"]];
    
    self.inviteFriendButton.layer.cornerRadius = 5.0;
    self.inviteFriendButton.layer.borderWidth = 1.0;
    self.inviteFriendButton.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    self.inviteFriendButton.layer.shadowOffset = CGSizeMake(2, 2);
    self.inviteFriendButton.layer.shadowColor = [[UIColor darkGrayColor]CGColor];
    
    self.followFriendButton.layer.cornerRadius = 5.0;
    self.followFriendButton.layer.borderWidth = 1.0;
    self.followFriendButton.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    self.followFriendButton.layer.shadowOffset = CGSizeMake(2, 2);
    self.followFriendButton.layer.shadowColor = [[UIColor darkGrayColor]CGColor];
    
    self.likeUsOnFBButton.layer.cornerRadius = 5.0;
    self.likeUsOnFBButton.layer.borderWidth = 1.0;
    self.likeUsOnFBButton.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    self.likeUsOnFBButton.layer.shadowOffset = CGSizeMake(2, 2);
    self.likeUsOnFBButton.layer.shadowColor = [[UIColor darkGrayColor]CGColor];
    
    self.bottomTextLabel1.delaysContentTouches = NO;
    self.bottomTextLabel1.delegate = self;
    
    NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:self.bottomTextLabel1.text];
    [message addAttribute:NSFontAttributeName
                    value:[UIFont fontWithName:@"comfortaa" size:15]
                    range:NSMakeRange(0, message.length)];
    NSRange range = [self.bottomTextLabel1.text rangeOfString:@"Terms and Conditions"];
    [message addAttribute:NSLinkAttributeName value:[@"Terms and Conditions" stringByAppendingString:@"TEST"] range:range];
    self.bottomTextLabel1.attributedText = message;
    self.bottomTextLabel1.textAlignment = NSTextAlignmentCenter;
}



-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.referalField.leftView = self.referalLeftView;
    self.referalField.leftViewMode = UITextFieldViewModeAlways;
    self.referalCodeHeightConstraint.constant = [[NSUserDefaults standardUserDefaults] boolForKey:@"referred"] == YES ? 0 : 92;
}

- (void)textViewTapped:(UITapGestureRecognizer *)sender {
    
    NSString *wordTarget = @"Terms";
    
    NSString *wordTarget1 = @"and";
    
    NSString *wordTarget2 = @"Conditions";
    
    NSString* word = [self getWordAtPosition:[sender locationInView:self.bottomTextLabel1] textView:self.bottomTextLabel1];
    if ([word isEqualToString:wordTarget]|[word isEqualToString:wordTarget1]|[word isEqualToString:wordTarget2]) {
        NSString *plainString = self.bottomTextLabel1.attributedText.string;
        NSMutableArray* substrings = [[NSMutableArray alloc]init];
        NSScanner *scanner = [[NSScanner alloc]initWithString:plainString];
        [scanner scanUpToString:@"#" intoString:nil];
        while (![scanner isAtEnd]) {
            NSString* substring = nil;
            [scanner scanString:@"#" intoString:nil];
            NSString* space = @" ";
            if ([scanner scanUpToString:space intoString:&substring]) {
                [substrings addObject:substring];
            }
            [scanner scanUpToString:@"#" intoString:nil];
        }
        
        NSLog(@"action added");
        
    }
    
}

- (NSString*)getWordAtPosition:(CGPoint)position textView:(UITextView *)textView {
    //remove scrollOffset
    CGPoint correctedPoint = CGPointMake(position.x, textView.contentOffset.y + position.y);
    UITextPosition *tapPosition = [textView closestPositionToPoint:correctedPoint];
    UITextRange *wordRange = [textView.tokenizer rangeEnclosingPosition:tapPosition withGranularity:UITextGranularityWord inDirection:UITextLayoutDirectionRight];
    return [textView textInRange:wordRange];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    
    //    NSLog(@"%ld",characterRange);
    
    //    if ([URL.scheme isEqualToString:@"Terms and Conditions"]) {
    //        // Launch View controller
    //        return NO;
    //    }
    
    if (self.referalField.isFirstResponder) {
        [self.referalField resignFirstResponder];
        return YES;
    }
    
    UIStoryboard *sb =[UIStoryboard storyboardWithName:@"BUDocumentViewer" bundle:nil];
    BUDocumentViewVC *vc = [sb instantiateViewControllerWithIdentifier:@"BUDocumentViewVC"];
    vc.documentName = @"TOS.docx";
    [self.navigationController pushViewController:vc animated:YES];
    
    NSLog(@"Action");
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

static NSString * const reuseIdentifier = @"Cell";
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(100, 80);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dupProducts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BUGoldTabCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BUGoldTabCell" forIndexPath:indexPath];
    
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:[[self.dupProducts objectAtIndex:indexPath.row] priceLocale]];
    NSString *formattedPrice = [numberFormatter stringFromNumber:[[self.dupProducts objectAtIndex:indexPath.row] price]];
    
    NSLog(@"%@", formattedPrice);
    
    cell.goldLabel.text = [[[self.dupProducts objectAtIndex:indexPath.row] localizedTitle] stringByReplacingOccurrencesOfString:@" gold coins" withString:@""];
    cell.priceLabel.text = formattedPrice;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"collectionView willDisplayCell: %ld",(long)indexPath.row);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.referalField.isFirstResponder) {
        [self.referalField resignFirstResponder];
        return;
    }
    
    self.selectedIndexPath = indexPath;
    
    [[PWInAppHelper sharedInstance] buyProduct:[self.dupProducts objectAtIndex:indexPath.row]];
    
    return;
    
    
}

-(IBAction)followUsInInstagram:(id)sender
{
    
    
    if (self.referalField.isFirstResponder) {
        [self.referalField resignFirstResponder];
        return;
    }
    
    if (self.instagramFollowDone == YES) {
        [self showAlert:@"You already followed us on Instagram"];
        return;
    }
    
    //    NSString *urlString=[NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/relationship?access_token=%@",<user id>,<access token>];
    //
    //    NSURL* url = [NSURL URLWithString:urlString];
    //    theRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:1000.0];
    //    NSString *parameters=@"action=follow";
    //    [theRequest setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    //    [theRequest setHTTPMethod:@"POST"];
    
    
    if (![self.instagramEngine isSessionValid])
    {
        IKLoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationViewController"];
        loginViewController.parentController = self;
        loginViewController.socialType = @"instagram";
        UINavigationController *navCtr = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        
        [self presentViewController:navCtr animated:YES completion:nil];
    }
    else
    {
        
        [self.instagramEngine logout];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"InstagramKit" message:@"You are now logged out." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"Cancelled");
            break;
        case MessageComposeResultFailed:
            NSLog(@"unknown error sending m");
            break;
        case MessageComposeResultSent:
            NSLog(@"Message sent successfully");
            
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(IBAction)inviteFriend:(id)sender
{
    
    
    //    UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:@"Invite a Friend"  message:nil  preferredStyle:UIAlertControllerStyleActionSheet];
    //    [alertController addAction:[UIAlertAction actionWithTitle:@"SMS" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    //        if ([MFMessageComposeViewController canSendText])
    //        {
    //            MFMessageComposeViewController *messageVC = [[MFMessageComposeViewController alloc] init];
    //
    //            NSString *refCode = [BUWebServicesManager sharedManager].referalCode;
    //
    //            messageVC.body = [NSString stringWithFormat: @"Hi, Use my referal code : %@ to signup and get 500 Gold Coins. Click https://itunes.apple.com/us/app/thebureau/id1036009141?ls=1&mt=8 to download the TheBureau App.",refCode];
    //            //    messageVC.recipients = @[@"+31646204287"];
    //            messageVC.messageComposeDelegate = self;
    //            [self presentViewController:messageVC animated:NO completion:NULL];
    //        }
    //        else
    //        {
    //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message Failure"
    //                                                            message:@"Your device doesn't support in-app message"
    //                                                           delegate:nil
    //                                                  cancelButtonTitle:@"OK"
    //                                                  otherButtonTitles:nil];
    //            [alert show];
    //        }
    //    }]];
    //    [alertController addAction:[UIAlertAction actionWithTitle:@"Email" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    //        if ([MFMailComposeViewController canSendMail])
    //        {
    //            MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    //
    //            mailer.mailComposeDelegate = self;
    //
    //            [mailer setSubject:@"Check out TheBureau App"];
    //
    //            NSMutableString *emailBody = [NSMutableString string];
    //
    //            NSString *refCode = [BUWebServicesManager sharedManager].referalCode;
    //
    //            [emailBody appendString:[NSString stringWithFormat: @"Hi, Use my referal code : <b>%@</b> to signup and get 500 Gold Coins. <a href='https://itunes.apple.com/us/app/thebureau/id1036009141?ls=1&mt=8'>Click here</a> to download the TheBureau App.",refCode]];
    //
    //            [mailer setMessageBody:emailBody isHTML:YES];
    //
    //            [self.navigationController presentViewController:mailer animated:YES completion:^{}];
    //
    //        }
    //        else
    //        {
    //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mail Failure"
    //                                                            message:@"Your device doesn't support in-app email"
    //                                                           delegate:nil
    //                                                  cancelButtonTitle:@"OK"
    //                                                  otherButtonTitles:nil];
    //            [alert show];
    //        }
    //    }]];
    //    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    //
    //    }]];
    //    [self presentViewController:alertController animated:YES completion:nil];
    
    if (self.referalField.isFirstResponder) {
        [self.referalField resignFirstResponder];
        return;
    }
    
    FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
    
    content.appLinkURL = [NSURL URLWithString:@"https://app.cancerlife.com/fb.html"];
    
    [FBSDKAppInviteDialog showFromViewController:self withContent:content delegate:self];
    
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:^{}];
}

/*!
 @abstract Sent to the delegate when the app invite completes without error.
 @param appInviteDialog The FBSDKAppInviteDialog that completed.
 @param results The results from the dialog.  This may be nil or empty.
 */
- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results;
{
    
    //    {
    //        completionGesture = cancel;
    //        didComplete = 1;
    //    }
    
    
    //    {
    //        didComplete = 1;
    //    }
    
    NSLog(@"%@",results);
    
    if (![results isEqual:NULL]&&([[results objectForKey:@"didComplete"] intValue] == 1)&&!([[results objectForKey:@"completionGesture"] isEqualToString:@"Cancel"])) {
        [self updateGold:150 did:@"Earned"];
    }
    
    //
}
/*!
 @abstract Sent to the delegate when the app invite encounters an error.
 @param appInviteDialog The FBSDKAppInviteDialog that completed.
 @param error The error.
 */
- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error;
{
    
    NSLog(@"%@",error);
    
    //[self updateGold:100];
}


-(void)showSuccessMessageWithGold:(NSInteger)purchasedGold
{
    NSInteger gold = [[NSUserDefaults standardUserDefaults] integerForKey:@"purchasedGold"];
    
    
    [[NSUserDefaults standardUserDefaults] setInteger:gold + purchasedGold forKey:@"purchasedGold"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    gold = [[NSUserDefaults standardUserDefaults] integerForKey:@"purchasedGold"];
    
    NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"You have Earned %ld Gold, Your total gold is %ld",(long)purchasedGold,(long)gold]];
    [message addAttribute:NSFontAttributeName
                    value:[UIFont fontWithName:@"comfortaa" size:15]
                    range:NSMakeRange(0, message.length)];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController setValue:message forKey:@"attributedTitle"];
    
    
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                 {
                                     [self updateGold:purchasedGold did:@"Purchased"];
                                     NSLog(@"OK");
                                     self.totalGoldLabel.text = [NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"purchasedGold"]];
                                     
                                     [(BUHomeTabbarController *)[self tabBarController] updateGoldValue:[[NSUserDefaults standardUserDefaults] integerForKey:@"purchasedGold"]];
                                 }];
        
        action;
    })];
    [self presentViewController:alertController  animated:YES completion:nil];
    
}



-(void)updateGold:(NSInteger)purchasedGold did:(NSString*)status
{
    /*
     API to  upload :
     http://app.thebureauapp.com/admin/update_profile_step6
     
     Parameters
     
     userid => user id of user
     years_in_usa => e.g. 0 - 2, 2 - 6
     legal_status => e.g. Citizen/Green Card, Greencard
     
     */
    
    NSDictionary *parameters = nil;
    parameters = @{@"userid": [BUWebServicesManager sharedManager].userID,
                   @"gold_to_add":[NSString stringWithFormat:@"%ld",(long)purchasedGold]
                   };
    
    
    [self startActivityIndicator:YES];
    [[BUWebServicesManager sharedManager]queryServer:parameters
                                             baseURL:@"gold/add"
                                        successBlock:^(id response, NSError *error)
     {
         [self stopActivityIndicator];
         
         
         NSInteger gold = [[NSUserDefaults standardUserDefaults] integerForKey:@"purchasedGold"];
         
         [[NSUserDefaults standardUserDefaults] setInteger:gold + purchasedGold forKey:@"purchasedGold"];
         [[NSUserDefaults standardUserDefaults] synchronize];
         
         gold = [[NSUserDefaults standardUserDefaults] integerForKey:@"purchasedGold"];
         
         NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"You have %@ %ld Gold, Your total gold is %ld",status,(long)purchasedGold,gold]];
         [message addAttribute:NSFontAttributeName
                         value:[UIFont fontWithName:@"comfortaa" size:15]
                         range:NSMakeRange(0, message.length)];
         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
         [alertController setValue:message forKey:@"attributedTitle"];
         
         
         [alertController addAction:({
             UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                 NSLog(@"OK");
                 self.totalGoldLabel.text = [NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"purchasedGold"]];
                 
                 [(BUHomeTabbarController *)[self tabBarController] updateGoldValue:[[NSUserDefaults standardUserDefaults] integerForKey:@"purchasedGold"]];
                 
             }];
             
             action;
         })];
         [self presentViewController:alertController  animated:YES completion:nil];
         
     }
                                        failureBlock:^(id response, NSError *error)
     {
         [self stopActivityIndicator];
         
         if (error.code == NSURLErrorTimedOut) {
             
             [self timeoutError:@"Connection timed out, please try again later"];
         }
         else
         {
             
             [self showFailureAlert];
             
         }
         
         //         NSInteger gold = [[NSUserDefaults standardUserDefaults] integerForKey:@"purchasedGold"];
         //
         //         [[NSUserDefaults standardUserDefaults] setInteger:gold + purchasedGold forKey:@"purchasedGold"];
         //         [[NSUserDefaults standardUserDefaults] synchronize];
         //
         //         gold = [[NSUserDefaults standardUserDefaults] integerForKey:@"purchasedGold"];
         //
         //         NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"You have purchased %ld Gold, Your total gold is %ld",(long)purchasedGold,gold]];
         //         [message addAttribute:NSFontAttributeName
         //                         value:[UIFont fontWithName:@"comfortaa" size:15]
         //                         range:NSMakeRange(0, message.length)];
         //         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
         //         [alertController setValue:message forKey:@"attributedTitle"];
         //
         //
         //         [alertController addAction:({
         //             UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
         //                 NSLog(@"OK");
         //                 self.totalGoldLabel.text = [NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"purchasedGold"]];
         //
         //                 [(BUHomeTabbarController *)[self tabBarController] updateGoldValue:[[NSUserDefaults standardUserDefaults] integerForKey:@"purchasedGold"]];
         //
         //             }];
         //
         //             action;
         //         })];
         //         [self presentViewController:alertController  animated:YES completion:nil];
         
     }];
}


-(IBAction)likeUsOnFB:(id)sender
{
    
    if (self.referalField.isFirstResponder) {
        [self.referalField resignFirstResponder];
        return;
    }
    if (self.fbLikeDone == YES) {
        [self showAlert:@"You already liked us on Facebook"];
        return;
    }
    IKLoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationViewController"];
    loginViewController.parentController = self;
    loginViewController.socialType = @"fb";
    UINavigationController *navCtr = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self presentViewController:navCtr animated:YES completion:nil];
    
    /*    [FBSession openActiveSessionWithAllowLoginUI:NO];
     if ([[FBSession activeSession] isOpen]) {
     // do regular stuff
     } else {
     // segue to loginView
     }
     
     if ([FBSDKAccessToken currentAccessToken]) {
     
     IKLoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationViewController"];
     loginViewController.parentController = self;
     loginViewController.socialType = @"fb";
     UINavigationController *navCtr = [[UINavigationController alloc] initWithRootViewController:loginViewController];
     
     [self presentViewController:navCtr animated:YES completion:nil];
     
     }
     else
     
     {
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:@"Please sign in to your account" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
     [alert show];
     }
     */
    
    
    /*
     
     NSDictionary *parameters = nil;
     parameters = @{@"userid": [BUWebServicesManager sharedManager].userID,
     @"social_media": @"fb"
     };
     [self startActivityIndicator:YES];
     
     
     NSString *baseURl = @"http://app.thebureauapp.com/admin/socialShare";
     
     [[BUWebServicesManager sharedManager] queryServer:parameters
     baseURL:baseURl
     successBlock:^(id response, NSError *error)
     {
     
     
     [self stopActivityIndicator];
     
     NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[response objectForKey:@"response"]]];
     [message addAttribute:NSFontAttributeName
     value:[UIFont fontWithName:@"comfortaa" size:15]
     range:NSMakeRange(0, message.length)];
     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
     [alertController setValue:message forKey:@"attributedTitle"];
     
     [alertController addAction:({
     UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
     {
     
     
     
     
     if ([[response objectForKey:@"msg"] isEqualToString:@"Success"]) {
     self.fbLikeDone = YES;
     }
     //[self startActivityIndicator:YES];
     [self updateGold:50 did:@"Earned"];
     }];
     
     action;
     })];
     
     
     
     [self presentViewController:alertController  animated:YES completion:nil];
     
     
     }
     failureBlock:^(id response, NSError *error) {
     
     [self stopActivityIndicator];
     
     NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"Connectivity Error!"];
     [message addAttribute:NSFontAttributeName
     value:[UIFont fontWithName:@"comfortaa" size:15]
     range:NSMakeRange(0, message.length)];
     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
     [alertController setValue:message forKey:@"attributedTitle"];
     
     [alertController addAction:({
     UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
     {
     
     
     }];
     
     action;
     })];
     
     [self presentViewController:alertController  animated:YES completion:nil];
     
     }];
     
     */
    
    
}


-(void)purchaseSuccess
{
    /*
     API to  upload :
     http://app.thebureauapp.com/admin/update_profile_step6
     
     Parameters
     
     userid => user id of user
     years_in_usa => e.g. 0 - 2, 2 - 6
     legal_status => e.g. Citizen/Green Card, Greencard
     
     */
    
    //NSInteger purchasedGold = 0;
    
    
    //    switch (self.selectedIndexPath.row)
    //    {
    //        case 0:
    //            purchasedGold = 1000;
    //            break;
    //        case 1:
    //            purchasedGold = 100;
    //            break;
    //        case 2:
    //            purchasedGold = 250;
    //            break;
    //        case 3:
    //            purchasedGold = 300;
    //            break;
    //        case 4:
    //            purchasedGold = 500;
    //            break;
    //        case 5:
    //            purchasedGold = 750;
    //            break;
    //
    //        default:
    //            break;
    //    }
    
    
    //    switch (self.selectedIndexPath.row)
    //    {
    //        case 0:
    //            purchasedGold = 140;
    //            break;
    //        case 1:
    //            purchasedGold = 380;
    //            break;
    //        case 2:
    //            purchasedGold = 1000;
    //            break;
    //        default:
    //            break;
    //    }
    
    NSLog(@"%ld",(long)self.selectedIndexPath.row);
    
    NSString *purchasedGold = [[[self.dupProducts objectAtIndex:self.selectedIndexPath.row] localizedTitle] stringByReplacingOccurrencesOfString:@" gold coins" withString:@""];
    
    NSDictionary *parameters = nil;
    parameters = @{@"userid": [BUWebServicesManager sharedManager].userID,
                   @"gold_to_add":purchasedGold
                   };
    
    
    [self startActivityIndicator:YES];
    [[BUWebServicesManager sharedManager]queryServer:parameters
                                             baseURL:@"gold/add"
                                        successBlock:^(id response, NSError *error)
     {
         [self stopActivityIndicator];
         
         
         NSInteger gold = [[NSUserDefaults standardUserDefaults] integerForKey:@"purchasedGold"];
         NSInteger purchasedGold = 0;
         
         
         
         NSLog(@"%ld",(long)self.selectedIndexPath.row);
         
         purchasedGold = [[[[self.dupProducts objectAtIndex:self.selectedIndexPath.row] localizedTitle] stringByReplacingOccurrencesOfString:@" gold coins" withString:@""] intValue];
         
         [[NSUserDefaults standardUserDefaults] setInteger:gold + purchasedGold forKey:@"purchasedGold"];
         [[NSUserDefaults standardUserDefaults] synchronize];
         
         gold = [[NSUserDefaults standardUserDefaults] integerForKey:@"purchasedGold"];
         
         NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"You have purchased %ld Gold, Your total gold is %ld",(long)purchasedGold,gold]];
         [message addAttribute:NSFontAttributeName
                         value:[UIFont fontWithName:@"comfortaa" size:15]
                         range:NSMakeRange(0, message.length)];
         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
         [alertController setValue:message forKey:@"attributedTitle"];
         
         
         [alertController addAction:({
             UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                 NSLog(@"OK");
                 self.totalGoldLabel.text = [NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"purchasedGold"]];
                 
                 [(BUHomeTabbarController *)[self tabBarController] updateGoldValue:[[NSUserDefaults standardUserDefaults] integerForKey:@"purchasedGold"]];
             }];
             
             action;
         })];
         [self presentViewController:alertController  animated:YES completion:nil];
         
     }
                                        failureBlock:^(id response, NSError *error)
     {
         [self stopActivityIndicator];
         [self showFailureAlert];
         
         //         NSInteger gold = [[NSUserDefaults standardUserDefaults] integerForKey:@"purchasedGold"];
         //         NSInteger purchasedGold = 0;
         
         
         //         switch (self.selectedIndexPath.row)
         //         {
         //             case 0:
         //                 purchasedGold = 1000;
         //                 break;
         //             case 1:
         //                 purchasedGold = 750;
         //                 break;
         //             case 2:
         //                 purchasedGold = 500;
         //                 break;
         //             case 3:
         //                 purchasedGold = 100;
         //                 break;
         //
         //             default:
         //                 break;
         //         }
         
         //         switch (self.selectedIndexPath.row)
         //         {
         //             case 0:
         //                 purchasedGold = 1000;
         //                 break;
         //             case 1:
         //                 purchasedGold = 140;
         //                 break;
         //             case 2:
         //                 purchasedGold = 380;
         //                 break;
         //             default:
         //                 break;
         //         }
         //
         //         [[NSUserDefaults standardUserDefaults] setInteger:gold + purchasedGold forKey:@"purchasedGold"];
         //         [[NSUserDefaults standardUserDefaults] synchronize];
         //
         //         gold = [[NSUserDefaults standardUserDefaults] integerForKey:@"purchasedGold"];
         //
         //         NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"You have purchased %ld Gold, Your total gold is %ld",(long)purchasedGold,gold]];
         //         [message addAttribute:NSFontAttributeName
         //                         value:[UIFont fontWithName:@"comfortaa" size:15]
         //                         range:NSMakeRange(0, message.length)];
         //         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
         //         [alertController setValue:message forKey:@"attributedTitle"];
         //
         //
         //         [alertController addAction:({
         //             UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
         //                 NSLog(@"OK");
         //                 self.totalGoldLabel.text = [NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"purchasedGold"]];
         //
         //                 [(BUHomeTabbarController *)[self tabBarController] updateGoldValue:[[NSUserDefaults standardUserDefaults] integerForKey:@"purchasedGold"]];
         //
         //             }];
         //
         //             action;
         //         })];
         //         [self presentViewController:alertController  animated:YES completion:nil];
         
     }];
    
    //         {
    //             [self stopActivityIndicator];
    //
    //             [self showFailureAlert];
    //         }];
    
}

-(void)purchaseFailed {
    
}



-(void)getGoldDetails
{
    
    
    [self startActivityIndicator:YES];
    
    
    NSString *baseURl = [NSString stringWithFormat:@"gold/getGoldAvailable/userid/%@",[BUWebServicesManager sharedManager].userID];
    
    [[BUWebServicesManager sharedManager] getqueryServer:nil
                                                 baseURL:baseURl
                                            successBlock:^(id response, NSError *error)
     {
         
         
         [[NSUserDefaults standardUserDefaults] setInteger:[[response valueForKey:@"gold_available"] intValue] forKey:@"purchasedGold"];
         [[NSUserDefaults standardUserDefaults] synchronize];
         
         self.totalGoldLabel.text = [NSString stringWithFormat:@"%d",[[response valueForKey:@"gold_available"] intValue]];
         
         self.fbLikeDone = [[response valueForKey:@"fb"] intValue] == 1 ? YES : NO;
         
         self.instagramFollowDone = [[response valueForKey:@"instagram"] intValue] == 1 ? YES : NO;
         
         [(BUHomeTabbarController *)[self tabBarController] updateGoldValue:[[response valueForKey:@"gold_available"] intValue]];
         
         [self reload];
     }
                                            failureBlock:^(id response, NSError *error) {
                                                
                                                [self stopActivityIndicator];
                                                
                                                if (error.code == NSURLErrorTimedOut) {
                                                    
                                                    [self showAlert:@"Connection timed out, please try again later"];
                                                }
                                                
                                                else
                                                {
                                                    [self showAlert:@"Connectivity Error!"];
                                                }
                                            }];
}

@end
