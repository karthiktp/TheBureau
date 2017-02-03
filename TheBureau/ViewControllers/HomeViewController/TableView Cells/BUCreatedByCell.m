//
//  BUCreatedByCell.m
//  TheBureau
//
//  Created by Manjunath on 20/04/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUCreatedByCell.h"

@implementation BUCreatedByCell

- (void)awakeFromNib {
    // Initialization code
}

-(IBAction)flagUSer:(id)sender

{
    
    NSString *message = @"You have chosen to flag this user.  Please provide a reason.  Examples are \"offensive language\" or \"inappropriate pictures\".";
    
    UIAlertController *alertControllerK2 = [UIAlertController
                                            alertControllerWithTitle:@"\u00A0"
                                            message:message
                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *K2okAction = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action) {
                                     // access text from text field
                                     NSString *text = ((UITextField *)[alertControllerK2.textFields firstObject]).text;                                                                                                                                                                                                                                                                                                   
                                     [self.parentVC flagWithText:text];
                                     
                                 }];
    UIAlertAction *K2cancelAction = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action) {
                                     // access text from text field
                                     
                                 }];
    [alertControllerK2 addTextFieldWithConfigurationHandler:^(UITextField *K2TextField)
     {
         K2TextField.placeholder = NSLocalizedString(@"Please provide reason", @"Please provide reason");
     }];
    [alertControllerK2 addAction:K2okAction];
    [alertControllerK2 addAction:K2cancelAction];
    [self.parentVC presentViewController:alertControllerK2 animated:YES completion:nil];
}

//-(void)flagWithText:(NSString *)inText
//{
//    
//    NSDictionary *parameters = nil;
//    parameters = @{@"userid": [BUWebServicesManager sharedManager].userID,
//                   @"flagged_userid":self.parentVC.matchUserID,
//                   @"reason":inText
//                   };
//    [self.parentVC startActivityIndicator:YES];
//    
//    NSString *baseURl = @"http://app.thebureauapp.com/admin/flagUsers";
//    
//    [[BUWebServicesManager sharedManager] queryServer:parameters
//                                              baseURL:baseURl
//                                         successBlock:^(id response, NSError *error)
//     {
//         [self.parentVC stopActivityIndicator];
//         NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:[response valueForKey:@"response"]];
//         [message addAttribute:NSFontAttributeName
//                         value:[UIFont fontWithName:@"comfortaa" size:15]
//                         range:NSMakeRange(0, message.length)];
//         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
//         [alertController setValue:message forKey:@"attributedTitle"];            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
//         [self.parentVC presentViewController:alertController animated:YES completion:nil];
//     }
//                                         failureBlock:^(id response, NSError *error)
//     {
//         [self.parentVC stopActivityIndicator];
//         
//         NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"Connectivity Error!"];
//         [message addAttribute:NSFontAttributeName
//                         value:[UIFont fontWithName:@"comfortaa" size:15]
//                         range:NSMakeRange(0, message.length)];
//         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
//         [alertController setValue:message forKey:@"attributedTitle"];
//         
//         [alertController addAction:({
//             UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//                 NSLog(@"OK");
//                 
//                 self.parentVC.matchBtn.hidden = YES;
//                 self.parentVC.passBtn.hidden = YES;
//                 self.parentVC.profileStatusImgView.hidden = NO;
//                 self.parentVC.profileStatusImgView.image = [UIImage imageNamed:@"btn_liked"];
//             }];
//             
//             action;
//         })];
//         
//         [self.parentVC presentViewController:alertController  animated:YES completion:nil];
//         
//     }];
//    
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
