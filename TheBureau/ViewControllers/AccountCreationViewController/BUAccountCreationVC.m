//
//  BUAccountCreationVC.m
//  TheBureau
//
//  Created by Manjunath on 01/12/15.
//  Copyright © 2015 Bureau. All rights reserved.
//

#import "BUAccountCreationVC.h"
#import "BUProfileDetailsVC.h"
#import "UIView+FLKAutoLayout.h"
#import "BUProfileImageCell.h"
#import "BULayerHelper.h"
@interface BUAccountCreationVC ()<UIActionSheetDelegate>


@property(nonatomic,weak) IBOutlet UITextField *firstNameTF;
@property(nonatomic,weak) IBOutlet UITextField *lastNameTF;

@property(nonatomic,weak) IBOutlet UITextField *emailIdTF;
@property(nonatomic,weak) IBOutlet UITextField *mobileNumTF;
@property(nonatomic,weak) IBOutlet UITextField *dateofbirthTF;

@property(nonatomic,weak) IBOutlet UIImageView *femaleImgView,*maleImgView;
@property(nonatomic,weak) IBOutlet UIButton *genderSelectionBtn;

@property (nonatomic, assign) CGSize keyboardSize;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollview;
@property (nonatomic, strong) UIView *keyboarAccessoryview;


@property(nonatomic) eNavigatedFrom navFrom;
-(IBAction)setGender:(id)sender;
-(IBAction)setDOB:(id)sender;
-(IBAction)continueButtonClicked:(id)sender;
@end

@implementation BUAccountCreationVC


