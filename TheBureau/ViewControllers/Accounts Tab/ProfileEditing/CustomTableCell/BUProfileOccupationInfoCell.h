//
//  BUProfileOccupationInfoCell.h
//  TheBureau
//
//  Created by Manjunath on 25/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BUProfileEditingVC.h"

@interface BUProfileOccupationInfoCell : UITableViewCell<UITextFieldDelegate>
@property(weak, nonatomic) IBOutlet UIView *nonEditingView,*editingView;
@property(weak, nonatomic) IBOutlet BUProfileEditingVC *parentVC;

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


-(void)setDatasource:(NSMutableDictionary *)inBasicInfoDict;
@end
