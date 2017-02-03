//
//  BUHomeViewController.m
//  TheBureau
//
//  Created by Manjunath on 08/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//
#import "BUHomeViewController.h"
#import "BUHomeProfileImgPrevCell.h"
#import "BUMatchInfoCell.h"
#import "BUAboutMeCell.h"
#import "BUCreatedByCell.h"
//#import "AFHTTPSessionManager.h"
#import "Localytics.h"
#import "BUChatContact.h"
#import "AppDelegate.h"
@interface BUHomeViewController ()
@property(nonatomic, strong) NSMutableArray *imagesList;
//@property(nonatomic, strong) IBOutlet UITableView *imgScrollerTableView;
@property(nonatomic, strong) NSMutableDictionary *datasourceList;
@property(nonatomic, strong) NSMutableArray *keysList;

//@property(nonatomic, strong) NSDictionary *datasourceList;

@end

@implementation BUHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //  self.imagesList = [NSMutableArray arrayWithObjects:@"1",@"5",@"4",@"3",@"2", nil];
    self.datasourceList = nil;
    self.imagesList = [NSMutableArray new];
    
    // Do any additional setup after loading the view.
    self.imgScrollerTableView.hidden = YES;
    
    self.profileStatusImgView.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateView:) name:@"updateRoot" object:nil];
    
}


- (void)updateView:(NSNotification *)notification {
    
    [self getMatchMakingfortheDay];
    NSLog(@"heheheheheh");
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isChat == YES) {
        self.title = @"Profile Info";
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
        self.navigationItem.leftBarButtonItem = backButton;
        
    }
    
    self.navigationController.navigationBarHidden = NO;
    
    [self getGoldDetails];
}

-(void)backAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.imagePreview == YES) {
        self.imagePreview = NO;
        return;
    }
    
    self.noProfileImgView.hidden = NO;
    NSLog(@"Table view size frame: %@",NSStringFromCGRect(self.imgScrollerTableView.bounds));
    // self.imgScrollerTableView.hidden = NO;
    self.messageLabel.text = @"";
    self.messageLabel.hidden = YES;
    // [self.imgScrollerTableView reloadData];
    self.imgScrollerTableView.hidden = YES;
    [self getMatchMakingfortheDay];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    
    if((0 == indexPath.row)||([[self.keysList objectAtIndex:indexPath.row -1] isEqualToString:@"Horoscope Image"]))
    {
        // return self.view.frame.size.height;
        return self.view.bounds.size.height - 70;
        //   return self.imgScrollerTableView.frame.size.height;
    }
    if (1 == indexPath.row) {
        return 40;
    }
    
    NSString *key = [self.keysList objectAtIndex:indexPath.row - 1];
    
    if (![[self.datasourceList valueForKey:key] length]) {
        return 0;
    }
    
    //NSString *key = [self.keysList objectAtIndex:indexPath.row];
    
    CGSize constraintSize = {self.view.frame.size.width/2 - 30, 20000};
    
    NSString *string = [self.datasourceList valueForKey:key];
    
    //    string = [string stringByReplacingOccurrencesOfString:@". " withString:@"  "];
    
    CGRect textRect = [string boundingRectWithSize:constraintSize
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Comfortaa-Bold" size:15]}
                                           context:nil];
    if([[self.keysList objectAtIndex:indexPath.row-1] isEqualToString:@"About Me"]) {
        return 200;
    }
    //    CGSize  neededSize   = [string sizeWithFont:[UIFont fontWithName:@"Comfortaa-Bold" size:15] constrainedToSize:constraintSize  lineBreakMode:NSLineBreakByWordWrapping];
    
    
    //    if ([string rangeOfString:@"dummy text"].location != NSNotFound) {
    //        NSLog(@"string does not contain bla");
    //    }
    
    return  textRect.size.height <= 20 ? 20 : textRect.size.height;
    
    //    if(self.keysList.count  == indexPath.row)
    //    {
    //        return 100;
    //    }
    //
    //    return 20;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.keysList.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    if(0 == indexPath.row)
    {
        BUHomeProfileImgPrevCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BUHomeProfileImgPrevCell"];
        [cell setImagesListToScroll:self.imagesList];
        if (self.isChat) {
            [cell setHomeView:self withBool:self.isChat];
        }else{
            [cell setParentView:self];
        }
        //  cell.isChat = self.isChat;
        return cell;
        
    }
    
    if ([[self.keysList objectAtIndex:indexPath.row -1] isEqualToString:@"Horoscope Image"]) {
        BUHomeProfileImgPrevCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BUHomeProfileImgPrevCell"];
        
        if (self.isChat) {
            [cell setHomeView:self withBool:self.isChat];
        }else{
            [cell setParentView:self];
        }
        
        //  [cell addLabel];
        //NSLog(@"%@",)
        [cell setImagesListToScroll:[[NSArray arrayWithObject:[self.datasourceList valueForKey:[self.keysList objectAtIndex:indexPath.row-1]]] mutableCopy]];
        return cell;
    }
    else {
        
        if(1 == indexPath.row) {
            BUCreatedByCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BUCreatedByCell"];
            NSString *key = [self.keysList objectAtIndex:0];
            
            cell.matchDescritionLabel.text = [NSString stringWithFormat:@"Created by: %@",[self.datasourceList valueForKey:key]];
            return cell;
        }
        if([[self.keysList objectAtIndex:indexPath.row-1] isEqualToString:@"About Me"])
        {
            BUAboutMeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BUAboutMeCell"];
            NSString *key = [self.keysList objectAtIndex:indexPath.row - 1];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.aboutMeDetailTV.attributedText = [self getAboutMeFormatString:[self.datasourceList valueForKey:key]];
            });
            return cell;
        }
        else{
            BUMatchInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BUMatchInfoCell"];
            NSString *key = [self.keysList objectAtIndex:indexPath.row - 1];
            
            
            if([key isEqualToString:@"Honors"] || [key isEqualToString:@"Major"] || [key isEqualToString:@"School"] || [key isEqualToString:@"Year"]) {
                cell.matchTitleLabel.text = [NSString stringWithFormat:@"        %@",key];
            }
            else {
                NSLog(@"Key : %@ and indexPath:%d",key, indexPath.row);
                cell.matchTitleLabel.text = [NSString stringWithFormat:@"%@",key];
            }
            cell.matchDescritionLabel.text = [NSString stringWithFormat:@"%@",[self.datasourceList valueForKey:key]];
            return cell;
        }
    }
    return nil;
}
-(NSAttributedString *)getAboutMeFormatString:(NSString *)string1{
    NSString *aboutmeSring = [NSString stringWithFormat:@"About Me         %@",string1];
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:aboutmeSring];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.0;
    
    NSDictionary *dict = @{NSParagraphStyleAttributeName : paragraphStyle};
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:170.0/255.0 green:170/255.0 blue:170.0/255.0 alpha:1.0] range:NSMakeRange(0,8)];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, string.length)];
    [string addAttributes:dict range:NSMakeRange(0, [aboutmeSring length])];
    return string;
}

