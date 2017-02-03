//
//  HoroscopeDetails.m
//  TheBureau
//
//  Created by Ama1's iMac on 29/07/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "HoroscopeDetails.h"
#import "UIView+FLKAutoLayout.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"

@interface HoroscopeDetails ()
@property (strong, nonatomic) IBOutlet UIView *aboutMeView;
@property (strong, nonatomic) IBOutlet UIView *dobView;
@property (strong, nonatomic) IBOutlet UIView *tobView;
@property (strong, nonatomic) IBOutlet UIView *lobView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *aboutmeHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *aboutmeViewHtConstraint;

@end

@implementation HoroscopeDetails

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(editProfileDetails:)];
    
    self.aboutMeTextView.delegate = self;
    self.aboutMeTextView.layer.borderColor = [[UIColor blackColor]CGColor];
    self.aboutMeTextView.layer.borderWidth = 1.0;
    self.aboutMeTextView.layer.cornerRadius = 5.0;
    // Do any additional setup after loading the view.
    
    self.dobLabel.text  =  [[self.horoscopeDict valueForKey:@"horoscope_dob"] isEqualToString:@""] ? [[NSUserDefaults standardUserDefaults]objectForKey:@"uDOB"] : [self.horoscopeDict valueForKey:@"horoscope_dob"];
    
    self.tobLabel.text  = [self.horoscopeDict valueForKey:@"horoscope_tob"];
    self.locLabel.text  = [self.horoscopeDict valueForKey:@"horoscope_lob"];
    self.aboutMeTextView.text  = [self.horoscopeDict valueForKey:@"about_me"];
    
    if (([[self.horoscopeDict valueForKey:@"horoscope_path"] isKindOfClass:[UIImage class]])) {
        self.uploadBtn.hidden = YES;
        self.viewBtn.hidden = NO;
        self.deleteBtn.hidden = NO;
    }
    else if ((nil != [self.horoscopeDict valueForKey:@"horoscope_path"]) && (NO == [[self.horoscopeDict valueForKey:@"horoscope_path"] isEqualToString:@""])) {
        self.uploadBtn.hidden = YES;
        self.viewBtn.hidden = NO;
        self.deleteBtn.hidden = NO;
    }
    else {
        self.uploadBtn.hidden = NO;
        self.viewBtn.hidden = YES;
        self.deleteBtn.hidden = YES;
    }
    
    if (_isHoroscope == YES) {
        self.title = @"Horoscope";
        self.aboutMeView.hidden = YES;
    }
    else {
        self.title = @"About Me";
        _aboutmeHeightConstraint.constant = 20;
        self.aboutmeViewHtConstraint.constant = 107;
        self.dobView.hidden = YES;
        self.tobView.hidden = YES;
        self.lobView.hidden = YES;
        self.uploadBtn.hidden = YES;
        self.viewBtn.hidden = YES;
        self.deleteBtn.hidden = YES;
    }
    
}

- (IBAction)editProfileDetails:(id)sender
{
    [self.view endEditing:YES];
    [self updateProfile];
    //    [self.profileTableView reloadData];
}

-(void)updateProfile
{
    
//    [self.profileImageCell saveProfileImages];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    
//    [parameters addEntriesFromDictionary:self.basicInfoDict];
//    [parameters addEntriesFromDictionary:self.educationDict];
//    [parameters addEntriesFromDictionary:self.occupationDict];
    [parameters addEntriesFromDictionary:self.horoscopeDict];
//    [parameters addEntriesFromDictionary:self.socialHabitsDict];
//    [parameters addEntriesFromDictionary:self.legalStatus];
//    [parameters addEntriesFromDictionary:self.heritageDict];
    [parameters setValue:[BUWebServicesManager sharedManager].userID forKey:@"userid"];
    
    [self startActivityIndicator:YES];
    
    [[BUWebServicesManager sharedManager] queryServer:parameters
                                              baseURL:@"profile/update"
                                         successBlock:^(id response, NSError *error)
     {
         [self stopActivityIndicator];
         
         
         NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"Profile updated"];
         [message addAttribute:NSFontAttributeName
                         value:[UIFont fontWithName:@"comfortaa" size:15]
                         range:NSMakeRange(0, message.length)];
         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
         [alertController setValue:message forKey:@"attributedTitle"];
         
         [alertController addAction:({
             UIAlertAction *action = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                 NSLog(@"OK");
                 [self.navigationController popViewControllerAnimated:YES];
             }];
             
             action;
         })];
         
         [self presentViewController:alertController  animated:YES completion:nil];
         
     }
                                         failureBlock:^(id response, NSError *error)
     {
         [self stopActivityIndicator];
         if (error.code == NSURLErrorTimedOut) {
             
             [self showAlert:@"Connection timed out, please try again later"];
         }
         else
         {
             [self showAlert:@"Connectivity Error"];
         }
     }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    //[self.parentVC hideKeyBoard123];
}

