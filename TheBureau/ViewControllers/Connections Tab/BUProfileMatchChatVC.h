//
//  BUProfileMatchChatVC.h
//  TheBureau
//
//  Created by Accion Labs on 16/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BUBaseViewController.h"
@interface BUProfileMatchChatVC : BUBaseViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UIActivityIndicatorView *spinner;
@property (nonatomic, strong) UIView *activityView;
@end