-(void)getMatchMakingfortheDay
{
    if (self.isChat == YES) {
        
        self.matchBtn.hidden = YES;
        self.passBtn.hidden = YES;
        
        [self startActivityIndicator:YES];
        NSString *baseUrl = [NSString stringWithFormat:@"profile/readprofiledetails/userid/%@",self.participant];
        // http://app.thebureauapp.com/admin/readProfileDetails
        __weak typeof(self) weakSelf = self;
        [[BUWebServicesManager sharedManager] getqueryServer:nil
                                                     baseURL:baseUrl
                                                successBlock:^(id response, NSError *error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [weakSelf stopActivityIndicator];
             });
             
             NSLog(@"%@",response);
             
             if(nil != response)
             {
                 if ([response[@"error_code"] isEqualToString:@"invalid user"]){
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [weakSelf alertUser:response[@"error_code"]];
                     });
                     // [weakSelf getContactDetails];
                 } else
                 {
                     weakSelf.imgScrollerTableView.hidden = NO;
                     weakSelf.noProfileImgView.hidden = YES;
                     weakSelf.messageLabel.hidden = YES;
                     
                     //            weakSelf.datasourceList = respDict ;
                     
                     weakSelf.datasourceList = [[NSMutableDictionary alloc] init];
                     [weakSelf.keysList removeAllObjects];
                     [weakSelf.imagesList removeAllObjects];
                     NSDictionary *respDict  = response;
                     {
                         
                         weakSelf.noProfileImgView.hidden = YES;
                         
                         weakSelf.keysList = [[NSMutableArray alloc] init];
                         weakSelf.matchUserID = [respDict valueForKey:@"userid"];
                         
                         
                         
                         [weakSelf.datasourceList setValue:[respDict valueForKey:@"created_by"] forKey:@"created_by"];
                         [weakSelf.keysList addObject:@"created_by"];
                         
                         NSString *profileName = [NSString stringWithFormat:@"%@",[respDict valueForKey:@"profile_first_name"]]; //,[respDict valueForKey:@"profile_last_name"]
                         
                         [weakSelf.datasourceList setValue:profileName forKey:@"Name"];
                         [weakSelf.keysList addObject:@"Name"];
                         
                         [weakSelf.datasourceList setValue:[respDict valueForKey:@"age"] forKey:@"Age"];
                         [weakSelf.keysList addObject:@"Age"];
                         
                         [weakSelf.datasourceList setValue:[respDict valueForKey:@"location"] forKey:@"Location"];
                         [weakSelf.keysList addObject:@"Location"];
                         
                         
                         NSString *height = [NSString stringWithFormat:@"%@' %@\"",[respDict valueForKey:@"height_feet"],[respDict valueForKey:@"height_inch"]];
                         [weakSelf.datasourceList setValue:height forKey:@"Height"];
                         [weakSelf.keysList addObject:@"Height"];
                         
                         
                         [weakSelf.datasourceList setValue:[respDict valueForKey:@"mother_tongue"] forKey:@"Mother Toungue"];
                         [weakSelf.keysList addObject:@"Mother Toungue"];
                         
                         [weakSelf.datasourceList setValue:[respDict valueForKey:@"religion_name"] forKey:@"Religion"];
                         [weakSelf.keysList addObject:@"Religion"];
                         
                         [weakSelf.datasourceList setValue:[respDict valueForKey:@"family_origin_name"] forKey:@"Family Origin"];
                         [weakSelf.keysList addObject:@"Family Origin"];
                         
                         [weakSelf.datasourceList setValue:[respDict valueForKey:@"gothra"] forKey:@"Gothra"];
                         [weakSelf.keysList addObject:@"Gothra"];
                         
                         [weakSelf.datasourceList setValue:[respDict valueForKey:@"maritial_status"] forKey:@"Marital Status"];
                         [weakSelf.keysList addObject:@"Marital Status"];
                         
                         [weakSelf.datasourceList setValue:@"" forKey:@"Specification"];
                         [weakSelf.keysList addObject:@"Specification"];
                         
                         [weakSelf.datasourceList setValue:[respDict valueForKey:@"highest_education"] forKey:@"Education"];
                         [weakSelf.keysList addObject:@"Education"];
                         
                         if ([[respDict valueForKey:@"honors"] isEqualToString:@""]) {
                             [weakSelf.datasourceList setValue:@"-" forKey:@"Honors"];
                             [weakSelf.keysList addObject:@"Honors"];
                         }else{
                             [weakSelf.datasourceList setValue:[respDict valueForKey:@"honors"] forKey:@"Honors"];
                             [weakSelf.keysList addObject:@"Honors"];
                         }
                         
                         if ([[respDict valueForKey:@"major"] isEqualToString:@""]) {
                             [weakSelf.datasourceList setValue:@"-" forKey:@"Major"];
                             [weakSelf.keysList addObject:@"Major"];
                         }else{
                             [weakSelf.datasourceList setValue:[respDict valueForKey:@"major"] forKey:@"Major"];
                             [weakSelf.keysList addObject:@"Major"];
                         }
                         
                         //                         [weakSelf.datasourceList setValue:[respDict valueForKey:@"major"] forKey:@"Major"];
                         //                         [weakSelf.keysList addObject:@"Major"];
                         
                         if ([[respDict valueForKey:@"college"] isEqualToString:@""]) {
                             [weakSelf.datasourceList setValue:@"-" forKey:@"School"];
                             [weakSelf.keysList addObject:@"School"];
                         }else{
                             [weakSelf.datasourceList setValue:[respDict valueForKey:@"college"] forKey:@"School"];
                             [weakSelf.keysList addObject:@"School"];
                         }
                         
                         
                         //                         [weakSelf.datasourceList setValue:[respDict valueForKey:@"college"] forKey:@"College"];
                         //                         [weakSelf.keysList addObject:@"College"];
                         
                         if ([[respDict valueForKey:@"graduated_year"] isEqualToString:@""]) {
                             [weakSelf.datasourceList setValue:@"-" forKey:@"Year"];
                             [weakSelf.keysList addObject:@"Year"];
                         }else{
                             [weakSelf.datasourceList setValue:[respDict valueForKey:@"graduated_year"] forKey:@"Year"];
                             [weakSelf.keysList addObject:@"Year"];
                         }
                         
                         
                         //                         [weakSelf.datasourceList setValue:[respDict valueForKey:@"graduated_year"] forKey:@"Year"];
                         //                         [weakSelf.keysList addObject:@"Year"];
                         //
                         
                         
                         //                         [weakSelf.datasourceList setValue:[respDict valueForKey:@"education_second"] forKey:@"Secondary Education"];
                         //                         [weakSelf.keysList addObject:@"Secondary Education"];
                         //
                         //                         [weakSelf.datasourceList setValue:[respDict valueForKey:@"honors_second"] forKey:@"Honors "];
                         //                         [weakSelf.keysList addObject:@"Honors "];
                         //
                         //                         [weakSelf.datasourceList setValue:[respDict valueForKey:@"majors_second"] forKey:@"Major "];
                         //                         [weakSelf.keysList addObject:@"Major "];
                         //
                         //                         [weakSelf.datasourceList setValue:[respDict valueForKey:@"college_second"] forKey:@"College "];
                         //                         [weakSelf.keysList addObject:@"College "];
                         //
                         //                         [weakSelf.datasourceList setValue:[respDict valueForKey:@"graduation_years_second"] forKey:@"Year "];
                         //                         [weakSelf.keysList addObject:@"Year "];
                         
                         
                         [weakSelf.datasourceList setValue:[respDict valueForKey:@"employment_status"] forKey:@"Occupation"];
                         [weakSelf.keysList addObject:@"Occupation"];
                         
                         [weakSelf.datasourceList setValue:[respDict valueForKey:@"company"] forKey:@"Employer"];
                         [weakSelf.keysList addObject:@"Employer"];
                         
                         
                         [weakSelf.datasourceList setValue:[respDict valueForKey:@"diet"] forKey:@"Diet"];
                         [weakSelf.keysList addObject:@"Diet"];
                         
                         [weakSelf.datasourceList setValue:[respDict valueForKey:@"smoking"] forKey:@"Smoking"];
                         [weakSelf.keysList addObject:@"Smoking"];
                         
                         [weakSelf.datasourceList setValue:[respDict valueForKey:@"drinking"] forKey:@"Drinking"];
                         [weakSelf.keysList addObject:@"Drinking"];
                         
                         [weakSelf.datasourceList setValue:[respDict valueForKey:@"years_in_usa"] forKey:@"Years in USA"];
                         [weakSelf.keysList addObject:@"Years in USA"];
                         
                         [weakSelf.datasourceList setValue:[respDict valueForKey:@"legal_status"] forKey:@"Legal Status"];
                         [weakSelf.keysList addObject:@"Legal Status"];
                         
                         
                         [weakSelf.datasourceList setValue:[respDict valueForKey:@"horoscope_dob"] forKey:@"Date of Birth"];
                         [weakSelf.keysList addObject:@"Date of Birth"];
                         
                         [weakSelf.datasourceList setValue:[respDict valueForKey:@"horoscope_tob"] forKey:@"Time of Birth"];
                         [weakSelf.keysList addObject:@"Time of Birth"];
                         
                         [weakSelf.datasourceList setValue:[respDict valueForKey:@"horoscope_lob"] forKey:@"Location of Birth"];
                         [weakSelf.keysList addObject:@"Location of Birth"];
                         
                         /*
                          
                          "horoscope_dob" = "";
                          "horoscope_lob" = "";
                          "horoscope_path" = "";
                          "horoscope_tob" = "";
                          
                          */
                         
                         [weakSelf.datasourceList setValue:[respDict valueForKey:@"about_me"] forKey:@"About Me"];
                         [weakSelf.keysList addObject:@"About Me"];
                         
                         if([[respDict valueForKey:@"img_url"] count] > 0)
                         {
                             [weakSelf.imagesList addObjectsFromArray:[respDict valueForKey:@"img_url"]];
                             //[weakSelf.imagesList addObject:[[respDict valueForKey:@"img_url"] firstObject]];
                         }
                         else
                         {
                             [weakSelf.imagesList addObject:@"http://dev.thebureauapp.com/assets/images/user.jpg"];
                         }
                         
                         if (_isChat == YES) {
                             if ([[respDict valueForKey:@"horoscope_path"] length]) {
                                 [weakSelf.datasourceList setObject:[respDict valueForKey:@"horoscope_path"] forKey:@"Horoscope Image"];
                                 [weakSelf.keysList addObject:@"Horoscope Image"];
                             }
                         }
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [weakSelf.imgScrollerTableView reloadData];
                         });
                         //                                                             return;
                         //                                                         }
                         
                         
                         
                     }
                     //            NSDictionary *respDict = respDict ;
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [weakSelf.imgScrollerTableView reloadData];
                     });
                 }
             }
             else
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     weakSelf.flagBtn.hidden = YES;
                     [weakSelf alertUser:nil];
                 });
                 
                 //                                                     NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"Connectivity Error"];
                 //                                                     [message addAttribute:NSFontAttributeName
                 //                                                                     value:[UIFont fontWithName:@"comfortaa" size:15]
                 //                                                                     range:NSMakeRange(0, message.length)];
                 //                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
                 //                                                     [alertController setValue:message forKey:@"attributedTitle"];
                 //                                                     [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
                 //                                                     [self presentViewController:alertController animated:YES completion:nil];
             }
         }
                                                failureBlock:^(id response, NSError *error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [weakSelf stopActivityIndicator];
             });
             
             if (error.code == NSURLErrorTimedOut) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [weakSelf timeoutError:@"Connection timed out, please try again later"];
                 });
             }
             else {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [weakSelf showAlert:@"Connectivity Error"];
                 });
             }
         }];
        
        return;
    }
    
    
    NSDictionary *parameters = nil;
    parameters = @{@"userid": [BUWebServicesManager sharedManager].userID
                   };
    
    //    parameters = @{@"userid": @"152"
    //                   };
    
    NSString *baseUrl = [NSString stringWithFormat:@"match/view/userid/%@",[BUWebServicesManager sharedManager].userID];
    [self startActivityIndicator:YES];
    [[BUWebServicesManager sharedManager] getqueryServer:nil baseURL:baseUrl successBlock:^(id response, NSError *error) {
        [self stopActivityIndicator];
        
        NSLog(@"%@",response);
        
        if([response isKindOfClass:[NSDictionary class]])
        {
            NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:[response valueForKey:@"response"]];
            [message addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName:@"comfortaa-Bold" size:15]
                            range:NSMakeRange(0, message.length)];
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            [style setLineSpacing:10];
            [message addAttribute:NSParagraphStyleAttributeName
                            value:style
                            range:NSMakeRange(0, message.length)];
            
            self.imgScrollerTableView.hidden = YES;
            self.profileStatusImgView.hidden  = YES;
            
            self.messageLabel.hidden = NO;
            self.messageLabel.attributedText = message;
            self.messageLabel.textAlignment = NSTextAlignmentCenter;
            
            //            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
            //            [alertController setValue:message forKey:@"attributedTitle"];            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            //            [self presentViewController:alertController animated:YES completion:nil];
            return;
        }
        if(nil != response && 0 < [response count])
        {
            
            self.noProfileImgView.hidden = YES;
            self.messageLabel.hidden = YES;
            
            //            self.datasourceList = respDict ;
            
            self.datasourceList = [[NSMutableDictionary alloc] init];
            [self.keysList removeAllObjects];
            [self.imagesList removeAllObjects];
            NSDictionary *respDict  = [response firstObject];
            {
                
                self.matchBtn.hidden = NO;
                self.passBtn.hidden = NO;
                self.profileStatusImgView.hidden = NO;
                
                NSString *userAction = [respDict valueForKey:@"user_action"];
                
                if([userAction isKindOfClass:[NSNull class]])
                {
                    self.matchBtn.hidden = NO;
                    self.passBtn.hidden = NO;
                    self.profileStatusImgView.hidden = YES;
                }
                else if([userAction isEqualToString:@"Passed"])
                {
                    self.matchBtn.hidden = YES;
                    self.passBtn.hidden = YES;
                    self.profileStatusImgView.hidden = YES;
                    self.profileStatusImgView.image = [UIImage imageNamed:@"btn_passed"];
                }
                else if([userAction isEqualToString:@"Liked"])
                {
                    self.matchBtn.hidden = YES;
                    self.passBtn.hidden = YES;
                    self.profileStatusImgView.hidden = YES;
                    self.profileStatusImgView.image = [UIImage imageNamed:@"btn_liked"];
                }
                else if([userAction isEqualToString:@"Connected"])
                {
                    self.matchBtn.hidden = YES;
                    self.passBtn.hidden = YES;
                    self.profileStatusImgView.hidden = YES;
                    self.profileStatusImgView.image = [UIImage imageNamed:@"btn_connected"];
                }
                [self.datasourceList setValue:[respDict valueForKey:@"user_action"] forKey:@"UserAction"];
                
                //                else
                {
                    //                    self.noProfileImgView.hidden = YES;
                    
                    self.keysList = [[NSMutableArray alloc] init];
                    self.matchUserID = [respDict valueForKey:@"userid"];
                    
                    [self.datasourceList setValue:[respDict valueForKey:@"created_by"] forKey:@"created_by"];
                    [self.keysList addObject:@"created_by"];
                    
                    NSString *profileName = [NSString stringWithFormat:@"%@",[respDict valueForKey:@"profile_first_name"]]; //,[respDict valueForKey:@"profile_last_name"]
                    
                    [self.datasourceList setValue:profileName forKey:@"Name"];
                    [self.keysList addObject:@"Name"];
                    
                    [self.datasourceList setValue:[respDict valueForKey:@"age"] forKey:@"Age"];
                    [self.keysList addObject:@"Age"];
                    
                    [self.datasourceList setValue:[respDict valueForKey:@"location"] forKey:@"Location"];
                    [self.keysList addObject:@"Location"];
                    
                    
                    NSString *height = [NSString stringWithFormat:@"%@' %@\"",[respDict valueForKey:@"height_feet"],[respDict valueForKey:@"height_inch"]];
                    [self.datasourceList setValue:height forKey:@"Height"];
                    [self.keysList addObject:@"Height"];
                    
                    
                    [self.datasourceList setValue:[respDict valueForKey:@"mother_tongue"] forKey:@"Mother Toungue"];
                    [self.keysList addObject:@"Mother Toungue"];
                    
                    [self.datasourceList setValue:[respDict valueForKey:@"religion_name"] forKey:@"Religion"];
                    [self.keysList addObject:@"Religion"];
                    
                    [self.datasourceList setValue:[respDict valueForKey:@"family_origin_name"] forKey:@"Family Origin"];
                    [self.keysList addObject:@"Family Origin"];
                    
                    //                    [self.datasourceList setValue:[respDict valueForKey:@"gothra"] forKey:@"Gothra"];
                    //                    [self.keysList addObject:@"Gothra"];
                    [self.datasourceList setValue:[respDict valueForKey:@"specification_name"] forKey:@"Specification"];
                    [self.keysList addObject:@"Specification"];
                    [self.datasourceList setValue:[respDict valueForKey:@"maritial_status"] forKey:@"Marital Status"];
                    [self.keysList addObject:@"Marital Status"];
                    
                    
                    
                    [self.datasourceList setValue:[respDict valueForKey:@"highest_education"] forKey:@"Education"];
                    [self.keysList addObject:@"Education"];
                    
                    if ([[respDict valueForKey:@"honors"] isEqualToString:@""]) {
                        [self.datasourceList setValue:@"-" forKey:@"Honors"];
                        [self.keysList addObject:@"Honors"];
                    }else{
                        [self.datasourceList setValue:[respDict valueForKey:@"honors"] forKey:@"Honors"];
                        [self.keysList addObject:@"Honors"];
                    }
                    
                    if ([[respDict valueForKey:@"major"] isEqualToString:@""]) {
                        [self.datasourceList setValue:@"-" forKey:@"Major"];
                        [self.keysList addObject:@"Major"];
                    }else{
                        [self.datasourceList setValue:[respDict valueForKey:@"major"] forKey:@"Major"];
                        [self.keysList addObject:@"Major"];
                    }
                    
                    
                    //                    [self.datasourceList setValue:[respDict valueForKey:@"honors"] forKey:@"Honors"];
                    //                    [self.keysList addObject:@"Honors"];
                    
                    //                    [self.datasourceList setValue:[respDict valueForKey:@"major"] forKey:@"Major"];
                    //                    [self.keysList addObject:@"Major"];
                    if ([[respDict valueForKey:@"college"] isEqualToString:@""]) {
                        [self.datasourceList setValue:@"-" forKey:@"School"];
                        [self.keysList addObject:@"School"];
                    }else{
                        [self.datasourceList setValue:[respDict valueForKey:@"college"] forKey:@"School"];
                        [self.keysList addObject:@"School"];
                    }
                    
                    
                    if ([[respDict valueForKey:@"graduated_year"] isEqualToString:@""]) {
                        [self.datasourceList setValue:@"-" forKey:@"Year"];
                        [self.keysList addObject:@"Year"];
                    }else{
                        [self.datasourceList setValue:[respDict valueForKey:@"graduated_year"] forKey:@"Year"];
                        [self.keysList addObject:@"Year"];
                    }
                    
                    //                    [self.datasourceList setValue:[respDict valueForKey:@"college"] forKey:@"College"];
                    //                    [self.keysList addObject:@"College"];
                    
                    //                    [self.datasourceList setValue:[respDict valueForKey:@"graduated_year"] forKey:@"Year"];
                    //                    [self.keysList addObject:@"Year"];
                    
                    // employee
                    if ([[respDict objectForKey:@"employment_status"] isEqualToString:@"Employed"]) {
                        
                        if ([[respDict valueForKey:@"employment_status"] isEqualToString:@""]) {
                            [self.datasourceList setValue:@"-" forKey:@"Occupation"];
                            [self.keysList addObject:@"Occupation"];
                        }else{
                            [self.datasourceList setValue:[respDict valueForKey:@"employment_status"] forKey:@"Occupation"];
                            [self.keysList addObject:@"Occupation"];
                        }
                        if ([[respDict valueForKey:@"company"] isEqualToString:@""]) {
                            [self.datasourceList setValue:@"-" forKey:@"Employer"];
                            [self.keysList addObject:@"Employer"];
                        }else{
                            [self.datasourceList setValue:[respDict valueForKey:@"company"] forKey:@"Employer"];
                            [self.keysList addObject:@"Employer"];
                        }
                    }
                    //                    [self.datasourceList setValue:[respDict valueForKey:@"education_second"] forKey:@"Secondary Education"];
                    //                    [self.keysList addObject:@"Secondary Education"];
                    //
                    //                    [self.datasourceList setValue:[respDict valueForKey:@"honors_second"] forKey:@"Honors "];
                    //                    [self.keysList addObject:@"Honors "];
                    //
                    //                    [self.datasourceList setValue:[respDict valueForKey:@"majors_second"] forKey:@"Major "];
                    //                    [self.keysList addObject:@"Major "];
                    //
                    //                    [self.datasourceList setValue:[respDict valueForKey:@"college_second"] forKey:@"College "];
                    //                    [self.keysList addObject:@"College "];
                    //
                    //                    [self.datasourceList setValue:[respDict valueForKey:@"graduation_years_second"] forKey:@"Year "];
                    //                    [self.keysList addObject:@"Year "];
                    
                    //may be modified
                    if ([[respDict objectForKey:@"employment_status"] isEqualToString:@"Student"]) {
                        if ([[respDict valueForKey:@"employment_status"] isEqualToString:@""]) {
                            [self.datasourceList setValue:@"-" forKey:@"Occupation"];
                            [self.keysList addObject:@"Occupation"];
                        }else{
                            [self.datasourceList setValue:[respDict valueForKey:@"employment_status"] forKey:@"Occupation"];
                            [self.keysList addObject:@"Occupation"];
                        }
                        
                        //                        if ([[respDict valueForKey:@"occupation_student"] isEqualToString:@""]) {
                        //                            [self.datasourceList setValue:@"-" forKey:@"Honors"];
                        //                            [self.keysList addObject:@"Honors"];
                        //                        }else{
                        //                            [self.datasourceList setValue:[respDict valueForKey:@"occupation_student"] forKey:@"Honors"];
                        //                            [self.keysList addObject:@"Honors"];
                        //                        }
                    }
                    
                    if ([[respDict objectForKey:@"employment_status"] isEqualToString:@"Other"]) {
                        if ([[respDict valueForKey:@"employment_status"] isEqualToString:@""]) {
                            [self.datasourceList setValue:@"-" forKey:@"Occupation"];
                            [self.keysList addObject:@"Occupation"];
                        }else{
                            [self.datasourceList setValue:[respDict valueForKey:@"employment_status"] forKey:@"Occupation"];
                            [self.keysList addObject:@"Occupation"];
                        }
                        if ([[respDict valueForKey:@"occupation_other"] isEqualToString:@""]) {
                            [self.datasourceList setValue:@"-" forKey:@"Other"];
                            [self.keysList addObject:@"Other"];
                        }else{
                            [self.datasourceList setValue:[respDict valueForKey:@"occupation_other"] forKey:@"Other"];
                            [self.keysList addObject:@"Other"];
                        }
                    }
                    
                    if ([[respDict valueForKey:@"diet"] isEqualToString:@""]) {
                        [self.datasourceList setValue:@"-" forKey:@"Diet"];
                    }else{
                        [self.datasourceList setValue:[respDict valueForKey:@"diet"] forKey:@"Diet"];
                    }
                    [self.keysList addObject:@"Diet"];
                    
                    //                    [self.datasourceList setValue:[respDict valueForKey:@"diet"] forKey:@"Diet"];
                    //                    [self.keysList addObject:@"Diet"];
                    
                    if ([[respDict valueForKey:@"smoking"] isEqualToString:@""]) {
                        [self.datasourceList setValue:@"-" forKey:@"Smoking"];
                    }else{
                        [self.datasourceList setValue:[respDict valueForKey:@"smoking"] forKey:@"Smoking"];
                    }
                    [self.keysList addObject:@"Smoking"];
                    
                    //                    [self.datasourceList setValue:[respDict valueForKey:@"smoking"] forKey:@"Smoking"];
                    //                    [self.keysList addObject:@"Smoking"];
                    
                    if ([[respDict valueForKey:@"drinking"] isEqualToString:@""]) {
                        [self.datasourceList setValue:@"-" forKey:@"Drinking"];
                    }else{
                        [self.datasourceList setValue:[respDict valueForKey:@"drinking"] forKey:@"Drinking"];
                    }
                    [self.keysList addObject:@"Drinking"];
                    
                    //                    [self.keysList addObject:@"Smoking"];
                    //                    [self.datasourceList setValue:[respDict valueForKey:@"drinking"] forKey:@"Drinking"];
                    if ([[respDict objectForKey:@"country_residing"] isEqualToString:@"USA"]){
                        if ([[respDict valueForKey:@"years_in_usa"] isEqualToString:@""]) {
                            [self.datasourceList setValue:@"-" forKey:@"Years in USA"];
                        }else{
                            [self.datasourceList setValue:[respDict valueForKey:@"years_in_usa"] forKey:@"Years in USA"];
                        }
                        [self.keysList addObject:@"Years in USA"];
                        
                        
                        if ([[respDict valueForKey:@"legal_status"] isEqualToString:@""]) {
                            [self.datasourceList setValue:@"-" forKey:@"Legal Status"];
                        }else{
                            [self.datasourceList setValue:[respDict valueForKey:@"Legal Status"] forKey:@"Legal Status"];
                        }
                        [self.keysList addObject:@"Legal Status"];
                        //[self.datasourceList setValue:[respDict valueForKey:@"years_in_usa"] forKey:@"Years in USA"];
                        
                        //   [self.datasourceList setValue:[respDict valueForKey:@"legal_status"] forKey:@"Legal Status"];
                    }
                    
                    
                    
                    if ([userAction isEqualToString:@"Connected"]) {
                        if ([[respDict valueForKey:@"horoscope_dob"] isEqualToString:@""]) {
                            [self.datasourceList setValue:@"-" forKey:@"Date of Birth"];
                        }else{
                            [self.datasourceList setValue:[respDict valueForKey:@"horoscope_dob"] forKey:@"Date of Birth"];
                        }
                        [self.keysList addObject:@"Date of Birth"];
                        // [self.datasourceList setValue:[respDict valueForKey:@"horoscope_dob"] forKey:@"Date of Birth"];
                        
                        if ([[respDict valueForKey:@"horoscope_tob"] isEqualToString:@""]) {
                            [self.datasourceList setValue:@"-" forKey:@"Time of Birth"];
                        }else{
                            [self.datasourceList setValue:[respDict valueForKey:@"horoscope_tob"] forKey:@"Time of Birth"];
                        }
                        [self.keysList addObject:@"Time of Birth"];
                        
                        //                        [self.datasourceList setValue:[respDict valueForKey:@"horoscope_tob"] forKey:@"Time of Birth"];
                        //                        [self.keysList addObject:@"Time of Birth"];
                        if ([[respDict valueForKey:@"horoscope_lob"] isEqualToString:@""]) {
                            [self.datasourceList setValue:@"-" forKey:@"Location of Birth"];
                        }else{
                            [self.datasourceList setValue:[respDict valueForKey:@"horoscope_lob"] forKey:@"Location of Birth"];
                        }
                        //[self.datasourceList setValue:[respDict valueForKey:@"horoscope_lob"] forKey:@"Location of Birth"];
                        [self.keysList addObject:@"Location of Birth"];
                    }
                    
                    
                    [self.datasourceList setValue:[respDict valueForKey:@"about_me"] forKey:@"About Me"];
                    [self.keysList addObject:@"About Me"];
                    
                    NSLog(@"%@\n%@",self.keysList,self.datasourceList);
                    
                    
                    if([[respDict valueForKey:@"img_url"] count] > 0) {
                        [self.imagesList addObjectsFromArray:[respDict valueForKey:@"img_url"]];
                        //[self.imagesList addObject:[[respDict valueForKey:@"img_url"] firstObject]];
                    }
                    else {
                        [self.imagesList addObject:@"https://camo.githubusercontent.com/9ba96d7bcaa2481caa19be858a58f180ef236c7b/687474703a2f2f692e696d6775722e636f6d2f7171584a3246442e6a7067"];
                    }
                    
                    
                    //                    if ([userAction isEqualToString:@"Connected"]) {
                    //                        if ([[respDict valueForKey:@"horoscope_path"] length]) {
                    //                            [self.datasourceList setObject:[respDict valueForKey:@"horoscope_path"] forKey:@"Horoscope Image"];
                    //                            [self.keysList addObject:@"Horoscope Image"];
                    //                        }
                    //                    }
                    
                    
                    self.matchBtn.hidden = NO;
                    self.passBtn.hidden = NO;
                    self.profileStatusImgView.hidden = YES;
                    
                    NSString *userAction = [respDict valueForKey:@"user_action"];
                    
                    if([userAction isKindOfClass:[NSNull class]])
                    {
                        self.matchBtn.hidden = NO;
                        self.passBtn.hidden = NO;
                        self.profileStatusImgView.hidden = YES;
                    }
                    else if([userAction isEqualToString:@"Passed"])
                    {
                        self.matchBtn.hidden = YES;
                        self.passBtn.hidden = YES;
                        self.profileStatusImgView.hidden = NO;
                        self.profileStatusImgView.image = [UIImage imageNamed:@"btn_passed"];
                    }
                    else if([userAction isEqualToString:@"Liked"])
                    {
                        self.matchBtn.hidden = YES;
                        self.passBtn.hidden = YES;
                        self.profileStatusImgView.hidden = NO;
                        self.profileStatusImgView.image = [UIImage imageNamed:@"btn_liked"];
                    }
                    
                    else if([userAction isEqualToString:@"Connected"])
                    {
                        self.matchBtn.hidden = YES;
                        self.passBtn.hidden = YES;
                        self.profileStatusImgView.hidden = NO;
                        self.profileStatusImgView.image = [UIImage imageNamed:@"btn_connected"];
                    }
                    
                    
                    self.imgScrollerTableView.hidden = NO;
                    [self.imgScrollerTableView reloadData];
                    return;
                }
                
                
                
            }
            //            NSDictionary *respDict = respDict ;
            
            //   [self.imgScrollerTableView reloadData];
        }
        else
        {
            self.flagBtn.hidden = YES;
            [self alertUser:nil];
            //            NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"Connectivity Error"];
            //            [message addAttribute:NSFontAttributeName
            //                            value:[UIFont fontWithName:@"comfortaa" size:15]
            //                            range:NSMakeRange(0, message.length)];
            //            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
            //            [alertController setValue:message forKey:@"attributedTitle"];
            //            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            //            [self presentViewController:alertController animated:YES completion:nil];
        }
    } failureBlock:^(id response, NSError *error) {
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


-(void)alertUser:(NSString*)errorCode{
    NSString *errorMessage;
    if ([errorCode  isEqual: @"invalid user"]) {
        errorMessage = @"User account has been deleted.";
    }else{
        errorMessage = @"Connectivity Error";
    }
    self.flagBtn.hidden = YES;
    NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:errorMessage];
    [message addAttribute:NSFontAttributeName
                    value:[UIFont fontWithName:@"comfortaa" size:15]
                    range:NSMakeRange(0, message.length)];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController setValue:message forKey:@"attributedTitle"];
    __weak BUHomeViewController *weakself = self;
    if ([errorCode  isEqual: @"invalid user"]) {
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Close"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       // [self getContactDetails];
                                       NSArray *viewControllers = weakself.navigationController.viewControllers;
                                       for (UIViewController *viewController in viewControllers) {
                                           if ([viewController isKindOfClass:[BUHomeTabbarController class]]) {
                                               [weakself.navigationController popToViewController:viewController animated:YES];
                                               return;
                                           }
                                       }
                                   }];
        [alertController addAction:okAction];
    }else{
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
}



