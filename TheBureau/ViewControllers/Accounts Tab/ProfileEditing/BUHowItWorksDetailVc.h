//
//  BUHowItWorksDetailVc.h
//  TheBureau
//
//  Created by Ama1's iMac on 29/07/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BUHowItWorksDetailVc : UIViewController
@property(strong, nonatomic) NSString *titleString;
@property(strong, nonatomic) NSString *textViewText;
@property (strong, nonatomic) IBOutlet UITextView *detailTextView;
@end
