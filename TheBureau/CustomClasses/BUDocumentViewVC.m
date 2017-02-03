//
//  BUDocumentViewVC.m
//  TheBureau
//
//  Created by Manjunath on 20/04/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUDocumentViewVC.h"

@interface BUDocumentViewVC ()

@end

@implementation BUDocumentViewVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"TheBureau";
    // Do any additional setup after loading the view.
//    /Users/accion/Skype Downloads/TheBureau/AppFizz/TheBureau/TheBureau/PrivacyPolicy.docx

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadDocument:self.documentName];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"logo44"] style:UIBarButtonItemStylePlain target:nil action:nil];
    
}
-(void)loadDocument:(NSString*)documentName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:documentName ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.documentLoaderView loadRequest:request];
}

// Calling -loadDocument:inView:


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
