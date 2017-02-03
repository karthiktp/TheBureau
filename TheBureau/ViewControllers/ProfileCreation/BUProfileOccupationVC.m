    //
    //  BUProfileOccupationVC.m
    //  TheBureau
    //
    //  Created by Manjunath on 25/01/16.
    //  Copyright © 2016 Bureau. All rights reserved.
    //

#import "BUProfileOccupationVC.h"
#import "EmployementStatusTVCell.h"
#import "HighLevelEducationTVCell.h"
#import "BUProfileLegalStatusVC.h"
#import "BUHomeTabbarController.h"
#import "Localytics.h"

@interface BUProfileOccupationVC ()<UITableViewDataSource,UITableViewDelegate, HighLevelEducationTVCellDelegate,EmployementStatusTVCellDelegate,UIActionSheetDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSInteger tableViewDataSource;
@property (nonatomic) CGFloat employementTVCellHeight;
@property (nonatomic) CGFloat highLevelEducationTVCellHeight;
@property BOOL oneFirstCall, twoFiratCall;
@property(nonatomic) NSArray *educationLevelArray;

@property(nonatomic) NSIndexPath *selectedIndexpath;

@property(nonatomic) UITextField *currentTextField;

@property BOOL added;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBtmConstraint;

@end

@implementation BUProfileOccupationVC

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.added = NO;
    
    self.oneFirstCall = NO;
    self.twoFiratCall = NO;
    
    if (NO == [[NSUserDefaults standardUserDefaults] boolForKey:@"isUSCitizen"])
    {
        self.continueLabel.text = @"Finish";
    }
    
    if (self.isDirect == YES) {
        self.navigationController.navigationBarHidden = NO;
            //self.navigationItem.hidesBackButton = YES;
    }
        //    else {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(viewPopOnBackButton)];
    self.navigationItem.leftBarButtonItem = backButton;
        //    }
    
    self.title = [NSString stringWithFormat:@"%@'s Occupation",[[NSUserDefaults standardUserDefaults]objectForKey:@"uName"]];
    
    _educationLevelArray = [[NSArray alloc]initWithObjects:@"Doctorate",@"Masters",@"Bachelors",@"Associates",@"Grade School", nil];
    
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    
    [self loadUI];
    [self loadData];
    self.dataSourceDict = [[NSMutableDictionary alloc] init];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSDictionary *profDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"profileDetails"];
    
    if ((self.isDirect == YES) && ([[profDict objectForKey:@"employment_status"] length])) {
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"profileDetails"]) {
            
            [self.dataSourceDict setValue:[profDict objectForKey:@"userid"] forKey:@"userid"];
            [self.dataSourceDict setValue:[profDict objectForKey:@"employment_status"] forKey:@"employment_status"];
            [self.dataSourceDict setValue:[profDict objectForKey:@"position_title"] forKey:@"position_title"];
            [self.dataSourceDict setValue:[profDict objectForKey:@"company"] forKey:@"company"];
            
            [self.dataSourceDict setValue:[profDict objectForKey:@"highest_education"] forKey:@"highest_education"];
            [self.dataSourceDict setValue:[profDict objectForKey:@"honors"] forKey:@"honors"];
            [self.dataSourceDict setValue:[profDict objectForKey:@"major"] forKey:@"major"];
            [self.dataSourceDict setValue:[profDict objectForKey:@"college"] forKey:@"college"];
            [self.dataSourceDict setValue:[profDict objectForKey:@"graduated_year"] forKey:@"graduated_year"];
            
            [self.dataSourceDict setValue:[profDict objectForKey:@"education_second"] forKey:@"education_second"];
            [self.dataSourceDict setValue:[profDict objectForKey:@"honors_second"] forKey:@"honors_second"];
            [self.dataSourceDict setValue:[profDict objectForKey:@"majors_second"] forKey:@"majors_second"];
            [self.dataSourceDict setValue:[profDict objectForKey:@"college_second"] forKey:@"college_second"];
            [self.dataSourceDict setValue:[profDict objectForKey:@"graduation_years_second"] forKey:@"graduation_years_second"];
            
            if ([[self.dataSourceDict objectForKey:@"highest_education"] length]) {
                self.highLevelEducationTVCellHeight = 280.0;
            }
            
            if ([[self.dataSourceDict objectForKey:@"education_second"] length]) {
                self.tableViewDataSource = 3;
                    //                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.tableViewDataSource - 1 inSection:0];
                    //                [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                
                self.added = YES;
            }
            
            if ([[profDict objectForKey:@"country_residing"] isEqualToString:@"USA"]) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isUSCitizen"];
            }
            else {
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isUSCitizen"];
                self.continueLabel.text = @"Finish";
            }
            
            /*
             userid => user id of user
             employment_status=> e.g. Employed, Unemployed
             position_title => position title
             company => company name
             highest_education=> e.g. Doctorate, Masters
             honors=> honors (text)
             major=> major
             college=> college
             graduated_year=> graduated year
             education_second => secondary education
             honors_second => honors (if second education is there)
             majors_second => major
             college_second => college
             graduation_years_second => graduation year
             */
            
        }
        self.oneFirstCall = YES;
        self.twoFiratCall = YES;
        [self.tableView reloadData];
    }
    
    NSLog(@"%@",self.dataSourceDict);
    
    
    
    
}

