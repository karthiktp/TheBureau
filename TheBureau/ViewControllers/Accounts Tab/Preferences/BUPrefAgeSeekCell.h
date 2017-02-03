//
//  BUPrefAgeSeekCell.h
//  TheBureau
//
//  Created by Manjunath on 07/03/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFADoubleSlider.h"
#import "BUPreferencesVC.h"

@interface BUPrefAgeSeekCell : UITableViewCell<JFADoubleSliderDelegate>

@property(nonatomic, weak) IBOutlet UILabel *minValueLabel,*maxValueLabel;
@property(nonatomic, weak) IBOutlet UIView *leftView,*rightView,*overLayView;
@property(nonatomic, weak) IBOutlet UILabel *leftLabel, *rightLabel;
@property(nonatomic, assign) BOOL shouldMoveLeftView,shouldMoveRightView;
@property(nonatomic, assign) CGPoint prevLocation,currentLocation;
@property(nonatomic, assign) CGFloat interval;
@property(nonatomic, strong) NSMutableDictionary *preferenceDict;
@property(nonatomic, assign) NSInteger minFeet,minInch,maxFeet,maxInch;
@property(nonatomic, assign) IBInspectable int cellType;

@property(strong, nonatomic) BUPreferencesVC *parentVc;

@property(nonatomic, weak) IBOutlet JFADoubleSlider *ageSlider;

@property(nonatomic, weak) IBOutlet JFADoubleSlider *heightSlider;

@property(nonatomic, weak) IBOutlet JFADoubleSlider *areaSlider;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftViewLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightViewRightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *minLabelLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *maxLabelRightConstraint;

-(void)setDatasource:(NSMutableDictionary *)inDict;

@end
