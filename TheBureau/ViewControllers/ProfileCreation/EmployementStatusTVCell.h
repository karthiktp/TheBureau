//
//  EmployementStatusCellTableViewCell.h
//  SampleUI
//
//  Created by Sarath Neeravallil Sasi on 04/02/16.
//  Copyright © 2016 Sarath Neeravallil Sasi. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol EmployementStatusTVCellDelegate <NSObject>

- (void)updateEmployementCellHeightForEmployed;
- (void)updateEmployementCellHeightForOthers;
-(void)updateStudentOther;

@end

@interface EmployementStatusTVCell : UITableViewCell<UITextFieldDelegate>
-(void)updateBtnStatus:(NSDictionary*)dataSource;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unemployedYConstraint;

@property (weak, nonatomic) IBOutlet UIView *employmentDetailView;
@property (weak, nonatomic) IBOutlet UIButton *employedBtn;
@property (weak, nonatomic) IBOutlet UIButton *unemployedBtn;

@property (weak, nonatomic) IBOutlet UIButton *studentBtn;
@property (weak, nonatomic) IBOutlet UIButton *othersBtn;
@property(nonatomic) NSMutableDictionary *dataSourceDict;

@property (strong, nonatomic) IBOutlet UITextField *positionField;
@property (strong, nonatomic) IBOutlet UITextField *companyField;
@property (strong, nonatomic) IBOutlet UIView *studentDtView;
@property (strong, nonatomic) IBOutlet UIView *otherViw;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *stdVwheight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *otherHeightConstraint;
@property (strong, nonatomic) IBOutlet UITextField *studentTF;
@property (strong, nonatomic) IBOutlet UITextField *otherTF;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *otherBtnYconstraint;



@property (nonatomic,assign) id <EmployementStatusTVCellDelegate> delegate;


@end
