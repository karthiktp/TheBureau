//
//  BUCustomPickerView.m
//  TheBureau
//
//  Created by Manjunath on 25/04/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUCustomPickerView.h"
#import "PWCustomPickerCell.h"

@implementation BUCustomPickerView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */




- (IBAction)closePickerView:(id)sender
{
    [self.view removeFromSuperview];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view removeFromSuperview];
}

-(void)showCusptomPickeWithDelegate:(id<PWPickerViewDelegate>) inDelegate
{
    self.delegate = inDelegate;
    UIWindow *window  =  [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self.view];
    [window bringSubviewToFront:self.view];
    [self.pickerTableView reloadData];
    
    self.pickerOverLay.layer.cornerRadius = 5.0;
}

#pragma mark - TableView delegate and datasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.pickerDataSource.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cellIdentifier = @"mediaIdentifier";
    PWCustomPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
    {
        cell = [PWCustomPickerCell createPWCustomPickerCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
        
    }
    PWHeritageObj *inDataSourceDict = [self.pickerDataSource objectAtIndex:indexPath.row];
    cell.titleLabel.text = inDataSourceDict.name;
    [cell selectDatasource:inDataSourceDict.isSelected];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PWHeritageObj *obj = [self.pickerDataSource objectAtIndex:indexPath.row];
    
    if ([obj.name isEqualToString:@"No Preference"]) {
        for (int g=0; g<[self.pickerDataSource count]; g++) {
            PWHeritageObj *obj1 = [self.pickerDataSource objectAtIndex:g];
            if(NO == [obj isSelected])
            {
                obj1.isSelected = YES;
                [self.delegate didItemSelected:obj1];
            }
            else
            {
                obj1.isSelected = NO;
                [self.delegate didItemDeselectedSelected:obj1];
            }
        }
    }
    else {
        
        if(NO == [obj isSelected])
        {
            obj.isSelected = YES;
            [self.delegate didItemSelected:obj];
        }
        else
        {
            obj.isSelected = NO;
            [self.delegate didItemDeselectedSelected:obj];
        }
        
        
        
        int count = 0;
        
        for (int g=0; g<[self.pickerDataSource count]-1; g++) {
            PWHeritageObj *obj1 = [self.pickerDataSource objectAtIndex:g];
            if (obj1.isSelected) {
                count++;
            }
        }
        
        PWHeritageObj *noPrefObj = [self.pickerDataSource objectAtIndex:[self.pickerDataSource count]-1];
        
        if (count ==[self.pickerDataSource count]-1) {
            noPrefObj.isSelected = YES;
            [self.delegate didItemSelected:noPrefObj];
        }
        else {
            noPrefObj.isSelected = NO;
            [self.delegate didItemDeselectedSelected:noPrefObj];
        }
        
        
    }
        
    [tableView reloadData];
}

-(void)resetDataSource
{
    for (NSMutableDictionary *dict in self.pickerDataSource)
    {
        [dict setValue:[NSNumber numberWithBool:NO] forKey:@"state"];
    }
}


@end
