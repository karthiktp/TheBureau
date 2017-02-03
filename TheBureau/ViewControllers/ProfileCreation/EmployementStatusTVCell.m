//
//  EmployementStatusCellTableViewCell.m
//  SampleUI
//
//  Created by Sarath Neeravallil Sasi on 04/02/16.
//  Copyright © 2016 Sarath Neeravallil Sasi. All rights reserved.
//

#import "EmployementStatusTVCell.h"
#import "BUConstants.h"
#define UNEMPLOYEDYCONSTANTBEFOREDETAILVIEW  4.0
#define UNEMPLOYEDYCONSTANTAFTERDETAILVIEW   94.0


@implementation EmployementStatusTVCell

- (void)awakeFromNib
{
    self.unemployedYConstraint.constant = UNEMPLOYEDYCONSTANTBEFOREDETAILVIEW;
    self.employmentDetailView.hidden = YES;
}

-(void)updateBtnStatus:(NSDictionary*)dataSource {
    NSLog(@"%@",[dataSource objectForKey:@"employment_status"]);
    
    if (![[dataSource objectForKey:@"employment_status"] isEqualToString:@""]) {
        if ([[dataSource objectForKey:@"employment_status"] isEqualToString:@"Employed"]) {
            self.unemployedYConstraint.constant = UNEMPLOYEDYCONSTANTAFTERDETAILVIEW;
            self.employmentDetailView.hidden = NO;
            
            [self.employedBtn setSelected:YES];
            [self.othersBtn setSelected:NO];
            [self.unemployedBtn setSelected:NO];
            [self.studentBtn setSelected:NO];
            
            self.positionField.text = [dataSource objectForKey:@"position_title"];
            self.companyField.text = [dataSource objectForKey:@"company"];
            
            [self.delegate updateEmployementCellHeightForEmployed];
        }
        else if ([[dataSource objectForKey:@"employment_status"] isEqualToString:@"Unemployed"]) {
            if(!self.employmentDetailView.hidden)
            {
                self.unemployedYConstraint.constant = UNEMPLOYEDYCONSTANTBEFOREDETAILVIEW;
                self.employmentDetailView.hidden = YES;
                
                [self.delegate updateEmployementCellHeightForOthers];
            }
            [self.employedBtn setSelected:NO];
            [self.othersBtn setSelected:NO];
            [self.unemployedBtn setSelected:YES];
            [self.studentBtn setSelected:NO];
        }
        else if ([[dataSource objectForKey:@"employment_status"] isEqualToString:@"Student"]) {
            
            if(!self.employmentDetailView.hidden)
            {
                self.unemployedYConstraint.constant = UNEMPLOYEDYCONSTANTBEFOREDETAILVIEW;
                self.employmentDetailView.hidden = YES;
            
                [self.delegate updateEmployementCellHeightForOthers];
            }
            [self.delegate updateStudentOther];
            
            self.studentDtView.hidden = NO;
            self.stdVwheight.constant = 32;
            self.otherBtnYconstraint.constant = 36;
            
            [self.employedBtn setSelected:NO];
            [self.othersBtn setSelected:NO];
            [self.unemployedBtn setSelected:NO];
            [self.studentBtn setSelected:YES];
        }
        else if ([[dataSource objectForKey:@"employment_status"] isEqualToString:@"Other"]) {
            if(!self.employmentDetailView.hidden)
            {
                self.unemployedYConstraint.constant = UNEMPLOYEDYCONSTANTBEFOREDETAILVIEW;
                self.employmentDetailView.hidden = YES;
                
                [self.delegate updateEmployementCellHeightForOthers];
            }
             [self.delegate updateStudentOther];
             
            self.otherViw.hidden = NO;
            self.otherHeightConstraint.constant = 32;
            self.otherBtnYconstraint.constant = 2;
            
            [self.employedBtn setSelected:NO];
            [self.othersBtn setSelected:YES];
            [self.unemployedBtn setSelected:NO];
            [self.studentBtn setSelected:NO];
        }
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}

- (IBAction)employementStatusButtonTapped:(id)sender
{
    UIButton *employementStatusButton = (UIButton *)sender;
    
    switch (employementStatusButton.tag)
    {
        case EmployementStatusEmployed:
        {
            [self.studentTF resignFirstResponder];
            [self.otherTF resignFirstResponder];
            
            self.unemployedYConstraint.constant = UNEMPLOYEDYCONSTANTAFTERDETAILVIEW;
            self.employmentDetailView.hidden = NO;
            
            [self.employedBtn setSelected:YES];
            [self.othersBtn setSelected:NO];
            [self.unemployedBtn setSelected:NO];
            [self.studentBtn setSelected:NO];
//            self.stdVwheight.constant = 34;
//            self.otherHeightConstraint.constant = 34;
            self.studentDtView.hidden = YES;
            self.otherViw.hidden = YES;
            self.otherBtnYconstraint.constant = 4;
            [self.delegate updateEmployementCellHeightForEmployed];

            break;
        }
        case EmployementStatusUnEmployed:
        {
            [self.studentTF resignFirstResponder];
            [self.otherTF resignFirstResponder];
            
            if(!self.employmentDetailView.hidden)
            {
                self.unemployedYConstraint.constant = UNEMPLOYEDYCONSTANTBEFOREDETAILVIEW;
                self.employmentDetailView.hidden = YES;
              
                
                [self.delegate updateEmployementCellHeightForOthers];
            }
            
            if (!self.studentDtView.hidden || !self.otherViw.hidden) {
                
               [self.delegate updateEmployementCellHeightForOthers];
            }
            
            
            [self.employedBtn setSelected:NO];
            [self.othersBtn setSelected:NO];
            [self.unemployedBtn setSelected:YES];
            [self.studentBtn setSelected:NO];
//            self.stdVwheight.constant = 34;
//            self.otherHeightConstraint.constant = 34;
            self.otherBtnYconstraint.constant = 4;
            self.studentDtView.hidden = YES;
            self.otherViw.hidden = YES;
            break;
        }
        case EmployementStatusStudent:
        {
            
            if(!self.employmentDetailView.hidden)
            {
                self.unemployedYConstraint.constant = UNEMPLOYEDYCONSTANTBEFOREDETAILVIEW;
                self.employmentDetailView.hidden = YES;

                [self.delegate updateEmployementCellHeightForOthers];
            }
            [self.delegate updateStudentOther];
             self.studentDtView.hidden = NO;
             self.stdVwheight.constant = 32;
             self.otherBtnYconstraint.constant = 36;
             self.otherViw.hidden = YES;
            [self.employedBtn setSelected:NO];
            [self.othersBtn setSelected:NO];
            [self.unemployedBtn setSelected:NO];
            [self.studentBtn setSelected:YES];
            self.studentTF.tag = 100;// for Student Textfield Identify
            [self.studentTF becomeFirstResponder];
            self.otherTF.text = @"";
            break;
        }
        case EmployementStatusOthers:
        {
            if(!self.employmentDetailView.hidden)
            {
                self.unemployedYConstraint.constant = UNEMPLOYEDYCONSTANTBEFOREDETAILVIEW;
                self.employmentDetailView.hidden = YES;
                [self.delegate updateEmployementCellHeightForOthers];
            }
            [self.delegate updateStudentOther];
            self.otherViw.hidden = NO;
            self.otherHeightConstraint.constant = 32;
            self.otherBtnYconstraint.constant = 2;
             self.studentDtView.hidden = YES;
            [self.employedBtn setSelected:NO];
            [self.othersBtn setSelected:YES];
            [self.unemployedBtn setSelected:NO];
            [self.studentBtn setSelected:NO];
            self.otherTF.tag = 101;// for Other Textfield Identify
            self.studentTF.text = @"";
            [self.otherTF becomeFirstResponder];

            break;
        }
        default: break;
    }
    
    [self.dataSourceDict setValue:[employementStatusButton.titleLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"employment_status"];

    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
        switch(textField.tag)
        {
            case 0:
            {
                [self.dataSourceDict setValue:textField.text forKey:@"position_title"];
                break;
            }
            case 1:
            {
                [self.dataSourceDict setValue:textField.text forKey:@"company"];
                break;
            }
            case 2:
            {
                [self.dataSourceDict setValue:textField.text forKey:@"occupation_student"];
                

                break;
            }
            case 3:
            {
                [self.dataSourceDict setValue:textField.text forKey:@"occupation_other"];
                break;
            }
        }
    [textField resignFirstResponder];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

@end
