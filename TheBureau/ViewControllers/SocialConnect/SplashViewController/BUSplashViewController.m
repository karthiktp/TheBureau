//
//  BUsplashViewController.m
//  TheBureau
//
//  Created by Accion Labs on 18/01/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUSplashViewController.h"
#import "UIImage+animatedGIF.h"

@interface BUSplashViewController ()

@end

@implementation BUSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"TheBureau_Splash" withExtension:@"gif"];
//    self.dataImageView.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];
  //  self.urlImageView.image = [UIImage animatedImageWithAnimatedGIFURL:url];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