-(void)match:(id)sender
{
    
    NSDictionary *parameters = nil;
    parameters = @{@"passed_by": [BUWebServicesManager sharedManager].userID,
                   @"userid_passed":self.matchUserID,
                   @"action_taken": @"Liked"
                   };
    
    
    [self startActivityIndicator:YES];
    [self matchWithparameters:parameters];
    
}

-(void)getContactDetails
{
    
    //    LYRConversation *conversation = [self.layerClient newConversationWithParticipants:[NSSet setWithObjects:@"USER-IDENTIFIER", nil] options:nil error:nil];
    //
    
    [UIAppDelegate.historyList removeAllObjects];
    
    NSString *baseURL = [NSString stringWithFormat:@"chat/view/userid/%@",[BUWebServicesManager sharedManager].userID];
    
    
    //[self startActivityIndicator:YES];
    __weak typeof(self) weakSelf = self;
    [[BUWebServicesManager sharedManager] getqueryServer:nil
                                             baseURL:baseURL
                                        successBlock:^(id response, NSError *error)
     {
         //[self stopActivityIndicator];
         
         NSMutableArray *dArray = [[NSMutableArray alloc]init];
         for (int j=0; j<[response count]; j++) {
             [dArray addObject:[response objectAtIndex:j]];
         }
         
         NSArray *actualChatList = [[NSOrderedSet orderedSetWithArray:dArray] array];
         
         for (int y=0; y<[actualChatList count]; y++) {
             NSDictionary *d = [actualChatList objectAtIndex:y];
             BUChatContact *contact = [[BUChatContact alloc] init];
             contact.userID = [d objectForKey:@"userid"];
             contact.relationShip = [d objectForKey:@"relation"];
             contact.fName = [d objectForKey:@"First Name"];
             contact.imgURL = [d objectForKey:@"img_url"];
             contact.lName = @"";
             contact.configuration = [[d objectForKey:@"chat_notification"] isEqualToString: @"YES"] ? YES : NO;
             contact.isNewmessage = false;
             //             contact.conversation = conversation;
             [UIAppDelegate.historyList addObject:contact];
         }
     }
                                        failureBlock:^(id response, NSError *error)
     {
         //[self stopActivityIndicator];
         if (error.code == NSURLErrorTimedOut) {
             [weakSelf timeoutError:@"Connection timed out, please try again later"];
         }
         else {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [weakSelf showAlert:@"Connectivity Error"];
             });
         }
     }];
}


