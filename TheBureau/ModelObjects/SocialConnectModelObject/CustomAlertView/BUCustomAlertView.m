//
//  BUCustomAlertView.m
//  TheBureau
//
//  Created by Accion Labs on 01/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUCustomAlertView.h"
#import <UIKit/UIKit.h>

@implementation BUCustomAlertView


+(void)showAlertView{
    
    
    
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Birthday\n\n\n\n\n\n\n\n" message:@"\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
    UIDatePicker *picker = [[UIDatePicker alloc] init];
    [picker setDatePickerMode:UIDatePickerModeDate];
    [alertController.view addSubview:picker];
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"OK");
            NSLog(@"%@",picker.date);
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
 //   [self presentViewController:alertController  animated:YES completion:nil];
    
    
}


@end