- (void) hideKeyboard {
    
    [self.currentTextField resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UI

- (void)loadUI
{
    self.tableView.dataSource   = self;
    self.tableView.delegate     = self;
}

- (void)loadData
{
    self.tableViewDataSource            = 2;
    self.employementTVCellHeight        = 160.0;
    self.highLevelEducationTVCellHeight = 65.0;
}

#pragma mark - Table View Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableViewDataSource;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cellToReturn = nil;
    if (indexPath.row == 0)
    {
        static NSString *employementCellIdentifier = @"EmployementStatusTVCell";
        EmployementStatusTVCell *cell = [tableView dequeueReusableCellWithIdentifier:employementCellIdentifier];
        cell.delegate = self;
        if (self.oneFirstCall == YES) {
            [cell updateBtnStatus:self.dataSourceDict];
            self.oneFirstCall = NO;
        }
            // cell.studentTF.delegate = self;
            // cell.otherTF.delegate = self;
        cell.dataSourceDict = self.dataSourceDict;
        cellToReturn = cell;
    }
    else {
        static NSString *educationCellIdentifier = @"HighLevelEducationTVCell";
        HighLevelEducationTVCell *cell = [tableView dequeueReusableCellWithIdentifier:educationCellIdentifier];
        cell.indexpath = indexPath;
        cell.educationLevel = indexPath.row;
        cell.yearTextField.inputAccessoryView = self.toolBar;
        
        cell.delegate = self;
        cell.dataSourceDict = self.dataSourceDict;
        if (self.twoFiratCall == YES) {
            [cell updateBtnStatus:self.dataSourceDict];
            self.twoFiratCall= NO;
        }
        
        if(indexPath.row >= 2) {
            cell.addEducationLevelBtn.hidden = YES;
            cell.highestLevelLabel.text = @"Second Level";
        }
        
        
        cellToReturn = cell;
    }
    
    return cellToReturn;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    
    if (indexPath.row == 0)
    {
        height = self.employementTVCellHeight;
    }
    else
    {
        height = self.highLevelEducationTVCellHeight;
    }
    return height;
}


#pragma mark - textField Delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    self.currentTextField = textField;
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.currentTextField = textField;
    if (textField.tag == 100 || textField.tag == 101) {
        if ([[self.dataSourceDict objectForKey:@"employment_status"] isEqualToString:@"Student"]) {
            [self.dataSourceDict setObject:textField.text forKey:@"occupation_student"];
            
            [self.dataSourceDict setObject:@"" forKey:@"occupation_other"];
        }else{
            [self.dataSourceDict setObject:@"" forKey:@"occupation_student"];
            [self.dataSourceDict setObject:textField.text forKey:@"occupation_other"];
        }
    }
    if (textField.tag == 900) {
        if ([[self.dataSourceDict objectForKey:@"employment_status"] isEqualToString:@"Employed"]) {
            [self.dataSourceDict setObject:textField.text forKey:@"position_title"];
        }
    }if (textField.tag == 901){
        if ([[self.dataSourceDict objectForKey:@"employment_status"] isEqualToString:@"Employed"]) {
            [self.dataSourceDict setObject:textField.text forKey:@"company"];
        }
    }
    
}

#pragma mark - HighLevelEducationTVCellDelegate