-(void)matchWithparameters:(NSDictionary *)inParams;
{
    
    NSString *baseURL = @"match/pass_like";
    __weak typeof(self) weakSelf = self;
    [[BUWebServicesManager sharedManager] queryServer:inParams
                                              baseURL:baseURL
                                         successBlock:^(id response, NSError *error) {
                                             [weakSelf stopActivityIndicator];
                                             
                                             if([response valueForKey:@"msg"] != nil && [[response valueForKey:@"msg"] isEqualToString:@"Error"]) {
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     [weakSelf showAlert:[response valueForKey:@"response"]];
                                                 });
                                             }
                                             else {
                                                 NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"localHistory"];
                                                 NSMutableArray *localHistory = data ? [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy] : @[].mutableCopy;
                                                 [localHistory addObject:[response objectForKey:@"data"]];
                                                 NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:localHistory];
                                                 [[NSUserDefaults standardUserDefaults] setObject:data1 forKey:@"localHistory"];
                                                 [[NSUserDefaults standardUserDefaults] synchronize];
                                                 NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"localHistory"]);
                                                 
                                                 ////////////////////////////////////////////
                                                 
                                                 if ([[response valueForKey:@"response"]isEqualToString:@"You have chosen to match with this user. Congratulations and good luck!"]) {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:[response valueForKey:@"response"]];
                                                         [message addAttribute:NSFontAttributeName
                                                                         value:[UIFont fontWithName:@"comfortaa" size:15]
                                                                         range:NSMakeRange(0, message.length)];
                                                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
                                                         [alertController setValue:message forKey:@"attributedTitle"];
                                                         
                                                         [alertController addAction:({
                                                             UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                                                 NSLog(@"OK");
                                                                 
                                                                 weakSelf.matchBtn.hidden = YES;
                                                                 weakSelf.passBtn.hidden = YES;
                                                                 weakSelf.profileStatusImgView.hidden = NO;
                                                                 weakSelf.profileStatusImgView.image = [UIImage imageNamed:@"btn_liked"];
                                                                 
                                                                 [weakSelf getGoldDetails];
                                                                 [weakSelf getMatchMakingfortheDay];
                                                                 
                                                             }];
                                                             action;
                                                         })];
                                                         [weakSelf presentViewController:alertController  animated:YES completion:nil];
                                                     });
                                                 }
                                                 else {
                                                     
                                                     weakSelf.matchBtn.hidden = YES;
                                                     weakSelf.passBtn.hidden = YES;
                                                     weakSelf.profileStatusImgView.hidden = NO;
                                                     weakSelf.profileStatusImgView.image = [UIImage imageNamed:@"btn_liked"];
                                                     
                                                     [weakSelf getGoldDetails];
                                                     [weakSelf getMatchMakingfortheDay];
                                                 }
                                             }
                                             NSLog(@"Success: %@", response);
                                         } failureBlock:^(id response, NSError *error) {
                                             [weakSelf stopActivityIndicator];
                                             if (error.code == NSURLErrorTimedOut) {
                                                 [weakSelf timeoutError:@"Connection timed out, please try again later"];
                                             }
                                             NSLog(@"Error: %@", error);
                                         }];
}

