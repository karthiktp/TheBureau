//
//  BUHomeConnectionsVC.m
//  TheBureau
//
//  Created by Accion Labs on 16/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUHomeConnectionsVC.h"
#import "BUHomeConnectionTabVC.h"
#import <Smooch/Smooch.h>
//@protocol BUHomeConnectionsVCDelegate<NSObject>
//@optional
//-(void)smoochConversationViewControllerPresented;
//@end
@interface BUHomeConnectionsVC ()<BUHomeConnectionTabVCDelegate>

@property(nonatomic) BUHomeConnectionTabVC *tabContainerVC;
//@property(nonatomic,weak)IBOutlet UIButton *csChatBtn;
//@property(nonatomic,weak)IBOutlet UIButton *chatBtn;
//@property(nonatomic,weak)IBOutlet UIButton *rematchBtn;
//@property(nonatomic, weak) id<BUHomeConnectionsVCDelegate> delegate;

@end

@implementation BUHomeConnectionsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tabContainerVC.delegate = self;
   // self.title =@"Connections";
   
    [_chatBtn setSelected:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tabChanges:(UIButton *)button;
{
    [self showConnectionsSegment:button];
}

- (IBAction)showConnectionsSegment:(UIButton *)sender
{
    
    if (sender.selected) {
        return;
    }
    
    
    if (sender.tag == 0)
    {
        //        if (!self.controller) {
        //            self.controller = [Smooch newConversationViewController];
        //        }
        //        [self.navigationController addChildViewController:self.controller];
        //        [self.view addSubview:self.controller.view];
        //        self.controller.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        //
        //        [self.controller didMoveToParentViewController:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BUSmoochConversationViewControllerPresentedNotification" object:nil];
        [_csChatBtn setSelected:YES];
        [_chatBtn setSelected:NO];
        [_rematchBtn setSelected:NO];
        
        //    return;
    }
    
    else if (sender.tag == 1) {
        [_csChatBtn setSelected:NO];
        [_chatBtn setSelected:YES];
        [_rematchBtn setSelected:NO];
    }
    else{
        [_csChatBtn setSelected:NO];
        [_chatBtn setSelected:NO];
        [_rematchBtn setSelected:YES];
    }
    [self.tabContainerVC showViewControllerFromIndex:sender.tag];
}
-(void)upDateButtons:(NSInteger)segment{
    switch (segment) {
        case 0:
            [self showConnectionsSegment:_csChatBtn];
            break;
        case 1:
            [self showConnectionsSegment:_chatBtn];
        default:
            break;
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
     NSLog(@"Expected called");
    if ([segue.identifier isEqualToString:@"embedContainer"]) {
        self.tabContainerVC = segue.destinationViewController;
       NSLog(@"Expectedddddd ifffff");
    }
}
@end