-(IBAction)dropDownBtn:(id)sender
{
    [self.view endEditing:YES];
    if([self.currentTextField isFirstResponder]){
        [self.currentTextField resignFirstResponder];
    }
    
if([self.firstNameTF.text isEqualToString:@""] || [self.lastNameTF.text isEqualToString:@""])
{
    [self alertMessage:@"enter First name and last name"];
    return;
}

    
    UIActionSheet *acSheet = [[UIActionSheet alloc] initWithTitle:@"Select Relationship" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: nil];
    
    for (NSString *str in _relationCircle)
    {
        [acSheet addButtonWithTitle:str];
    }
    
    [acSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0)
    {
        self.relationLabel.text = _relationCircle[buttonIndex - 1];
    }
    if ([self.relationLabel.text isEqualToString:@"Self"]) {
        
        self.profileFirstNameTF.text = self.firstNameTF.text;
        self.profileLastNameTF.text = self.lastNameTF.text;
    }
    else{
        
        self.profileFirstNameTF.text = nil;
        self.profileLastNameTF.text = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Account Creation";
    
    //[NSThread detachNewThreadSelector:@selector(authenticateLayer) toTarget:self withObject:nil];
    
    self.navigationItem.hidesBackButton = YES;
    
    _relationCircle = [NSArray arrayWithObjects: @"Self", @"Brother", @"Sister", @"Son", @"Daughter", @"Relative" ,@"Cousin", @"Friend",nil];
    
    
    UIImageView * leftView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,25,25)];
    leftView1.image =  [UIImage imageNamed:@"ic_user"];
    leftView1.contentMode = UIViewContentModeCenter;
    self.profileFirstNameTF.leftView = leftView1;
    self.profileFirstNameTF.leftViewMode = UITextFieldViewModeAlways;
    self.profileFirstNameTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    
    
    UIImageView * leftView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,25,25)];
    leftView2.image =  [UIImage imageNamed:@"ic_user"];
    leftView2.contentMode = UIViewContentModeCenter;
    
    
    self.profileLastNameTF.leftViewMode = UITextFieldViewModeAlways;
    self.profileLastNameTF.leftView = leftView2;
    self.profileLastNameTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    // Do any additional setup after loading the view.
    
    
    
    UIImageView * leftView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,25,25)];
    leftView3.image =  [UIImage imageNamed:@"ic_user"];
    leftView3.contentMode = UIViewContentModeCenter;
    self.firstNameTF.leftView = leftView3;
    self.firstNameTF.leftViewMode = UITextFieldViewModeAlways;
    self.firstNameTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    
    UIImageView * leftView4 = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,25,25)];
    leftView4.image =  [UIImage imageNamed:@"ic_user"];
    leftView4.contentMode = UIViewContentModeCenter;
    self.lastNameTF.leftView = leftView4;
    self.lastNameTF.leftViewMode = UITextFieldViewModeAlways;
    self.lastNameTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    
    
    
    //    self.lastNameTF.leftViewMode = UITextFieldViewModeAlways;
    //    self.lastNameTF.leftView = leftView;
    //    self.lastNameTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    //[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_user"]];
    
    UIImageView * leftView5 = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,25,25)];
    leftView5.image =  [UIImage imageNamed:@"ic_email"];
    leftView5.contentMode = UIViewContentModeCenter;
    self.emailIdTF.leftView = leftView5;
    self.emailIdTF.leftViewMode = UITextFieldViewModeAlways;
    self.emailIdTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    
    UIImageView * leftView6 = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,25,25)];
    leftView6.image =  [UIImage imageNamed:@"ic_mobile"];
    leftView6.contentMode = UIViewContentModeCenter;
    self.mobileNumTF.leftView = leftView6;
    self.mobileNumTF.leftViewMode = UITextFieldViewModeAlways;
    self.mobileNumTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    
    UIImageView * leftView7 = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,25,25)];
    leftView7.image =  [UIImage imageNamed:@"ic_dob"];
    leftView7.contentMode = UIViewContentModeCenter;
    self.dateofbirthTF.leftView = leftView7;
    self.dateofbirthTF.leftViewMode = UITextFieldViewModeAlways;
    self.dateofbirthTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.scrollview addGestureRecognizer:gestureRecognizer];
    
    
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(viewPopOnBackButton)];
//    
//    
//    self.navigationItem.leftBarButtonItem = backButton;
    
    self.genderSelectionBtn.tag = 0;
    
    if (self.isDirect != YES) {
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"uName"];
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"uDOB"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"uGender"];
    }
    else{
    NSDictionary *profDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"profileDetails"];
        if ([[profDict objectForKey:@"first_name"] length]) {
            
            self.firstNameTF.text = [profDict objectForKey:@"first_name"];
            self.lastNameTF.text = [profDict objectForKey:@"last_name"];
            self.dateofbirthTF.text = [profDict objectForKey:@"dob"];
            self.genderSelectionBtn.tag = [[profDict objectForKey:@"gender"] isEqualToString:@"Male"] ? 0 : 1;
            [self setGender:self.genderSelectionBtn];
            
            self.mobileNumTF.text = [profDict objectForKey:@"phone_number"];
            self.emailIdTF.text = [profDict objectForKey:@"email"];
            
            self.relationLabel.text = [profDict objectForKey:@"created_by"] ? [[profDict objectForKey:@"created_by"] isEqualToString:@""] ? @"Select" : [profDict objectForKey:@"created_by"] : @"Select";
            
            self.profileFirstNameTF.text = [profDict objectForKey:@"profile_first_name"];
            self.profileLastNameTF.text = [profDict objectForKey:@"profile_last_name"];
            [[NSUserDefaults standardUserDefaults]setObject:[profDict objectForKey:@"profile_first_name"] forKey:@"uName"];
            
        }
    }
    
    // Do any additional setup after loading the view.
}