-(void)pass:(id)sender
{
    //pass
    
    /*
     http://app.thebureauapp.com/admin/passMatches
     
     Parameters :
     
     passed_by => user id of the logged in user
     userid_passed => user id of the user that has been passed / skipped
     action_taken => Passed or Liked (Send one of these two options )
     */
    
    NSDictionary *parameters = nil;
    parameters = @{@"passed_by": [BUWebServicesManager sharedManager].userID,
                   @"userid_passed":self.matchUserID,
                   @"action_taken": @"Passed"
                   };
    
    [self startActivityIndicator:YES];
    
    
    
    NSString *baseURL = [NSString stringWithFormat:@"match/pass_like"];
    [[BUWebServicesManager sharedManager] queryServer:parameters baseURL:baseURL successBlock:^(id response, NSError *error) {
        [self stopActivityIndicator];
        
        NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:[response valueForKey:@"response"]];
        [message addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"comfortaa" size:15]
                        range:NSMakeRange(0, message.length)];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController setValue:message forKey:@"attributedTitle"];
        
        [alertController addAction:({
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                self.matchBtn.hidden = YES;
                self.passBtn.hidden = YES;
                self.profileStatusImgView.hidden = NO;
                self.profileStatusImgView.image = [UIImage imageNamed:@"btn_passed"];
                [self getGoldDetails];
                [self getMatchMakingfortheDay];
            }];
            
            action;
        })];
        
        [self presentViewController:alertController  animated:YES completion:nil];
        NSLog(@"Success: %@", response);
    } failureBlock:^(id response, NSError *error) {
            [self stopActivityIndicator];
            if (error.code == NSURLErrorTimedOut) {
                [self timeoutError:@"Connection timed out, please try again later"];
            }
            else {
                [self showFailureAlert];
            }
            NSLog(@"Error: %@", error);
    }];
}


