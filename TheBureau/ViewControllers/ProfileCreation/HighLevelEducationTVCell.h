//
//  HighLevelEducationTVCell.h
//  SampleUI
//
//  Created by Sarath Neeravallil Sasi on 04/02/16.
//  Copyright © 2016 Sarath Neeravallil Sasi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HighLevelEducationTVCellDelegate <NSObject>

-(void)addNextLevelButtonTapped;
- (void)updateHighLevelEducationTVCell : (NSIndexPath *)indexpath;


-(void)slideTableUp;
-(void)slideTableDown;
@end

@interface HighLevelEducationTVCell : UITableViewCell<UITextFieldDelegate>
-(void)updateBtnStatus:(NSDictionary*)dataSource;
@property (weak, nonatomic) IBOutlet UIButton *addEducationLevelBtn;
@property (nonatomic,assign) id <HighLevelEducationTVCellDelegate> delegate;
@property(nonatomic) NSIndexPath *indexpath;
@property(nonatomic) NSInteger educationLevel;
@property(nonatomic) NSMutableDictionary *dataSourceDict;

@property (nonatomic,weak) IBOutlet UILabel *educationlevelLbl;
@property (nonatomic,weak) IBOutlet UITextField *honorTextField;
@property (nonatomic,weak) IBOutlet UITextField *yearTextField;

@property (nonatomic,weak) IBOutlet UITextField *collegeTextField;
@property (nonatomic,weak) IBOutlet UITextField *majorTextField;

@property (strong, nonatomic) IBOutlet UILabel *highestLevelLabel;

@end
