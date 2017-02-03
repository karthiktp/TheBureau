//
//  BUConfigurationVC.m
//  TheBureau
//
//  Created by Manjunath on 01/03/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUConfigurationVC.h"
#import "UIColor+APColor.h"
#import "BUAppNotificationCell.h"
#import "BUUtilities.h"
#import "BUDocumentViewVC.h"
#define APP_URL_STRING  @"https://itunes.apple.com/us/app/thebureau/id1036009141?ls=1&mt=8"
@interface BUConfigurationVC ()


@end

@implementation BUConfigurationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Configuration";
    [self getAppStoreLinks];
}

- (void) getAppStoreLinks {
    
    _productID = [[NSUserDefaults standardUserDefaults] objectForKey:@"productID"]; //NSNumber instance variable
    _appStoreReviewLink = [[NSUserDefaults standardUserDefaults] objectForKey:@"appStoreReviewLink"]; //NSString instance variable
    _appStoreLink = [[NSUserDefaults standardUserDefaults] objectForKey:@"appStoreLink"]; //NSString instance variable
    
    if (!_productID || !_appStoreReviewLink || !_appStoreLink) {
        NSString *iTunesServiceURL = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?bundleId=%@", [NSBundle mainBundle].bundleIdentifier];
        NSURLSession *sharedSes = [NSURLSession sharedSession];
        [[sharedSes dataTaskWithURL:[NSURL URLWithString:iTunesServiceURL]
                  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                      
                      NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
                      
                      if (data && statusCode == 200) {
                          
                          id json = [[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions)0 error:nil][@"results"] lastObject];
                          
                          //productID should be NSNumber but integerValue also work with NSString
                          _productID = json[@"trackId"];
                          
                          if (_productID) {
                              _appStoreReviewLink = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%ld&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8",(long)_productID.integerValue];
                              _appStoreLink = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%ld",(long)_productID.integerValue];
                              
                              [[NSUserDefaults standardUserDefaults] setObject:_productID forKey:@"productID"];
                              [[NSUserDefaults standardUserDefaults] setObject:_appStoreReviewLink forKey:@"appStoreReviewLink"];
                              [[NSUserDefaults standardUserDefaults] setObject:_appStoreLink forKey:@"appStoreLink"];
                              
                          }
                      } else if (statusCode >= 400) {
                          NSLog(@"Error:%@",error.description);
                      }
                  }
          ] resume];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [BUUtilities removeLogo:self.navigationController];
    //    self.navigationItem.rightBarButtonItem = self.rightBarButton;
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"logo44"] style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [BUUtilities setNavBarLogo:self.navigationController image:[UIImage imageNamed:@"logo44"]];
//    self.navigationItem.rightBarButtonItem = nil;
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self startActivityIndicator:YES];
    NSString *baseURl = [NSString stringWithFormat:@"configuration/view/userid/%@",[BUWebServicesManager sharedManager].userID];
    
    NSDictionary *parameters = nil;
    parameters = @{@"userid": [BUWebServicesManager sharedManager].userID};
    
    [[BUWebServicesManager sharedManager] getqueryServer:nil
                                              baseURL:baseURl
                                         successBlock:^(id response, NSError *error)
     {
         [self stopActivityIndicator];
         
         if([response valueForKey:@"msg"] != nil && [[response valueForKey:@"msg"] isEqualToString:@"Error"])
         {
             [self stopActivityIndicator];
             [self showFailureAlert:[response valueForKey:@"response"]];
             
             if ([response objectForKey:@"notification"] != nil) {
                 NSDictionary *notif = [[response objectForKey:@"notification"] objectAtIndex:0];
                 
                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"BUAppNotificationCellTypeDailyMatch"];
                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"BUAppNotificationCellTypeChatNotifications"];
                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"BUAppNotificationCellTypeCustomerService"];
                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"BUAppNotificationCellTypeBlogRelease"];
                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"BUAppNotificationCellTypeSounds"];
                 
                 
                 [[NSUserDefaults standardUserDefaults] setBool:[[notif objectForKey:@"daily_match"] isEqualToString:@"Enable"] ? YES : NO forKey:@"BUAppNotificationCellTypeDailyMatch1"];
                 [[NSUserDefaults standardUserDefaults] setBool:[[notif objectForKey:@"chat_notification"] isEqualToString:@"Enable"] ? YES : NO forKey:@"BUAppNotificationCellTypeChatNotifications1"];
                 [[NSUserDefaults standardUserDefaults] setBool:[[notif objectForKey:@"customer_service"] isEqualToString:@"Enable"] ? YES : NO forKey:@"BUAppNotificationCellTypeCustomerService1"];
                 [[NSUserDefaults standardUserDefaults] setBool:[[notif objectForKey:@"blog_release"] isEqualToString:@"Enable"] ? YES : NO forKey:@"BUAppNotificationCellTypeBlogRelease1"];
                 [[NSUserDefaults standardUserDefaults] setBool:[[notif objectForKey:@"sound"] isEqualToString:@"Enable"] ? YES : NO forKey:@"BUAppNotificationCellTypeSounds1"];
                 
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 
                 [self.cell1 updateBtnStatus];
                 [self.cell2 updateBtnStatus];
                 [self.cell3 updateBtnStatus];
                 [self.cell4 updateBtnStatus];
                 [self.cell5 updateBtnStatus];
                 [self.cell6 updateBtnStatus];
                 [self.cell7 updateBtnStatus];
                 