-(void)getGoldDetails
{
    
    //    [self startActivityIndicator:YES];
NSString *baseURl = [NSString stringWithFormat:@"gold/getGoldAvailable/userid/%@",[BUWebServicesManager sharedManager].userID];
    
    [[BUWebServicesManager sharedManager] getqueryServer:nil
                                              baseURL:baseURl
                                         successBlock:^(id response, NSError *error) {
                                             
                                             [[NSUserDefaults standardUserDefaults] setInteger:[[response valueForKey:@"gold_available"] intValue] forKey:@"purchasedGold"];
                                             [[NSUserDefaults standardUserDefaults] synchronize];
                                             
                                             
                                             [(BUHomeTabbarController *)[self tabBarController] updateGoldValue:[[response valueForKey:@"gold_available"] integerValue]];
                                         }
                                         failureBlock:^(id response, NSError *error) {
                                             
                                             
                                             if (error.code == NSURLErrorTimedOut) {
                                                 NSLog(@"Connection Timeout");
                                             }
                                             
                                         }];
    
}

-(IBAction)flagUSer:(id)sender

{
    
    NSString *message = @"You have chosen to flag this user.  Please provide a reason.  Examples are \"offensive language\" or \"inappropriate pictures\".";
    
    UIAlertController *alertControllerK2 = [UIAlertController
                                            alertControllerWithTitle:@"\u00A0"
                                            message:message
                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *K2okAction = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action) {
                                     // access text from text field
                                     NSString *text = ((UITextField *)[alertControllerK2.textFields firstObject]).text;
                                     [self flagWithText:text];
                                     
                                 }];
    [alertControllerK2 addTextFieldWithConfigurationHandler:^(UITextField *K2TextField)
     {
         K2TextField.placeholder = NSLocalizedString(@"Please provide reason", @"Please provide reason");
     }];
    [alertControllerK2 addAction:K2okAction];
    [self presentViewController:alertControllerK2 animated:YES completion:nil];
}


