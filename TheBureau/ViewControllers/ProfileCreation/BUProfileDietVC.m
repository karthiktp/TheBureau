//
//  BUProfileDietVCViewController.m
//  TheBureau
//
//  Created by Accion Labs on 11/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUProfileDietVC.h"
#import "BUProfileOccupationVC.h"
#import "BUConstants.h"


    
    
    

@interface BUProfileDietVC ()
@property(nonatomic,weak)IBOutlet UIButton *vegetarianBtn;
@property(nonatomic,weak)IBOutlet UIButton *eegetarianBtn;

@property(nonatomic,weak)IBOutlet UIButton *veganBtn;
@property(nonatomic,weak)IBOutlet UIButton *nonVegetarianBtn;

@property(nonatomic,weak)IBOutlet UIButton *drinkingSelectionBtn;
@property(nonatomic,weak)IBOutlet UIButton *smokingSelectionBtn;

@property(nonatomic,weak)IBOutlet UILabel *sociallyLabel;
@property(nonatomic,weak)IBOutlet UILabel *neverLabel;

@property(nonatomic,weak)IBOutlet UILabel *yesLabel;
@property(nonatomic,weak)IBOutlet UILabel *noLabel;


@property(nonatomic, strong) NSString *dieting,*smoke,*drink;

@end

@implementation BUProfileDietVC

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
    
    self.title = [NSString stringWithFormat:@"%@'s Social Habits",[[NSUserDefaults standardUserDefaults]objectForKey:@"uName"]];
    
    
    
    
    [_vegetarianBtn setSelected:YES];
    [_eegetarianBtn setSelected:NO];
    [_nonVegetarianBtn setSelected:NO];
    [_veganBtn setSelected:NO];
    self.dieting = @"Vegetarian";
    self.drink = @"Socially";
    self.smoke = @"No";

    

    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (self.isDirect == YES) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"profileDetails"]) {
            
            NSDictionary *profDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"profileDetails"];
            
            if ([[profDict objectForKey:@"diet"] isEqualToString:@"Vegan"]) {
                [_vegetarianBtn setSelected:NO];
                [_eegetarianBtn setSelected:NO];
                [_nonVegetarianBtn setSelected:NO];
                [_veganBtn setSelected:YES];
                self.dieting = @"Vegan";
            }
            else if ([[profDict objectForKey:@"diet"] isEqualToString:@"Non Vegetarian"]) {
                [_vegetarianBtn setSelected:NO];
                [_eegetarianBtn setSelected:NO];
                [_nonVegetarianBtn setSelected:YES];
                [_veganBtn setSelected:NO];
                self.dieting = @"Non Vegetarian";
            }
            else if ([[profDict objectForKey:@"diet"] isEqualToString:@"Eggetarian"]) {
                [_vegetarianBtn setSelected:NO];
                [_eegetarianBtn setSelected:YES];
                [_nonVegetarianBtn setSelected:NO];
                [_veganBtn setSelected:NO];
                self.dieting = @"Eggetarian";
            }
            else {
                [_vegetarianBtn setSelected:YES];
                [_eegetarianBtn setSelected:NO];
                [_nonVegetarianBtn setSelected:NO];
                [_veganBtn setSelected:NO];
                self.dieting = @"Vegetarian";
            }
            
            self.drinkingSelectionBtn.tag = [[profDict objectForKey:@"drinking"] isEqualToString:@"Never"] ? 0 : 1;
            [self setDrinking:self.drinkingSelectionBtn];
            
            self.smokingSelectionBtn.tag = [[profDict objectForKey:@"smoking"] isEqualToString:@"Yes"] ? 0 : 1;
            [self setSmoking:self.smokingSelectionBtn];
            
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)setDiet:(id)sender{
    
    UIButton *dietButton = (UIButton *)sender;
    switch (dietButton.tag)
    {
        case ButtonTypeVegetarian:
        {
            
            [_vegetarianBtn setSelected:YES];
            [_eegetarianBtn setSelected:NO];
            [_nonVegetarianBtn setSelected:NO];
            [_veganBtn setSelected:NO];
            self.dieting = @"Vegetarian";
            break;
        }
        case ButtonTypeEegetarian:
        {
            
            [_vegetarianBtn setSelected:NO];
            [_eegetarianBtn setSelected:YES];
            [_nonVegetarianBtn setSelected:NO];
            [_veganBtn setSelected:NO];
            self.dieting = @"Eggetarian";
            break;
        }
        case ButtonTypeNonvegetarian:
        {
            
            [_vegetarianBtn setSelected:NO];
            [_eegetarianBtn setSelected:NO];
            [_nonVegetarianBtn setSelected:YES];
            [_veganBtn setSelected:NO];
            self.dieting = @"Non Vegetarian";
            break;
        }
        default:
        {
            [_vegetarianBtn setSelected:NO];
            [_eegetarianBtn setSelected:NO];
            [_nonVegetarianBtn setSelected:NO];
            [_veganBtn setSelected:YES];
            self.dieting = @"Vegan";
            break;
        }
    }
    
}

