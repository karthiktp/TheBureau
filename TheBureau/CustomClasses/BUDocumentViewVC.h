//
//  BUDocumentViewVC.h
//  TheBureau
//
//  Created by Manjunath on 20/04/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUBaseViewController.h"

@interface BUDocumentViewVC : BUBaseViewController
@property(nonatomic, weak) IBOutlet UIWebView *documentLoaderView;
@property(nonatomic, weak) NSString *documentName;
@end
