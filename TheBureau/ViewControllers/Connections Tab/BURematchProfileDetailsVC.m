//
//  BURematchProfileDetailsVC.m
//  TheBureau
//
//  Created by Manjunath on 07/03/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BURematchProfileDetailsVC.h"
#import "BUHomeProfileImgPrevCell.h"
#import "BUMatchInfoCell.h"
#import "AFHTTPSessionManager.h"
#import "BUAboutMeCell.h"
@interface BURematchProfileDetailsVC ()
@property(nonatomic, strong) IBOutlet UITableView *imgScrollerTableView;
@property(nonatomic, strong) IBOutlet UIImageView *noProfileImgView;
@property(nonatomic, strong) NSMutableArray *keysList;
@property (nonatomic, assign) Boolean isPressed;

//@property(nonatomic, strong) UIButton *matchBtn,*payBtn;


@end

@implementation BURematchProfileDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imgScrollerTableView.hidden = YES;
    _isPressed = NO;
}


-(void)cookupDataSource
{
    self.imagesList = [[NSMutableArray alloc] initWithArray:[self.datasourceList valueForKey:@"img_url"]];
    
    NSDictionary *respDict = self.datasourceList;
    
    self.keysList = [[NSMutableArray alloc] init];
    
    //    NSString *profileName = [NSString stringWithFormat:@"%@ %@",[respDict valueForKey:@"profile_first_name"],[respDict valueForKey:@"profile_last_name"]];
    
//    [self.datasourceList setValue:[respDict valueForKey:@"created_by"] forKey:@"Profile created by"];
//    [self.keysList addObject:@"Profile created by"];
    /////////////
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
        
//        if ([[respDict valueForKey:@"occupation_student"] isEqualToString:@""]) {
//            [self.datasourceList setValue:@"-" forKey:@"Honors"];
//            [self.keysList addObject:@"Honors"];
//        }else{
//            [self.datasourceList setValue:[respDict valueForKey:@"occupation_student"] forKey:@"Honors"];
//            [self.keysList addObject:@"Honors"];
//        }
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
    
    
    
//        if ([[respDict valueForKey:@"horoscope_dob"] isEqualToString:@""]) {
//            [self.datasourceList setValue:@"-" forKey:@"Date of Birth"];
//        }else{
//            [self.datasourceList setValue:[respDict valueForKey:@"horoscope_dob"] forKey:@"Date of Birth"];
//        }
//        [self.keysList addObject:@"Date of Birth"];
//        // [self.datasourceList setValue:[respDict valueForKey:@"horoscope_dob"] forKey:@"Date of Birth"];
//        
//        if ([[respDict valueForKey:@"horoscope_tob"] isEqualToString:@""]) {
//            [self.datasourceList setValue:@"-" forKey:@"Time of Birth"];
//        }else{
//            [self.datasourceList setValue:[respDict valueForKey:@"horoscope_tob"] forKey:@"Time of Birth"];
//        }
//        [self.keysList addObject:@"Time of Birth"];
//        
//        //                        [self.datasourceList setValue:[respDict valueForKey:@"horoscope_tob"] forKey:@"Time of Birth"];
//        //                        [self.keysList addObject:@"Time of Birth"];
//        if ([[respDict valueForKey:@"horoscope_lob"] isEqualToString:@""]) {
//            [self.datasourceList setValue:@"-" forKey:@"Location of Birth"];
//        }else{
//            [self.datasourceList setValue:[respDict valueForKey:@"horoscope_lob"] forKey:@"Location of Birth"];
//        }
//        //[self.datasourceList setValue:[respDict valueForKey:@"horoscope_lob"] forKey:@"Location of Birth"];
//        [self.keysList addObject:@"Location of Birth"];
    
    
    [self.datasourceList setValue:[respDict valueForKey:@"about_me"] forKey:@"About Me"];
    [self.keysList addObject:@"About Me"];
    

    
    
    ///////////
//    [self.datasourceList setValue:[respDict valueForKey:@"age"] forKey:@"Age"];
//    [self.keysList addObject:@"Age"];
//    
//    [self.datasourceList setValue:[respDict valueForKey:@"location"] forKey:@"Location"];
//    [self.keysList addObject:@"Location"];
//    
//    
//    NSString *height = [NSString stringWithFormat:@"%@' %@\"",[respDict valueForKey:@"height_feet"],[respDict valueForKey:@"height_inch"]];
//    [self.datasourceList setValue:height forKey:@"Height"];
//    [self.keysList addObject:@"Height"];
//    
//    [self.datasourceList setValue:[respDict valueForKey:@"mother_tongue"] forKey:@"Mother Toungue"];
//    [self.keysList addObject:@"Mother Toungue"];
//    
//    [self.datasourceList setValue:[respDict valueForKey:@"religion_name"] forKey:@"Religion"];
//    [self.keysList addObject:@"Religion"];
//    
//    [self.datasourceList setValue:[respDict valueForKey:@"family_origin_name"] forKey:@"Family Origin"];
//    [self.keysList addObject:@"Family Origin"];
//    
//    [self.datasourceList setValue:@"" forKey:@"Specification"];
//    [self.keysList addObject:@"Specification"];
//    
//    [self.datasourceList setValue:[respDict valueForKey:@"highest_education"] forKey:@"Education"];
//    [self.keysList addObject:@"Education"];
//    
//    [self.datasourceList setValue:[respDict valueForKey:@"honors"] forKey:@"Honors"];
//    [self.keysList addObject:@"Honors"];
//
//    [self.datasourceList setValue:[respDict valueForKey:@"major"] forKey:@"Major"];
//    [self.keysList addObject:@"Major"];
//
//    [self.datasourceList setValue:[respDict valueForKey:@"college"] forKey:@"College"];
//    [self.keysList addObject:@"College"];
//
//    [self.datasourceList setValue:[respDict valueForKey:@"graduated_year"] forKey:@"Year"];
//    [self.keysList addObject:@"Year"];
//    
//    [self.datasourceList setValue:[respDict valueForKey:@"employment_status"] forKey:@"Occupation"];
//    [self.keysList addObject:@"Occupation"];
//    
//    [self.datasourceList setValue:[respDict valueForKey:@"company"] forKey:@"Employer"];
//    [self.keysList addObject:@"Employer"];
//
//    [self.datasourceList setValue:[respDict valueForKey:@"diet"] forKey:@"Diet"];
//    [self.keysList addObject:@"Diet"];
//
//    [self.datasourceList setValue:[respDict valueForKey:@"smoking"] forKey:@"Smoking"];
//    [self.keysList addObject:@"Smoking"];
//
//    [self.datasourceList setValue:[respDict valueForKey:@"drinking"] forKey:@"Drinking"];
//    [self.keysList addObject:@"Drinking"];
//
//    [self.datasourceList setValue:[respDict valueForKey:@"years_in_usa"] forKey:@"Years in USA"];
//    [self.keysList addObject:@"Years in USA"];
//
//    [self.datasourceList setValue:[respDict valueForKey:@"legal_status"] forKey:@"Legal Status"];
//    [self.keysList addObject:@"Legal Status"];
//
////    [self.datasourceList setValue:[respDict valueForKey:@"profile_dob"] forKey:@"Date of Birth"];
////    [self.keysList addObject:@"Date of Birth"];
////
////    [self.datasourceList setValue:@"" forKey:@"Time of Birth"];
////    [self.keysList addObject:@"Time of Birth"];
//
//    [self.datasourceList setValue:[respDict valueForKey:@"about_me"] forKey:@"About Me"];
//    [self.keysList addObject:@"About Me"];
    
//    [self.collectionView reloadData];
    [self.imgScrollerTableView reloadData];
    
//    for (int p=0; p<[self.imagesList count]; p++) {
//
//    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    self.imagesList = [[NSMutableArray alloc] initWithArray:[self.datasourceList valueForKey:@"img_url"]];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.noProfileImgView.hidden = YES;
    NSLog(@"Table view size frame: %@",NSStringFromCGRect(self.imgScrollerTableView.bounds));
    self.imgScrollerTableView.hidden = NO;
    [self cookupDataSource];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(0 == indexPath.row)
    {
        return self.view.bounds.size.height - 70;

      //  return self.imgScrollerTableView.frame.size.height;
    }
    
    NSString *key = [self.keysList objectAtIndex:indexPath.row -1];
    
    CGSize constraintSize = {self.view.frame.size.width/2 - 30, 20000};
    
    NSString *string = [self.datasourceList valueForKey:key];
    
    //    string = [string stringByReplacingOccurrencesOfString:@". " withString:@"  "];
    
    CGRect textRect = [string boundingRectWithSize:constraintSize
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Comfortaa-Bold" size:15]}
                                           context:nil];
    
    //    CGSize  neededSize   = [string sizeWithFont:[UIFont fontWithName:@"Comfortaa-Bold" size:15] constrainedToSize:constraintSize  lineBreakMode:NSLineBreakByWordWrapping];
    
    
    //    if ([string rangeOfString:@"dummy text"].location != NSNotFound) {
    //        NSLog(@"string does not contain bla");
    //    }
    return  textRect.size.height <= 20 ? 20 : textRect.size.height;
  //  return  textRect.size.height <= 20 ? ([string isEqualToString:@""] ? 0 : 20) : textRect.size.height;  //[key isEqualToString:@"About Me"] ? neededSize.height : 20;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.keysList.count + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(0 == indexPath.row) {
       // BUHomeProfileImgPrevCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BUHomeProfileImgPrevCell" forIndexPath:indexPath];
        BUHomeProfileImgPrevCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BUHomeProfileImgPrevCell"];
        [cell setImagesListToScroll:self.imagesList];
        [cell setRematchView:self];
        self.matchBtn.hidden = _isPressed;
        self.payBtn.hidden = !_isPressed;

        return cell;
        
    }
    if(self.keysList.count  == indexPath.row)
    {
        BUAboutMeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BUAboutMeCell"];
        NSString *key = [self.keysList objectAtIndex:indexPath.row - 1];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.aboutMeDetailTV.attributedText = [self getAboutMeFormatString:[self.datasourceList valueForKey:key]];
        });
        return cell;

