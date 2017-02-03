//
//  PWCustomPickerView.m
//  PerfectWellness
//
//  Created by Apple on 19/04/15.
//
//

#import "PWCustomPickerView.h"
#import "PWCustomPickerCell.h"

@implementation PWCustomPickerView

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
    NSMutableDictionary *inDataSourceDict = [self.pickerDataSource objectAtIndex:indexPath.row];
    
    switch (self.selectedHeritage)
    {
        case eReligionList:
        {

            cell.titleLabel.text = [inDataSourceDict valueForKey:@"religion_name"];
            break;
        }
        case eMotherToungueList:
        {
            cell.titleLabel.text = [inDataSourceDict valueForKey:@"mother_tongue"];
            break;
        }
        case eFamilyOriginList:
        {
            cell.titleLabel.text = [inDataSourceDict valueForKey:@"family_origin_name"];
            break;
        }
        case eSpecificationList:
        {
            cell.titleLabel.text = [inDataSourceDict valueForKey:@"specification_name"];
            break;
        }
        case eGothraList:
        {
//            cell.titleLabel.text = [inDataSourceDict valueForKey:@""];
            break;
        }
            
        default:
            break;
    }
    
//    if(YES == self.allowMultipleSelection)
//    {
//        if([[inDataSourceDict valueForKey:@"isSelected"] isEqualToString:@"1"])
//            [cell selectDatasource:YES];
//        else
//            [cell selectDatasource:NO];
//    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(NO == self.allowMultipleSelection)
    {
        NSMutableDictionary *dict =  [self.pickerDataSource objectAtIndex:indexPath.row];
        [self.delegate didItemSelected:dict];
        [self.view removeFromSuperview];
    }
    else
    {
        
        PWCustomPickerCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if(NO == [cell isCellSelected])
        {
            NSMutableDictionary *dict =  [self.pickerDataSource objectAtIndex:indexPath.row];
//            [dict setValue:@"1" forKey:@"isSelected"];
            [self.delegate didItemSelected:dict];
        }
        else
        {
            NSMutableDictionary *dict =  [self.pickerDataSource objectAtIndex:indexPath.row];
//            [dict setValue:@"0" forKey:@"isSelected"];
            [self.delegate didItemDeselectedSelected:dict];
        }
        
        [cell selectDatasource:![cell isCellSelected]];
    }}

-(void)resetDataSource
{
    for (NSMutableDictionary *dict in self.pickerDataSource)
    {
        [dict setValue:[NSNumber numberWithBool:NO] forKey:@"state"];
    }
}


@end
