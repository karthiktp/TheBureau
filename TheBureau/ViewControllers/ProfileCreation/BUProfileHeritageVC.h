//
//  BUProfileHeritageVC.h
//  TheBureau
//
//  Created by Manjunath on 25/01/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUBaseViewController.h"
#import "PWCustomPickerView.h"
#import "BUWebServicesManager.h"

@interface BUProfileHeritageVC : BUBaseViewController<PWPickerViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollBottomConstraint;
@property BOOL isDirect;
@end
