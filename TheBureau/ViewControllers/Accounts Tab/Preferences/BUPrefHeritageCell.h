//
//  BUPrefHeritageCell.h
//  TheBureau
//
//  Created by Manjunath on 18/03/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWCustomPickerView.h"
#import "BUCustomPickerView.h"
#import "BUPreferencesVC.h"
#import "BUWebServicesManager.h"
@interface BUPrefHeritageCell : UITableViewCell<PWPickerViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property(weak, nonatomic) IBOutlet BUPreferencesVC *prefVC;

@property(nonatomic, strong) BUCustomPickerView *customPickerView;
@property(nonatomic, strong) NSMutableArray *religionIDList,*famliyIDList,*motherToungueIDList;
@property(nonatomic, strong) NSMutableArray *religionList,*famliyList,*motherToungueList,*mTongSelList,*relgSelList;

@property(nonatomic, strong) IBOutlet UITextField *religionTF,*motherToungueTF,*specificationTF,*gothraTF,*familyOriginTF;

@property(nonatomic) eHeritageList heritageList;
@property(nonatomic, assign) BOOL isUpdatingProfile;

@property (strong, nonatomic) NSMutableDictionary *heritageDict;

-(void)setDatasource:(NSMutableDictionary *)inBasicInfoDict;
-(void)setPreference:(NSMutableDictionary *)inBasicInfoDict;


@property(nonatomic, strong) NSMutableArray *relList,*famList,*mToungList;
@end
