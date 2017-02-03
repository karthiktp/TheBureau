//
//  BUMatchPoolViewController.m
//  TheBureau
//
//  Created by Manjunath on 22/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUMatchPoolViewController.h"
#import "BUHomeImagePreviewCell.h"
#import "BUPoolProfileDetailsVC.h"
#import "BUImagePreviewVC.h"

@interface BUMatchPoolViewController ()
@property(nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property(nonatomic, strong) NSMutableArray *datasourceList;
@property(nonatomic, strong) NSMutableArray *imagesList;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong,nonatomic) NSDictionary *goldValues;

@end

@implementation BUMatchPoolViewController
static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.pageControl.transform = CGAffineTransformMakeScale(2.0, 2.0);

    self.collectionView.hidden = NO;
    self.pageControl.hidden = NO;
    [self getGoldDetails];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tapToContinueBtn.hidden = YES;
    self.messageLabel.hidden = YES;
    self.messageLabel.text= @"";
    [self getMatchPoolFortheDay];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)showProfileDetails:(id)sender
{
    UIStoryboard *sb =[UIStoryboard storyboardWithName:@"HomeView" bundle:nil];
    BUPoolProfileDetailsVC *vc = [sb instantiateViewControllerWithIdentifier:@"BUPoolProfileDetailsVC"];
    vc.datasourceList = [[NSMutableDictionary alloc] initWithDictionary:[self.datasourceList objectAtIndex:self.pageControl.currentPage]];
    vc.goldDict = [[NSDictionary alloc]initWithDictionary:self.goldValues];
     NSLog(@"%@",self.datasourceList);
    //[vc cookupDataSource];
    [self.tabBarController.navigationController pushViewController:vc animated:NO];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.collectionView.frame.size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    self.pageControl.numberOfPages = self.imagesList.count;
    return self.imagesList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BUHomeImagePreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BUHomeImagePreviewCell"
                                                                             forIndexPath:indexPath];
    
    [cell setFrameRect:self.collectionView.frame];
    [cell setImageURL:[self.imagesList objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark <UICollectionViewDelegate>


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.pageControl.currentPage = indexPath.row;
    NSLog(@"collectionView willDisplayCell: %ld",(long)indexPath.row);
}

-(void)getMatchPoolFortheDay
{
    
    NSDictionary *parameters = nil;
    parameters = @{@"userid": [BUWebServicesManager sharedManager].userID
                   };

//    parameters = @{@"userid": @"327"};

    [self startActivityIndicator:YES];
    NSString *baseUrl = [NSString stringWithFormat:@"pool/view/userid/%@",[BUWebServicesManager sharedManager].userID];
    [[BUWebServicesManager sharedManager] getqueryServer:nil
                                                 baseURL:baseUrl
                                            successBlock:^(id response, NSError *error)
    {
        [self stopActivityIndicator];
        
        self.datasourceList = [[NSMutableArray alloc] init];
        self.imagesList = [[NSMutableArray alloc] init];
        
        if([response valueForKey:@"msg"] != nil && [[response valueForKey:@"msg"] isEqualToString:@"Error"])
        {
            [self stopActivityIndicator];
            NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:[response valueForKey:@"response"]];
            [message addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName:@"comfortaa-Bold" size:15]
                            range:NSMakeRange(0, message.length)];
            
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            [style setLineSpacing:10];
            [message addAttribute:NSParagraphStyleAttributeName
                            value:style
                            range:NSMakeRange(0, message.length)];
            
            self.collectionView.hidden = YES;
            
            if ([self.imagesList count]==0) {
                self.pageControl.hidden = YES;
            }
            else {
                self.pageControl.hidden = NO;
            }
            
            self.messageLabel.hidden = NO;
            self.messageLabel.attributedText = message;
            self.messageLabel.textAlignment = NSTextAlignmentCenter;
            return;
        }
        else
        {
            self.tapToContinueBtn.hidden = NO;
            self.messageLabel.hidden = YES;
            for (NSString *key in [response allKeys])
            {
                if((NO == [[response valueForKey:key] isKindOfClass:[NSNull class]]) && (NO == [[response valueForKey:key] isKindOfClass:[NSString class]]))
                {
                    
                    
                    if ([key isEqualToString:@"gold_values"]) {
                        
                        NSLog(@"New key added is %@",[response objectForKey:key]);
                        
                        self.goldValues = [[NSDictionary alloc]initWithDictionary:[response objectForKey:key]];
                        
                    }
                    
                    else
                    {
                        NSArray *poolMembers = [response valueForKey:key];
                        for (NSDictionary *poolMember in poolMembers) {
                            [self.datasourceList addObject:poolMember];
                            if([[[self.datasourceList lastObject] valueForKey:@"img_url"] count] > 0)
                            {
                                [self.imagesList addObject:[[[self.datasourceList lastObject] valueForKey:@"img_url"] firstObject]];
                            }
                            else
                            {
                                [self.imagesList addObject:@"https://camo.githubusercontent.com/9ba96d7bcaa2481caa19be858a58f180ef236c7b/687474703a2f2f692e696d6775722e636f6d2f7171584a3246442e6a7067"];
                            }
                        }
                    }
                }
            }
            [self.collectionView reloadData];
        }
    } failureBlock:^(id response, NSError *error) {
        [self stopActivityIndicator];
        
        
        if (error.code == NSURLErrorTimedOut) {
            
            [self timeoutError:@"Connection timed out, please try again later"];
        }
        else
        {
            [self showAlert:@"Connectivity Error"];
        }
    }];
}



-(void)didSuccess:(id)inResult; {
    [self stopActivityIndicator];
    if(nil != inResult && 0 < [inResult count]) {
        self.datasourceList = inResult;
        
        self.imagesList = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in inResult) {
            [self.imagesList addObject:[[dict valueForKey:@"img_url"] firstObject]];
        }
        if ([self.imagesList count]==0) {
            self.pageControl.hidden = YES;
        }
        else {
            self.pageControl.hidden = NO;
        }
        [self.collectionView reloadData];
    }
    else {
        [self showAlert:@"Connectivity Error"];
    }
}
-(void)getGoldDetails {
    
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
                                             if (error.code == NSURLErrorTimedOut) {
                                                 [self timeoutError:@"Connection timed out, please try again later"];
                                             }
                                             else {
                                                 [self showFailureAlert];
                                             }}];
}

@end
