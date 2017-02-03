//
//  BUProfileEditingVC.m
//  TheBureau
//
//  Created by Manjunath on 25/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUProfileEditingVC.h"
#import "BUProfileImageCell.h"
#import "BUProfileBasicInfoCell.h"
#import "BUProfileEducationInfoCell.h"
#import "BUProfileOccupationInfoCell.h"
#import "BUProfileLegalStatusInfoCell.h"
#import "BUProfileHeritageInfoCell.h"
#import "BUProfileSocialHabitsInfoCell.h"
#import "BUProfileHoroscopeInfoCell.h"
#import "BUUtilities.h"
#import "BUConstants.h"

#import "HoroscopeDetails.h"
#import "BasicDetailsViewController.h"
#import "ProfileImageDetail.h"
#import "EducationDetails.h"
#import "OccupationDetails.h"
#import "HeritageDetails.h"
#import "SocialHabitsDetails.h"
#import "LegalStatusDetails.h"

@interface BUProfileEditingVC ()
@property(nonatomic) NSInteger selectedRow;


#pragma mark - Account selection
@property (assign, nonatomic) BOOL shouldExpand,isEditing;
@property (assign, nonatomic) NSIndexPath *selectedCellIndex;
@property (assign, nonatomic) BUProfileImageCell *profileImageCell;


@property (strong, nonatomic) NSMutableDictionary *profileImageDict,*basicInfoDict,*educationDict,*occupationDict,*heritageDict,*socialHabitsDict,*horoscopeDict,*legalStatus;



@end

@implementation BUProfileEditingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedRow = -1;
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Profile";
    // Do any additional setup after loading the view.
    self.isEditing = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [self getProfileDetails];
    [super viewWillAppear:animated];
    [BUUtilities removeLogo:self.navigationController];
    //    self.navigationItem.rightBarButtonItem = self.rightBarButton;
    
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(editProfileDetails:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"logo44"] style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboard) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyBoard) name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [BUUtilities setNavBarLogo:self.navigationController image:[UIImage imageNamed:@"logo44"]];
    //    self.navigationItem.rightBarButtonItem = nil;
    
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

//-(IBAction)deleteHoroscope:(id)sender {
//    [self.horoscopeDict setValue:@"" forKey:@"horoscope_path"];
//
//    [self startActivityIndicator:YES];
//    [[BUWebServicesManager sharedManager] deleteHoroscope:@"" successBlock:^(id response, NSError *error)
//     {
//         [self stopActivityIndicator];
//
//         NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[response objectForKey:@"response"]]];
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
//
//             }];
//
//             action;
//         })];
//         //  UIPopoverPresentationController *popoverController = alertController.popoverPresentationController;
//         //  popoverController.sourceView = sender;
//         //   popoverController.sourceRect = [sender bounds];
//         [self presentViewController:alertController  animated:YES completion:nil];
//
//         //         {"msg":"Success","response":"Horoscope Deleted Successfully"}
//         //
//         //         Response on failure:
//         //         {"msg":"Error","response":"Horoscope could not be Deleted"}
//
//         if ([[response objectForKey:@"msg"] isEqualToString:@"Success"]) {
//             [self.horoscopeDict setValue:@"" forKey:@"horoscope_path"];
//         }
//
////         if((nil != [self.horoscopeDict valueForKey:@"horoscope_path"]) && (NO == [[self.horoscopeDict valueForKey:@"horoscope_path"] isEqualToString:@""]))
////         {
////             //[self.uploadBtn setTitle:@"View Horoscope" forState:UIControlStateNormal];
////
////             self.uploadBtn.hidden = YES;
////             self.viewBtn.hidden = NO;
////             self.deleteBtn.hidden = NO;
////
////         }
////         else
////         {
////             //[self.uploadBtn setTitle:@"Upload Horoscope" forState:UIControlStateNormal];
////             self.uploadBtn.hidden = NO;
////             self.viewBtn.hidden = YES;
////             self.deleteBtn.hidden = YES;
////         }
//
//     }
//                                             failureBlock:^(id response, NSError *error)
//     {
//
//         //[self.profileTableView reloadData];
//
//         [self stopActivityIndicator];
//     }];
//}


