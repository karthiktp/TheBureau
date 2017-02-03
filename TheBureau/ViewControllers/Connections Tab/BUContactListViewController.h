//
//  BUContactListViewController.h
//  TheBureau
//
//  Created by Accion Labs on 26/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BUBaseViewController.h"
#import "BUChatContact.h"
#import "BULayerHelper.h"

@interface BUContactListViewController : BUBaseViewController<LYRQueryControllerDelegate>
//@property(nonatomic,strong) NSMutableArray *contactList;
@property (nonatomic) LYRQueryController *queryController;
@property (nonatomic) LYRClient *layerClient;
@end
