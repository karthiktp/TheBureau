//
//  BUProfileLegalStatusInfoCell.h
//  TheBureau
//
//  Created by Manjunath on 25/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BUProfileEditingVC.h"

@interface BUProfileLegalStatusInfoCell : UITableViewCell<UITextFieldDelegate>
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

@property (strong, nonatomic) NSMutableDictionary *legalStausrInfo;
@end
