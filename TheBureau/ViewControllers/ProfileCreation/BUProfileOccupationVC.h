//
//  BUProfileOccupationVC.h
//  TheBureau
//
//  Created by Manjunath on 25/01/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUBaseViewController.h"
#import "BUWebServicesManager.h"
@interface BUProfileOccupationVC : BUBaseViewController

@property(nonatomic) NSMutableDictionary *dataSourceDict;
@property BOOL isDirect;
@property (strong, nonatomic) IBOutlet UILabel *continueLabel;
@end
