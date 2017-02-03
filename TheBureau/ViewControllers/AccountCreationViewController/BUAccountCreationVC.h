//
//  BUAccountCreationVC.h
//  TheBureau
//
//  Created by Manjunath on 01/12/15.
//  Copyright © 2015 Bureau. All rights reserved.
//

#import "BUBaseViewController.h"
#import "BUSocialChannel.h"

@interface BUAccountCreationVC : BUBaseViewController

@property(nonatomic, strong) BUSocialChannel *socialChannel;
@property(nonatomic,weak) IBOutlet UITextField *profileFirstNameTF;
@property(nonatomic,weak) IBOutlet UITextField *profileLastNameTF;
@property(nonatomic)IBOutlet UITextField *currentTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollBottomConstraint;

//@property(nonatomic,weak) IBOutlet NSLayoutConstraint

@property (weak, nonatomic) IBOutlet UILabel *relationLabel;
@property BOOL isDirect;
@property(nonatomic,strong)NSArray* relationCircle;

-(void)viewPopOnBackButton;
@end
