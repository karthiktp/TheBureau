//
//  BUProfileRematchVC.m
//  TheBureau
//
//  Created by Accion Labs on 16/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUProfileRematchVC.h"
#import "BURematchCollectionViewCell.h"
#import "BUUserProfile.h"
#import "BUHomeViewController.h"
#import "BURematchProfileDetailsVC.h"
@interface BUProfileRematchVC ()

@property(nonatomic) NSArray * imageArray;
@property(nonatomic, strong) NSMutableArray *datasourceList;
//@property(nonatomic, strong) NSMutableArray *imagesList;
@property(nonatomic,weak) IBOutlet UICollectionView *rematchCollectionView;
@property(nonatomic,strong) BUUserProfile *userProfile;
@property(nonatomic, strong) NSMutableArray *userStatus;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UILabel *topViewLabel;
@property (strong, nonatomic) IBOutlet UILabel *lbl;
@property (strong,nonatomic)NSDictionary *goldUsage;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;



@end

@implementation BUProfileRematchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _datasourceList = [[NSMutableArray alloc]init];
    _imageArray = [[NSArray alloc]initWithObjects:@"img_photo1",@"img_photo1",@"img_photo1",@"img_photo1", @"img_photo2",@"img_photo2",@"img_photo2",@"img_photo2",nil];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.messageLabel.hidden = YES;
    self.messageLabel.text= @"";
    _topView.hidden = YES;
    [self getRematchProfile];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getRematchProfile
{
    
    self.userStatus = [[NSMutableArray alloc] init];
    self.topView.hidden = NO;
    NSString *baseUrl = [NSString stringWithFormat:@"rematch/view/userid/%@",[BUWebServicesManager sharedManager].userID];
    [self startActivityIndicator:YES];
    [[BUWebServicesManager sharedManager] getqueryServer:nil baseURL:baseUrl successBlock:^(id inResult, NSError *error) {
        [self stopActivityIndicator];
        // [self.imagesList removeAllObjects];
        
        if([inResult isKindOfClass:[NSDictionary class]])
        {
            if([[inResult valueForKey:@"msg"] isEqualToString:@"Error"])
            {
                [self stopActivityIndicator];
                NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:[inResult valueForKey:@"response"]];
                [message addAttribute:NSFontAttributeName
                                value:[UIFont fontWithName:@"comfortaa-Bold" size:15]
                                range:NSMakeRange(0, message.length)];
                
                NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
                [style setLineSpacing:10];
                [message addAttribute:NSParagraphStyleAttributeName
                                value:style
                                range:NSMakeRange(0, message.length)];
                
                self.messageLabel.hidden = NO;
                self.messageLabel.attributedText = message;
                // self.messageLabel.textAlignment = NSTextAlignmentCenter;
                
                [self.rematchCollectionView reloadData];
                return ;
            }
        }
        if(nil != inResult && 0 < [inResult count])
        {
            self.datasourceList = inResult;
            self.messageLabel.hidden = YES;
            //      self.userProfile = [[BUUserProfile alloc]initWithUserProfile:inResult];
            
            
            
            /*    for (NSDictionary *dict in inResult)
             {
             // [self.userStatus addObject:[dict valueForKey:@"rematch_profiles"]];
             
             
             
             if([[dict valueForKey:@"img_url"] count] > 0)
             {
             [self.imagesList addObject:[[dict valueForKey:@"img_url"] firstObject]];
             }
             else
             {
             [self.imagesList addObject:@"https://camo.githubusercontent.com/9ba96d7bcaa2481caa19be858a58f180ef236c7b/687474703a2f2f692e696d6775722e636f6d2f7171584a3246442e6a7067"];
             
             }
             
             
             //                 if ([[dict valueForKey:@"img_url"] firstObject]) {
             //                     [self.imagesList addObject:[[dict valueForKey:@"img_url"] firstObject]];
             //                 }
             
             }*/
            
            self.userStatus = [inResult objectForKey:@"rematch_profiles"];
            self.goldUsage = [[NSDictionary alloc]initWithDictionary:[inResult objectForKey:@"goldUsage"]];
            
            //             if([[dict valueForKey:@"img_url"] count] > 0)
            //             {
            //                 [self.imagesList addObject:[[dict valueForKey:@"img_url"] firstObject]];
            //             }
            //             else
            //             {
            //                 [self.imagesList addObject:@""];
            //
            //             }https://camo.githubusercontent.com/9ba96d7bcaa2481caa19be858a58f180ef236c7b/687474703a2f2f692e696d6775722e636f6d2f7171584a3246442e6a7067
            //
            
            
            if ([self.userStatus count]>0) {
                
                self.topView.hidden = NO;
                _lbl.hidden = NO;
                
                NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"|\n  You have the ability to connect with past matches.  Click on the match to view their profile.  \n!"]];
                
                //    [self setColorForText:@"red" withColor:[UIColor redColor] withString:string];
                //    [self setColorForText:@"blue" withColor:[UIColor blueColor] withString:string];
                [self setColorForText:@"|" withColor:[UIColor colorWithRed:254.0/255.0 green:243.0/255.0 blue:197.0/255.0 alpha:0.8] withString:string];
                [self setColorForText:@"!" withColor:[UIColor colorWithRed:254.0/255.0 green:243.0/255.0 blue:197.0/255.0 alpha:0.8] withString:string];
                _lbl.attributedText = string;
                
                [self.lbl sizeToFit];
                
                self.lbl.layer.cornerRadius = 5.0;
                self.lbl.clipsToBounds = YES;
                
            }
            
            [self.rematchCollectionView reloadData];
            
        }
    } failureBlock:^(id response, NSError *error) {
        [self stopActivityIndicator];
        [self showAlert:@"Connectivity Error"];
    }];
}

