//
//  BUProfileEditingVC.h
//  TheBureau
//
//  Created by Manjunath on 25/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUBaseViewController.h"
#import "BUWebServicesManager.h"

@interface BUProfileEditingVC : BUBaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarButton;
@property(nonatomic , strong) IBOutlet UITableView *profileTableView;
@property(nonatomic , assign) NSInteger currentSelectedTab,previousSelectedTab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottomConstraint;

- (IBAction)editProfileDetails:(id)sender;

-(void)showKeyboard;
-(void)hideKeyBoard;
-(void)hideKeyBoard123;
-(void)showKeyboard123;

@end