- (IBAction)editProfileDetails:(id)sender
{
    [self.view endEditing:YES];
    [self updateProfile];
    //    [self.profileTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSLog(@"country is %@ ",[[NSUserDefaults standardUserDefaults]objectForKey:@"isUSCitizen"]);
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"isUSCitizen"]) {
        return 9;
    }
    else {
        return 8;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    switch (indexPath.section)
    {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"BUProfileImageCell"];
            [(BUProfileImageCell *)cell setProfileImageDict:self.profileImageDict];
            self.profileImageCell = (BUProfileImageCell *)cell;
            self.profileImageCell.isProfileCreation = NO;
            break;
        }
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"BUProfileBasicInfoCell"];
            [(BUProfileBasicInfoCell *)cell setDatasource:self.basicInfoDict];
            break;
        }
        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"BUProfileEducationInfoCell"];
            [(BUProfileEducationInfoCell *)cell setDatasource:self.educationDict];
            break;
        }
        case 3:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"BUProfileOccupationInfoCell"];
            [(BUProfileOccupationInfoCell *)cell setDatasource:self.occupationDict];
            break;
        }
        case 4:
        {
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"isUSCitizen"])
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"BUProfileLegalStatusInfoCell"];
                //[(BUProfileLegalStatusInfoCell *)cell setDatasource:self.legalStatus];
                
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"BUProfileHeritageInfoCell"];
                [(BUProfileHeritageInfoCell *)cell setDatasource:self.heritageDict];
            }
            
            break;
        }
        case 5:
        {
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"isUSCitizen"])
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"BUProfileHeritageInfoCell"];
                [(BUProfileHeritageInfoCell *)cell setDatasource:self.heritageDict];
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"BUProfileSocialHabitsInfoCell"];
                [(BUProfileSocialHabitsInfoCell *)cell setDatasource:self.socialHabitsDict];
            }
            
            break;
        }
        case 6:
        {
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"isUSCitizen"])
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"BUProfileSocialHabitsInfoCell"];
                [(BUProfileSocialHabitsInfoCell *)cell setDatasource:self.socialHabitsDict];
            }
            else
            {
                /*cell = [tableView dequeueReusableCellWithIdentifier:@"BUProfileHoroscopeInfoCell"];
                 [(BUProfileHoroscopeInfoCell *)cell setDatasource:self.horoscopeDict];*/
                
                BUProfileHoroscopeInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BUProfileHoroscopeInfoCell"];
                cell.headerLabel.text = @"Horoscope";
                cell.clipsToBounds = YES;
                cell.headerBtn.tag = 7;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setDatasource:self.horoscopeDict];
                return cell;
            }
            
            break;
        }
        case 7:
        {
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"isUSCitizen"])
            {
                //                cell = [tableView dequeueReusableCellWithIdentifier:@"BUProfileHoroscopeInfoCell"];
                //                [(BUProfileHoroscopeInfoCell *)cell setDatasource:self.horoscopeDict];
                BUProfileHoroscopeInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BUProfileHoroscopeInfoCell"];
                cell.headerLabel.text = @"Horoscope";
                cell.clipsToBounds = YES;
                cell.headerBtn.tag = 7;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setDatasource:self.horoscopeDict];
                return cell;
                
            }
            else
            {
                BUProfileHoroscopeInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BUProfileHoroscopeInfoCell"];
                cell.headerLabel.text = @"About Me";
                cell.clipsToBounds = YES;
                cell.headerBtn.tag = 8;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setDatasource:self.horoscopeDict];
                return cell;
            }
            
            break;
        }
        case 8:
        {
            BUProfileHoroscopeInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BUProfileHoroscopeInfoCell"];
            cell.headerLabel.text = @"About Me";
            cell.clipsToBounds = YES;
            cell.headerBtn.tag = 8;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setDatasource:self.horoscopeDict];
            return cell;
            break;
        }
        default:
            break;
    }
    
    //Clip whatever is out the cell frame
    cell.clipsToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //    [cell.contentView setUserInteractionEnabled:self.isEditing];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat normalHeight = 80;
    CGFloat expandedHeight = 300;
    CGFloat height = 0;
    
    switch (indexPath.section) {
        case 0:
        {
            expandedHeight = 200;
            break;
        }
        case 1:
        {
            expandedHeight = 390;
            break;
        }
        case 2:
        {
            expandedHeight = 380;
            break;
        }
        case 3:
        {
            expandedHeight = 300;
            break;
        }
        case 4:
        {
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"isUSCitizen"])
            {
                expandedHeight = 487;
            }
            else
            {
                expandedHeight = 330;
                
            }
            
            break;
        }
        case 5:
        {
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"isUSCitizen"])
            {
                expandedHeight = 330;
            }
            else
            {
                expandedHeight = 320;
                
            }
            break;
        }
        case 6:
        {
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"isUSCitizen"])
            {
                expandedHeight = 320;
            }
            else
            {
                expandedHeight = 350;
                
            }
            break;
        }
        case 7:
        {
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"isUSCitizen"])
            {
                expandedHeight = 320;
            }
            else
            {
                expandedHeight = 350;
                
            }
            break;
        }
        case 8:
        {
            expandedHeight = 350;
            break;
        }
        default:
            break;
    }
    height =   (self.selectedRow != indexPath.section) ? normalHeight :expandedHeight;
    if(NO == self.shouldExpand)
        height = normalHeight;
    return height;
}


