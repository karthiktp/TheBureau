//
//  BUProfileSocialHabitsInfoCell.m
//  TheBureau
//
//  Created by Manjunath on 25/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUProfileSocialHabitsInfoCell.h"
#import "BUConstants.h"
@implementation BUProfileSocialHabitsInfoCell

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

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
-(void)setDatasource:(NSMutableDictionary *)inBasicInfoDict
{
    self.socialHabitsDict = inBasicInfoDict;
    [self dietUpdate];
    [self updateSmoking];
    [self updateDrinking];
}


-(void)updateSmoking
{
    NSString *occupationStr = [self.socialHabitsDict valueForKey:@"smoking"];
    occupationStr = occupationStr == nil ? @"" : occupationStr;
    NSInteger tag = 1;
    if([[self.yesLabel text] containsString:occupationStr])
    {
        tag = 1;
    }
    else
    {
        tag = 0;
    }
    [self updateSmokingForTag:tag];
}

-(void)updateDrinking
{
    NSString *occupationStr = [self.socialHabitsDict valueForKey:@"drinking"];
    occupationStr = occupationStr == nil ? @"" : occupationStr;
    NSInteger tag = 1;
    if([[self.sociallyLabel text] containsString:occupationStr])
    {
        tag = 0;
    }
    else
    {
        tag = 1;
    }
    [self updateDrinkingForTag:tag];
}

-(void)dietUpdate
{
    NSString *occupationStr = [self.socialHabitsDict valueForKey:@"diet"];
    occupationStr = occupationStr == nil ? @"" : occupationStr;
    NSInteger tag = 1;
    
    if([[[_vegetarianBtn titleLabel] text] containsString:occupationStr])
    {
        tag = ButtonTypeVegetarian;
    }
    else if([[[_eegetarianBtn titleLabel] text] containsString:occupationStr])
    {
        tag = ButtonTypeEegetarian;
    }
    else if([[[_nonVegetarianBtn titleLabel] text] containsString:occupationStr])
    {
        tag = ButtonTypeNonvegetarian;
    }
    else if([[[_veganBtn titleLabel] text] containsString:occupationStr])
    {
        tag = ButtonTypeVegan;
    }
    [self updateDietForTag:tag];
}

#pragma mark -
#pragma mark - Social habits

-(void)updateDietForTag:(NSInteger)inTag
{
    UIButton *selectedBtn;
    if (inTag == ButtonTypeVegetarian)
    {
        selectedBtn = _vegetarianBtn;
        [_vegetarianBtn setSelected:YES];
        [_eegetarianBtn setSelected:NO];
        [_nonVegetarianBtn setSelected:NO];
        [_veganBtn setSelected:NO];
    }
    else if (inTag == ButtonTypeEegetarian)
    {
        [_vegetarianBtn setSelected:NO];
        [_eegetarianBtn setSelected:YES];
        [_nonVegetarianBtn setSelected:NO];
        [_veganBtn setSelected:NO];
        selectedBtn = _eegetarianBtn;
    }
    else if (inTag == ButtonTypeNonvegetarian)
    {
        [_vegetarianBtn setSelected:NO];
        [_eegetarianBtn setSelected:NO];
        [_nonVegetarianBtn setSelected:YES];
        [_veganBtn setSelected:NO];
        selectedBtn = _nonVegetarianBtn;
    }
    else
    {
        [_vegetarianBtn setSelected:NO];
        [_eegetarianBtn setSelected:NO];
        [_nonVegetarianBtn setSelected:NO];
        [_veganBtn setSelected:YES];
        selectedBtn = _veganBtn;
    }
    [self.socialHabitsDict setValue:[[selectedBtn titleLabel] text] forKey:@"diet"];
}

-(void)updateDrinkingForTag:(NSInteger)inTag
{
    NSString *switchBtnStr;
    if(1 == inTag)
    {
        _sociallyLabel.textColor = [UIColor lightGrayColor];
        _neverLabel.textColor = [UIColor blackColor];
        switchBtnStr = @"switch_ON";
        [self.socialHabitsDict setValue:[_neverLabel text]
                                 forKey:@"drinking"];
    }
    else
    {
        _sociallyLabel.textColor = [UIColor blackColor];
        _neverLabel.textColor = [UIColor lightGrayColor];
        switchBtnStr = @"switch_OFF";
        [self.socialHabitsDict setValue:[_sociallyLabel text] forKey:@"drinking"];
    }
    [self.drinkingSelectionBtn setBackgroundImage:[UIImage imageNamed:switchBtnStr]
                                         forState:UIControlStateNormal];
}

-(void)updateSmokingForTag:(NSInteger)inTag
{
    NSString *switchBtnStr;
    if(1 == inTag)
    {
        _yesLabel.textColor = [UIColor blackColor];
        _noLabel.textColor = [UIColor lightGrayColor];
        switchBtnStr = @"switch_ON";
        [self.socialHabitsDict setValue:[_yesLabel text] forKey:@"smoking"];
    }
    else
    {
        _yesLabel.textColor = [UIColor lightGrayColor];
        _noLabel.textColor = [UIColor blackColor];
        switchBtnStr = @"switch_OFF";
        [self.socialHabitsDict setValue:[_noLabel text] forKey:@"smoking"];
    }
    [self.smokingSelectionBtn setBackgroundImage:[UIImage imageNamed:switchBtnStr]
                                        forState:UIControlStateNormal];
}

-(IBAction)setDiet:(id)sender
{
    UIButton *setYearBtn = (UIButton *)sender;
    [self updateDietForTag:setYearBtn.tag];
}

-(IBAction)setDrinking:(id)sender
{
    NSString *switchBtnStr;
    if(0 == self.drinkingSelectionBtn.tag)
    {
        _sociallyLabel.textColor = [UIColor lightGrayColor];
        _neverLabel.textColor = [UIColor blackColor];
        switchBtnStr = @"switch_ON";
        self.drinkingSelectionBtn.tag = 1;
        [self.socialHabitsDict setValue:[_neverLabel text]
                                 forKey:@"drinking"];
   }
    else
    {
        self.drinkingSelectionBtn.tag = 0;
        _sociallyLabel.textColor = [UIColor blackColor];
        _neverLabel.textColor = [UIColor lightGrayColor];
        switchBtnStr = @"switch_OFF";
        [self.socialHabitsDict setValue:[_sociallyLabel text] forKey:@"drinking"];
    }
    [self.drinkingSelectionBtn setBackgroundImage:[UIImage imageNamed:switchBtnStr]
                                         forState:UIControlStateNormal];
}

-(IBAction)setSmoking:(id)sender
{
    NSString *switchBtnStr;
    if(0 == self.smokingSelectionBtn.tag)
    {
        _yesLabel.textColor = [UIColor blackColor];
        _noLabel.textColor = [UIColor lightGrayColor];
        switchBtnStr = @"switch_ON";
        self.smokingSelectionBtn.tag = 1;
        [self.socialHabitsDict setValue:[_yesLabel text] forKey:@"smoking"];
    }
    else
    {
        self.smokingSelectionBtn.tag = 0;
        _yesLabel.textColor = [UIColor lightGrayColor];
        _noLabel.textColor = [UIColor blackColor];
        switchBtnStr = @"switch_OFF";
        [self.socialHabitsDict setValue:[_noLabel text] forKey:@"smoking"];
    }
    [self.smokingSelectionBtn setBackgroundImage:[UIImage imageNamed:switchBtnStr]
                                        forState:UIControlStateNormal];
}

@end
