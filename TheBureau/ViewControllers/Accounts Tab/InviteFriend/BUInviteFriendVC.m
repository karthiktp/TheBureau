//
//  BUInviteFriendVC.m
//  TheBureau
//
//  Created by Manjunath on 01/03/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUInviteFriendVC.h"
#import "BUProfileImageCell.h"
#import <MessageUI/MessageUI.h>
#import "BUWebServicesManager.h"
@interface BUInviteFriendVC ()<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>

@end

@implementation BUInviteFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Invite a Friend";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"logo44"] style:UIBarButtonItemStylePlain target:nil action:nil];

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



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


#pragma mark - Table view data source



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = nil;
    
    switch (indexPath.section)
    {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"BUProfileImageCell"];
            [(BUProfileImageCell *)cell setProfileImageList:[NSArray array]];
            
            break;
        }
        default:
            break;
    }
    //Clip whatever is out the cell frame
    cell.clipsToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
   
}



- (IBAction)showMailComposerAndSend:(id)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:@"Check out TheBureau App"];
        
        NSMutableString *emailBody = [NSMutableString string];
        
        NSString *refCode = [BUWebServicesManager sharedManager].referalCode;
        
        [emailBody appendString:[NSString stringWithFormat: @"Hi! Join me on TheBureau by downloading the app <a href='https://itunes.apple.com/us/app/thebureau/id1036009141?ls=1&mt=8'>here</a>.  Use my referral code  <b>%@</b>  to sign up and get 150 free gold coins.",refCode]];
    
        [mailer setMessageBody:emailBody isHTML:YES];
        
        [self.navigationController presentViewController:mailer animated:YES completion:^{}];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mail Failure"
                                                        message:@"Please add atleast one mail account to use this feature !!!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:^{}];
}



- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    {
        case MessageComposeResultCancelled:
            NSLog(@"Message was cancelled");
            [self dismissViewControllerAnimated:YES completion:NULL];
            break;
        case MessageComposeResultFailed:
            NSLog(@"Message failed");
            [self dismissViewControllerAnimated:YES completion:NULL];
            break;
        case MessageComposeResultSent:
            NSLog(@"Message was sent");
            [self dismissViewControllerAnimated:YES completion:NULL];
            break;
        default:
            break;
    }
}


- (IBAction)sendMessage:(id)sender
{
    if ([MFMessageComposeViewController canSendText])
    {
        MFMessageComposeViewController *messageVC = [[MFMessageComposeViewController alloc] init];
        
        NSString *refCode = [BUWebServicesManager sharedManager].referalCode;
        
        messageVC.body = [NSString stringWithFormat: @"Hi! Join me on TheBureau by downloading the app here:\"https://itunes.apple.com/us/app/thebureau/id1036009141?ls=1&mt=8\".  Use my referral code - %@ to sign up and get 150 free gold coins.",refCode];
        //    messageVC.recipients = @[@"+31646204287"];
        messageVC.messageComposeDelegate = self;
        [self presentViewController:messageVC animated:NO completion:NULL];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message Failure"
                                                        message:@"Your device doesn't support in-app message"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }

    
}
@end
