//
//  BUHomeConnectionTabVC.m
//  TheBureau
//
//  Created by Accion Labs on 16/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUHomeConnectionTabVC.h"
#import "BUCustomerServiceChatVC.h"
#import "BUProfileMatchChatVC.h"
#import "BUProfileRematchVC.h"
#import "AppDelegate.h"
#import "BUHomeConnectionsVC.h"
#import "BUConstants.h"

#define SegueIdentifierFirst    @"embedCustomerService"
#define SegueIdentifierSecond   @"embedProfileMatchChat"
#define SegueIdentifierThird    @"embedProfileRematch"






@interface BUHomeConnectionTabVC ()
{
    NSUInteger selectedIndex;
    NSUInteger oldSelectedIndex;
    
}

@property (strong, nonatomic)     BUCustomerServiceChatVC *firstViewController;
@property (strong, nonatomic)     BUProfileMatchChatVC *secondViewController;
@property (strong, nonatomic)     BUProfileRematchVC *thirdViewController;
@property (assign, nonatomic) BOOL  transitionInProgress;
@property (strong, nonatomic) id    currentViewController;

@end

@implementation BUHomeConnectionTabVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    DLog(@"AAAAA setupConversationDataSource");
     self.transitionInProgress = NO;
     self.currentViewController = self.secondViewController;
    [self performSegueWithIdentifier:SegueIdentifierSecond sender:nil];
    self.isInAppChatNotification = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inAppNotificationArrived:) name:@"InAppNotification" object:nil];

}

-(void)viewWillAppear:(BOOL)animated
{
    [self getGoldDetails];
   
}
-(void)inAppNotificationArrived:(NSNotification *)notificaiton{
    NSDictionary *dictionary1 = [notificaiton userInfo];
    //  NSDictionary *dictionary = [[notificaiton userInfo] objectForKey:@"object"];
    if ([dictionary1 objectForKey:@"layer"]) {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(upDateButtons:)]) {
            [self.delegate upDateButtons:1];
        }
        
    }
    if ([dictionary1 objectForKey:@"SmoochNotification"]) {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(upDateButtons:)]) {
            [self.delegate upDateButtons:0];
        }
    }
    //  self.isInAppChatNotification = YES;
}

-(void)viewDidAppear:(BOOL)animated {
    
    //      DLog(@"Finally Here");
    //         if (selectedIndex == 2) {
    //          UIStoryboard   *sb =[UIStoryboard storyboardWithName:@"HomeView" bundle:nil];
    //          BUProfileRematchVC * homeConections = [[BUProfileRematchVC alloc]init];
    //          homeConections = (BUProfileRematchVC *)[sb instantiateViewControllerWithIdentifier:@"BUProfileRematchVC"];
    //    }
    if (self.isInAppChatNotification){
        self.isInAppChatNotification = NO;
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(upDateButtons:)]) {
            [self.delegate upDateButtons:0];
        }
        //[self performSegueWithIdentifier:SegueIdentifierSecond sender:nil];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segway Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Instead of creating new VCs on each seque we want to hang on to existing
    // instances if we have it.
    if (([segue.identifier isEqualToString:SegueIdentifierFirst]) && !self.firstViewController) {
        self.firstViewController = segue.destinationViewController;
    }
    
    if (([segue.identifier isEqualToString:SegueIdentifierSecond]) && !self.secondViewController) {
        self.secondViewController = segue.destinationViewController;
    }
    
    if (([segue.identifier isEqualToString:SegueIdentifierThird]) && !self.thirdViewController) {
        self.thirdViewController = segue.destinationViewController;
    }
    
    // by default first view controller will load, first
    
    if ([segue.identifier isEqualToString:SegueIdentifierFirst]) {
        // If this is not the first time we're loading this.
        if (self.childViewControllers.count > 0) {
            [self pr_swapFromViewController:self.currentViewController toViewController:self.firstViewController];
            self.currentViewController = self.firstViewController;
        }
        else {
            // If this is the very first time we're loading this we need to do
            // an initial load and not a swap.
            self.currentViewController = self.firstViewController;
            [self addChildViewController:segue.destinationViewController];
            ((UIViewController *)segue.destinationViewController).view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:((UIViewController *)segue.destinationViewController).view];
            [segue.destinationViewController didMoveToParentViewController:self];
        }
    }
    // By definition the second view controller will always be swapped with the
    // first one.
    else if ([segue.identifier isEqualToString:SegueIdentifierSecond]) {
        if (self.childViewControllers.count > 0) {
            [self pr_swapFromViewController:self.currentViewController toViewController:self.secondViewController];
            self.currentViewController = self.secondViewController;        }
        else {
            // If this is the very first time we're loading this we need to do
            // an initial load and not a swap.
            self.currentViewController = self.secondViewController;
            [self addChildViewController:segue.destinationViewController];
            
            ((UIViewController *)segue.destinationViewController).view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:((UIViewController *)segue.destinationViewController).view];
            [segue.destinationViewController didMoveToParentViewController:self];
        }

       
    }
    else if ([segue.identifier isEqualToString:SegueIdentifierThird]) {
        [self pr_swapFromViewController:self.currentViewController toViewController:self.thirdViewController];
        self.currentViewController = self.thirdViewController;
    }
}


#pragma mark - Public API

- (void)showViewControllerFromIndex:(NSInteger)index {
    
    NSString *segueIdentifier;
    if      (index == 0)    segueIdentifier = SegueIdentifierFirst;
    else if (index == 1)    segueIdentifier = SegueIdentifierSecond;
    else if (index == 2)    segueIdentifier = SegueIdentifierThird;
    else                    return;                                 // invalid value, get out from here
    
    oldSelectedIndex = selectedIndex;
    selectedIndex = index;
    if (self.transitionInProgress) {
        return;
    }
    self.transitionInProgress = YES;
    [self performSegueWithIdentifier:segueIdentifier sender:self];
}

//- (void)currentViewControllerUpdateLanguage:(NSString *)language {
//    if([self.currentViewController respondsToSelector:@selector(updateLanguage:)]) {
//        [self.currentViewController updateLanguage:language];
//    }
//}
//
#pragma mark - Private Methods

- (void)pr_swapFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
{
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    if (oldSelectedIndex < selectedIndex)
        rect.origin.x = rect.size.width;
    else
        rect.origin.x = -rect.size.width;
    
    toViewController.view.frame = rect;
    
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    
    [self transitionFromViewController:fromViewController toViewController:toViewController duration:0.3 options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect rect = fromViewController.view.frame;
        if (oldSelectedIndex < selectedIndex)
            rect.origin.x = -rect.size.width;
        else
            rect.origin.x = rect.size.width;
        
        fromViewController.view.frame = rect;
        toViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];
        self.transitionInProgress = NO;
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)getGoldDetails
{
    
    //    [self startActivityIndicator:YES];
    
    NSString *baseURl = [NSString stringWithFormat:@"gold/getGoldAvailable/userid/%@",[BUWebServicesManager sharedManager].userID];
    [[BUWebServicesManager sharedManager] getqueryServer:nil
                                              baseURL:baseURl
                                         successBlock:^(id response, NSError *error) {
                                             
                                             [[NSUserDefaults standardUserDefaults] setInteger:[[response valueForKey:@"gold_available"] intValue] forKey:@"purchasedGold"];
                                             [[NSUserDefaults standardUserDefaults] synchronize];
                                             
                                             
                                             [(BUHomeTabbarController *)[self tabBarController] updateGoldValue:[[response valueForKey:@"gold_available"] integerValue]];
                                         }
                                         failureBlock:^(id response, NSError *error) {
                                             
                                         }];
    
}
@end