- (void)addNextLevelButtonTapped
{
    
    [self.dataSourceDict setObject:@"" forKey:@"education_second"];
    [self.dataSourceDict setObject:@"" forKey:@"honors_second"];
    [self.dataSourceDict setObject:@"" forKey:@"majors_second"];
    [self.dataSourceDict setObject:@"" forKey:@"college_second"];
    [self.dataSourceDict setObject:@"" forKey:@"graduation_years_second"];
    
    if (self.added == NO) {
        self.tableViewDataSource++;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.tableViewDataSource - 1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        self.added = YES;
        return;
    }
    
    self.tableViewDataSource--;
    [self.dataSourceDict removeObjectForKey:@"graduation_years_second"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.tableViewDataSource inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
    self.added = NO;
    
}

- (void)updateHighLevelEducationTVCell:(NSIndexPath *)indexpath
{
    self.selectedIndexpath = indexpath;
    self.highLevelEducationTVCellHeight = 280.0;
    [self.tableView reloadData];
    [self selectEducationLevel];
}

#pragma mark - EmployementStatusTVCellDelegate

- (void)updateEmployementCellHeightForOthers
{
    self.employementTVCellHeight = 160.0;
    [self.tableView reloadData];
}

- (void)updateEmployementCellHeightForEmployed
{
    self.employementTVCellHeight =  255.0;
    [self.tableView reloadData];
}

-(void)updateStudentOther
{
    self.employementTVCellHeight = 220.0;
    [self.tableView reloadData];
}

-(IBAction)didTapScreen:(id)sender {
    [self.view endEditing:YES];
}


-(void)selectEducationLevel
{
    
    UIActionSheet *acSheet = [[UIActionSheet alloc] initWithTitle:@"Select Education Level" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: nil];
    
    for (NSString *str in _educationLevelArray)
    {
        [acSheet addButtonWithTitle:str];
    }
    
    [acSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0)
    {
        HighLevelEducationTVCell *cell =(HighLevelEducationTVCell*) [_tableView cellForRowAtIndexPath:_selectedIndexpath];
        
        cell.educationlevelLbl.text = _educationLevelArray[buttonIndex - 1];
        if(cell.educationLevel == 1)
            [self.dataSourceDict setValue:cell.educationlevelLbl.text forKey:@"highest_education"];
        else
            [self.dataSourceDict setValue:cell.educationlevelLbl.text forKey:@"education_second"];
        
    }
}

- (IBAction)doneAction:(id)sender {
    [self.view endEditing:YES];
}
-(void)alertMessage:(NSString *)message2{
    [self showAlert:message2];
}
-(IBAction)continueClicked:(id)sender
{
    /*
     
     userid => user id of user
     employment_status=> e.g. Employed, Unemployed
     position_title => position title
     company => company name
     highest_education=> e.g. Doctorate, Masters
     honors=> honors (text)
     major=> major
     college=> college
     graduated_year=> graduated year
     education_second => secondary education
     honors_second => honors (if second education is there)
     majors_second => major
     college_second => college
     graduation_years_second => graduation year
     */
    NSLog(@"%@",self.dataSourceDict);
    if (([[self.dataSourceDict objectForKey:@"occupation_student"] length] < 1) && ([[self.dataSourceDict objectForKey:@"employment_status"] isEqualToString:@"Student"])) {
        [self alertMessage:@"Please enter valid student details"];
        return;
        
    }
    if (([[self.dataSourceDict objectForKey:@"occupation_other"] length] < 1) && ([[self.dataSourceDict objectForKey:@"employment_status"] isEqualToString:@"Other"])) {
        [self alertMessage:@"Please enter valid other occupation details"];
        return;
    }
    
    if (![self.dataSourceDict objectForKey:@"employment_status"]) {
        
        [self alertMessage:@"Please select Employment Status."];
        return;
    }
    
    if (![[self.dataSourceDict objectForKey:@"highest_education"] length]) {
        
        [self alertMessage:@"Please select highest level of education."];
        return;
    }
    NSLog(@"%@,%lu",[self.dataSourceDict objectForKey:@"graduated_year"],[[self.dataSourceDict objectForKey:@"graduated_year"] length]);
    
    if ([[self.dataSourceDict objectForKey:@"graduated_year"] length]) {
        if (([[self.dataSourceDict objectForKey:@"graduated_year"] length] != 4)) {
            
            [self.dataSourceDict setObject:@"" forKey:@"graduated_year"];
            [self showAlert:@"Please provide valid year"];
            return;
        }
    }
    
    NSLog(@"%@,%lu",[self.dataSourceDict objectForKey:@"graduation_years_second"],[[self.dataSourceDict objectForKey:@"graduation_years_second"] length]);
    
    if (([[self.dataSourceDict objectForKey:@"education_second"] isEqualToString:@""])&&(self.added == YES)) {
        [self showAlert:@"Please select second level of education."];
        return;
    }
    
    if (self.added == YES) {
        if ([[self.dataSourceDict objectForKey:@"graduation_years_second"] length]) {
            if (([[self.dataSourceDict objectForKey:@"graduation_years_second"] length] != 4)) {
                
                [self.dataSourceDict setObject:@"" forKey:@"graduation_years_second"];
                [self showAlert:@"Please provide valid year"];
                return;
            }
        }
    }
    
    NSLog(@"%@",self.dataSourceDict);
    
    [self.dataSourceDict setValue:[BUWebServicesManager sharedManager].userID forKey:@"userid"];
    
        //    NSDictionary *parameters = nil;
        //    parameters = @{@"userid": [BUWebServicesManager sharedManager].userID,
        //                   @"diet":self.dieting,
        //                   @"drinking":self.drink,
        //                   @"smoking":self.smoke
        //                   };
    
    
    [self startActivityIndicator:YES];
    [[BUWebServicesManager sharedManager] queryServer:self.dataSourceDict
                                              baseURL:@"profile/update_profile_step5"
                                         successBlock:^(id response, NSError *error)
     {
         
         /*
          
          {
          college = "";
          "college_second" = "";
          company = "";
          "education_second" = "Grade School";
          "employment_status" = Other;
          "graduated_year" = "";
          "graduation_years_second" = "";
          "highest_education" = Bachelors;
          honors = "";
          "honors_second" = "";
          major = "";
          "majors_second" = "";
          "position_title" = "";
          userid = 381;
          }
          
          */
         
         if (self.isDirect == YES) {
             NSMutableDictionary *profDict = [[[NSUserDefaults standardUserDefaults] objectForKey:@"profileDetails"] mutableCopy];
             
             [profDict setValue:[self.dataSourceDict objectForKey:@"college"] forKey:@"college"];
             [profDict setValue:[self.dataSourceDict objectForKey:@"college_second"] forKey:@"college_second"];
             [profDict setValue:[self.dataSourceDict objectForKey:@"company"] forKey:@"company"];
             [profDict setValue:[self.dataSourceDict objectForKey:@"education_second"] forKey:@"education_second"];
             [profDict setValue:[self.dataSourceDict objectForKey:@"employment_status"] forKey:@"employment_status"];
             [profDict setValue:[self.dataSourceDict objectForKey:@"graduated_year"] forKey:@"graduated_year"];
             [profDict setValue:[self.dataSourceDict objectForKey:@"graduation_years_second"] forKey:@"graduation_years_second"];
             [profDict setValue:[self.dataSourceDict objectForKey:@"highest_education"] forKey:@"highest_education"];
             [profDict setValue:[self.dataSourceDict objectForKey:@"honors"] forKey:@"honors"];
             [profDict setValue:[self.dataSourceDict objectForKey:@"honors_second"] forKey:@"honors_second"];
             [profDict setValue:[self.dataSourceDict objectForKey:@"major"] forKey:@"major"];
             [profDict setValue:[self.dataSourceDict objectForKey:@"majors_second"] forKey:@"majors_second"];
             [profDict setValue:[self.dataSourceDict objectForKey:@"position_title"] forKey:@"position_title"];
             
             [[NSUserDefaults standardUserDefaults]setObject:profDict forKey:@"profileDetails"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
         }
         
         if([[NSUserDefaults standardUserDefaults] boolForKey:@"isUSCitizen"])
         {
             UIStoryboard *sb =[UIStoryboard storyboardWithName:@"ProfileCreation" bundle:nil];
             BUProfileLegalStatusVC *vc = [sb instantiateViewControllerWithIdentifier:@"BUProfileLegalStatusVC"];
             vc.isDirect = self.isDirect;
             [self stopActivityIndicator];
             [self.navigationController pushViewController:vc animated:YES];
         }
         else
         {
             [Localytics tagEvent:@"Login Successful"];
             [Localytics setCustomerId:[BUWebServicesManager sharedManager].userID];
             
             UIStoryboard *sb =[UIStoryboard storyboardWithName:@"HomeView" bundle:nil];
             BUHomeTabbarController *vc = [sb instantiateViewControllerWithIdentifier:@"BUHomeTabbarController"];
             [self stopActivityIndicator];
             [self.navigationController pushViewController:vc animated:YES];
             
         }
         
     }
                                         failureBlock:^(id response, NSError *error)
     {
         
         if (error.code == NSURLErrorTimedOut) {
             
             [self timeoutError:@"Connection timed out, please try again later"];
         }
         else
         {
             
             [self showFailureAlert];
             
         }
         [self stopActivityIndicator];
         
     }];
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;{
    [self slideTableDown];
    [self.view endEditing:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self slideTableDown];
    [self.view endEditing:YES];
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
                //NSLog(@"%@",picker.date);
            
        }];
        
        action;
    })];
    
    [self presentViewController:alertController  animated:YES completion:nil];
}

-(void)slideTableUp{
    self.tableBtmConstraint.constant = 250;
    [self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(void)slideTableDown{
    self.tableBtmConstraint.constant = 48;
    [self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

@end