-(IBAction)setDrinking:(id)sender
{
    NSString *switchBtnStr;
    
    if(0 == self.drinkingSelectionBtn.tag)
    {
        _sociallyLabel.textColor = [UIColor lightGrayColor];
        _neverLabel.textColor = [UIColor blackColor];
        switchBtnStr = @"switch_ON";
        self.drink = @"Never";
        self.drinkingSelectionBtn.tag = 1;
    }
    else
    {
        self.drinkingSelectionBtn.tag = 0;
        _sociallyLabel.textColor = [UIColor blackColor];
        _neverLabel.textColor = [UIColor lightGrayColor];
        self.drink = @"Socially";
        switchBtnStr = @"switch_OFF";
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
        self.smoke = @"Yes";
    }
    else
    {
        self.smokingSelectionBtn.tag = 0;
        _yesLabel.textColor = [UIColor lightGrayColor];
        _noLabel.textColor = [UIColor blackColor];
        self.smoke = @"No";
        switchBtnStr = @"switch_OFF";
    }
    
    [self.smokingSelectionBtn setBackgroundImage:[UIImage imageNamed:switchBtnStr]
                                         forState:UIControlStateNormal];
    
}


-(void)alertMessage : (NSString *)message
{
    
    
    [[[UIAlertView alloc] initWithTitle:@"Alert"
                                message:[NSString stringWithFormat:@"Please select %@",message]
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
    
}


-(IBAction)continueClicked:(id)sender {
  /*
    API to  upload :
http://app.thebureauapp.com/admin/update_profile_step4
    
    Parameter
    userid => user id of user
    diet => e.g. Vegetarian, Eggetarian, Non Vegetarian
    drinking => e.g. Socially, Never
    smoking => e.g. Yes, No
*/
    
    if (YES == [self.dieting isEqualToString:@""] || nil == self.dieting)
    {
        [self alertMessage:@"Diet"];
    }
    
    else    if (YES == [self.drink isEqualToString:@""] || nil == self.drink)
    {
        [self alertMessage:@"Diet"];
    }
    

    else     if (YES == [self.smoke isEqualToString:@""] || nil == self.smoke)
    {
        [self alertMessage:@"Diet"];
    }
    


    
    NSDictionary *parameters = nil;
    parameters = @{@"userid": [BUWebServicesManager sharedManager].userID,
                   @"diet":self.dieting,
                   @"drinking":self.drink,
                   @"smoking":self.smoke
                   };
    
    [self startActivityIndicator:YES];
    [[BUWebServicesManager sharedManager] queryServer:parameters
                                             baseURL:@"profile/update_profile_step4"
                                        successBlock:^(id response, NSError *error)
     {
         [self stopActivityIndicator];
         UIStoryboard *sb =[UIStoryboard storyboardWithName:@"ProfileCreation" bundle:nil];
         BUProfileOccupationVC *vc = [sb instantiateViewControllerWithIdentifier:@"BUProfileOccupationVC"];
         vc.isDirect = self.isDirect;
         
         if (self.isDirect == YES) {
             NSMutableDictionary *profDict = [[[NSUserDefaults standardUserDefaults] objectForKey:@"profileDetails"] mutableCopy];
             
             [profDict setValue:self.dieting forKey:@"diet"];
             [profDict setValue:self.drink forKey:@"drinking"];
             [profDict setValue:self.smoke forKey:@"smoking"];
             
             [[NSUserDefaults standardUserDefaults]setObject:profDict forKey:@"profileDetails"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
         }
         
         
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
