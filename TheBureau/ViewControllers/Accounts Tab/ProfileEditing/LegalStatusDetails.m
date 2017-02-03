//
//  LegalStatusDetails.m
//  TheBureau
//
//  Created by Ama1's iMac on 01/08/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "LegalStatusDetails.h"

@interface LegalStatusDetails ()
@property BOOL isDidload;
@end

@implementation LegalStatusDetails

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Legal Status";
    self.isDidload = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(editProfileDetails:)];
    
    NSLog(@"%@",_legalStausrInfo);
    
    [self yearsInUSUpdate];
    [self legalStautsUpdate];
}

- (IBAction)editProfileDetails:(id)sender
{
    [self.view endEditing:YES];
    [self updateProfile];
    //    [self.profileTableView reloadData];
}

-(void)updateProfile
{
    
    
    if ([[self.legalStausrInfo valueForKey:@"legal_status"] isEqualToString:@"Other"] && [[self.legalStausrInfo valueForKey:@"other_legal_status"] isEqualToString:@""]) {
        
        NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"Provide Other Legal Status"];
        [message addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"comfortaa" size:15]
                        range:NSMakeRange(0, message.length)];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController setValue:message forKey:@"attributedTitle"];
        
        [alertController addAction:({
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSLog(@"OK");
                [self.othersTextField becomeFirstResponder];
            }];
            
            action;
        })];
        
        [self presentViewController:alertController  animated:YES completion:nil];
        return;
    }
    
    
    //    [self.profileImageCell saveProfileImages];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    
    //    [parameters addEntriesFromDictionary:self.basicInfoDict];
    //    [parameters addEntriesFromDictionary:self.educationInfo];
    //    [parameters addEntriesFromDictionary:self.occupationInfoDict];
    //    [parameters addEntriesFromDictionary:self.horoscopeDict];
//    [parameters addEntriesFromDictionary:self.socialHabitsDict];
        [parameters addEntriesFromDictionary:self.legalStausrInfo];
    //    [parameters addEntriesFromDictionary:self.heritageDict];
    [parameters setValue:[BUWebServicesManager sharedManager].userID forKey:@"userid"];
    
    NSLog(@"%@",self.legalStausrInfo);
    
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

//-(void)setDatasource:(NSMutableDictionary *)inBasicInfoDict
//{
//    self.legalStausrInfo = inBasicInfoDict;
//    
//    [self yearsInUSUpdate];
//    [self legalStautsUpdate];
//}


-(void)yearsInUSUpdate
{
    NSString *occupationStr = [self.legalStausrInfo valueForKey:@"years_in_usa"];
    
    occupationStr = occupationStr == nil ? @"" : occupationStr;
    NSInteger tag = 1;
    
    if([[[self.twoYearBtn titleLabel] text] containsString:occupationStr])
    {
        tag = 1;
    }
    else if([[[self.two_sixYearBtn titleLabel] text] containsString:occupationStr])
    {
        tag = 2;
    }
    else if([[[self.sixPlusYearBtn titleLabel] text] containsString:occupationStr])
    {
        tag = 3;
    }
    else if([[[self.bornAndRaisedBtn titleLabel] text] containsString:occupationStr])
    {
        tag = 4;
    }
    [self updateYearsInUSForTag:tag];
    
}

-(void)legalStautsUpdate
{
    NSString *occupationStr = [self.legalStausrInfo valueForKey:@"legal_status"];
    
    occupationStr = occupationStr == nil ? @"" : occupationStr;
    NSInteger tag = 1;
    
    if([[[self.US_CitizenBtn titleLabel] text] containsString:occupationStr])
    {
        tag = 1;
    }
    else if([[[self.greenCardBtn titleLabel] text] containsString:occupationStr])
    {
        tag = 2;
    }
    else if([[[self.greenCardProcessingBtn titleLabel] text] containsString:occupationStr])
    {
        tag = 3;
    }
    else if([[[self.h1VisaBtn titleLabel] text] containsString:occupationStr])
    {
        tag = 5;
    }
    else if([[[self.othersBtn titleLabel] text] containsString:occupationStr])
    {
        tag = 6;
    }
    else if([[[self.studentVisaBtn titleLabel] text] containsString:occupationStr])
    {
        tag = 4;
    }
    [self updateLegalStatusForTag:tag];
    
}

-(IBAction)setYearsInUs:(id)sender
{
    UIButton *setYearBtn = (UIButton *)sender;
    
    [self updateYearsInUSForTag:setYearBtn.tag];
}


-(void)updateYearsInUSForTag:(NSInteger)inTag
{
    
    UIButton *selectedButton;
    selectedButton = [_US_CitizenBtn copy];
    if (inTag == 1) {
        
        [_twoYearBtn setSelected:YES];
        [_sixPlusYearBtn setSelected:NO];
        [_two_sixYearBtn setSelected:NO];
        [_bornAndRaisedBtn setSelected:NO];
        
        selectedButton = _twoYearBtn;
    }
    else if (inTag == 2){
        
        [_twoYearBtn setSelected:NO];
        [_sixPlusYearBtn setSelected:NO];
        [_two_sixYearBtn setSelected:YES];
        [_bornAndRaisedBtn setSelected:NO];
        selectedButton = _two_sixYearBtn;
        
    }
    else if (inTag == 3){
        
        [_twoYearBtn setSelected:NO];
        [_sixPlusYearBtn setSelected:YES];
        [_two_sixYearBtn setSelected:NO];
        [_bornAndRaisedBtn setSelected:NO];
        selectedButton = _sixPlusYearBtn;
        
    }
    else{
        [_twoYearBtn setSelected:NO];
        [_sixPlusYearBtn setSelected:NO];
        [_two_sixYearBtn setSelected:NO];
        [_bornAndRaisedBtn setSelected:YES];
        selectedButton = _bornAndRaisedBtn;
    }
    
    [self.legalStausrInfo setValue:[[selectedButton titleLabel] text] forKey:@"years_in_usa"];
    selectedButton = nil;

}
-(IBAction)setLegalStatus:(id)sender
{
    UIButton *setLegalStatusBtn = (UIButton *)sender;
    [self updateLegalStatusForTag:setLegalStatusBtn.tag];
}

