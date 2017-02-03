//
//  BUProfileOccupationInfoCell.m
//  TheBureau
//
//  Created by Manjunath on 25/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUProfileOccupationInfoCell.h"
#import "BUConstants.h"
@implementation BUProfileOccupationInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
if([textField tag] == 0)
    [self.occupationInfoDict setValue:self.positionTitleTF.text forKey:@"position_title"];
else
    [self.occupationInfoDict setValue:self.companyTF.text forKey:@"company"];
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([textField tag] == 0)
        [self.occupationInfoDict setValue:self.positionTitleTF.text forKey:@"position_title"];
    else
        [self.occupationInfoDict setValue:self.companyTF.text forKey:@"company"];
    [textField resignFirstResponder];
}

-(void)setDatasource:(NSMutableDictionary *)inBasicInfoDict
{
    NSString *occupationStr = [inBasicInfoDict valueForKey:@"employment_status"];
    
    occupationStr = occupationStr == nil ? @"" : occupationStr;
    EmployementStatus tag = EmployementStatusEmployed;
    
    if([[[self.employedBtn titleLabel] text] containsString:occupationStr])
    {
        tag = EmployementStatusEmployed;
    }
    else if([[[self.unemployedBtn titleLabel] text] containsString:occupationStr])
    {
        tag = EmployementStatusUnEmployed;
    }
    else if([[[self.studentBtn titleLabel] text] containsString:occupationStr])
    {
        tag = EmployementStatusStudent;
    }
    else
    {
        tag = EmployementStatusOthers;
    }
    [self updateOccupation:tag];
    
    
    self.positionTitleTF.text = [inBasicInfoDict valueForKey:@"position_title"];
    self.positionTitleTF.tag = 0;
    self.positionTitleTF.delegate = self;
    self.companyTF.text = [inBasicInfoDict valueForKey:@"company"];
    self.companyTF.tag = 1;
    self.companyTF.delegate = self;
    
    self.occupationInfoDict = inBasicInfoDict;
}


#pragma mark -Occupation

- (IBAction)employementStatusButtonTapped:(id)sender
{
    [self updateOccupation:[sender tag]];
}

-(void)updateOccupation:(EmployementStatus)inTag
{
    
    self.positionTitleTF.enabled = YES;
    self.companyTF.enabled = YES;

    switch (inTag)
    {
        case EmployementStatusEmployed:
        {
            [self.employedBtn setSelected:YES];
            [self.othersBtn setSelected:NO];
            [self.unemployedBtn setSelected:NO];
            [self.studentBtn setSelected:NO];
            [self.occupationInfoDict setValue:[[[self.employedBtn titleLabel] text] stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"employment_status"];
            break;
        }
        case EmployementStatusUnEmployed:
        {
            [self.employedBtn setSelected:NO];
            [self.othersBtn setSelected:NO];
            [self.unemployedBtn setSelected:YES];
            [self.studentBtn setSelected:NO];
            [self.occupationInfoDict setValue:[[[self.unemployedBtn titleLabel] text] stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"employment_status"];
            
            self.positionTitleTF.enabled = NO;
            self.companyTF.enabled = NO;

            
            self.positionTitleTF.text = @"";
            self.companyTF.text = @"";

            break;
        }
        case EmployementStatusStudent:
        {
            [self.employedBtn setSelected:NO];
            [self.othersBtn setSelected:NO];
            [self.unemployedBtn setSelected:NO];
            [self.studentBtn setSelected:YES];
            [self.occupationInfoDict setValue:[[[self.studentBtn titleLabel] text] stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"employment_status"];

            self.positionTitleTF.enabled = NO;
            self.companyTF.enabled = NO;
            
            self.positionTitleTF.text = @"";
            self.companyTF.text = @"";

            break;
        }
        case EmployementStatusOthers:
        {
            [self.employedBtn setSelected:NO];
            [self.othersBtn setSelected:YES];
            [self.unemployedBtn setSelected:NO];
            [self.studentBtn setSelected:NO];
            [self.occupationInfoDict setValue:[[[self.othersBtn titleLabel] text] stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"employment_status"];
            
            self.positionTitleTF.enabled = NO;
            self.companyTF.enabled = NO;
            
            self.positionTitleTF.text = @"";
            self.companyTF.text = @"";
            break;
        }
        default: break;
    }
    
    [self.occupationInfoDict setValue:self.positionTitleTF.text forKey:@"position_title"];
    [self.occupationInfoDict setValue:self.companyTF.text forKey:@"company"];

}
@end
