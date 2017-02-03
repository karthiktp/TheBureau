//
//  UINavigationController+CompletionHandler.h
//  TheBureau
//
//  Created by Ama1's iMac on 27/09/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (CompletionHandler)
- (void)completionhandler_pushViewController:(UIViewController *)viewController
                                    animated:(BOOL)animated
                                  completion:(void (^)(void))completion;
@end
