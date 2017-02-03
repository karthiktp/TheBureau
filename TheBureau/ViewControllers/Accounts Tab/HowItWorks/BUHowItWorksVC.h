//
//  BUHowItWorksVC.h
//  TheBureau
//
//  Created by Manjunath on 01/03/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUBaseViewController.h"

@interface BUHowItWorksVC : BUBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic , strong) IBOutlet UITableView *profileTableView;

@end