-(void)flagWithText:(NSString *)inText
{
    
    NSDictionary *parameters = nil;
    parameters = @{@"userid": [BUWebServicesManager sharedManager].userID,
                   @"flagged_userid":self.matchUserID,
                   @"reason":inText
                   };
    [self startActivityIndicator:YES];
    
    NSString *baseURl = @"profile/flagUsers";
    
    [[BUWebServicesManager sharedManager] queryServer:parameters
                                              baseURL:baseURl
                                         successBlock:^(id response, NSError *error)
     {
         [self stopActivityIndicator];
         [self showAlert:[response valueForKey:@"response"]];
     }
                                         failureBlock:^(id response, NSError *error)
     {
         [self stopActivityIndicator];
         
         if (error.code == NSURLErrorTimedOut) {
             
             [self showAlert:@"Connection timed out, please try again later"];
             return ;
         }
         
         
         NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"Connectivity Error!"];
         [message addAttribute:NSFontAttributeName
                         value:[UIFont fontWithName:@"comfortaa" size:15]
                         range:NSMakeRange(0, message.length)];
         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
         [alertController setValue:message forKey:@"attributedTitle"];
         
         [alertController addAction:({
             UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                 NSLog(@"OK");
                 self.matchBtn.hidden = YES;
                 self.passBtn.hidden = YES;
                 self.profileStatusImgView.hidden = NO;
                 self.profileStatusImgView.image = [UIImage imageNamed:@"btn_liked"];
             }];
             action;
         })];
         [self presentViewController:alertController  animated:YES completion:nil];
     }];
}

-(void)notifyMethod
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"matchNotification" object:self];
}
-(NSMutableDictionary *)getDataInfoDictionary{
    return self.datasourceList;
}
@end