//                 self.cell4.frame = CGRectMake(self.cell4.frame.origin.x, self.cell4.frame.origin.y, self.cell4.frame.size.width, self.cell4.frame.size.height);
//                 
//                 [self.configTable layoutSubviews];
//                 
//                 [self.configTable layoutIfNeeded];
//                 
//                 [self.configTable setNeedsLayout];
                 
                 [self.configTable reloadData];
                 
             }
             
             
         }
         else
         {
             
//             {"configuration":[{"notification_id":"142","userid":"144","daily_match":"YES","chat_notification":"YES","customer_service":"YES","blog_release":"YES","sound":"YES"}],"notification":[{"customer_service":"Disable","blog_release":"Disable","daily_match":"Enable","chat_notification":"Enable","sound":"Enable"}]}
             
             NSDictionary *config = [[response objectForKey:@"configuration"] objectAtIndex:0];
             
             NSDictionary *notif = [[response objectForKey:@"notification"] objectAtIndex:0];
             
             [[NSUserDefaults standardUserDefaults] setBool:[[config objectForKey:@"daily_match"] isEqualToString:@"YES"] ? YES : NO forKey:@"BUAppNotificationCellTypeDailyMatch"];
             [[NSUserDefaults standardUserDefaults] setBool:[[config objectForKey:@"chat_notification"] isEqualToString:@"YES"] ? YES : NO forKey:@"BUAppNotificationCellTypeChatNotifications"];
             [[NSUserDefaults standardUserDefaults] setBool:[[config objectForKey:@"customer_service"] isEqualToString:@"YES"] ? YES : NO forKey:@"BUAppNotificationCellTypeCustomerService"];
             [[NSUserDefaults standardUserDefaults] setBool:[[config objectForKey:@"blog_release"] isEqualToString:@"YES"] ? YES : NO forKey:@"BUAppNotificationCellTypeBlogRelease"];
             [[NSUserDefaults standardUserDefaults] setBool:[[config objectForKey:@"sound"] isEqualToString:@"YES"] ? YES : NO forKey:@"BUAppNotificationCellTypeSounds"];
             
             
             [[NSUserDefaults standardUserDefaults] setBool:[[notif objectForKey:@"daily_match"] isEqualToString:@"Enable"] ? YES : NO forKey:@"BUAppNotificationCellTypeDailyMatch1"];
             [[NSUserDefaults standardUserDefaults] setBool:[[notif objectForKey:@"chat_notification"] isEqualToString:@"Enable"] ? YES : NO forKey:@"BUAppNotificationCellTypeChatNotifications1"];
             [[NSUserDefaults standardUserDefaults] setBool:[[notif objectForKey:@"customer_service"] isEqualToString:@"Enable"] ? YES : NO forKey:@"BUAppNotificationCellTypeCustomerService1"];
             [[NSUserDefaults standardUserDefaults] setBool:[[notif objectForKey:@"blog_release"] isEqualToString:@"Enable"] ? YES : NO forKey:@"BUAppNotificationCellTypeBlogRelease1"];
             [[NSUserDefaults standardUserDefaults] setBool:[[notif objectForKey:@"sound"] isEqualToString:@"Enable"] ? YES : NO forKey:@"BUAppNotificationCellTypeSounds1"];
             
             [[NSUserDefaults standardUserDefaults] synchronize];
             
             [self.cell1 updateBtnStatus];
             [self.cell2 updateBtnStatus];
             [self.cell3 updateBtnStatus];
             [self.cell4 updateBtnStatus];
             [self.cell5 updateBtnStatus];
             [self.cell6 updateBtnStatus];
             [self.cell7 updateBtnStatus];
             
//             self.cell4.frame = CGRectMake(self.cell4.frame.origin.x, self.cell4.frame.origin.y, self.cell4.frame.size.width, self.cell4.frame.size.height);
//             
//             [self.configTable layoutSubviews];
//             
//             [self.configTable layoutIfNeeded];
//             
//             [self.configTable setNeedsLayout];
             
             [self.configTable reloadData];
         }
     }
                                         failureBlock:^(id response, NSError *error)
     {
         [self stopActivityIndicator];
         
         
         if (error.code == NSURLErrorTimedOut) {
             
             [self showFailureAlert:@"Connection timed out, please try again later"];
         }
         else
         {
             [self showFailureAlert:@"Connectivity Error"];
         
         }
     }
     ];
    // http://app.thebureauapp.com/admin/view_notification_ws
    
}

