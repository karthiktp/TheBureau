//
//  BUCreatedByCell.h
//  TheBureau
//
//  Created by Manjunath on 20/04/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BUHomeViewController.h"

@interface BUCreatedByCell : UITableViewCell
@property(nonatomic, strong) IBOutlet UILabel *matchDescritionLabel;
@property (weak, nonatomic) IBOutlet UIButton *flagBtn;
@property (weak, nonatomic) IBOutlet BUHomeViewController *parentVC;
@end