- (void) hideKeyboard {
    
    [self.currentTextField resignFirstResponder];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.rightBarButtonItem = nil;
    
    [self.scrollview setContentOffset:CGPointZero animated:YES];
    
    if (self.socialChannel.profileDetails.firstName != nil) {
        self.firstNameTF.text = [NSString stringWithFormat:@" %@",self.socialChannel.profileDetails.firstName];
    }
    if (self.socialChannel.profileDetails.lastName != nil) {
        self.lastNameTF.text = [NSString stringWithFormat:@" %@",self.socialChannel.profileDetails.lastName];
    }
    if (self.socialChannel.emailID != nil) {
        self.emailIdTF.text = [NSString stringWithFormat:@" %@",self.socialChannel.emailID];
    }
    if (self.socialChannel.mobileNumber != nil) {
        self.mobileNumTF.text = [NSString stringWithFormat:@" %@",self.socialChannel.mobileNumber];

    }
    if (self.socialChannel.profileDetails.dob != nil) {
        self.dateofbirthTF.text = [NSString stringWithFormat:@" %@",self.socialChannel.profileDetails.dob];
    }
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)setGender:(id)sender
{
    [self.view endEditing:YES];

    NSString *femaleImgName,*maleImgName,*genderImgName;
    
    if(1 == self.genderSelectionBtn.tag)
    {
        femaleImgName = @"ic_female_s2.png";
        maleImgName = @"ic_male_s1.png";
        genderImgName = @"switch_female.png";
        self.genderSelectionBtn.tag = 0;
    }
    else
    {
        self.genderSelectionBtn.tag = 1;
        femaleImgName = @"ic_female_s1.png";
        maleImgName = @"ic_male_s2.png";
        genderImgName = @"switch_male.png";
    }
    
    self.femaleImgView.image = [UIImage imageNamed:femaleImgName];
    self.maleImgView.image = [UIImage imageNamed:maleImgName];
    [self.genderSelectionBtn setImage:[UIImage imageNamed:genderImgName]
                             forState:UIControlStateNormal];
    
}

-(IBAction)setDOB:(id)sender
{
    
}

- (void)adjustScrollViewOffsetToCenterTextField:(UITextField *)textField
{
    CGRect textFieldFrame = textField.frame;
    
    CGPoint buttonOrigin = textFieldFrame.origin;
    
    CGFloat buttonHeight = textFieldFrame.size.height;
    
    CGRect visibleRect = self.view.frame;
    
    visibleRect.size.height -= _keyboardSize.height+100;
    
    if (!CGRectContainsPoint(visibleRect, buttonOrigin)){
        
        CGPoint scrollPoint = CGPointMake(0.0, buttonOrigin.y - visibleRect.size.height + buttonHeight);
        
        [self.scrollview setContentOffset:scrollPoint animated:YES];
        
        
    }
    
    
    
}

-(IBAction)dateofbirthBtn:(id)sender
{
    
    [self.view endEditing:YES];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Birthday\n\n\n\n\n\n\n" message:@"\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
    UIDatePicker *picker = [[UIDatePicker alloc] init];
    [picker setDatePickerMode:UIDatePickerModeDate];
    [alertController.view addSubview:picker];
    
    [picker alignCenterYWithView:alertController.view predicate:@"0.0"];
    [picker alignCenterXWithView:alertController.view predicate:@"0.0"];
    [picker constrainWidth:@"270" ];
    
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    [comps setMonth:1];
    [comps setYear:1990];
    NSDate *currentDate = [[NSCalendar currentCalendar] dateFromComponents:comps];

    
    
    NSDate *todayDate = [NSDate date];
    NSDate *newDate = [todayDate dateByAddingTimeInterval:(-1*18*365*24*60*60)];
    picker.maximumDate = newDate;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-yyyy"];
    
    
    
    if ([self.dateofbirthTF.text isEqualToString:@""]) {
        picker.date = currentDate;
    }
    else {
        picker.date = [dateFormat dateFromString:self.dateofbirthTF.text];
    }
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"OK");
            NSLog(@"%@",picker.date);
            
            NSString *dateString = [dateFormat stringFromDate:picker.date];
            self.dateofbirthTF.text = [NSString stringWithFormat:@"%@",dateString];
        }];
        action;
    })];
    
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"Cancel");
            //NSLog(@"%@",picker.date);
        }];
        action;
    })];
    [self presentViewController:alertController  animated:YES completion:nil];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField;           // became first responder
{
    self.currentTextField = textField;
    self.scrollBottomConstraint.constant = 250;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.scrollBottomConstraint.constant = 0;
    [self.currentTextField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.currentTextField resignFirstResponder];
    self.scrollBottomConstraint.constant = 0;
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
     if ([string isEqualToString:@" "]) {
         return NO;
    }
    return YES;
}

