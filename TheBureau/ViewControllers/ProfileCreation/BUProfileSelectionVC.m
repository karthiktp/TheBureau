//
//  BUProfileSelectionVC.m
//  TheBureau
//
//  Created by Manjunath on 25/01/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUProfileSelectionVC.h"
#import "BUProfileDetailsVC.h"



@interface BUProfileSelectionVC ()<UIActionSheetDelegate>
@property(nonatomic,weak) IBOutlet UITextField *firstNameTF;
@property(nonatomic,weak) IBOutlet UITextField *lastNameTF;
@property(nonatomic)IBOutlet UITextField *currentTextField;

@property (weak, nonatomic) IBOutlet UILabel *relationLabel;

@property(nonatomic,strong)NSArray* relationCircle;

-(IBAction)continueClicked:(id)sender;
-(void)viewPopOnBackButton;

@end

@implementation BUProfileSelectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Profile Creation";
    
    
    
    _relationCircle = [NSArray arrayWithObjects: @"Self",@"Brother", @"Sister", @"Son", @"Daughter", @"Relative" ,@"Cousin", @"Friend",nil];
    
    
    UIImageView * leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,25,25)];
    leftView.image =  [UIImage imageNamed:@"ic_user"];
    leftView.contentMode = UIViewContentModeCenter;
    self.firstNameTF.leftView = leftView;
    self.firstNameTF.leftViewMode = UITextFieldViewModeAlways;
    self.firstNameTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    
    
    UIImageView * leftView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,25,25)];
    leftView1.image =  [UIImage imageNamed:@"ic_user"];
    leftView1.contentMode = UIViewContentModeCenter;
    
    
    //    self.firstNameTF.leftView = leftView;
    //    self.firstNameTF.leftViewMode = UITextFieldViewModeAlways;
    //    self.firstNameTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //
    
    
    self.lastNameTF.leftViewMode = UITextFieldViewModeAlways;
    self.lastNameTF.leftView = leftView1;
    self.lastNameTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(viewPopOnBackButton)];
    
    
    self.navigationItem.leftBarButtonItem = backButton;
    
    
}

- (void) hideKeyboard {
    
    [self.currentTextField resignFirstResponder];
    
}



-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)dropDownBtn:(id)sender{
    
    if([self.currentTextField isFirstResponder]){
        [self.currentTextField resignFirstResponder];
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
        
        self.firstNameTF.text = self.firstName;
        self.lastNameTF.text = self.lastName;
    }
    else {
        self.firstNameTF.text = nil;
        self.lastNameTF.text = nil;
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(IBAction)continueClicked:(id)sender
{
    
    if (![self.firstNameTF.text length])
    {
        [self alertMessage:@"First Name"];
    }
    else if (![self.lastNameTF.text length])
    {
        [self alertMessage:@"Last Name"];
    }
    else if (![self.relationLabel.text length])
    {
        [self alertMessage:@"Relation"];
    }
    else
    {
        NSDictionary *parameters = nil;
        
        /*
         
         1. API for screen 4_profile_setup (Of the mockup screens)
         
         http://app.thebureauapp.com/admin/matchMaking
         
         Parameters to be sent to this API :
         
         userid => user id of user
         profile_for => profile for eg. self, brother, sister =>One of these values
         profile_first_name => first name for profile
         profile_last_name => last name for profile
         
         API to view the above details for a user :
         */
        
        parameters = @{@"userid": [BUWebServicesManager sharedManager].userID,
                       @"profile_for":self.relationLabel.text,
                       @"profile_first_name":self.lastNameTF.text,
                       @"profile_last_name":self.lastNameTF.text};
        
        [self startActivityIndicator:YES];
        //        [[BUWebServicesManager sharedManager] updateProfileSelectionwithParameters:parameters
        //                                                                      successBlock:^(id inResult, NSError *error)
        //         {
        //             [self stopActivityIndicator];
        //
        //             if(YES == [[inResult valueForKey:@"msg"] isEqualToString:@"Success"])
        //             {
        //                 UIStoryboard *sb =[UIStoryboard storyboardWithName:@"ProfileCreation" bundle:nil];
        //                 BUProfileDetailsVC *vc = [sb instantiateViewControllerWithIdentifier:@"BUProfileDetailsVC"];
        //                 [self.navigationController pushViewController:vc animated:YES];
        //
        //             }
        //             else
        //             {
        //                 NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"Connectivity Error"];
        //                 [message addAttribute:NSFontAttributeName
        //                                 value:[UIFont fontWithName:@"comfortaa" size:15]
        //                                 range:NSMakeRange(0, message.length)];
        //                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        //                 [alertController setValue:message forKey:@"attributedTitle"];
        //                 [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        //                 [self presentViewController:alertController animated:YES completion:nil];
        //             }
        //
        //         }
        //                                                                      failureBlock:^(id response, NSError *error)
        //         {
        //             [self stopActivityIndicator];
        //
        //             if (error.code == NSURLErrorTimedOut) {
        //
        //                 [self timeoutError:@"Connection timed out, please try again later"];
        //             }
        //             else
        //             {
        //             NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"Connectivity Error"];
        //             [message addAttribute:NSFontAttributeName
        //                             value:[UIFont fontWithName:@"comfortaa" size:15]
        //                             range:NSMakeRange(0, message.length)];
        //             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        //             [alertController setValue:message forKey:@"attributedTitle"];
        //             [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        //             [self presentViewController:alertController animated:YES completion:nil];
        //             }
        //         }];
        //    }
        
    }
}

-(void)alertMessage:(NSString *)message
{
    
    
    [[[UIAlertView alloc] initWithTitle:@"Alert"
                                message:[NSString stringWithFormat:@"Please Enter %@",message]
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    
    [textField resignFirstResponder];
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField;           // became first responder
{
    
    self.currentTextField = textField;
    
    
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


@end
