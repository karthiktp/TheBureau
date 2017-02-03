//
//  BUTroubleInlLoginVC.m
//  TheBureau
//
//  Created by Accion Labs on 01/12/15.
//  Copyright © 2015 Bureau. All rights reserved.
//

#import "BUTroubleInLoginVC.h"

@interface BUTroubleInLoginVC ()

@property(nonatomic,weak) IBOutlet UITextField *fullNameTF;
@property(nonatomic,weak) IBOutlet UITextField *emailIdTF;
@property(nonatomic,weak) IBOutlet UITextField *mobileNumTF;
@property(nonatomic,weak) IBOutlet UITextView  *messageTV;



@end

@implementation BUTroubleInLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fullNameTF.leftViewMode = UITextFieldViewModeAlways;
    self.fullNameTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_user"]];
    
    self.fullNameTF.layer.sublayerTransform = CATransform3DMakeTranslation(0, 0, 30);
    

    self.emailIdTF.leftViewMode = UITextFieldViewModeAlways;
    self.emailIdTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_email"]];
    
    self.mobileNumTF.leftViewMode = UITextFieldViewModeAlways;
    self.mobileNumTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_mobile"]];
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


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
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
