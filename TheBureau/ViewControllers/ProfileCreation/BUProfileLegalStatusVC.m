//
//  BUProfileLegalStatusVC.m
//  TheBureau
//
//  Created by Manjunath on 25/01/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUProfileLegalStatusVC.h"
#import "BUHomeTabbarController.h"
#import "Localytics.h"


@interface BUProfileLegalStatusVC ()

@property(nonatomic,weak) IBOutlet UIButton *twoYearBtn;
@property(nonatomic,weak) IBOutlet UIButton *two_sixYearBtn;
@property(nonatomic,weak) IBOutlet UIButton *sixPlusYearBtn;
@property(nonatomic,weak) IBOutlet UIButton *bornAndRaisedBtn;

@property(nonatomic,weak) IBOutlet UIButton *US_CitizenBtn;
@property(nonatomic,weak) IBOutlet UIButton *greenCardBtn;
@property(nonatomic,weak) IBOutlet UIButton *greenCardProcessingBtn;
@property(nonatomic,weak) IBOutlet UIButton *h1VisaBtn;
@property(nonatomic,weak) IBOutlet UIButton *othersBtn;
@property(nonatomic,weak) IBOutlet UIButton *studentVisaBtn;


@property (strong, nonatomic) IBOutlet UITextField *othersTextField;
@property (strong, nonatomic) IBOutlet UILabel *provideStatus;
@property (strong, nonatomic) IBOutlet UILabel *colon;
@property (strong, nonatomic) IBOutlet UILabel *underLine;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *greenCardProcessingLabel;

@property(nonatomic,strong) NSString *yearsInUSA,*citizenShip;





@end

@implementation BUProfileLegalStatusVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isDirect == YES) {
        self.navigationController.navigationBarHidden = NO;
        //self.navigationItem.hidesBackButton = YES;
    }
//    else {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(viewPopOnBackButton)];
        self.navigationItem.leftBarButtonItem = backButton;
//    }
    
    self.title = [NSString stringWithFormat:@"%@'s Legal Status",[[NSUserDefaults standardUserDefaults]objectForKey:@"uName"]];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)setYearsInUs:(id)sender{
    
    UIButton *setYearBtn = (UIButton *)sender;
    
    if (setYearBtn.tag == 1) {
        
        [_twoYearBtn setSelected:YES];
        [_sixPlusYearBtn setSelected:NO];
        [_two_sixYearBtn setSelected:NO];
        [_bornAndRaisedBtn setSelected:NO];

    }
    else if (setYearBtn.tag == 2){
        
        [_twoYearBtn setSelected:NO];
        [_sixPlusYearBtn setSelected:NO];
        [_two_sixYearBtn setSelected:YES];
        [_bornAndRaisedBtn setSelected:NO];
        
    }
    else if (setYearBtn.tag == 3){
        
        [_twoYearBtn setSelected:NO];
        [_sixPlusYearBtn setSelected:YES];
        [_two_sixYearBtn setSelected:NO];
        [_bornAndRaisedBtn setSelected:NO];
        
    }
    else{
        [_twoYearBtn setSelected:NO];
        [_sixPlusYearBtn setSelected:NO];
        [_two_sixYearBtn setSelected:NO];
        [_bornAndRaisedBtn setSelected:YES];
        
        
    }
    
    self.yearsInUSA = setYearBtn.titleLabel.text;
    
}

