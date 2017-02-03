//
//  PWCustomPickerCell.m
//  PerfectWellness
//
//  Created by Apple on 19/04/15.
//
//

#import "PWCustomPickerCell.h"

@implementation PWCustomPickerCell

+(PWCustomPickerCell *)createPWCustomPickerCell
{
    {
        NSArray *xibViews = [[NSBundle mainBundle] loadNibNamed:@"PWCustomPickerCell" owner:nil options:nil];
        
        return [xibViews lastObject];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDatasource:(NSMutableDictionary *)inDataSourceDict
{
    self.titleLabel.text = [inDataSourceDict valueForKey:@"title"];
//    ic_tick_grey
}

-(void)selectDatasource:(BOOL)inBool
{
    self.isCellSelected = inBool;
    self.radioBtnImgView.hidden = !inBool;
}

@end