-(void)updateLegalStatusForTag:(NSInteger)inTag
{
    self.othersTextField.hidden = YES;
    self.provideStatus.hidden = YES;
    self.colon.hidden = YES;
    self.underLine.hidden = YES;
    
    self.greenCardProcessingLabel.textColor = [UIColor darkTextColor];
    
    UIButton *selectedButton;
    selectedButton = [_US_CitizenBtn copy];
    if (inTag == 1) {
        [_US_CitizenBtn setSelected:YES];
        [_greenCardBtn setSelected:NO];
        [_greenCardProcessingBtn setSelected:NO];
        [_studentVisaBtn setSelected:NO];
        [_h1VisaBtn setSelected:NO];
        [_othersBtn setSelected:NO];
        self.othersTextField.text = @"";
        [self.legalStausrInfo setValue:@"" forKey:@"other_legal_status"];
        [self.othersTextField resignFirstResponder];
        selectedButton = _US_CitizenBtn;
    }
    else if (inTag == 2){
        [_US_CitizenBtn setSelected:NO];
        [_greenCardBtn setSelected:YES];
        [_greenCardProcessingBtn setSelected:NO];
        [_studentVisaBtn setSelected:NO];
        [_h1VisaBtn setSelected:NO];
        [_othersBtn setSelected:NO];
        self.othersTextField.text = @"";
        [self.legalStausrInfo setValue:@"" forKey:@"other_legal_status"];
        [self.othersTextField resignFirstResponder];
        selectedButton = _greenCardBtn;
        
    }
    else if (inTag == 3){
        
        [_US_CitizenBtn setSelected:NO];
        [_greenCardBtn setSelected:NO];
        [_greenCardProcessingBtn setSelected:YES];
        self.greenCardProcessingLabel.textColor = [UIColor whiteColor];
        [_studentVisaBtn setSelected:NO];
        [_h1VisaBtn setSelected:NO];
        [_othersBtn setSelected:NO];
        self.othersTextField.text = @"";
        [self.legalStausrInfo setValue:@"" forKey:@"other_legal_status"];
        [self.othersTextField resignFirstResponder];
        selectedButton = _greenCardProcessingBtn;
        
    }
    else if (inTag == 4){
        
        [_US_CitizenBtn setSelected:NO];
        [_greenCardBtn setSelected:NO];
        [_greenCardProcessingBtn setSelected:NO];
        [_studentVisaBtn setSelected:YES];
        [_h1VisaBtn setSelected:NO];
        [_othersBtn setSelected:NO];
        self.othersTextField.text = @"";
        [self.legalStausrInfo setValue:@"" forKey:@"other_legal_status"];
        [self.othersTextField resignFirstResponder];
        selectedButton = _studentVisaBtn;
        
    }
    else if (inTag == 5){
        
        [_US_CitizenBtn setSelected:NO];
        [_greenCardBtn setSelected:NO];
        [_greenCardProcessingBtn setSelected:NO];
        [_studentVisaBtn setSelected:NO];
        [_h1VisaBtn setSelected:YES];
        [_othersBtn setSelected:NO];
        self.othersTextField.text = @"";
        [self.legalStausrInfo setValue:@"" forKey:@"other_legal_status"];
        [self.othersTextField resignFirstResponder];
        selectedButton = _h1VisaBtn;
    }
    
    else{
        [_US_CitizenBtn setSelected:NO];
        [_greenCardBtn setSelected:NO];
        [_greenCardProcessingBtn setSelected:NO];
        [_studentVisaBtn setSelected:NO];
        [_h1VisaBtn setSelected:NO];
        [_othersBtn setSelected:YES];
        
        selectedButton = _othersBtn;
        self.othersTextField.hidden = NO;
        self.provideStatus.hidden = NO;
        self.colon.hidden = NO;
        self.underLine.hidden = NO;
        self.othersTextField.text = [self.legalStausrInfo objectForKey:@"other_legal_status"];
        if (self.isDidload == YES) {
            self.isDidload = NO;
        }
        else {
            [self.othersTextField becomeFirstResponder];
        }
    }
    
    NSLog(@"%@",[[selectedButton titleLabel] text]);
    
    [self.legalStausrInfo setValue:[[selectedButton titleLabel] text] forKey:@"legal_status"];
    selectedButton = nil;
}

-(IBAction)didTapScreen:(id)sender {
    [self.view endEditing:YES];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    CGPoint bottomOffset = CGPointMake(0, 214);
    [self.scrollView setContentOffset:bottomOffset animated:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"%@",textField.text);
    CGPoint bottomOffset = CGPointMake(0, 0);
    [self.scrollView setContentOffset:bottomOffset animated:YES];
    [self.legalStausrInfo setValue:textField.text forKey:@"other_legal_status"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
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

@end
