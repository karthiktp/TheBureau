//
//  BUHowItWorksDetailVc.m
//  TheBureau
//
//  Created by Ama1's iMac on 29/07/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUHowItWorksDetailVc.h"

@interface BUHowItWorksDetailVc ()

@end

@implementation BUHowItWorksDetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.titleString;
    self.detailTextView.text = self.textViewText;
    
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"logo44"] style:UIBarButtonItemStylePlain target:nil action:nil];
    
}

-(void)viewWillLayoutSubviews
{
    
   // if ([UIScreen mainScreen].bounds.size.height==480) {
        
        // [self.detailTextView setContentOffset:CGPointMake(0, -200)];
        [self.detailTextView setContentOffset:CGPointZero animated:YES];
        
   // }

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
