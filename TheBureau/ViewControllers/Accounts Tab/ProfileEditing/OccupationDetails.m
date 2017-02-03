//
//  OccupationDetails.m
//  TheBureau
//
//  Created by Ama1's iMac on 01/08/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "OccupationDetails.h"
#import "BUConstants.h"
#define employementHeigt 53;
#define studentheight 29

@interface OccupationDetails ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *employeMentHeigtConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *studentHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherHeightConstraint;
@property (weak, nonatomic) IBOutlet UITextField *studentTextField;
@property (weak, nonatomic) IBOutlet UITextField *otherTextField;
@property (weak, nonatomic) IBOutlet UIView *employeView;
@property (weak, nonatomic) IBOutlet UIView *otherView;
@property (weak, nonatomic) IBOutlet UIView *studentView;

@end

@implementation OccupationDetails

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Occupation";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(editProfileDetails:)];
    
    NSString *occupationStr = [self.occupationInfoDict valueForKey:@"employment_status"];
    
    occupationStr = occupationStr == nil ? @"" : occupationStr;
    EmployementStatus tag = EmployementStatusEmployed;
    
    if([[[self.employedBtn titleLabel] text] containsString:occupationStr])
    {
        tag = EmployementStatusEmployed;
        self.positionTitleTF.text = [self.occupationInfoDict valueForKey:@"position_title"];
        self.companyTF.text = [self.occupationInfoDict valueForKey:@"company"];
        self.studentView.hidden = YES;
        self.employeView.hidden = NO;
        self.otherView.hidden = YES;
        self.studentHeightConstraint.constant = 0.0f;
        self.otherHeightConstraint.constant = 0.0f;
        self.employeMentHeigtConstraint.constant = employementHeigt;
    }
    else if([[[self.unemployedBtn titleLabel] text] containsString:occupationStr])
    {
        tag = EmployementStatusUnEmployed;
        self.studentHeightConstraint.constant = 0.0f;
        self.otherHeightConstraint.constant = 0.0f;
        self.employeMentHeigtConstraint.constant = 0.0f;
        self.studentView.hidden = YES;
        self.employeView.hidden = YES;
        self.otherView.hidden = YES;
    }
    else if([[[self.studentBtn titleLabel] text] containsString:occupationStr])
    {
        tag = EmployementStatusStudent;
        self.studentTextField.text = [self.occupationInfoDict valueForKey:@"occupation_student"];
        self.studentHeightConstraint.constant = studentheight;
        self.otherHeightConstraint.constant = 0.0f;
        self.employeMentHeigtConstraint.constant = 0.0f;
        self.studentView.hidden = NO;
        self.employeView.hidden = YES;
        self.otherView.hidden = YES;
    }
    else
    {
        tag = EmployementStatusOthers;
        self.studentTextField.text = [self.occupationInfoDict valueForKey:@"occupation_other"];
        self.studentHeightConstraint.constant = 0.0f;
        self.otherHeightConstraint.constant = studentheight;
        self.employeMentHeigtConstraint.constant = 0.0f;
        self.studentView.hidden = YES;
        self.employeView.hidden = YES;
        self.otherView.hidden = NO;
    }
    
    self.positionTitleTF.text = [self.occupationInfoDict valueForKey:@"position_title"];
    self.positionTitleTF.tag = 0;
    self.positionTitleTF.delegate = self;
    self.companyTF.text = [self.occupationInfoDict valueForKey:@"company"];
    self.companyTF.tag = 1;
    self.companyTF.delegate = self;
    if ([self.occupationInfoDict valueForKey:@"occupation_other"] != nil) {
         self.otherTextField.text = [self.occupationInfoDict valueForKey:@"occupation_other"];
    }
    if ([self.occupationInfoDict valueForKey:@"occupation_student"] != nil) {
        self.studentTextField.text = [self.occupationInfoDict valueForKey:@"occupation_student"];
    }
    [self updateOccupation:tag];
    
}

