//
//  BUForgotPasswordVC.m
//  TheBureau
//
//  Created by Accion Labs on 01/12/15.
//  Copyright © 2015 Bureau. All rights reserved.
//

#import "BUForgotPasswordVC.h"

@interface BUForgotPasswordVC ()
@property(nonatomic,weak) IBOutlet UITextField *forgotEmailIdTF;


@end

@implementation BUForgotPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.forgotEmailIdTF.leftViewMode = UITextFieldViewModeAlways;
    self.forgotEmailIdTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_email_mobile"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [textField resignFirstResponder];
    return YES;
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
