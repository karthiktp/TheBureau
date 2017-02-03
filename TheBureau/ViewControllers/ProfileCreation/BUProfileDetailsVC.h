//
//  BUProfileDetailsVC.h
//  TheBureau
//
//  Created by Manjunath on 25/01/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUBaseViewController.h"
#import "BUWebServicesManager.h"

@interface BUProfileDetailsVC : BUBaseViewController

@property(nonatomic,strong) NSString *dobStr;
@property(nonatomic, strong) NSString *genStr;
@property BOOL isDirect;
@end