- (IBAction)editProfileDetails:(id)sender {
    [self.view endEditing:YES];
    [self updateProfile];
    //    [self.profileTableView reloadData];
}
-(void)alertMessage:(NSString *)message1{
    NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:message1];
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
-(void)updateProfile
{
    
    //    [self.profileImageCell saveProfileImages];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    NSLog(@"%@",self.occupationInfoDict);
    if ([[self.occupationInfoDict valueForKey:@"employment_status"] isEqualToString:@"Employed"]) {
        [parameters setValue:@"Employed" forKey:@"employment_status"];
        if (self.positionTitleTF.text.length < 1 || self.companyTF.text.length < 1) {
            [self alertMessage:@"Please Enter Valid Occupation Details"];
            return;
        }
        [parameters setValue:self.positionTitleTF.text forKey:@"position_title"];
        [parameters setValue:self.companyTF.text forKey:@"company"];
        [parameters setValue:@"" forKey:@"occupation_student"];
        [parameters setValue:@"" forKey:@"occupation_other"];
    }else if([[self.occupationInfoDict valueForKey:@"employment_status"] isEqualToString:@"Student"]){
        if (self.studentTextField.text.length < 1) {
            [self alertMessage:@"Please enter valid student details"];
            return;
        }
        [parameters setValue:@"Student" forKey:@"employment_status"];
        [parameters setValue:@"" forKey:@"position_title"];
        [parameters setValue:@"" forKey:@"company"];
        [parameters setValue:self.studentTextField.text forKey:@"occupation_student"];
        [parameters setValue:@"" forKey:@"occupation_other"];
    }else if([[self.occupationInfoDict valueForKey:@"employment_status"] isEqualToString:@"Other"]){
        if (self.otherTextField.text.length < 1) {
            [self alertMessage:@"Please enter valid other occupation details"];
            return;
        }
        [parameters setValue:@"Other" forKey:@"employment_status"];
        [parameters setValue:@"" forKey:@"position_title"];
        [parameters setValue:@"" forKey:@"company"];
        [parameters setValue:@"" forKey:@"occupation_student"];
        [parameters setValue:self.otherTextField.text forKey:@"occupation_other"];
        
    }else if ([[self.occupationInfoDict valueForKey:@"employment_status"] isEqualToString:@"Unemployed"]){
        [parameters setValue:@"Unemployed" forKey:@"employment_status"];
        [parameters setValue:@"" forKey:@"position_title"];
        [parameters setValue:@"" forKey:@"company"];
        [parameters setValue:@"" forKey:@"occupation_student"];
        [parameters setValue:@"" forKey:@"occupation_other"];    }
    
    // [parameters addEntriesFromDictionary:self.occupationInfoDict];
    [parameters setValue:[BUWebServicesManager sharedManager].userID forKey:@"userid"];
    
    [self startActivityIndicator:YES];
    
    [[BUWebServicesManager sharedManager] queryServer:parameters
                                              baseURL:@"profile/update"
                                         successBlock:^(id response, NSError *error) {
                                             [self alertMessage:@"Profile updated"];
                                             [self stopActivityIndicator];
                                             
                                         }
                                         failureBlock:^(id response, NSError *error) {
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
    //    if([textField tag] == 0)
    //        [self.occupationInfoDict setValue:self.positionTitleTF.text forKey:@"position_title"];
    //    else
    //        [self.occupationInfoDict setValue:self.companyTF.text forKey:@"company"];
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //    if([textField tag] == 0)
    //        [self.occupationInfoDict setValue:self.positionTitleTF.text forKey:@"position_title"];
    //    else
    //        [self.occupationInfoDict setValue:self.companyTF.text forKey:@"company"];
    [textField resignFirstResponder];
}


#pragma mark -Occupation

- (IBAction)employementStatusButtonTapped:(id)sender
{
    [self updateOccupation:[sender tag]];
}

-(void)updateOccupation:(EmployementStatus)inTag
{
    
    self.positionTitleTF.enabled = YES;
    self.companyTF.enabled = YES;
    
    switch (inTag)
    {
        case EmployementStatusEmployed:
        {
            [self.employedBtn setSelected:YES];
            [self.othersBtn setSelected:NO];
            [self.unemployedBtn setSelected:NO];
            [self.studentBtn setSelected:NO];
            [self.occupationInfoDict setValue:[[[self.employedBtn titleLabel] text] stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"employment_status"];
            [self.positionTitleTF becomeFirstResponder];
            self.studentHeightConstraint.constant = 0.0f;
            self.otherHeightConstraint.constant = 0.0f;
            self.employeMentHeigtConstraint.constant = employementHeigt;
            self.studentTextField.text = @"";
            self.otherTextField.text = @"";
            self.studentView.hidden = YES;
            self.employeView.hidden = NO;
            self.otherView.hidden = YES;
            break;
        }
        case EmployementStatusUnEmployed:
        {
            [self.employedBtn setSelected:NO];
            [self.othersBtn setSelected:NO];
            [self.unemployedBtn setSelected:YES];
            [self.studentBtn setSelected:NO];
            [self.occupationInfoDict setValue:[[[self.unemployedBtn titleLabel] text] stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"employment_status"];
            
            self.positionTitleTF.text = @"";
            self.companyTF.text = @"";
            
            self.studentTextField.text = @"";
            self.otherTextField.text = @"";
            self.studentHeightConstraint.constant = 0.0f;
            self.otherHeightConstraint.constant = 0.0f;
            self.employeMentHeigtConstraint.constant = 0.0f;
            self.studentView.hidden = YES;
            self.employeView.hidden = YES;
            self.otherView.hidden = YES;
            break;
        }
        case EmployementStatusStudent:
        {
            [self.employedBtn setSelected:NO];
            [self.othersBtn setSelected:NO];
            [self.unemployedBtn setSelected:NO];
            [self.studentBtn setSelected:YES];
            [self.occupationInfoDict setValue:[[[self.studentBtn titleLabel] text] stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"employment_status"];
            [self.studentTextField becomeFirstResponder];
            self.positionTitleTF.text = @"";
            self.companyTF.text = @"";
            
            self.otherTextField.text = @"";
            self.studentHeightConstraint.constant = studentheight;
            self.otherHeightConstraint.constant = 0.0f;
            self.employeMentHeigtConstraint.constant = 0.0f;
            self.studentView.hidden = NO;
            self.employeView.hidden = YES;
            self.otherView.hidden = YES;
            break;
        }
        case EmployementStatusOthers:
        {
            [self.employedBtn setSelected:NO];
            [self.othersBtn setSelected:YES];
            [self.unemployedBtn setSelected:NO];
            [self.studentBtn setSelected:NO];
            [self.occupationInfoDict setValue:[[[self.othersBtn titleLabel] text] stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"employment_status"];
            [self.otherTextField becomeFirstResponder];
            self.positionTitleTF.text = @"";
            self.companyTF.text = @"";
            
            self.studentHeightConstraint.constant = 0.0f;
            self.otherHeightConstraint.constant = studentheight;
            self.employeMentHeigtConstraint.constant = 0.0f;
            self.studentTextField.text = @"";
            self.studentView.hidden = YES;
            self.employeView.hidden = YES;
            self.otherView.hidden = NO;
            
            break;
        }
        default: break;
    }
    
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
