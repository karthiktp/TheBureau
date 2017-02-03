//
//  BUProfileLegalStatusInfoCell.m
//  TheBureau
//
//  Created by Manjunath on 25/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUProfileLegalStatusInfoCell.h"

@implementation BUProfileLegalStatusInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}




-(void)setDatasource:(NSMutableDictionary *)inBasicInfoDict
{
    self.legalStausrInfo = inBasicInfoDict;

    [self yearsInUSUpdate];
    [self legalStautsUpdate];
}


-(void)yearsInUSUpdate
{
    NSString *occupationStr = [self.legalStausrInfo valueForKey:@"years_in_usa"];
    
    occupationStr = occupationStr == nil ? @"" : occupationStr;
    NSInteger tag = 1;
    
    if([[[self.twoYearBtn titleLabel] text] containsString:occupationStr])
    {
        tag = 1;
    }
    else if([[[self.two_sixYearBtn titleLabel] text] containsString:occupationStr])
    {
        tag = 2;
    }
    else if([[[self.sixPlusYearBtn titleLabel] text] containsString:occupationStr])
    {
        tag = 3;
    }
    else if([[[self.bornAndRaisedBtn titleLabel] text] containsString:occupationStr])
    {
        tag = 4;
    }
    [self updateYearsInUSForTag:tag];
    
}

-(void)legalStautsUpdate
{
    NSString *occupationStr = [self.legalStausrInfo valueForKey:@"legal_status"];
    
    occupationStr = occupationStr == nil ? @"" : occupationStr;
    NSInteger tag = 1;
    
    if([[[self.US_CitizenBtn titleLabel] text] containsString:occupationStr])
    {
        tag = 1;
    }
    else if([[[self.greenCardBtn titleLabel] text] containsString:occupationStr])
    {
        tag = 2;
    }
    else if([[[self.greenCardProcessingBtn titleLabel] text] containsString:occupationStr])
    {
        tag = 3;
    }
    else if([[[self.h1VisaBtn titleLabel] text] containsString:occupationStr])
    {
        tag = 5;
    }
    else if([[[self.othersBtn titleLabel] text] containsString:occupationStr])
    {
        tag = 6;
    }
    else if([[[self.studentVisaBtn titleLabel] text] containsString:occupationStr])
    {
        tag = 4;
    }
    [self updateLegalStatusForTag:tag];

}

-(IBAction)setYearsInUs:(id)sender
{
    UIButton *setYearBtn = (UIButton *)sender;

    [self updateYearsInUSForTag:setYearBtn.tag];
}


-(void)updateYearsInUSForTag:(NSInteger)inTag
{
    
    UIButton *selectedButton;
    selectedButton = [_US_CitizenBtn copy];
    if (inTag == 1) {
        
        [_twoYearBtn setSelected:YES];
        [_sixPlusYearBtn setSelected:NO];
        [_two_sixYearBtn setSelected:NO];
        [_bornAndRaisedBtn setSelected:NO];
        
        selectedButton = _twoYearBtn;
    }
    else if (inTag == 2){
        
        [_twoYearBtn setSelected:NO];
        [_sixPlusYearBtn setSelected:NO];
        [_two_sixYearBtn setSelected:YES];
        [_bornAndRaisedBtn setSelected:NO];
        selectedButton = _two_sixYearBtn;
        
    }
    else if (inTag == 3){
        
        [_twoYearBtn setSelected:NO];
        [_sixPlusYearBtn setSelected:YES];
        [_two_sixYearBtn setSelected:NO];
        [_bornAndRaisedBtn setSelected:NO];
        selectedButton = _sixPlusYearBtn;
        
    }
    else{
        [_twoYearBtn setSelected:NO];
        [_sixPlusYearBtn setSelected:NO];
        [_two_sixYearBtn setSelected:NO];
        [_bornAndRaisedBtn setSelected:YES];
        selectedButton = _bornAndRaisedBtn;
    }
    
    [self.legalStausrInfo setValue:[[selectedButton titleLabel] text] forKey:@"years_in_usa"];
    selectedButton = nil;

}
-(IBAction)setLegalStatus:(id)sender
{
    UIButton *setLegalStatusBtn = (UIButton *)sender;
    [self updateLegalStatusForTag:setLegalStatusBtn.tag];
}

-(void)updateLegalStatusForTag:(NSInteger)inTag
{
    
    UIButton *selectedButton;
    selectedButton = [_US_CitizenBtn copy];
    if (inTag == 1) {
        [_US_CitizenBtn setSelected:YES];
        [_greenCardBtn setSelected:NO];
        [_greenCardProcessingBtn setSelected:NO];
        [_studentVisaBtn setSelected:NO];
        [_h1VisaBtn setSelected:NO];
        [_othersBtn setSelected:NO];
        
        selectedButton = _US_CitizenBtn;
    }
    else if (inTag == 2){
        [_US_CitizenBtn setSelected:NO];
        [_greenCardBtn setSelected:YES];
        [_greenCardProcessingBtn setSelected:NO];
        [_studentVisaBtn setSelected:NO];
        [_h1VisaBtn setSelected:NO];
        [_othersBtn setSelected:NO];
        
        selectedButton = _greenCardBtn;
        
    }
    else if (inTag == 3){
        
        [_US_CitizenBtn setSelected:NO];
        [_greenCardBtn setSelected:NO];
        [_greenCardProcessingBtn setSelected:YES];
        [_studentVisaBtn setSelected:NO];
        [_h1VisaBtn setSelected:NO];
        [_othersBtn setSelected:NO];
        
        selectedButton = _greenCardProcessingBtn;
        
    }
    else if (inTag == 4){
        
        [_US_CitizenBtn setSelected:NO];
        [_greenCardBtn setSelected:NO];
        [_greenCardProcessingBtn setSelected:NO];
        [_studentVisaBtn setSelected:YES];
        [_h1VisaBtn setSelected:NO];
        [_othersBtn setSelected:NO];
        
        selectedButton = _studentVisaBtn;
        
    }
    else if (inTag == 5){
        
        [_US_CitizenBtn setSelected:NO];
        [_greenCardBtn setSelected:NO];
        [_greenCardProcessingBtn setSelected:NO];
        [_studentVisaBtn setSelected:NO];
        [_h1VisaBtn setSelected:YES];
        [_othersBtn setSelected:NO];
        
        selectedButton = _h1VisaBtn;
    }
    
    else{
        [_US_CitizenBtn setSelected:NO];
        [_greenCardBtn setSelected:NO];
        [_greenCardProcessingBtn setSelected:NO];
        [_studentVisaBtn setSelected:NO];
        [_h1VisaBtn setSelected:NO];
        [_othersBtn setSelected:YES];
        
        selectedButton = _othersBtn;
    }
    
    [self.legalStausrInfo setValue:[[selectedButton titleLabel] text] forKey:@"legal_status"];
    selectedButton = nil;

}

@end
