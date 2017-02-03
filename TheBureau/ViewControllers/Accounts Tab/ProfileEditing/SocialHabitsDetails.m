//
//  SocialHabitsDetails.m
//  TheBureau
//
//  Created by Ama1's iMac on 01/08/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "SocialHabitsDetails.h"
#import "BUConstants.h"

@interface SocialHabitsDetails ()

@end

@implementation SocialHabitsDetails

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Social Habits";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(editProfileDetails:)];
    
    // Do any additional setup after loading the view.
    [self dietUpdate];
    [self updateSmoking];
    [self updateDrinking];
}

- (IBAction)editProfileDetails:(id)sender
{
    [self.view endEditing:YES];
    [self updateProfile];
    //    [self.profileTableView reloadData];
}

-(void)updateProfile
{
    
    //    [self.profileImageCell saveProfileImages];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    
    //    [parameters addEntriesFromDictionary:self.basicInfoDict];
    //    [parameters addEntriesFromDictionary:self.educationInfo];
    //    [parameters addEntriesFromDictionary:self.occupationInfoDict];
    //    [parameters addEntriesFromDictionary:self.horoscopeDict];
        [parameters addEntriesFromDictionary:self.socialHabitsDict];
    //    [parameters addEntriesFromDictionary:self.legalStatus];
//    [parameters addEntriesFromDictionary:self.heritageDict];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

-(void)updateSmoking
{
    NSString *occupationStr = [self.socialHabitsDict valueForKey:@"smoking"];
    occupationStr = occupationStr == nil ? @"" : occupationStr;
    NSInteger tag = 1;
    if([[self.yesLabel text] containsString:occupationStr])
    {
        tag = 1;
    }
    else
    {
        tag = 0;
    }
    [self updateSmokingForTag:tag];
}

-(void)updateDrinking
{
    NSString *occupationStr = [self.socialHabitsDict valueForKey:@"drinking"];
    occupationStr = occupationStr == nil ? @"" : occupationStr;
    NSInteger tag = 1;
    if([[self.sociallyLabel text] containsString:occupationStr])
    {
        tag = 0;
    }
    else
    {
        tag = 1;
    }
    [self updateDrinkingForTag:tag];
}

-(void)dietUpdate
{
    NSString *occupationStr = [self.socialHabitsDict valueForKey:@"diet"];
    occupationStr = occupationStr == nil ? @"" : occupationStr;
    NSInteger tag = 1;
    
    if([[[_vegetarianBtn titleLabel] text] containsString:occupationStr])
    {
        tag = ButtonTypeVegetarian;
    }
    else if([[[_eegetarianBtn titleLabel] text] containsString:occupationStr])
    {
        tag = ButtonTypeEegetarian;
    }
    else if([[[_nonVegetarianBtn titleLabel] text] containsString:occupationStr])
    {
        tag = ButtonTypeNonvegetarian;
    }
    else if([[[_veganBtn titleLabel] text] containsString:occupationStr])
    {
        tag = ButtonTypeVegan;
    }
    [self updateDietForTag:tag];
}

#pragma mark -
#pragma mark - Social habits

-(void)updateDietForTag:(NSInteger)inTag
{
    UIButton *selectedBtn;
    if (inTag == ButtonTypeVegetarian)
    {
        selectedBtn = _vegetarianBtn;
        [_vegetarianBtn setSelected:YES];
        [_eegetarianBtn setSelected:NO];
        [_nonVegetarianBtn setSelected:NO];
        [_veganBtn setSelected:NO];
    }
    else if (inTag == ButtonTypeEegetarian)
    {
        [_vegetarianBtn setSelected:NO];
        [_eegetarianBtn setSelected:YES];
        [_nonVegetarianBtn setSelected:NO];
        [_veganBtn setSelected:NO];
        selectedBtn = _eegetarianBtn;
    }
    else if (inTag == ButtonTypeNonvegetarian)
    {
        [_vegetarianBtn setSelected:NO];
        [_eegetarianBtn setSelected:NO];
        [_nonVegetarianBtn setSelected:YES];
        [_veganBtn setSelected:NO];
        selectedBtn = _nonVegetarianBtn;
    }
    else
    {
        [_vegetarianBtn setSelected:NO];
        [_eegetarianBtn setSelected:NO];
        [_nonVegetarianBtn setSelected:NO];
        [_veganBtn setSelected:YES];
        selectedBtn = _veganBtn;
    }
    [self.socialHabitsDict setValue:[[selectedBtn titleLabel] text] forKey:@"diet"];
}

-(void)updateDrinkingForTag:(NSInteger)inTag
{
    NSString *switchBtnStr;
    if(1 == inTag)
    {
        _sociallyLabel.textColor = [UIColor lightGrayColor];
        _neverLabel.textColor = [UIColor blackColor];
        switchBtnStr = @"switch_ON";
        [self.socialHabitsDict setValue:[_neverLabel text]
                                 forKey:@"drinking"];
    }
    else
    {
        _sociallyLabel.textColor = [UIColor blackColor];
        _neverLabel.textColor = [UIColor lightGrayColor];
        switchBtnStr = @"switch_OFF";
        [self.socialHabitsDict setValue:[_sociallyLabel text] forKey:@"drinking"];
    }
    [self.drinkingSelectionBtn setBackgroundImage:[UIImage imageNamed:switchBtnStr]
                                         forState:UIControlStateNormal];
}

-(void)updateSmokingForTag:(NSInteger)inTag
{
    NSString *switchBtnStr;
    if(1 == inTag)
    {
        _yesLabel.textColor = [UIColor blackColor];
        _noLabel.textColor = [UIColor lightGrayColor];
        switchBtnStr = @"switch_ON";
        [self.socialHabitsDict setValue:[_yesLabel text] forKey:@"smoking"];
    }
    else
    {
        _yesLabel.textColor = [UIColor lightGrayColor];
        _noLabel.textColor = [UIColor blackColor];
        switchBtnStr = @"switch_OFF";
        [self.socialHabitsDict setValue:[_noLabel text] forKey:@"smoking"];
    }
    [self.smokingSelectionBtn setBackgroundImage:[UIImage imageNamed:switchBtnStr]
                                        forState:UIControlStateNormal];
}

-(IBAction)setDiet:(id)sender
{
    UIButton *setYearBtn = (UIButton *)sender;
    [self updateDietForTag:setYearBtn.tag];
}

-(IBAction)setDrinking:(id)sender
{
    NSString *switchBtnStr;
    if(0 == self.drinkingSelectionBtn.tag)
    {
        _sociallyLabel.textColor = [UIColor lightGrayColor];
        _neverLabel.textColor = [UIColor blackColor];
        switchBtnStr = @"switch_ON";
        self.drinkingSelectionBtn.tag = 1;
        [self.socialHabitsDict setValue:[_neverLabel text]
                                 forKey:@"drinking"];
    }
    else
    {
        self.drinkingSelectionBtn.tag = 0;
        _sociallyLabel.textColor = [UIColor blackColor];
        _neverLabel.textColor = [UIColor lightGrayColor];
        switchBtnStr = @"switch_OFF";
        [self.socialHabitsDict setValue:[_sociallyLabel text] forKey:@"drinking"];
    }
    [self.drinkingSelectionBtn setBackgroundImage:[UIImage imageNamed:switchBtnStr]
                                         forState:UIControlStateNormal];
}

-(IBAction)setSmoking:(id)sender
{
    NSString *switchBtnStr;
    if(0 == self.smokingSelectionBtn.tag)
    {
        _yesLabel.textColor = [UIColor blackColor];
        _noLabel.textColor = [UIColor lightGrayColor];
        switchBtnStr = @"switch_ON";
        self.smokingSelectionBtn.tag = 1;
        [self.socialHabitsDict setValue:[_yesLabel text] forKey:@"smoking"];
    }
    else
    {
        self.smokingSelectionBtn.tag = 0;
        _yesLabel.textColor = [UIColor lightGrayColor];
        _noLabel.textColor = [UIColor blackColor];
        switchBtnStr = @"switch_OFF";
        [self.socialHabitsDict setValue:[_noLabel text] forKey:@"smoking"];
    }
    [self.smokingSelectionBtn setBackgroundImage:[UIImage imageNamed:switchBtnStr]
                                        forState:UIControlStateNormal];
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

@end