-(void)alertMessage : (NSString *)message {
    [[[UIAlertView alloc] initWithTitle:@"Alert"
                                message:[NSString stringWithFormat:@"Please %@",message]
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

-(void)viewPopOnBackButton {
    [self.view endEditing:YES];
    NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"Are you sure, you want to go back? Your Information has not been saved"];
    [message addAttribute:NSFontAttributeName
                    value:[UIFont fontWithName:@"comfortaa" size:15]
                    range:NSMakeRange(0, message.length)];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController setValue:message forKey:@"attributedTitle"];
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"OK");
            [self.navigationController popViewControllerAnimated:YES];
        }];
        action;
    })];
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"Cancel");
            //NSLog(@"%@",picker.date);
        }];
        action;
    })];
    //  UIPopoverPresentationController *popoverController = alertController.popoverPresentationController;
    //  popoverController.sourceView = sender;
    //   popoverController.sourceRect = [sender bounds];
    [self presentViewController:alertController  animated:YES completion:nil];
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


#pragma mark - Web services handler

-(IBAction)continueButtonClicked:(id)sender;
{
    [self.view endEditing:YES];
    
    [[NSUserDefaults standardUserDefaults]setObject:self.profileFirstNameTF.text forKey:@"uName"];
    
    if ([self.relationLabel.text isEqualToString:@"Self"]) {
        
        [[NSUserDefaults standardUserDefaults]setObject:_dateofbirthTF.text forKey:@"uDOB"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    if (![self.firstNameTF.text length]) {
        [self alertMessage:@"enter First Name"];
    }
    else if (![self.lastNameTF.text length]){
        [self alertMessage:@"enter Last Name"];
    }
    else if (![self.dateofbirthTF.text length]){
        
        [self alertMessage:@"select Date Of Birth"];
    }
    else if (![self.mobileNumTF.text length]){
        [self alertMessage:@"enter Mobile Number"];
        
    }
    else if (([self.emailIdTF.text length])&&(![self NSStringIsValidEmail:self.emailIdTF.text])){
        
        
        {
            [[[UIAlertView alloc] initWithTitle:@"Alert"
                                        message:[NSString stringWithFormat:@"Please Enter valid Email"]
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
        
        
    }
    else  if (![self.emailIdTF.text length]){
        [self alertMessage:@"enter Email Address"];
    }
    else if ([self.relationLabel.text isEqualToString:@"Select"]){
        
        [self alertMessage:@"select Relationship"];
        
    }
    else if (![self.profileFirstNameTF.text length]){
        
        [self alertMessage:@"enter Profile First Name"];
        
    }
    else if (![self.profileLastNameTF.text length]){
        
        [self alertMessage:@"enter Profile Last Name"];
        
    }
    else
    {
        /*
         
         userid => User's ID
         first_name => First name of account holder
         last_name => Last name of account holder
         dob => Date of birth (dd-mm-yyyy)
         gender => Gender - enum('Male', 'Female')
         phone_number => Phone number of account holder
         email => Email of account holder
         */
        
        NSLog(@"%@",self.emailIdTF.text);
        
        
        NSDictionary *parameters = nil;
        
        parameters = @{@"userid": [BUWebServicesManager sharedManager].userID,
                       @"first_name":self.firstNameTF.text,
                       @"last_name":self.lastNameTF.text,
                       @"profile_first_name":self.profileFirstNameTF.text,
                       @"profile_last_name":self.profileLastNameTF.text,
                       @"profile_for":self.relationLabel.text,
                       @"dob":self.dateofbirthTF.text,
                       @"gender":self.genderSelectionBtn.tag == 1 ? @"Male" : @"Female",
                       @"phone_number":self.mobileNumTF.text,
                       @"email":self.emailIdTF.text
                       };
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)self.genderSelectionBtn.tag] forKey:@"uGender"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        [BUWebServicesManager sharedManager].userName = self.firstNameTF.text;

        [[NSUserDefaults standardUserDefaults] setValue:[BUWebServicesManager sharedManager].userName forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        [self startActivityIndicator:YES];
        
        
        NSString *urlString = @"profile/create";
        
        if (self.isDirect == YES) {
            urlString = @"profile/update";
        }
        
        [[BUWebServicesManager sharedManager] queryServer:parameters
                                                  baseURL:urlString
                                             successBlock:^(id response, NSError *error) {
                                                 [self stopActivityIndicator];
                                                 
//                                                 if ([response objectForKey:@"response"]) {
//                                                     if ([[response objectForKey:@"response"] isEqualToString:@"User Id already exist"]) {
//                                                         self.isDirect = YES;
//                                                         [self continueButtonClicked:self];
//                                                         return ;
//                                                     }
//                                                 }
                                                 
                                                 UIStoryboard *sb =[UIStoryboard storyboardWithName:@"ProfileCreation" bundle:nil];
                                                 BUProfileDetailsVC *vc = [sb instantiateViewControllerWithIdentifier:@"BUProfileDetailsVC"];
                                                 vc.isDirect = self.isDirect;
                                                 if([self.relationLabel.text isEqualToString:@"Self"])
                                                 {
                                                     vc
                                                     .dobStr = self.dateofbirthTF.text;
                                                     vc.genStr = [NSString stringWithFormat:@"%ld",(long)self.genderSelectionBtn.tag];
                                                 }
                                                 else
                                                 {
                                                     vc
                                                     .dobStr = @"";
                                                     vc.genStr = @"0";
                                                 }
                                                 
                                                 if (self.isDirect == YES) {
                                                     NSMutableDictionary *profDict = [[[NSUserDefaults standardUserDefaults] objectForKey:@"profileDetails"] mutableCopy];
                                                     
                                                     [profDict setValue:self.firstNameTF.text forKey:@"first_name"];
                                                     [profDict setValue:self.lastNameTF.text forKey:@"last_name"];
                                                     [profDict setValue:self.dateofbirthTF.text forKey:@"dob"];
                                                     [profDict setValue:(self.genderSelectionBtn.tag == 1 ? @"Male" : @"Female") forKey:@"gender"];
                                                     [profDict setValue:self.mobileNumTF.text forKey:@"phone_number"];
                                                     [profDict setValue:self.emailIdTF.text forKey:@"email"];
                                                     [profDict setValue:self.relationLabel.text forKey:@"created_by"];
                                                     [profDict setValue:self.profileFirstNameTF.text forKey:@"profile_first_name"];
                                                     [profDict setValue:self.profileLastNameTF.text forKey:@"profile_last_name"];
                                                     
                                                     //[[NSUserDefaults standardUserDefaults]objectForKey:@"uName"]
                                                     
                                                     [[NSUserDefaults standardUserDefaults]setObject:self.profileFirstNameTF.text forKey:@"uName"];
                                                     
                                                     [[NSUserDefaults standardUserDefaults]setObject:profDict forKey:@"profileDetails"];
                                                     [[NSUserDefaults standardUserDefaults] synchronize];
                                                 
                                                 
                                                     
                                                 }
                                                 self.isDirect = YES;
                                                 
                                                 [self.navigationController pushViewController:vc animated:YES];
                                                 
                                             } failureBlock:^(id response, NSError *error) {
                                                 [self stopActivityIndicator];
                                                 
                                                 if (error.code == NSURLErrorTimedOut) {
                                                     
                                                     [self showAlert:@"Connection timed out, please try again later"];
                                                 }
                                                 else {
                                                     [self showAlert:@"Connectivity Error"];
                                                 }
                                             }
         ];
        
    }
}
    


@end