-(void)showKeyBoard:(BOOL)inBool
{
    //    CGFloat constant = 0;
    //    if(NO == inBool)
    //    {
    //        constant = 58;
    //    }
    //    else
    //    {
    //        constant = 320;
    //    }
    //
    //    self.textViewBottomConstraint.constant = constant;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.horoscopeDict setValue:textField.text forKey:@"horoscope_lob"];
}


- (void)textViewDidEndEditing:(UITextView *)textView;
{
    [self.horoscopeDict setValue:textView.text forKey:@"about_me"];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
    textView.text = [textView.text stringByReplacingOccurrencesOfString:@"Your text here ..." withString:@""];
    //[self.parentVC performSelector:@selector(showKeyboard123) withObject:nil afterDelay:1.0];
    return YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
    if(range.location == 250)
        return NO;
    //    NSLog(@"Range ==> %@",NSStringFromRange(range));
    return YES;
}


//-(void)setDatasource:(NSMutableDictionary *)inBasicInfoDict
//{
//    
//    self.horoscopeDict = inBasicInfoDict;
//    
//    self.dobLabel.text  =  [[inBasicInfoDict valueForKey:@"horoscope_dob"] isEqualToString:@""] ? [[NSUserDefaults standardUserDefaults]objectForKey:@"uDOB"] : [inBasicInfoDict valueForKey:@"horoscope_dob"];
//    
//    self.tobLabel.text  = [inBasicInfoDict valueForKey:@"horoscope_tob"];
//    self.locLabel.text  = [inBasicInfoDict valueForKey:@"horoscope_lob"];
//    self.aboutMeTextView.text  = [inBasicInfoDict valueForKey:@"about_me"];
//    
//    if((nil != [self.horoscopeDict valueForKey:@"horoscope_path"]) && (NO == [[self.horoscopeDict valueForKey:@"horoscope_path"] isEqualToString:@""]))
//    {
//        //[self.uploadBtn setTitle:@"View Horoscope" forState:UIControlStateNormal];
//        
//        self.uploadBtn.hidden = YES;
//        self.viewBtn.hidden = NO;
//        self.deleteBtn.hidden = NO;
//        
//    }
//    else
//    {
//        //[self.uploadBtn setTitle:@"Upload Horoscope" forState:UIControlStateNormal];
//        self.uploadBtn.hidden = NO;
//        self.viewBtn.hidden = YES;
//        self.deleteBtn.hidden = YES;
//    }
//    
//}