//        BUAboutMeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BUAboutMeCell"];
//        NSString *key = [self.keysList objectAtIndex:indexPath.row - 1];
//        
//        
//        {
//            cell.matchTitleLabel.text = [NSString stringWithFormat:@"    %@",key];
//        }
//        cell.aboutMeDetailTV.text = [NSString stringWithFormat:@"%@",[self.datasourceList valueForKey:key]];
//        return cell;
    }
    else
    {
        BUMatchInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BUMatchInfoCell"];
        NSString *key = [self.keysList objectAtIndex:indexPath.row - 1];
        
        if([key isEqualToString:@"Honors"] || [key isEqualToString:@"Major"] || [key isEqualToString:@"School"] || [key isEqualToString:@"Year"])
        {
            cell.matchTitleLabel.text = [NSString stringWithFormat:@"            %@",key];
        }
        else
        {
            cell.matchTitleLabel.text = [NSString stringWithFormat:@"    %@",key];
        }
        cell.matchDescritionLabel.text = [NSString stringWithFormat:@"    %@",[self.datasourceList valueForKey:key]];
        return cell;
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


-(void)match:(id)sender
{
    [self stopActivityIndicator];
    [self.payBtn setTitle:[self.goldDict objectForKey:@"rematch"] forState:UIControlStateNormal];

//    NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"You have the ability to connect with past matches.  Click on the match to view their profile."];
//    [message addAttribute:NSFontAttributeName
//                    value:[UIFont fontWithName:@"comfortaa" size:15]
//                    range:NSMakeRange(0, message.length)];
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Rematch" message:nil preferredStyle:UIAlertControllerStyleAlert];
//    [alertController setValue:message forKey:@"attributedTitle"];
//    
//    [alertController addAction:({
//        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            NSLog(@"OK");
    self.isPressed = YES;
            self.matchBtn.hidden = YES;
            self.payBtn.hidden = NO;
//        }];
//        
//        action;
//    })];
//    
//    [self presentViewController:alertController  animated:YES completion:nil];
    
}


-(void)payAndMatch:(id)sender
{
    NSDictionary *parameters = nil;
    parameters = @{@"userid1": [BUWebServicesManager sharedManager].userID,
                   @"userid2": [self.datasourceList valueForKey:@"userid"],
                   @"gold_amount":[self.goldDict objectForKey:@"rematch"]
                   };
    
    [self startActivityIndicator:YES];
    [self matchWithparameters:parameters];
    
}
-(void)matchWithparameters:(NSDictionary *)inParams;
{
    [[BUWebServicesManager sharedManager] queryServer:inParams baseURL:@"rematch/rematch" successBlock:^(id responseObject, NSError *error) {
        [self stopActivityIndicator];
        
        if([responseObject valueForKey:@"msg"] != nil && [[responseObject valueForKey:@"msg"] isEqualToString:@"Error"]) {
            [self stopActivityIndicator];
            [self showAlert:[responseObject valueForKey:@"response"]];
            return;
        }
        else {
            NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"Good luck!  Your match has been notified."];
            [message addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName:@"comfortaa" size:15]
                            range:NSMakeRange(0, message.length)];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertController setValue:message forKey:@"attributedTitle"];
            
            [alertController addAction:({
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    NSLog(@"OK");
                    
                    self.payBtn.hidden = YES;
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                
                action;
            })];
            
            [self presentViewController:alertController  animated:YES completion:nil];
        }
        
        NSLog(@"Success: %@", responseObject);
    } failureBlock:^(id response, NSError *error) {
        [self stopActivityIndicator];
        NSLog(@"Error: %@", error);
    }];
}


@end