-(void)showFailureAlert:(NSString *)toast
{
    [self stopActivityIndicator];
    NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:toast];
    [message addAttribute:NSFontAttributeName
                    value:[UIFont fontWithName:@"comfortaa" size:15]
                    range:NSMakeRange(0, message.length)];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController setValue:message forKey:@"attributedTitle"];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    if (searchCellShouldBeHidden) //BOOL saying cell should be hidden
//        return 0.0;
//    else
//        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                return [[NSUserDefaults standardUserDefaults] boolForKey:@"BUAppNotificationCellTypeDailyMatch1"] == YES ? [super tableView:tableView heightForRowAtIndexPath:indexPath] : 0;
                break;
            case 1:
                return [[NSUserDefaults standardUserDefaults] boolForKey:@"BUAppNotificationCellTypeChatNotifications1"] == YES ? [super tableView:tableView heightForRowAtIndexPath:indexPath] : 0;
                break;
            case 2:
                return [[NSUserDefaults standardUserDefaults] boolForKey:@"BUAppNotificationCellTypeCustomerService1"] == YES ? [super tableView:tableView heightForRowAtIndexPath:indexPath] : 0;
                break;
            case 3:
                return [[NSUserDefaults standardUserDefaults] boolForKey:@"BUAppNotificationCellTypeBlogRelease1"] == YES ? [super tableView:tableView heightForRowAtIndexPath:indexPath] : 0;
                break;
            case 4:
                return [[NSUserDefaults standardUserDefaults] boolForKey:@"BUAppNotificationCellTypeSounds1"] == YES ? [super tableView:tableView heightForRowAtIndexPath:indexPath] : 0;
                break;
            default:
                return [[NSUserDefaults standardUserDefaults] boolForKey:@"BUAppNotificationCellTypeDailyMatch1"] == YES ? [super tableView:tableView heightForRowAtIndexPath:indexPath] : 0;
                break;
        }
    }
    else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)startActivityIndicator:(BOOL)isWhite {
    _activityIndicatorCount++;
    if (_activityIndicatorCount > 1) {
        return;
    }
    [[[UIApplication sharedApplication].keyWindow viewWithTag:987] removeFromSuperview];
    [self.activityView removeFromSuperview];
    [self.view layoutIfNeeded];
    //    UIView *activityView = [[UIView alloc] initWithFrame:self.view.bounds];
    if (!self.activityView){
        self.activityView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.activityView.tag = 987;
        self.activityView.backgroundColor = [UIColor clearColor];
        self.activityView.alpha = 0.0f;
        //    [self.view addSubview:activityView];
        
        
        UIView *bgView = [[UIView alloc]initWithFrame:self.activityView.bounds];
        bgView.alpha = 0.0f;
        if ( isWhite ){
            [bgView setBackgroundColor:[UIColor XMApplicationColor]];
        }
        else{
            [bgView setBackgroundColor:[UIColor XMApplicationColor]];
        }
        [self.activityView addSubview:bgView];
        
        
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.activityView addSubview:spinner];
        spinner.center = self.activityView.center;
        //    spinner.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        if ( isWhite ){
            [spinner setColor:[UIColor redIndicatorColor]];
        }else{
            [spinner setColor:[UIColor whiteColor]];
        }
        [spinner startAnimating];
        
        [UIView animateWithDuration:0.2 animations:^{
            bgView.alpha = 0.5f;
            self.activityView.alpha = 1;
        }];
    }
    else{
        [UIView animateWithDuration:0.2 animations:^{
            self.activityView.alpha = 1;
        }];
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.activityView];
}

- (void)stopActivityIndicator {
    _activityIndicatorCount--;
    if (_activityIndicatorCount <= 0) {
        _activityIndicatorCount = 0;
        [UIView animateWithDuration:0.2 animations:^{
            self.activityView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.activityView removeFromSuperview];
        }];
    }
}

-(IBAction)rateUs:(id)sender {
    NSString *appStoreReviewLink = _appStoreReviewLink;
    
    NSLog(@"%@",appStoreReviewLink);
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreReviewLink]];
    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: APP_URL_STRING]];
    
}

-(IBAction)showTerms:(id)sender
{
    UIStoryboard *sb =[UIStoryboard storyboardWithName:@"BUDocumentViewer" bundle:nil];
    BUDocumentViewVC *vc = [sb instantiateViewControllerWithIdentifier:@"BUDocumentViewVC"];
    vc.documentName = @"TOS.docx";
    [self.navigationController pushViewController:vc animated:YES];
}
-(IBAction)showPrivacy:(id)sender
{
    UIStoryboard *sb =[UIStoryboard storyboardWithName:@"BUDocumentViewer" bundle:nil];
    BUDocumentViewVC *vc = [sb instantiateViewControllerWithIdentifier:@"BUDocumentViewVC"];
    vc.documentName = @"PrivacyPolicy.docx";
    [self.navigationController pushViewController:vc animated:YES];
}



@end