-(IBAction)setDOB:(id)sender
{
    
    [self.view endEditing:YES];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Birthday\n\n\n\n\n\n\n" message:@"\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
    UIDatePicker *picker = [[UIDatePicker alloc] init];
    [picker setDatePickerMode:UIDatePickerModeDate];
    [alertController.view addSubview:picker];
    
    [picker alignCenterYWithView:alertController.view predicate:@"0.0"];
    [picker alignCenterXWithView:alertController.view predicate:@"0.0"];
    [picker constrainWidth:@"270" ];
    //
    
    
    
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    [comps setMonth:1];
    [comps setYear:1990];
    NSDate *currentDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    
    
    NSDate *todayDate = [NSDate date];
    NSDate *newDate = [todayDate dateByAddingTimeInterval:(-1*18*365*24*60*60)];
    picker.maximumDate = newDate;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-yyyy"];
    
    if ([self.dobLabel.text isEqualToString:@""]) {
        picker.date = currentDate;
    }
    else {
        picker.date = [dateFormat dateFromString:self.dobLabel.text];
    }
    
    
    
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                 {
                                     NSLog(@"OK");
                                     NSLog(@"%@",picker.date);
                                     
                                     NSString *dateString = [dateFormat stringFromDate:picker.date];
                                     self.dobLabel.text = dateString;
                                     [self.horoscopeDict setValue:dateString forKey:@"horoscope_dob"];
                                 }];
        action;
    })];
    
    [alertController addAction:(
                                {
                                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                        NSLog(@"Cancel");
                                        //NSLog(@"%@",picker.date);
                                    }];
                                    action;
                                })];
    [self presentViewController:alertController  animated:YES completion:nil];
}
-(IBAction)setTOB:(id)sender
{
    
    [self.view endEditing:YES];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Time of Birth\n\n\n\n\n\n\n" message:@"\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
    UIDatePicker *picker = [[UIDatePicker alloc] init];
    [picker setDatePickerMode:UIDatePickerModeDate];
    [alertController.view addSubview:picker];
    
    [picker alignCenterYWithView:alertController.view predicate:@"0.0"];
    [picker alignCenterXWithView:alertController.view predicate:@"0.0"];
    [picker constrainWidth:@"270" ];
    //
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    [comps setMonth:1];
    [comps setYear:1990];
    NSDate *currentDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    
    picker.date = currentDate;
    picker.datePickerMode = UIDatePickerModeTime;
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                 {
                                     NSLog(@"OK");
                                     NSLog(@"%@",picker.date);
                                     
                                     
                                     NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                                     [dateFormat setDateFormat:@"HH:mm"];
                                     NSString *dateString = [dateFormat stringFromDate:picker.date];
                                     self.tobLabel.text = dateString;
                                     [self.horoscopeDict setValue:dateString forKey:@"horoscope_tob"];
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
    [self presentViewController:alertController  animated:YES completion:nil];
}
-(IBAction)uploadHoroscope:(id)sender
{
    
    if((nil != [self.horoscopeDict valueForKey:@"horoscope_path"]) && ([[self.horoscopeDict valueForKey:@"horoscope_path"] isKindOfClass:[UIImage class]])) {
        UIStoryboard *sb =[UIStoryboard storyboardWithName:@"HomeView" bundle:nil];
        self.imagePreviewVC = [sb instantiateViewControllerWithIdentifier:@"BUImagePreviewVC"];
        self.imagePreviewVC.imagesList = [[NSMutableArray alloc] initWithObjects:[self.horoscopeDict valueForKey:@"horoscope_path"], nil];
        self.imagePreviewVC.indexPathToScroll = [NSIndexPath indexPathForRow:0 inSection:0];
        [self presentViewController:self.imagePreviewVC animated:NO completion:nil];
    }
    else if((nil != [self.horoscopeDict valueForKey:@"horoscope_path"]) && (NO == [[self.horoscopeDict valueForKey:@"horoscope_path"] isEqualToString:@""]))
    {
        UIStoryboard *sb =[UIStoryboard storyboardWithName:@"HomeView" bundle:nil];
        self.imagePreviewVC = [sb instantiateViewControllerWithIdentifier:@"BUImagePreviewVC"];
        self.imagePreviewVC.imagesList = [[NSMutableArray alloc] initWithObjects:[self.horoscopeDict valueForKey:@"horoscope_path"], nil];
        self.imagePreviewVC.indexPathToScroll = [NSIndexPath indexPathForRow:0 inSection:0];
        [self presentViewController:self.imagePreviewVC animated:NO completion:nil];
    }
    else
    {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Photo Library",@"Cancel", nil];
        
        [actionSheet showInView:self.view];
        
       /* UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.allowsEditing = YES;
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];*/
        
    }
}


#pragma mark - ActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    
    if (buttonIndex == 2)
    {
        return;
    }
    else
    {
        __block UIImagePickerController *weakImagePicker = [[UIImagePickerController alloc] init];
        __weak UIViewController *weakself = self;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            weakImagePicker.allowsEditing = YES;
            weakImagePicker.delegate = self;
            if ( [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]&& buttonIndex == 0){
                weakImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            }
            else{
                weakImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                
            }
            weakImagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
            [weakself presentViewController:weakImagePicker animated:YES completion:nil];
        }];
    }
}

