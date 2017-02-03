//
//  OccupationDetails.h
//  TheBureau
//
//  Created by Ama1's iMac on 01/08/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUBaseViewController.h"
#import "BUProfileEditingVC.h"

@interface OccupationDetails : BUBaseViewController
@property(weak, nonatomic) IBOutlet UIView *nonEditingView,*editingView;

#pragma mark -
#pragma mark - Social habits

@property (weak, nonatomic) IBOutlet UIView *employmentDetailView;
@property (weak, nonatomic) IBOutlet UIButton *employedBtn;
@property (weak, nonatomic) IBOutlet UIButton *unemployedBtn;
@property (weak, nonatomic) IBOutlet UIButton *studentBtn;
@property (weak, nonatomic) IBOutlet UIButton *othersBtn;
@property (weak, nonatomic) IBOutlet UITextField *positionTitleTF,*companyTF;
@property (strong, nonatomic) NSMutableDictionary *occupationInfoDict;
@property (strong, nonatomic) IBOutlet UIButton *headerBtn;
@end
