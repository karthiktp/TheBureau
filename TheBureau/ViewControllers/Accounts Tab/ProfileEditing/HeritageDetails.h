//
//  HeritageDetails.h
//  TheBureau
//
//  Created by Ama1's iMac on 01/08/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUBaseViewController.h"
#import "BUProfileEditingVC.h"
#import "PWCustomPickerView.h"
#import "BUPreferencesVC.h"
@interface HeritageDetails : BUBaseViewController<PWPickerViewDelegate,UITextFieldDelegate>
@property(weak, nonatomic) IBOutlet BUProfileEditingVC *parentVC;

@property(weak, nonatomic) IBOutlet BUPreferencesVC *prefVC;

@property(nonatomic, strong) PWCustomPickerView *customPickerView;
@property(nonatomic, strong) NSString *religionID,*famliyID,*specificationID,*motherToungueID;

@property(nonatomic, strong) IBOutlet UITextField *religionTF,*motherToungueTF,*specificationTF,*gothraTF,*familyOriginTF;

@property(nonatomic) eHeritageList heritageList;
@property(nonatomic, assign) BOOL isUpdatingProfile;

@property (strong, nonatomic) NSMutableDictionary *heritageDict;
@property (strong, nonatomic) IBOutlet UIButton *headerBtn;
@end
