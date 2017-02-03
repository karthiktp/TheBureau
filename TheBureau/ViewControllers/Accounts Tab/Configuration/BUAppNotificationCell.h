//
//  BUAppNotificationCell.h
//  TheBureau
//
//  Created by Manjunath on 01/03/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BUConfigurationVC.h"
typedef NS_ENUM(NSInteger, BUAppNotificationCellType) {
    BUAppNotificationCellTypeDailyMatch = 0,
    BUAppNotificationCellTypeChatNotifications,
    BUAppNotificationCellTypeCustomerService,
    BUAppNotificationCellTypeBlogRelease,
    BUAppNotificationCellTypeSounds,
    BUAppNotificationCellTypeAccountStatus,
    BUAppNotificationCellTypeActiveOrInActive
};


@interface BUAppNotificationCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *notificationTitleLabel;
@property (nonatomic) IBInspectable NSInteger appNotificationCellType;
@property (weak, nonatomic) IBInspectable UIImage *avaImage;
@property (weak, nonatomic) IBOutlet BUConfigurationVC *parentVC;


- (IBAction)changeNotificationSettings:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *switchBtn;


- (IBAction)deactivateAccount:(id)sender;
- (IBAction)deleteAccount:(id)sender;
- (IBAction)logout:(id)sender;
-(void)updateBtnStatus;

@property(nonatomic, strong)UIAlertAction *okAction;

@end