-(void)setColorForText:(NSString*) textToFind withColor:(UIColor*) color withString:(NSMutableAttributedString*)string
{
    NSRange range = [string.mutableString rangeOfString:textToFind options:NSCaseInsensitiveSearch];
    
    if (range.location != NSNotFound) {
        [string addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
}


#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return [self.userStatus count];
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
   BURematchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BURematchCollectionViewCell" forIndexPath:indexPath];
    
     [[[self.userStatus objectAtIndex:indexPath.row]objectForKey:@"img_url"]count] > 0 ? [cell setImageURL:[[[self.userStatus objectAtIndex:indexPath.row]objectForKey:@"img_url"]objectAtIndex:0]] : [cell setImageURL:@"https://camo.githubusercontent.com/9ba96d7bcaa2481caa19be858a58f180ef236c7b/687474703a2f2f692e696d6775722e636f6d2f7171584a3246442e6a7067"];
    
    
  // cell.userMatchImageView.image = [[[self.userStatus objectAtIndex:indexPath.row]objectForKey:@"user_action"]isEqualToString:@"Liked"] ? [UIImage imageNamed:@"btn_liked"] :[UIImage imageNamed:@"btn_passed"];
    
   NSString *user_status = [[self.userStatus objectAtIndex:indexPath.row]objectForKey:@"user_action"];
    
    if ([user_status isEqualToString:@"Liked"]) {
        cell.userMatchImageView.image = [UIImage imageNamed:@"btn_liked"];

    }
    else if ([user_status isEqualToString:@"Not Responded"])
    {
         cell.userMatchImageView.image = [UIImage imageNamed:@"notrespond"];
    }
    else{
        
        cell.userMatchImageView.image = [UIImage imageNamed:@"btn_passed"];

    }
    
 
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    //NSLog(@"Selected user id : %@",[[self.datasourceList objectAtIndex:indexPath.row] valueForKey:@"userid"]);
    UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Connections" bundle:nil];
    BURematchProfileDetailsVC *vc = [sb instantiateViewControllerWithIdentifier:@"BURematchProfileDetailsVC"];
    vc.datasourceList = [[NSMutableDictionary alloc] initWithDictionary:[self.userStatus objectAtIndex:indexPath.row]];
    vc.goldDict = [[NSDictionary alloc]initWithDictionary:self.goldUsage];
    [self.tabBarController.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    CGFloat picDimension = self.view.frame.size.width/2;
    if (self.view.frame.size.width == 375) {
        return CGSizeMake(110, 150);
   
    }
    if (self.view.frame.size.width == 320) {
        return CGSizeMake(90, 150);
        
    }
    return CGSizeMake(110, 150);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    //CGFloat leftRightInset = self.view.frame.size.width / 14.0f;
    return UIEdgeInsetsMake(0, 10, 0, 10);
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
