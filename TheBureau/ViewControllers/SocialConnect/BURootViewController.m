//
//  BURootViewController.m
//  TheBureau
//
//  Created by Accion Labs on 17/12/15.
//  Copyright © 2015 Bureau. All rights reserved.
//

#import "BURootViewController.h"
#import "BUUtilities.h"
@interface BURootViewController ()

@end

@implementation BURootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self setNavBarLogo];

}
- (void)setNavBarLogo {
    
//    [BUUtilities setNavBarLogo:self.navigationController image:[UIImage imageNamed:@"logo44"]];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;

    
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