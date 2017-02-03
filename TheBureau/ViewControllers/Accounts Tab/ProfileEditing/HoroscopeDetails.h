//
//  HoroscopeDetails.h
//  TheBureau
//
//  Created by Ama1's iMac on 29/07/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BUProfileEditingVC.h"
#import "BUImagePreviewVC.h"

@interface HoroscopeDetails : BUBaseViewController<UITextViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property(weak, nonatomic) IBOutlet BUProfileEditingVC *parentVC;


@property(weak, nonatomic) IBOutlet UITextView *aboutMeTextView;
@property(weak, nonatomic) IBOutlet UITextField *tobLabel,*dobLabel,*locLabel;

@property(weak, nonatomic) IBOutlet UIButton *uploadBtn, *viewBtn, *deleteBtn;
@property(nonatomic, strong) NSMutableDictionary *horoscopeDict;
@property (strong, nonatomic) IBOutlet UIButton *headerBtn;
@property BOOL isHoroscope;
@property(weak, nonatomic) BUImagePreviewVC *imagePreviewVC;

//-(void)setDatasource:(NSMutableDictionary *)inBasicInfoDict;
-(IBAction)setDOB:(id)sender;
-(IBAction)setTOB:(id)sender;
-(IBAction)uploadHoroscope:(id)sender;
@end