#pragma mark - Table view delegate

-(IBAction)hideShowDetails:(id)inSender {
    NSInteger selectedTag = [inSender tag];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isUSCitizen"])
    {
        if (selectedTag > 3) {
            selectedTag = selectedTag - 1;
        }
    }
    
    switch (selectedTag)
    {
        case 0:
        {
            
            
            UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Accounts" bundle:nil];
            ProfileImageDetail *vc = [sb instantiateViewControllerWithIdentifier:@"ProfileImageDetail"];
            vc.imagesDict = self.profileImageDict;
            [self.navigationController pushViewController:vc animated:YES];
            
            //            cell = [tableView dequeueReusableCellWithIdentifier:@"BUProfileImageCell"];
            //            [(BUProfileImageCell *)cell setProfileImageDict:self.profileImageDict];
            //            self.profileImageCell = (BUProfileImageCell *)cell;
            //            self.profileImageCell.isProfileCreation = NO;
            break;
        }
        case 1:
        {
            
            
            UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Accounts" bundle:nil];
            BasicDetailsViewController *vc = [sb instantiateViewControllerWithIdentifier:@"BasicDetailsViewController"];
            vc.basicInfoDict = self.basicInfoDict;
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case 2:
        {
            
            UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Accounts" bundle:nil];
            EducationDetails *vc = [sb instantiateViewControllerWithIdentifier:@"EducationDetails"];
            vc.educationInfo = self.educationDict;
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case 3:
        {
            
            NSLog(@"%@",self.occupationDict);
            
            UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Accounts" bundle:nil];
            OccupationDetails *vc = [sb instantiateViewControllerWithIdentifier:@"OccupationDetails"];
            vc.occupationInfoDict = self.occupationDict;
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case 4:
        {
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"isUSCitizen"])
            {
                //                cell = [tableView dequeueReusableCellWithIdentifier:@"BUProfileLegalStatusInfoCell"];
                //                [(BUProfileLegalStatusInfoCell *)cell setDatasource:self.legalStatus];
                
                //
                
                UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Accounts" bundle:nil];
                LegalStatusDetails *vc = [sb instantiateViewControllerWithIdentifier:@"LegalStatusDetails"];
                NSLog(@"%@",self.legalStatus);
                vc.legalStausrInfo = self.legalStatus;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            else
            {
                //                cell = [tableView dequeueReusableCellWithIdentifier:@"BUProfileHeritageInfoCell"];
                //                [(BUProfileHeritageInfoCell *)cell setDatasource:self.heritageDict];
                
                //
                
                UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Accounts" bundle:nil];
                HeritageDetails *vc = [sb instantiateViewControllerWithIdentifier:@"HeritageDetails"];
                vc.heritageDict = self.heritageDict;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            
            break;
        }
        case 5:
        {
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"isUSCitizen"])
            {
                //                cell = [tableView dequeueReusableCellWithIdentifier:@"BUProfileHeritageInfoCell"];
                //                [(BUProfileHeritageInfoCell *)cell setDatasource:self.heritageDict];
                
                UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Accounts" bundle:nil];
                HeritageDetails *vc = [sb instantiateViewControllerWithIdentifier:@"HeritageDetails"];
                vc.heritageDict = self.heritageDict;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            else
            {
                
                UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Accounts" bundle:nil];
                SocialHabitsDetails *vc = [sb instantiateViewControllerWithIdentifier:@"SocialHabitsDetails"];
                vc.socialHabitsDict = self.socialHabitsDict;
                [self.navigationController pushViewController:vc animated:YES];
                
                
                //                cell = [tableView dequeueReusableCellWithIdentifier:@"BUProfileSocialHabitsInfoCell"];
                //                [(BUProfileSocialHabitsInfoCell *)cell setDatasource:self.socialHabitsDict];
            }
            
            break;
        }
        case 6:
        {
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"isUSCitizen"])
            {
                //                cell = [tableView dequeueReusableCellWithIdentifier:@"BUProfileSocialHabitsInfoCell"];
                //                [(BUProfileSocialHabitsInfoCell *)cell setDatasource:self.socialHabitsDict];
                
                UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Accounts" bundle:nil];
                SocialHabitsDetails *vc = [sb instantiateViewControllerWithIdentifier:@"SocialHabitsDetails"];
                vc.socialHabitsDict = self.socialHabitsDict;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            else
            {
                UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Accounts" bundle:nil];
                HoroscopeDetails *vc = [sb instantiateViewControllerWithIdentifier:@"HoroscopeDetails"];
                vc.horoscopeDict = self.horoscopeDict;
                vc.isHoroscope = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
            break;
        }
        case 7:
        {
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"isUSCitizen"])
            {
                //                cell = [tableView dequeueReusableCellWithIdentifier:@"BUProfileSocialHabitsInfoCell"];
                //                [(BUProfileSocialHabitsInfoCell *)cell setDatasource:self.socialHabitsDict];
                
                UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Accounts" bundle:nil];
                HoroscopeDetails *vc = [sb instantiateViewControllerWithIdentifier:@"HoroscopeDetails"];
                vc.horoscopeDict = self.horoscopeDict;
                vc.isHoroscope = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            else
            {
                
                UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Accounts" bundle:nil];
                HoroscopeDetails *vc = [sb instantiateViewControllerWithIdentifier:@"HoroscopeDetails"];
                vc.horoscopeDict = self.horoscopeDict;
                vc.isHoroscope = NO;
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 8:
            {
                UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Accounts" bundle:nil];
                HoroscopeDetails *vc = [sb instantiateViewControllerWithIdentifier:@"HoroscopeDetails"];
                vc.horoscopeDict = self.horoscopeDict;
                vc.isHoroscope = NO;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        default:
            break;
            
    }
    
    
    
    //    NSInteger selectedTag = [inSender tag];
    //
    //    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isUSCitizen"])
    //    {
    //        if (selectedTag > 3) {
    //            selectedTag = selectedTag - 1;
    //        }
    //    }
    //
    //    [self.view endEditing:YES];
    //    NSString *imgName = @"";
    //
    //    self.rightBarButton.tag = 0;
    //    imgName = @"ic_edit";
    //    self.isEditing = NO;
    //    self.rightBarButton.image = [UIImage imageNamed:imgName];
    //
    //    if(self.selectedRow == /*[inSender tag]*/selectedTag)
    //    {
    //        self.shouldExpand = !self.shouldExpand;
    //    }
    //    else
    //    {
    //        self.shouldExpand = YES;
    //    }
    //    self.selectedRow = /*[inSender tag]*/selectedTag;
    //    [self.profileTableView beginUpdates];
    //    [self.profileTableView endUpdates];
    //
    //    self.selectedCellIndex = [NSIndexPath indexPathForRow:0 inSection:/*[inSender tag]*/selectedTag];
    //
    //    [self performSelector:@selector(scrollToTop:) withObject:self.selectedCellIndex afterDelay:1.0];
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    [self.view endEditing:YES];
//    NSString *imgName = @"";
//
//    self.rightBarButton.tag = 0;
//    imgName = @"ic_edit";
//    self.isEditing = NO;
//    self.rightBarButton.image = [UIImage imageNamed:imgName];
//
//    if(self.selectedRow == indexPath.section)
//    {
//        self.shouldExpand = !self.shouldExpand;
//    }
//    else
//    {
//        self.shouldExpand = YES;
//    }
//    self.selectedRow = indexPath.section;
//    [self.profileTableView beginUpdates];
//    [self.profileTableView endUpdates];
//
//    self.selectedCellIndex = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
//
//    [self performSelector:@selector(scrollToTop:) withObject:self.selectedCellIndex afterDelay:1.0];
//
//
////    [self.view endEditing:YES];
////    NSString *imgName = @"";
////
////    self.rightBarButton.tag = 0;
////    imgName = @"ic_edit";
////    self.isEditing = NO;
////    self.rightBarButton.image = [UIImage imageNamed:imgName];
////
////    if(self.selectedRow == indexPath.section)
////    {
////        self.shouldExpand = !self.shouldExpand;
////    }
////    else
////    {
////        self.shouldExpand = YES;
////    }
////    self.selectedRow = indexPath.section;
////    [self.profileTableView beginUpdates];
////    [self.profileTableView endUpdates];
////
////   [self performSelector:@selector(scrollToTop:) withObject:indexPath afterDelay:1.0];
////    self.selectedCellIndex = indexPath;
//}


-(void)scrollToTop:(NSIndexPath *)indexPath
{
    [self.profileTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    
    //    [self.profileTableView reloadData];
}


-(void)getProfileDetails
{
    
    /*
     
     
     {
     age = 0;
     college = "MCE ashkjsd";
     company = asjhdjksdd;
     "country_residing" = India;
     "created_by" = Mother;
     "current_zip_code" = 45323437126;
     diet = "Non Vegetarian";
     dob = "2016-01-27";
     drinking = Never;
     email = "test@test.com";
     "employment_status" = Student;
     "family_origin_id" = 3;
     "family_origin_name" = Vaishya;
     "first_name" = aa;
     gender = Male;
     gothra = "gothra tested again";
     "graduated_year" = 2008;
     "height_feet" = 6;
     "height_inch" = 0;
     "highest_education" = "";
     honors = honors;
     "horoscope_path" = "http://app.thebureauapp.com/user_horoscope/8/pdf-sample.pdf";
     id = 54;
     "last_name" = vv;
     latitude = "22.3159047";
     "legal_status" = "<null>";
     location = "<null>";
     longitude = "-97.8549341";
     major = "<null>";
     "maritial_status" = "";
     "mother_tongue" = "<null>";
     "mother_tongue_id" = 0;
     "other_legal_status" = "<null>";
     "phone_number" = 0009898765;
     "position_title" = "<null>";
     "profile_dob" = "1969-12-31";
     "profile_first_name" = "<null>";
     "profile_for" = "<null>";
     "profile_gender" = "";
     "profile_last_name" = "<null>";
     "religion_id" = 0;
     "religion_name" = "<null>";
     smoking = "";
     "specification_id" = 0;
     "user_status" = "";
     userid = 8;
     "years_in_usa" = "<null>";
     }
     
     */
    NSString *urlString = [NSString stringWithFormat:@"profile/readprofiledetails/userid/%@",[BUWebServicesManager sharedManager].userID];
    [self startActivityIndicator:YES];
    [[BUWebServicesManager sharedManager] getqueryServer:nil
                                                 baseURL:urlString
                                            successBlock:^(id response, NSError *error) {
                                                NSDictionary *respDict = response;
                                                self.profileImageDict = [[NSMutableDictionary alloc] init];
                                                [self.profileImageDict setValue:([respDict valueForKey:@"img_url"] != nil && NO == [[respDict valueForKey:@"img_url"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"img_url"] : [respDict valueForKey:@"img_url"] forKey:@"img_url"];
                                                NSLog(@"%@",self.profileImageDict);
                                                
                                                
                                                self.basicInfoDict = [[NSMutableDictionary alloc] init];
                                                
                                                [self.basicInfoDict setValue:([respDict valueForKey:@"profile_first_name"] != nil && NO == [[respDict valueForKey:@"profile_first_name"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"profile_first_name"] : [respDict valueForKey:@"profile_first_name"] forKey:@"profile_first_name"];
                                                
                                                [self.basicInfoDict setValue:([respDict valueForKey:@"profile_dob"] != nil && NO == [[respDict valueForKey:@"profile_dob"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"profile_dob"] : @""  forKey:@"profile_dob"];
                                                
                                                [self.basicInfoDict setValue:([respDict valueForKey:@"profile_gender"] != nil && NO == [[respDict valueForKey:@"profile_gender"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"profile_gender"] : @""  forKey:@"profile_gender"];
                                                
                                                [self.basicInfoDict setValue:([respDict valueForKey:@"current_zip_code"] != nil && NO == [[respDict valueForKey:@"current_zip_code"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@""] : @""  forKey:@"current_zip_code"];
                                                
                                                [self.basicInfoDict setValue:([respDict valueForKey:@"height_feet"] != nil && NO == [[respDict valueForKey:@"height_feet"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"height_feet"] : @""  forKey:@"height_feet"];
                                                
                                                [self.basicInfoDict setValue:([respDict valueForKey:@"height_inch"] != nil && NO == [[respDict valueForKey:@"height_inch"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"height_inch"] : @""  forKey:@"height_inch"];
                                                
                                                [self.basicInfoDict setValue:([respDict valueForKey:@"maritial_status"] != nil && NO == [[respDict valueForKey:@"maritial_status"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"maritial_status"] : @""  forKey:@"maritial_status"];
                                                
                                                
                                                [self.basicInfoDict setValue:([respDict valueForKey:@"current_zip_code"] != nil && NO == [[respDict valueForKey:@"current_zip_code"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"current_zip_code"] : @""  forKey:@"current_zip_code"];
                                                
                                                
                                                
                                                self.educationDict = [[NSMutableDictionary alloc] init];
                                                [self.educationDict setValue:([respDict valueForKey:@"highest_education"] != nil && NO == [[respDict valueForKey:@"highest_education"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"highest_education"] : @""  forKey:@"highest_education"];
                                                
                                                
                                                [self.educationDict setValue:([respDict valueForKey:@"honors"] != nil && NO == [[respDict valueForKey:@"honors"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"honors"] : @""  forKey:@"honors"];
                                                
                                                [self.educationDict setValue:([respDict valueForKey:@"major"] != nil && NO == [[respDict valueForKey:@"major"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"major"] : @""  forKey:@"major"];
                                                
                                                
                                                [self.educationDict setValue:([respDict valueForKey:@"college"] != nil && NO == [[respDict valueForKey:@"college"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"college"] : @""  forKey:@"college"];
                                                
                                                [self.educationDict setValue:([respDict valueForKey:@"graduated_year"] != nil && NO == [[respDict valueForKey:@"graduated_year"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"graduated_year"] : @""  forKey:@"graduated_year"];
                                                
                                                
                                                [self.educationDict setValue:([respDict valueForKey:@"education_second"] != nil && NO == [[respDict valueForKey:@"education_second"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"education_second"] : @""  forKey:@"education_second"];
                                                
                                                
                                                [self.educationDict setValue:([respDict valueForKey:@"honors_second"] != nil && NO == [[respDict valueForKey:@"honors_second"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"honors_second"] : @""  forKey:@"honors_second"];
                                                
                                                [self.educationDict setValue:([respDict valueForKey:@"majors_second"] != nil && NO == [[respDict valueForKey:@"majors_second"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"majors_second"] : @""  forKey:@"majors_second"];
                                                
                                                
                                                [self.educationDict setValue:([respDict valueForKey:@"college_second"] != nil && NO == [[respDict valueForKey:@"college_second"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"college_second"] : @""  forKey:@"college_second"];
                                                
                                                [self.educationDict setValue:([respDict valueForKey:@"graduation_years_second"] != nil && NO == [[respDict valueForKey:@"graduation_years_second"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"graduation_years_second"] : @""  forKey:@"graduation_years_second"];
                                                
                                                
                                                
                                                self.occupationDict = [[NSMutableDictionary alloc] init];
                                                NSString *occupationName = [respDict valueForKey:@"employment_status"];
                                                
                                                [self.occupationDict setValue:([respDict valueForKey:@"employment_status"] != nil && NO == [[respDict valueForKey:@"employment_status"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"employment_status"] : @""  forKey:@"employment_status"];
                                                
                                                
                                                if ([occupationName isEqualToString:@"Employed"]) {
                                                    [self.occupationDict setValue:([respDict valueForKey:@"position_title"] != nil && NO == [[respDict valueForKey:@"position_title"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"position_title"] : @""  forKey:@"position_title"];
                                                    
                                                    
                                                    [self.occupationDict setValue:([respDict valueForKey:@"company"] != nil && NO == [[respDict valueForKey:@"company"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"company"] : @""  forKey:@"company"];
                                                }
                                                if ([occupationName isEqualToString:@"Student"]) {
                                                    [self.occupationDict setValue:([respDict valueForKey:@"occupation_student"] != nil && NO == [[respDict valueForKey:@"occupation_student"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"occupation_student"] : @""  forKey:@"occupation_student"];
                                                }
                                                if ([occupationName isEqualToString:@"Other"]) {
                                                    [self.occupationDict setValue:([respDict valueForKey:@"occupation_other"] != nil && NO == [[respDict valueForKey:@"occupation_other"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"occupation_other"] : @""  forKey:@"occupation_other"];
                                                }
                                                
                                                self.heritageDict = [[NSMutableDictionary alloc] init];
                                                [self.heritageDict setValue:([respDict valueForKey:@"religion_id"] != nil && NO == [[respDict valueForKey:@"religion_id"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"religion_id"] : @""  forKey:@"religion_id"];
                                                
                                                [self.heritageDict setValue:([respDict valueForKey:@"family_origin_name"] != nil && NO == [[respDict valueForKey:@"family_origin_name"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"family_origin_name"] : @""  forKey:@"family_origin_name"];
                                                
                                                [self.heritageDict setValue:([respDict valueForKey:@"gothra"] != nil && NO == [[respDict valueForKey:@"gothra"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"gothra"] : @""  forKey:@"gothra"];
                                                
                                                [self.heritageDict setValue:([respDict valueForKey:@"mother_tongue"] != nil && NO == [[respDict valueForKey:@"mother_tongue"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"mother_tongue"] : @""  forKey:@"mother_tongue"];
                                                
                                                [self.heritageDict setValue:([respDict valueForKey:@"religion_name"] != nil && NO == [[respDict valueForKey:@"religion_name"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"religion_name"] : @""  forKey:@"religion_name"];
                                                
                                                
                                                [self.heritageDict setValue:([respDict valueForKey:@"mother_tongue_id"] != nil && NO == [[respDict valueForKey:@"mother_tongue_id"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"mother_tongue_id"] : @""  forKey:@"mother_tongue_id"];
                                                
                                                [self.heritageDict setValue:([respDict valueForKey:@"family_origin_id"] != nil && NO == [[respDict valueForKey:@"family_origin_id"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"family_origin_id"] : @""  forKey:@"family_origin_id"];
                                                
                                                [self.heritageDict setValue:([respDict valueForKey:@"specification_id"] != nil && NO == [[respDict valueForKey:@"specification_id"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"specification_id"] : @""  forKey:@"specification_id"];
                                                
                                                [self.heritageDict setValue:([respDict valueForKey:@"specification_name"] != nil && NO == [[respDict valueForKey:@"specification_name"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"specification_name"] : @""  forKey:@"specification_name"];
                                                
                                                
                                                self.socialHabitsDict = [[NSMutableDictionary alloc] init];
                                                [self.socialHabitsDict setValue:([respDict valueForKey:@"diet"] != nil && NO == [[respDict valueForKey:@"diet"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"diet"] : @""  forKey:@"diet"];
                                                
                                                [self.socialHabitsDict setValue:([respDict valueForKey:@"drinking"] != nil && NO == [[respDict valueForKey:@"drinking"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"drinking"] : @""  forKey:@"drinking"];
                                                
                                                [self.socialHabitsDict setValue:([respDict valueForKey:@"smoking"] != nil && NO == [[respDict valueForKey:@"smoking"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"smoking"] : @""  forKey:@"smoking"];
                                                
                                                
                                                self.legalStatus = [[NSMutableDictionary alloc] init];
                                                [self.legalStatus setValue:([respDict valueForKey:@"years_in_usa"] != nil && NO == [[respDict valueForKey:@"years_in_usa"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"years_in_usa"] : @""  forKey:@"years_in_usa"];
                                                
                                                NSLog(@"%@",[respDict valueForKey:@"legal_status"]);
                                                
                                                [self.legalStatus setValue:([respDict valueForKey:@"other_legal_status"] != nil && NO == [[respDict valueForKey:@"other_legal_status"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"other_legal_status"] : @""  forKey:@"other_legal_status"];
                                                
                                                [self.legalStatus setValue:([respDict valueForKey:@"legal_status"] != nil && NO == [[respDict valueForKey:@"legal_status"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"legal_status"] : @""  forKey:@"legal_status"];
                                                
                                                NSLog(@"%@",self.legalStatus);
                                                
                                                bool value = [[respDict valueForKey:@"country_residing"] isEqualToString:@"USA"] ? YES : NO;
                                                
                                                [[NSUserDefaults standardUserDefaults] setBool:value forKey:@"isUSCitizen"];
                                                [[NSUserDefaults standardUserDefaults] synchronize];
                                                
                                                
                                                self.horoscopeDict = [[NSMutableDictionary alloc] init];
                                                
                                                [self.horoscopeDict setValue:([respDict valueForKey:@"horoscope_dob"] != nil && NO == [[respDict valueForKey:@"horoscope_dob"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"horoscope_dob"] : @""  forKey:@"horoscope_dob"];
                                                
                                                [self.horoscopeDict setValue:([respDict valueForKey:@"horoscope_tob"] != nil && NO == [[respDict valueForKey:@"horoscope_tob"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"horoscope_tob"] : @""  forKey:@"horoscope_tob"];
                                                
                                                [self.horoscopeDict setValue:([respDict valueForKey:@"horoscope_lob"] != nil && NO == [[respDict valueForKey:@"horoscope_lob"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"horoscope_lob"] : @""  forKey:@"horoscope_lob"];
                                                
                                                [self.horoscopeDict setValue:([respDict valueForKey:@"about_me"] != nil && NO == [[respDict valueForKey:@"about_me"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"about_me"] : @""  forKey:@"about_me"];
                                                
                                                [self.horoscopeDict setValue:([respDict valueForKey:@"horoscope_path"] != nil && NO == [[respDict valueForKey:@"horoscope_path"] isKindOfClass:[NSNull class]]) ?  [respDict valueForKey:@"horoscope_path"] : @""  forKey:@"horoscope_path"];
                                                
                                                [self stopActivityIndicator];
                                                [self.profileTableView reloadData];
                                            }
                                            failureBlock:^(id response, NSError *error)
     {
         
         if (error.code == NSURLErrorTimedOut) {
             
             [self showAlert:@"Connection timed out, please try again later"];
             
         }
         else
         {
             [self showAlert:@"Connectivity Error"];
         }
     }];
    
}


-(void)updateProfile
{
    
    [self.profileImageCell saveProfileImages];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    
    [parameters addEntriesFromDictionary:self.basicInfoDict];
    [parameters addEntriesFromDictionary:self.educationDict];
    [parameters addEntriesFromDictionary:self.occupationDict];
    [parameters addEntriesFromDictionary:self.horoscopeDict];
    [parameters addEntriesFromDictionary:self.socialHabitsDict];
    [parameters addEntriesFromDictionary:self.legalStatus];
    [parameters addEntriesFromDictionary:self.heritageDict];
    [parameters setValue:[BUWebServicesManager sharedManager].userID forKey:@"userid"];
    
    [self startActivityIndicator:YES];
    
    [[BUWebServicesManager sharedManager] queryServer:parameters
                                              baseURL:@"profile/update"
                                         successBlock:^(id response, NSError *error)
     {
         [self stopActivityIndicator];
         
         
         NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"Profile updated"];
         [message addAttribute:NSFontAttributeName
                         value:[UIFont fontWithName:@"comfortaa" size:15]
                         range:NSMakeRange(0, message.length)];
         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
         [alertController setValue:message forKey:@"attributedTitle"];
         
         [alertController addAction:({
             UIAlertAction *action = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                 NSLog(@"OK");
                 [self.navigationController popViewControllerAnimated:YES];
             }];
             
             action;
         })];
         
         [self presentViewController:alertController  animated:YES completion:nil];
         
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

-(void)showKeyboard123
{
    CGFloat constant = 0;
    constant = 216;
    self.tableBottomConstraint.constant = constant;
    [self performSelector:@selector(scrollTable) withObject:nil afterDelay:1.0];
    
}


-(void)scrollTable
{
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"isUSCitizen"])
    {
        [self.profileTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:8] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    else
    {
        [self.profileTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:7] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
    }
    
    
}

-(void)showKeyboard
{
}

-(void)hideKeyBoard
{
    
    CGFloat constant = 0;
    self.tableBottomConstraint.constant = constant;
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"isUSCitizen"])
    {
        [self.profileTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:8] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    else
    {
        [self.profileTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:7] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
    }
}
-(void)hideKeyBoard123
{
    
    CGFloat constant = 0;
    self.tableBottomConstraint.constant = constant;
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"isUSCitizen"])
    {
        [self.profileTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:8] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    else
    {
        [self.profileTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:7] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
    }
    
}
@end
