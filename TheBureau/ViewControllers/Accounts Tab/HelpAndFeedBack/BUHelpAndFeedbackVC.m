//
//  BUHelpAndFeedbackVC.m
//  TheBureau
//
//  Created by Manjunath on 01/03/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUHelpAndFeedbackVC.h"
#import "BUWebServicesManager.h"

@interface BUHelpAndFeedbackVC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewBottomConstraint;
- (IBAction)sendFeedback:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *feedbackTextView;

@end

@implementation BUHelpAndFeedbackVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.feedbackTextView.layer.cornerRadius = 5.0;
    self.feedbackTextView.layer.borderWidth = 1.0;
    self.title = @"Feedback";

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"logo44"] style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)didReceiveMemoryWarning
{
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

- (IBAction)sendFeedback:(id)sender
{
    [self.view endEditing:YES];
    [self showKeyBoard:NO];
    
    if (self.fdbckBtn.enabled) {
        
    if (![self.feedbackTextView.text length]) {
        
        //[self validationFunc:@"Please provide Feedback, message cannot be empty !"];
        [self showAlert:@"Please provide Feedback, message cannot be empty !"];
        return;
     }
    
    NSDictionary *parameters = nil;
    parameters = @{@"userid": [[BUWebServicesManager sharedManager] userID],
                   @"feedback_msg": self.feedbackTextView.text
                   };
    
    [self startActivityIndicator:YES];
    
    [[BUWebServicesManager sharedManager] queryServer:parameters
                                              baseURL:@"/profile/sendFeedback"
                                         successBlock:^(id response, NSError *error) {
                                             
                                             [self stopActivityIndicator];
                                             
                                             if ([[response objectForKey:@"msg"] isEqualToString:@"Success"]) {
                                                 self.feedbackTextView.text = @"";
                                             }
                                             
                                             NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:[response objectForKey:@"response"]];
                                             [message addAttribute:NSFontAttributeName
                                                             value:[UIFont fontWithName:@"comfortaa" size:15]
                                                             range:NSMakeRange(0, message.length)];
                                             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:nil preferredStyle:UIAlertControllerStyleAlert];
                                             [alertController setValue:message forKey:@"attributedTitle"];
                                             
                                             [alertController addAction:({
                                                 UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                                     NSLog(@"OK");
                                                     if ([[response objectForKey:@"response"] isEqualToString:@"Success"]) {
                                                         [self.navigationController popViewControllerAnimated:YES];
                                                     }
                                                 }];
                                                 
                                                 action;
                                             })];
                                             
                                             [self presentViewController:alertController  animated:YES completion:nil];
                                             
                                             
                                         }
                                         failureBlock:^(id response, NSError *error) {
                                             
                                             [self stopActivityIndicator];
                                             if (error.code == NSURLErrorTimedOut) {
                                                 [self showAlert:@"Connection timed out, please try again later"];
                                             }
                                             else {
                                                 [self showAlert:@"Connectivity Error"];
                                             }
                                         }];
    }
    
}

-(void)validationFunc:(NSString *)toast
{
    
  
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
   // [self showKeyBoard:NO];
}

-(void)showKeyBoard:(BOOL)inBool {
    CGFloat constant = 0;
    if(NO == inBool) {
        constant = 58;
    }
    else {
        constant = 320;
    }
    
    self.textViewBottomConstraint.constant = constant;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView; {
    textView.text = [textView.text stringByReplacingOccurrencesOfString:@"We’d love to hear from you.  Please leave your questions, comments and concerns below:" withString:@""];
    self.fdbckBtn.enabled = YES;
    [self showKeyBoard:YES];
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        textView.text = @"Enter your feedback here.";
    }
    [self showKeyBoard:NO];
    //self.fdbckBtn.selected = NO;
    //textView.text = @"Enter your feedback here.";
}

@end