-(IBAction)deleteHoroscope:(id)sender {
    [self.horoscopeDict setValue:@"" forKey:@"horoscope_path"];
    
    [self startActivityIndicator:YES];
    NSDictionary *parameters = @{@"userid": [BUWebServicesManager sharedManager].userID};
    [[BUWebServicesManager sharedManager] queryServer:parameters
                                              baseURL:@"profile/deleteHoroscope"
                                         successBlock:^(id response, NSError *error)
     {

         [self stopActivityIndicator];
         [self showAlert:[response objectForKey:@"response"]];
         //  UIPopoverPresentationController *popoverController = alertController.popoverPresentationController;
         //  popoverController.sourceView = sender;
         //   popoverController.sourceRect = [sender bounds];
         //         {"msg":"Success","response":"Horoscope Deleted Successfully"}
         //
         //         Response on failure:
         //         {"msg":"Error","response":"Horoscope could not be Deleted"}
         
         
         if ([[response objectForKey:@"msg"] isEqualToString:@"Success"]) {
             [self.horoscopeDict setValue:@"" forKey:@"horoscope_path"];
         }
         
         if((nil != [self.horoscopeDict valueForKey:@"horoscope_path"]) && ([[self.horoscopeDict valueForKey:@"horoscope_path"] isKindOfClass:[UIImage class]])) {
             self.uploadBtn.hidden = YES;
             self.viewBtn.hidden = NO;
             self.deleteBtn.hidden = NO;
         }
         else if((nil != [self.horoscopeDict valueForKey:@"horoscope_path"]) && (NO == [[self.horoscopeDict valueForKey:@"horoscope_path"] isEqualToString:@""]))
         {
             //[self.uploadBtn setTitle:@"View Horoscope" forState:UIControlStateNormal];
             
             self.uploadBtn.hidden = YES;
             self.viewBtn.hidden = NO;
             self.deleteBtn.hidden = NO;
             
         }
         else
         {
             //[self.uploadBtn setTitle:@"Upload Horoscope" forState:UIControlStateNormal];
             self.uploadBtn.hidden = NO;
             self.viewBtn.hidden = YES;
             self.deleteBtn.hidden = YES;
         }
         
     }
                                             failureBlock:^(id response, NSError *error)
     
     {
         
         [self stopActivityIndicator];
         if (error.code == NSURLErrorTimedOut) {
             
             [self showAlert:@"Connection timed out, please try again later"];
         }
         else
         {
             [self showFailureAlert];
         }
         
         
     }];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Are you sure to Upload this image?\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 70, 250, 250)];
    
    imageView.image = image;
    
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    
    [alertController.view addSubview:imageView];
    
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"OK");
            
            [self.horoscopeDict setValue:[info objectForKey:UIImagePickerControllerEditedImage] forKey:@"horoscope_path"];
            
            [self startActivityIndicator:YES];
            [[BUWebServicesManager sharedManager] uploadHoroscope:[info objectForKey:UIImagePickerControllerEditedImage] successBlock:^(id response, NSError *error)
             {
                 [self stopActivityIndicator];
                 
                 if((nil != [self.horoscopeDict valueForKey:@"horoscope_path"]) && ([[self.horoscopeDict valueForKey:@"horoscope_path"] isKindOfClass:[UIImage class]]))
                 {
                     // do somthing
                     self.uploadBtn.hidden = YES;
                     self.viewBtn.hidden = NO;
                     self.deleteBtn.hidden = NO;
                 }
                 else if((nil != [self.horoscopeDict valueForKey:@"horoscope_path"]) && (NO == [[self.horoscopeDict valueForKey:@"horoscope_path"] isEqualToString:@""]))
                 {
                     //[self.uploadBtn setTitle:@"View Horoscope" forState:UIControlStateNormal];
                     
                     self.uploadBtn.hidden = YES;
                     self.viewBtn.hidden = NO;
                     self.deleteBtn.hidden = NO;
                     
                 }
                 else
                 {
                     //[self.uploadBtn setTitle:@"Upload Horoscope" forState:UIControlStateNormal];
                     self.uploadBtn.hidden = NO;
                     self.viewBtn.hidden = YES;
                     self.deleteBtn.hidden = YES;
                 }
                 
             }
                                                     failureBlock:^(id response, NSError *error)
             {
                 [self.horoscopeDict setValue:nil forKey:@"horoscope_path"];
                 
                 [self stopActivityIndicator];
             }];
            
        }];
        action;
    })];
    
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"Cancel");
        }];
        action;
    })];
    [self presentViewController:alertController  animated:YES completion:nil];
    
    
}

- (void)didReceiveMemoryWarning {
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

@end
