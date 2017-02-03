//
//  LegalStatusDetails.h
//  TheBureau
//
//  Created by Ama1's iMac on 01/08/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUBaseViewController.h"
#import "BUProfileEditingVC.h"
@interface LegalStatusDetails : BUBaseViewController<UITextFieldDelegate>
@property(weak, nonatomic) IBOutlet UIView *nonEditingView,*editingView;
@property(weak, nonatomic) IBOutlet BUProfileEditingVC *parentVC;

-(void)setDatasource:(NSMutableDictionary *)inBasicInfoDict;
@property(nonatomic,weak) IBOutlet UIButton *twoYearBtn;
@property(nonatomic,weak) IBOutlet UIButton *two_sixYearBtn;
@property(nonatomic,weak) IBOutlet UIButton *sixPlusYearBtn;
@property(nonatomic,weak) IBOutlet UIButton *bornAndRaisedBtn;

@property(nonatomic,weak) IBOutlet UIButton *US_CitizenBtn;
@property(nonatomic,weak) IBOutlet UIButton *greenCardBtn;
@property(nonatomic,weak) IBOutlet UIButton *greenCardProcessingBtn;
@property(nonatomic,weak) IBOutlet UIButton *h1VisaBtn;
@property(nonatomic,weak) IBOutlet UIButton *othersBtn;
@property(nonatomic,weak) IBOutlet UIButton *studentVisaBtn;
@property (strong, nonatomic) IBOutlet UIButton *headerBtn;
@property (strong, nonatomic) IBOutlet UITextField *othersTextField;
@property (strong, nonatomic) IBOutlet UILabel *provideStatus;
@property (strong, nonatomic) IBOutlet UILabel *colon;
@property (strong, nonatomic) IBOutlet UILabel *underLine;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *greenCardProcessingLabel;

@property (strong, nonatomic) NSMutableDictionary *legalStausrInfo;
@end
