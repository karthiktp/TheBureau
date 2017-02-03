//
//  BUCustomerServiceChatVC.m
//  TheBureau
//
//  Created by Accion Labs on 16/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUCustomerServiceChatVC.h"
#import <Smooch/Smooch.h>
#import "BUWebServicesManager.h"
#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

@interface BUCustomerServiceChatVC ()

@property(nonatomic) UIViewController *controller;

@end

@implementation BUCustomerServiceChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    SKTSettings *smoochSetting = [SKTSettings settingsWithAppToken:@"98vczyf814ei6h4nyyasqhnxv"];
    //smoochSetting.enableAppDelegateSwizzling = NO;
    [Smooch initWithSettings:smoochSetting];
    [Smooch setUserFirstName:[BUWebServicesManager sharedManager].userName lastName:@""];
    
    // Do any additional setup after loading the view.
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.controller.view removeFromSuperview];
}

-(void)dealloc{
    [self.controller.view removeFromSuperview];
    self.controller = nil;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.controller) {
        self.controller = [Smooch newConversationViewController];
    }
    [self addChildViewController:self.controller];
    [self.view addSubview:self.controller.view];
    self.controller.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+50.0);
    [self.controller didMoveToParentViewController:self];
}
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)chatWithCustomerService:(id)sender{
    
    //    [Smooch showConversationFromViewController:self];
    
}

@end
