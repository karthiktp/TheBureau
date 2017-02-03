//
//  BUHomeViewController.h
//  TheBureau
//
//  Created by Manjunath on 08/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUBaseViewController.h"
#import "BUWebServicesManager.h"
#import "BURightBtnView.h"
#import "BUHomeTabbarController.h"
@interface BUHomeViewController : BUBaseViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) IBOutlet UIImageView *noProfileImgView;
@property(nonatomic, strong) IBOutlet UITableView *imgScrollerTableView;

@property (weak, nonatomic) IBOutlet UIImageView *profileStatusImgView;
@property (nonatomic) UIButton *matchBtn,*passBtn;
@property (weak, nonatomic) IBOutlet UIButton *flagBtn;
@property BOOL isChat,imagePreview;

@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property(nonatomic, strong) NSString *matchUserID, *participant;
-(IBAction)flagUSer:(id)sender;
-(void)flagWithText:(NSString *)inText;
-(NSMutableDictionary *)getDataInfoDictionary;
@end