-(IBAction)setLegalStatus:(id)sender{
    
    self.othersTextField.hidden = YES;
    self.provideStatus.hidden = YES;
    self.colon.hidden = YES;
    self.underLine.hidden = YES;
    
    self.greenCardProcessingLabel.textColor = [UIColor darkTextColor];
  
    UIButton *setLegalStatusBtn = (UIButton *)sender;

    if (setLegalStatusBtn.tag == 1) {
        self.citizenShip = setLegalStatusBtn.titleLabel.text;
        [_US_CitizenBtn setSelected:YES];
        [_greenCardBtn setSelected:NO];
        [_greenCardProcessingBtn setSelected:NO];
        [_studentVisaBtn setSelected:NO];
        [_h1VisaBtn setSelected:NO];
        [_othersBtn setSelected:NO];
        self.othersTextField.text = @"";
        [self.othersTextField resignFirstResponder];
    }
    else if (setLegalStatusBtn.tag == 2){
        self.citizenShip = setLegalStatusBtn.titleLabel.text;
        [_US_CitizenBtn setSelected:NO];
        [_greenCardBtn setSelected:YES];
        [_greenCardProcessingBtn setSelected:NO];
        [_studentVisaBtn setSelected:NO];
        [_h1VisaBtn setSelected:NO];
        [_othersBtn setSelected:NO];
        self.othersTextField.text = @"";
        [self.othersTextField resignFirstResponder];
        
    }
    else if (setLegalStatusBtn.tag == 3){
        
        self.citizenShip = @"Greencard Processing";
        [_US_CitizenBtn setSelected:NO];
        [_greenCardBtn setSelected:NO];
        [_greenCardProcessingBtn setSelected:YES];
        self.greenCardProcessingLabel.textColor = [UIColor whiteColor];
        [_studentVisaBtn setSelected:NO];
        [_h1VisaBtn setSelected:NO];
        [_othersBtn setSelected:NO];
        self.othersTextField.text = @"";
        [self.othersTextField resignFirstResponder];
        
    }
    else if (setLegalStatusBtn.tag == 4){
        self.citizenShip = setLegalStatusBtn.titleLabel.text;
        [_US_CitizenBtn setSelected:NO];
        [_greenCardBtn setSelected:NO];
        [_greenCardProcessingBtn setSelected:NO];
        [_studentVisaBtn setSelected:YES];
        [_h1VisaBtn setSelected:NO];
        [_othersBtn setSelected:NO];
        self.othersTextField.text = @"";
        [self.othersTextField resignFirstResponder];
        
    }
    else if (setLegalStatusBtn.tag == 5){
        self.citizenShip = setLegalStatusBtn.titleLabel.text;
        [_US_CitizenBtn setSelected:NO];
        [_greenCardBtn setSelected:NO];
        [_greenCardProcessingBtn setSelected:NO];
        [_studentVisaBtn setSelected:NO];
        [_h1VisaBtn setSelected:YES];
        [_othersBtn setSelected:NO];
        self.othersTextField.text = @"";
        [self.othersTextField resignFirstResponder];
        
    }

    else{
        
        self.citizenShip = setLegalStatusBtn.titleLabel.text;
        [_US_CitizenBtn setSelected:NO];
        [_greenCardBtn setSelected:NO];
        [_greenCardProcessingBtn setSelected:NO];
        [_studentVisaBtn setSelected:NO];
        [_h1VisaBtn setSelected:NO];
        [_othersBtn setSelected:YES];
        
        self.othersTextField.hidden = NO;
        self.provideStatus.hidden = NO;
        self.colon.hidden = NO;
        self.underLine.hidden = NO;
        [self.othersTextField becomeFirstResponder];
    }

    

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
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)continueClicked:(id)sender
{
    
    /*
     API to  upload :
     http://app.thebureauapp.com/admin/update_profile_step6
     
     Parameters
     
     userid => user id of user
     years_in_usa => e.g. 0 - 2, 2 - 6
     legal_status => e.g. Citizen/Green Card, Greencard
     
     */
    
    
    if (self.yearsInUSA == nil) {
        [self showAlert:@"Please select Years in USA."];
        return;
    }
    
    if (self.citizenShip == nil) {
        [self showAlert:@"Please select Legal Status."];
        return;
    }
    
    if ([self.citizenShip isEqualToString:@"Other"]&&[self.othersTextField.text isEqualToString:@""]) {
        NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"Please Provid Other Legal Status."];
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
    
    
    NSDictionary *parameters = nil;
    parameters = @{@"userid": [BUWebServicesManager sharedManager].userID,
                   @"years_in_usa":self.yearsInUSA != nil ? self.yearsInUSA : @"",
                   @"legal_status":self.citizenShip != nil ? self.citizenShip : @"",
                   @"other_legal_status":self.othersTextField.text
                   };
    
    
    [self startActivityIndicator:YES];
    [[BUWebServicesManager sharedManager]queryServer:parameters
                                             baseURL:@"profile/update_profile_step6"
                                        successBlock:^(id response, NSError *error)
     {
         [Localytics tagEvent:@"Login Successful"];
         [Localytics setCustomerId:[BUWebServicesManager sharedManager].userID];
         [self stopActivityIndicator];
         UIStoryboard *sb =[UIStoryboard storyboardWithName:@"HomeView" bundle:nil];
         BUHomeTabbarController *vc = [sb instantiateViewControllerWithIdentifier:@"BUHomeTabbarController"];
         [self.navigationController pushViewController:vc animated:YES];
         
     }
                                        failureBlock:^(id response, NSError *error)
     {
         [self stopActivityIndicator];
         
         if (error.code == NSURLErrorTimedOut) {
             
             [self timeoutError:@"Connection timed out, please try again later"];
         }
         else
         {
         [self showFailureAlert];
         }
     }];
    
    
    
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
