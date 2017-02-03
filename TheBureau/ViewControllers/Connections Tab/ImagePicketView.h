//
//  ImagePicketView.h
//  TheBureau
//
//  Created by Rajesh on 31/01/17.
//  Copyright © 2017 Bureau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePicketView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *selectedImage;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIButton *chooseButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end
