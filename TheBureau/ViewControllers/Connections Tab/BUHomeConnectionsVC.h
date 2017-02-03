//
//  BUHomeConnectionsVC.h
//  TheBureau
//
//  Created by Accion Labs on 16/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BUHomeConnectionsVC : UIViewController

@property(nonatomic, weak) IBOutlet UITabBarItem *connectionTabItem;
@property(nonatomic,weak)IBOutlet UIButton *csChatBtn;
@property(nonatomic,weak)IBOutlet UIButton *chatBtn;
@property(nonatomic,weak)IBOutlet UIButton *rematchBtn;
-(void)tabChanges:(UIButton *)button;

@end
