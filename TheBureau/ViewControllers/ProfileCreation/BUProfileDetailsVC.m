//
//  BUProfileDetailsVC.m
//  TheBureau
//
//  Created by Manjunath on 25/01/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUProfileDetailsVC.h"
#import "BUProfileHeritageVC.h"
#import "UIView+FLKAutoLayout.h"
#import "BUProfileImageCell.h"
@interface BUProfileDetailsVC ()<UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,weak) IBOutlet UITextField *dateofbirthTF;
@property(nonatomic,weak) IBOutlet UITextField *currentLocTF;
@property(nonatomic,strong) BUProfileImageCell *profileImageCell;


@property(nonatomic,weak) IBOutlet UIButton *neverMarriedBtn;
@property(nonatomic,weak) IBOutlet UIButton *divorcedBtn;
@property(nonatomic,weak) IBOutlet UIButton *widowedBtn;
@property(nonatomic,weak) IBOutlet UIImageView *femaleImgView,*maleImgView;
@property(nonatomic,weak) IBOutlet UIButton *genderSelectionBtn;

@property(nonatomic,weak) IBOutlet UIButton *btn_USA;
@property(nonatomic,weak) IBOutlet UIButton *btn_India;

@property(nonatomic,weak) IBOutlet UIPickerView *heightPicker;
@property(nonatomic,weak)IBOutlet UITextField *heighTextField;

@property(nonatomic) NSMutableArray *feetMutableArray;
@property(nonatomic) NSMutableArray *inchesMutableArray,*imageList;

@property(nonatomic,weak) NSString *feetStr,*inchStr,*maritalStatus;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;

-(IBAction)continueClicked:(id)sender;

@end

