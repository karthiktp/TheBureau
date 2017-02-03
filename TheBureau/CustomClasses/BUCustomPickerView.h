//
//  BUCustomPickerView.h
//  TheBureau
//
//  Created by Manjunath on 25/04/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUBaseViewController.h"
#import "PWCustomPickerView.h"
#import "PWHeritageObj.h"

@interface BUCustomPickerView : BUBaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *pickerOverLay;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *pickerTableView;
@property (nonatomic, assign) id <PWPickerViewDelegate> delegate;
@property (nonatomic) eHeritageList selectedHeritage;
@property (strong, nonatomic) NSMutableArray *pickerDataSource;
@property (nonatomic, assign) BOOL allowMultipleSelection;

@property (strong, nonatomic) NSMutableArray *selectedItemsList;

- (IBAction)closePickerView:(id)sender;
-(void)showCusptomPickeWithDelegate:(id<PWPickerViewDelegate>) inDelegate;

@end
