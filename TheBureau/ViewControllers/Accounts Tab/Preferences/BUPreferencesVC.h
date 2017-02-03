//
//  BUPreferencesVC.h
//  TheBureau
//
//  Created by Manjunath on 01/03/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUBaseViewController.h"

@interface BUPreferencesVC : UITableViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarButton;
@property (strong, nonatomic) NSDictionary *preferenceDict;
@property (nonatomic, strong) UIView *activityView;
@property (atomic, assign) int activityIndicatorCount;
@property(strong, nonatomic) NSMutableDictionary *profDict;
- (void)startActivityIndicator:(BOOL)isWhite;
- (void)stopActivityIndicator;
@end