@implementation BUProfileDetailsVC

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    else {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(viewPopOnBackButton)];
    self.navigationItem.leftBarButtonItem = backButton;
    //    }
    
    self.imageList = [[NSMutableArray alloc] init];
    self.inchesMutableArray = [[NSMutableArray alloc] init];
    self.feetMutableArray = [[NSMutableArray alloc] init];
    
    
    for (int i=0; i < 12; i++) {
        NSString *inches = [NSString stringWithFormat:@"%02d\"",i ];
        [self.inchesMutableArray addObject:inches];
    }
    
    for (int i=4; i < 8; i++) {
        NSString *feet = [NSString stringWithFormat:@"%d'",i ];
        [self.feetMutableArray addObject:feet];
    }
    
    self.currentLocTF.inputAccessoryView = self.toolBar;
    
    self.title = [NSString stringWithFormat:@"%@'s Information",[[NSUserDefaults standardUserDefaults]objectForKey:@"uName"]];
    
    [self.btn_USA setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s2"] forState:UIControlStateNormal];
    [self.btn_India setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s1"] forState:UIControlStateNormal];
    
    [self.btn_USA setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btn_India setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isUSCitizen"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    {
        [self.neverMarriedBtn setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s2"] forState:UIControlStateNormal];
        [self.divorcedBtn setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s1"] forState:UIControlStateNormal];
        [self.widowedBtn setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s1"] forState:UIControlStateNormal];
        
        
        self.maritalStatus = @"Never Married";
        
        self.feetStr = @"4";
        self.inchStr = @"00";
        
        [self.neverMarriedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.widowedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.divorcedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    if (self.isDirect == YES) {
        self.navigationController.navigationBarHidden = NO;
        //self.navigationItem.hidesBackButton = YES;
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"profileDetails"]) {
            NSDictionary *profDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"profileDetails"];
            if ([[profDict objectForKey:@"country_residing"] isEqualToString:@"India"]) {
                [self.btn_India setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s2"] forState:UIControlStateNormal];
                [self.btn_USA setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s1"] forState:UIControlStateNormal];
                
                [self.btn_India setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.btn_USA setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isUSCitizen"];
            }
            else
            {
                [self.btn_USA setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s2"] forState:UIControlStateNormal];
                [self.btn_India setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s1"] forState:UIControlStateNormal];
                
                [self.btn_USA setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.btn_India setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isUSCitizen"];
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            self.currentLocTF.text = [profDict objectForKey:@"current_zip_code"];
            
            self.heighTextField.text = [NSString stringWithFormat:@"%@' %@\"",[[profDict objectForKey:@"height_feet"] length] ? [profDict objectForKey:@"height_feet"] : @"4",[[profDict objectForKey:@"height_inch"]length] ? [profDict objectForKey:@"height_inch"] : @"00"];
            
            if ([[profDict objectForKey:@"maritial_status"]isEqualToString:@"Widowed"])
            {
                
                self.maritalStatus = @"Widowed";
                
                [self.widowedBtn setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s2"] forState:UIControlStateNormal];
                [self.neverMarriedBtn setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s1"] forState:UIControlStateNormal];
                [self.divorcedBtn setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s1"] forState:UIControlStateNormal];
                
                [self.widowedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.divorcedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.neverMarriedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
            }
            else if ([[profDict objectForKey:@"maritial_status"]isEqualToString:@"Divorced"]){
                
                self.maritalStatus = @"Divorced";
                
                [self.divorcedBtn setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s2"] forState:UIControlStateNormal];
                [self.neverMarriedBtn setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s1"] forState:UIControlStateNormal];
                [self.widowedBtn setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s1"] forState:UIControlStateNormal];
                
                
                [self.divorcedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.widowedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.neverMarriedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            else{
                self.maritalStatus = @"Never Married";
                
                [self.neverMarriedBtn setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s2"] forState:UIControlStateNormal];
                [self.divorcedBtn setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s1"] forState:UIControlStateNormal];
                [self.widowedBtn setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s1"] forState:UIControlStateNormal];
                
                
                
                [self.neverMarriedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.widowedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.divorcedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                
            }
            
            self.dobStr = [profDict objectForKey:@"profile_dob"];
            
            self.dateofbirthTF.text = self.dobStr;
            
            NSString *femaleImgName,*maleImgName,*genderImgName;
            
            if([[profDict objectForKey:@"profile_gender"] isEqualToString:@"Male"])
            {
                self.genderSelectionBtn.tag = 1;
                femaleImgName = @"ic_female_s1.png";
                maleImgName = @"ic_male_s2.png";
                genderImgName = @"switch_male.png";
                self.genStr = @"0";
            }
            else
            {
                femaleImgName = @"ic_female_s2.png";
                maleImgName = @"ic_male_s1.png";
                genderImgName = @"switch_female.png";
                self.genderSelectionBtn.tag = 0;
                self.genStr = @"1";
            }
            
            self.femaleImgView.image = [UIImage imageNamed:femaleImgName];
            self.maleImgView.image = [UIImage imageNamed:maleImgName];
            [self.genderSelectionBtn setImage:[UIImage imageNamed:genderImgName] forState:UIControlStateNormal];
            
            self.imageList = [[profDict objectForKey:@"img_url"] mutableCopy];
            
            [self.tableView reloadData];
            
        }
        
    }
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    
    
}

- (IBAction)doneAction:(id)sender {
    [self.view endEditing:YES];
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    self.dateofbirthTF.text = self.dobStr;
    
    NSLog(@"%@",self.genStr);
    
    self.genderSelectionBtn.tag = [self.genStr intValue];
    
    NSString *femaleImgName,*maleImgName,*genderImgName;
    
    if(1 == self.genderSelectionBtn.tag)
    {
        self.genderSelectionBtn.tag = 1;
        femaleImgName = @"ic_female_s1.png";
        maleImgName = @"ic_male_s2.png";
        genderImgName = @"switch_male.png";
    }
    else
    {
        femaleImgName = @"ic_female_s2.png";
        maleImgName = @"ic_male_s1.png";
        genderImgName = @"switch_female.png";
        self.genderSelectionBtn.tag = 0;
        
    }
    
    self.femaleImgView.image = [UIImage imageNamed:femaleImgName];
    self.maleImgView.image = [UIImage imageNamed:maleImgName];
    [self.genderSelectionBtn setImage:[UIImage imageNamed:genderImgName]
                             forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)selectDateofBirthBtn:(id)sender
{
    if (self.currentLocTF.isFirstResponder) {
        [self.currentLocTF resignFirstResponder];
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Birthday\n\n\n\n\n\n\n\n" message:@"\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
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
            self.dobStr=[NSString stringWithFormat:@"%@",dateString];
            
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



-(void)checkPinCode
{
    
    
    
    /*
     
     if (selectedBtn.tag == 1) {
     [self.btn_USA setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s2"] forState:UIControlStateNormal];
     [self.btn_India setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s1"] forState:UIControlStateNormal];
     
     [self.btn_USA setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [self.btn_India setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     
     [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isUSCitizen"];
     }
     else
     {
     [self.btn_India setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s2"] forState:UIControlStateNormal];
     [self.btn_USA setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s1"] forState:UIControlStateNormal];
     
     [self.btn_India setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [self.btn_USA setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     
     [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isUSCitizen"];
     }
     
     [[NSUserDefaults standardUserDefaults] synchronize];
     
     */
    
    UIButton *selectedBtn = [[UIButton alloc] init];
    
    
    //  login/checkZipCodes/zip_code/560004
    NSString *baseURl = [NSString stringWithFormat:@"login/checkZipCodes/zip_code/%@",self.currentLocTF.text];
    [self startActivityIndicator:YES];
    [[BUWebServicesManager sharedManager] getqueryServer:nil
                                                 baseURL:baseURl
                                            successBlock:^(id response, NSError *error)
     {
         [self stopActivityIndicator];
         
         if([[response valueForKey:@"msg"] isEqualToString:@"Success"])
         {
             
             NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"Residing country and Zipcode mismatch, Do you want to change residing country ?"];
             [message addAttribute:NSFontAttributeName
                             value:[UIFont fontWithName:@"comfortaa" size:15]
                             range:NSMakeRange(0, message.length)];
             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
             [alertController setValue:message forKey:@"attributedTitle"];
             
             [alertController addAction:({
                 UIAlertAction *action = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                          {
                                              if (selectedBtn.tag == 1) {
                                                  [self.btn_USA setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s2"] forState:UIControlStateNormal];
                                                  [self.btn_India setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s1"] forState:UIControlStateNormal];
                                                  
                                                  [self.btn_USA setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                                  [self.btn_India setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                                                  
                                                  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isUSCitizen"];
                                              }
                                              else
                                              {
                                                  [self.btn_India setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s2"] forState:UIControlStateNormal];
                                                  [self.btn_USA setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s1"] forState:UIControlStateNormal];
                                                  
                                                  [self.btn_India setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                                  [self.btn_USA setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                                                  
                                                  [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isUSCitizen"];
                                              }
                                              [[NSUserDefaults standardUserDefaults] synchronize];
                                              //[self saveDetails];
                                          }];
                 
                 action;
             })];
             
             [alertController addAction:({
                 UIAlertAction *action = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                          {
                                              self.currentLocTF.text = @"";
                                          }];
                 action;
             })];
             
             
             if(NO == [[NSUserDefaults standardUserDefaults] boolForKey:@"isUSCitizen"])
             {
                 if (![[response valueForKey:@"country"]isEqualToString:@"India"]) {
                     //NSLog(@"string does not contain bla");
                     selectedBtn.tag = 1;
                     [self presentViewController:alertController  animated:YES completion:nil];
                 }
             }
             else {
                 if ([[response valueForKey:@"country"]isEqualToString:@"India"]) {
                     //NSLog(@"string contain bla");
                     selectedBtn.tag = 0;
                     [self presentViewController:alertController  animated:YES completion:nil];
                 }
             }
         }
         else {
             self.currentLocTF.text = @"";
             [self stopActivityIndicator];
             [self showAlert:@"Invalid zip code"];
         }
     }
                                            failureBlock:^(id response, NSError *error)
     {
         
         self.currentLocTF.text = @"";
         
         [self stopActivityIndicator];
         
         if (error.code == NSURLErrorTimedOut) {
             
             [self showAlert:@"Connection timed out, please try again later"];
         }
         else{
             [self showAlert:@"Invalid zip code"];
         }
     }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![textField.text isEqualToString:@""]) {
        [self checkPinCode];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string

{
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    return YES;
}


-(IBAction)setGender:(id)sender
{
    NSString *femaleImgName,*maleImgName,*genderImgName;
    
    if(1 == self.genderSelectionBtn.tag)
    {
        femaleImgName = @"ic_female_s2.png";
        maleImgName = @"ic_male_s1.png";
        genderImgName = @"switch_female.png";
        self.genderSelectionBtn.tag = 0;
        self.genStr = @"0";
    }
    else
    {
        self.genderSelectionBtn.tag = 1;
        femaleImgName = @"ic_female_s1.png";
        maleImgName = @"ic_male_s2.png";
        genderImgName = @"switch_male.png";
        self.genStr = @"1";
    }
    
    self.femaleImgView.image = [UIImage imageNamed:femaleImgName];
    self.maleImgView.image = [UIImage imageNamed:maleImgName];
    [self.genderSelectionBtn setImage:[UIImage imageNamed:genderImgName]
                             forState:UIControlStateNormal];
    
}



-(IBAction)getMatialStatus:(id)sender
{
    UIButton *selectedBtn = (UIButton *)sender;
    if (selectedBtn.tag == 1)
    {
        self.maritalStatus = @"Never Married";
        
        [self.neverMarriedBtn setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s2"] forState:UIControlStateNormal];
        [self.divorcedBtn setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s1"] forState:UIControlStateNormal];
        [self.widowedBtn setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s1"] forState:UIControlStateNormal];
        
        
        
        [self.neverMarriedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.widowedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.divorcedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        
        
        
    }
    else if (selectedBtn.tag == 2){
        
        self.maritalStatus = @"Divorced";
        
        [self.divorcedBtn setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s2"] forState:UIControlStateNormal];
        [self.neverMarriedBtn setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s1"] forState:UIControlStateNormal];
        [self.widowedBtn setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s1"] forState:UIControlStateNormal];
        
        
        [self.divorcedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.widowedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.neverMarriedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        
        
    }
    else{
        
        self.maritalStatus = @"Widowed";
        
        [self.widowedBtn setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s2"] forState:UIControlStateNormal];
        [self.neverMarriedBtn setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s1"] forState:UIControlStateNormal];
        [self.divorcedBtn setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s1"] forState:UIControlStateNormal];
        
        [self.widowedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.divorcedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.neverMarriedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        
        
    }
    
    
    
}

-(IBAction)getResidingDetails:(id)sender{
    
    self.currentLocTF.text = @"";
    
    UIButton *selectedBtn = (UIButton *)sender;
    
    if (selectedBtn.tag == 1) {
        [self.btn_USA setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s2"] forState:UIControlStateNormal];
        [self.btn_India setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s1"] forState:UIControlStateNormal];
        
        [self.btn_USA setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btn_India setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isUSCitizen"];
    }
    else
    {
        [self.btn_India setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s2"] forState:UIControlStateNormal];
        [self.btn_USA setBackgroundImage:[UIImage imageNamed:@"bg_radiobutton_bubble_s1"] forState:UIControlStateNormal];
        
        [self.btn_India setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btn_USA setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isUSCitizen"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
}


#pragma mark - Picker View Data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    if (component ==1) {
        return [_inchesMutableArray count];
    }
    else
    {
        
        return [_feetMutableArray count];
        
        
    }
    
    
}

#pragma mark- Picker View Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    
    if (component == 1)
    {
        self.inchStr = [_inchesMutableArray objectAtIndex:row];
        
        
    }
    else
    {
        self.feetStr = [_feetMutableArray objectAtIndex:row];
        
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component
{
    
    if (component == 1) {
        return [_inchesMutableArray objectAtIndex:row];
        
    }
    else
    {
        return [_feetMutableArray objectAtIndex:row];
        
        
    }
}




-(IBAction)setheight {
    
    if (self.currentLocTF.isFirstResponder) {
        [self.currentLocTF resignFirstResponder];
        return;
    }
    
    NSLog(@"%@",self.inchStr);
    NSLog(@"%@",self.feetStr);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Height\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIPickerView *picker = [[UIPickerView alloc] init];
    [alertController.view addSubview:picker];
    [picker alignCenterYWithView:alertController.view predicate:@"0.0"];
    [picker alignCenterXWithView:alertController.view predicate:@"0.0"];
    [picker constrainWidth:@"270" ];
    picker.dataSource = self;
    picker.delegate = self ;
    
    
    [picker reloadAllComponents];
    
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"OK");
            
            NSUInteger numComponents = [[picker dataSource] numberOfComponentsInPickerView:picker];
            
            NSMutableString * text = [NSMutableString string];
            for(NSUInteger i = 0; i < numComponents; ++i) {
                NSString *title = [self pickerView:picker titleForRow:[picker selectedRowInComponent:i] forComponent:i];
                [text appendFormat:@" %@", title];
            }
            
            NSLog(@"%@", text);
            self.heighTextField.text = text;
            
            NSLog(@"%@",self.inchStr);
            NSLog(@"%@",self.feetStr);
            
        }];
        action;
    })];
    
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"Cancel");
        }];
        action;
    })];
    [self presentViewController:alertController  animated:YES completion:nil];
    
    
    
}

-(void)viewPopOnBackButton {
    
    NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"Are you sure, you want to go back? Your Information has not been saved"];
    [message addAttribute:NSFontAttributeName
                    value:[UIFont fontWithName:@"comfortaa" size:15]
                    range:NSMakeRange(0, message.length)];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController setValue:message forKey:@"attributedTitle"];
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"OK");
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        action;
    })];
    
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"Cancel");
        }];
        action;
    })];
    [self presentViewController:alertController  animated:YES completion:nil];
}
-(IBAction)continueClicked:(id)sender
{
    if (![self.currentLocTF.text length]) {
        [self alertMessage:@"enter Current Location"];
    }
    
    else if (![self.heighTextField.text length]){
        
        [self alertMessage:@"enter Height"];
        
    }
    else if (![self.dateofbirthTF.text length]){
        
        [self alertMessage:@"select Date Of Birth"];
    }
    else
    {
        NSDictionary *parameters = nil;
        NSString *citizen = @"USA";
        if(NO == [[NSUserDefaults standardUserDefaults] boolForKey:@"isUSCitizen"])
        {
            citizen = @"India";
        }
        
        
        /*
         
         2. API for screen 4a_profile_setup1 (Of the mockup screens)
         
         http://app.thebureauapp.com/admin/update_profile_step2
         
         Parameters to be sent :
         
         userid => user id of user
         profile_gender =>gender (Male,Female)
         profile_dob =>date of birth (dd-mm-yy format)
         country_residing => country residing (India, America) =>one of these values
         current_zip_code => current zip code
         height_feet => person height in feet
         height_inch => person height in inch
         maritial_status => marital status
         
         */
        
        self.inchStr = [self.inchStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        
        self.feetStr = [self.feetStr stringByReplacingOccurrencesOfString:@"'" withString:@""];
        
        NSLog(@"%@, %@, %@, %@, %@, %@, %@, %@",[BUWebServicesManager sharedManager].userID,citizen,self.currentLocTF.text,self.feetStr,self.inchStr,self.dateofbirthTF.text, self.genderSelectionBtn.tag == 1 ? @"Male" : @"Female", self.maritalStatus);
        
        parameters = @{@"userid": [BUWebServicesManager sharedManager].userID,
                       @"country_residing":citizen,
                       @"current_zip_code":self.currentLocTF.text,
                       @"height_feet":self.feetStr,
                       @"height_inch":self.inchStr,
                       @"profile_dob":self.dateofbirthTF.text,
                       @"profile_gender":self.genderSelectionBtn.tag == 1 ? @"Male" : @"Female",
                       @"maritial_status":self.maritalStatus
                       };
        
        [self startActivityIndicator:YES];
        [[BUWebServicesManager sharedManager] queryServer:parameters baseURL:@"profile/update_profile_step2"  successBlock:^(id inResult, NSError *error)
         {
             if(YES == [[inResult valueForKey:@"msg"] isEqualToString:@"Success"])
             {
                 UIStoryboard *sb =[UIStoryboard storyboardWithName:@"ProfileCreation" bundle:nil];
                 BUProfileHeritageVC *vc = [sb instantiateViewControllerWithIdentifier:@"BUProfileHeritageVC"];
                 vc.isDirect = self.isDirect;
                 
                 if (self.isDirect == YES) {
                     NSMutableDictionary *profDict = [[[NSUserDefaults standardUserDefaults] objectForKey:@"profileDetails"] mutableCopy];
                     
                     [profDict setValue:citizen forKey:@"country_residing"];
                     [profDict setValue:self.currentLocTF.text forKey:@"current_zip_code"];
                     [profDict setValue:self.feetStr forKey:@"height_feet"];
                     [profDict setValue:self.inchStr forKey:@"height_inch"];
                     
                     [profDict setValue:self.dateofbirthTF.text forKey:@"profile_dob"];
                     [profDict setValue:(self.genderSelectionBtn.tag == 1 ? @"Male" : @"Female") forKey:@"profile_gender"];
                     [profDict setValue:self.maritalStatus forKey:@"maritial_status"];
                     
                     [profDict setValue:self.imageList forKey:@"img_url"];
                     
                     [[NSUserDefaults standardUserDefaults]setObject:profDict forKey:@"profileDetails"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                     
                 }
                 [self stopActivityIndicator];
                 [self.navigationController pushViewController:vc animated:YES];
             }
             else {
                 [self showAlert:@"Connectivity Error"];
             }
             
         }
                                             failureBlock:^(id response, NSError *error)
         {
             [self stopActivityIndicator];
             if (error.code == NSURLErrorTimedOut) {
                 
                 [self showAlert:@"Connection timed out, please try again later"];
             }
             else{
                 [self showAlert:@"Connectivity Error"];
             }
         }];
    }
}


-(void)didSuccess:(id)inResult;
{
    [self stopActivityIndicator];
    
    if(YES == [[inResult valueForKey:@"msg"] isEqualToString:@"Success"])
    {
        UIStoryboard *sb =[UIStoryboard storyboardWithName:@"ProfileCreation" bundle:nil];
        BUProfileHeritageVC *vc = [sb instantiateViewControllerWithIdentifier:@"BUProfileHeritageVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        [self showAlert:@"Connectivity Error"];
    }
    
}
-(void)alertMessage : (NSString *)message {
    
    [[[UIAlertView alloc] initWithTitle:@"Alert"
                                message:[NSString stringWithFormat:@"Please %@",message]
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    switch (indexPath.section)
    {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"BUProfileImageCell"];
            [(BUProfileImageCell *)cell setProfileImageList:self.imageList];
            [(BUProfileImageCell *)cell setParentVC:self];
            [(BUProfileImageCell *)cell setIsProfileCreation:YES];
            cell.clipsToBounds = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            break;
        }
        default:
            break;
    }
    //Clip whatever is out the cell frame
    
    
    return nil;
}


@end
