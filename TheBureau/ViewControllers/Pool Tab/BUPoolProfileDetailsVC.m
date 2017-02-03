//
//  BUPoolProfileDetailsVC.m
//  TheBureau
//
//  Created by Manjunath on 22/02/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUPoolProfileDetailsVC.h"
#import "BUHomeImagePreviewCell.h"
#import "BUMatchInfoCell.h"
#import "BUImagePreviewVC.h"
@interface BUPoolProfileDetailsVC ()
@property(nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property(nonatomic, strong) NSMutableArray *imagesList;
@property(nonatomic, strong) IBOutlet UITableView *imgScrollerTableView;
@property(nonatomic, strong) NSMutableArray *keysList;
@property(nonatomic, strong) IBOutlet UIButton *anonymousBtn,*anonymousPayBtn,*directBtn,*directPayBtn;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageWidthconstraint1, *imageWidthconstraint2, *imageWidthconstraint3, *imageWidthconstraint4;

@property (strong, nonatomic) IBOutlet UIImageView *image1, *image2, *image3, *image4;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity1, *activity2, *activity3, *activity4;
@property (strong, nonatomic) IBOutlet UIView *aboutMeView;
@property (strong, nonatomic) IBOutlet UIView *aboutMeBorderView;
@property (strong, nonatomic) IBOutlet UITextView *aboutMeLabel;

-(IBAction)anonymousClicked:(id)sender;
-(IBAction)payAnonymousClicked:(id)sender;
-(IBAction)directClicked:(id)sender;
-(IBAction)payDirectClicked:(id)sender;

@end

@implementation BUPoolProfileDetailsVC
static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageControl.transform = CGAffineTransformMakeScale(2.0, 2.0);

    // Do any additional setup after loading the view.
    self.navigationItem.title = @"TheBureau";
    self.navigationItem.hidesBackButton = NO;
    
    [self cookupDataSource];
    
    float width = ([[UIScreen mainScreen]bounds].size.width - 20 -32)/4;
    
    self.imageWidthconstraint1.constant = width;
    self.imageWidthconstraint2.constant = width;
    self.imageWidthconstraint3.constant = width;
    self.imageWidthconstraint4.constant = width;
    
    
    for (int p=0; p<[self.imagesList count]; p++) {
        
        NSString *inImageURL = [self.imagesList objectAtIndex:p];
        
        switch (p) {
            case 0:
            {
                self.image1.hidden = NO;
                self.activity1.hidden = NO;
                
                self.image1.userInteractionEnabled = YES;
                self.image1.tag = 0;
                
                UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
                gestureRecognizer.numberOfTouchesRequired = 1;
                gestureRecognizer.numberOfTapsRequired = 1;
                [self.image1 addGestureRecognizer:gestureRecognizer];

                [self.image1 sd_setImageWithURL:[NSURL URLWithString:inImageURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    [self.activity1 stopAnimating];
                    
                    //         [self performSelector:@selector(blur:) withObject:image afterDelay:0.1];
                    
                }];
            }
                
                break;
            case 1:
            {
                
                self.image2.hidden = NO;
                self.activity2.hidden = NO;
                
                self.image2.userInteractionEnabled = YES;
                self.image2.tag = 1;
                
                UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
                gestureRecognizer.numberOfTouchesRequired = 1;
                gestureRecognizer.numberOfTapsRequired = 1;
                [self.image2 addGestureRecognizer:gestureRecognizer];
                
                [self.image2 sd_setImageWithURL:[NSURL URLWithString:inImageURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    [self.activity2 stopAnimating];
                    
                    //         [self performSelector:@selector(blur:) withObject:image afterDelay:0.1];
                    
                }];
            }
                
                break;
            case 2:
            {
                
                self.image3.hidden = NO;
                self.activity3.hidden = NO;
                
                self.image3.userInteractionEnabled = YES;
                self.image3.tag = 2;
                
                UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
                gestureRecognizer.numberOfTouchesRequired = 1;
                gestureRecognizer.numberOfTapsRequired = 1;
                [self.image3 addGestureRecognizer:gestureRecognizer];
                
                [self.image3 sd_setImageWithURL:[NSURL URLWithString:inImageURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    [self.activity3 stopAnimating];
                    
                    //         [self performSelector:@selector(blur:) withObject:image afterDelay:0.1];
                    
                }];
            }
                
                break;
            case 3:
            {
                
                self.image4.hidden = NO;
                self.activity4.hidden = NO;
                
                self.image4.userInteractionEnabled = YES;
                self.image4.tag = 3;
                
                UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
                gestureRecognizer.numberOfTouchesRequired = 1;
                gestureRecognizer.numberOfTapsRequired = 1;
                [self.image4 addGestureRecognizer:gestureRecognizer];
                
                [self.image4 sd_setImageWithURL:[NSURL URLWithString:inImageURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    [self.activity4 stopAnimating];
                    
                    //         [self performSelector:@selector(blur:) withObject:image afterDelay:0.1];
                    
                }];
            }
                
                break;
            default:
                break;
        }
        
    }
    
    
}

-(void)imageTapped:(UITapGestureRecognizer*)recognizer {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:recognizer.view.tag inSection:0];
    
    UIStoryboard *sb =[UIStoryboard storyboardWithName:@"HomeView" bundle:nil];
    BUImagePreviewVC *imagePreviewVC = [sb instantiateViewControllerWithIdentifier:@"BUImagePreviewVC"];
    imagePreviewVC.imagesList = self.imagesList;//[self.imagesList objectAtIndex:indexPath.row];
    imagePreviewVC.indexPathToScroll = indexPath;
    [self presentViewController:imagePreviewVC animated:NO completion:nil];
}

-(void)cookupDataSource
{
    
    self.imagesList = [[NSMutableArray alloc] initWithArray:[self.datasourceList valueForKey:@"img_url"]];
    
    NSDictionary *respDict = self.datasourceList;
    
    NSLog(@"%@",respDict);
    

    NSLog(@"Gold Dict is %@",self.goldDict);

    if (self.goldDict) {
        
        if ([[self.goldDict valueForKey:@"free_profile"]isEqualToString:@"Yes"]) {
            [self.anonymousPayBtn setTitle:@"Free" forState:UIControlStateNormal];
            [self.directPayBtn setTitle:@"Free" forState:UIControlStateNormal];
        }
        else
        {
            [self.anonymousPayBtn setTitle:[self.goldDict objectForKey:@"anonymous"] forState:UIControlStateNormal];
            [self.directPayBtn setTitle:[self.goldDict objectForKey:@"direct"] forState:UIControlStateNormal];
        }
        
    }

    self.keysList = [[NSMutableArray alloc] init];

//    NSString *profileName = [NSString stringWithFormat:@"%@ %@",[respDict valueForKey:@"profile_first_name"],[respDict valueForKey:@"profile_last_name"]];
    
    [self.datasourceList setValue:[respDict valueForKey:@"created_by"] forKey:@"Profile created by"];
    [self.keysList addObject:@"Profile created by"];
    
    [self.datasourceList setValue:[respDict valueForKey:@"age"] forKey:@"Age"];
    [self.keysList addObject:@"Age"];
    
    [self.datasourceList setValue:[respDict valueForKey:@"location"] forKey:@"Location"];
    [self.keysList addObject:@"Location"];
    
    
    NSString *height = [NSString stringWithFormat:@"%@' %@\"",[respDict valueForKey:@"height_feet"],[respDict valueForKey:@"height_inch"]];
    [self.datasourceList setValue:height forKey:@"Height"];
    [self.keysList addObject:@"Height"];
    
        
//    [self.datasourceList setValue:[respDict valueForKey:@"mother_tongue"] forKey:@"Mother Toungue"];
//    [self.keysList addObject:@"Mother Toungue"];
    
    [self.datasourceList setValue:[respDict valueForKey:@"religion_name"] forKey:@"Religion"];
    [self.keysList addObject:@"Religion"];
    
    [self.datasourceList setValue:[respDict valueForKey:@"family_origin_name"] forKey:@"Family Origin"];
    [self.keysList addObject:@"Family Origin"];
    
//    [self.datasourceList setValue:@"" forKey:@"Specification"];
//    [self.keysList addObject:@"Specification"];

    [self.datasourceList setValue:[respDict valueForKey:@"highest_education"] forKey:@"Education"];
    [self.keysList addObject:@"Education"];
    
//    [self.datasourceList setValue:[respDict valueForKey:@"honors"] forKey:@"Honors"];
//    [self.keysList addObject:@"Honors"];
//    
//    [self.datasourceList setValue:[respDict valueForKey:@"major"] forKey:@"Major"];
//    [self.keysList addObject:@"Major"];
//    
//    [self.datasourceList setValue:[respDict valueForKey:@"college"] forKey:@"School"];
//    [self.keysList addObject:@"School"];
//
//    [self.datasourceList setValue:[respDict valueForKey:@"graduated_year"] forKey:@"Year"];
//    [self.keysList addObject:@"Year"];
    
    [self.datasourceList setValue:[respDict valueForKey:@"employment_status"] forKey:@"Occupation"];
    [self.keysList addObject:@"Occupation"];
    
//    if ([[respDict valueForKey:@"employment_status"] isEqualToString:@"Employed"]) {
//            [self.datasourceList setValue:[respDict valueForKey:@"company"] forKey:@"Employer"];
//            [self.keysList addObject:@"Employer"];
//    }
    
//    [self.datasourceList setValue:[respDict valueForKey:@"company"] forKey:@"Employer"];
//    [self.keysList addObject:@"Employer"];
//
//    [self.datasourceList setValue:[respDict valueForKey:@"diet"] forKey:@"Diet"];
//    [self.keysList addObject:@"Diet"];
//    
//    [self.datasourceList setValue:[respDict valueForKey:@"smoking"] forKey:@"Smoking"];
//    [self.keysList addObject:@"Smoking"];
//    
//    [self.datasourceList setValue:[respDict valueForKey:@"drinking"] forKey:@"Drinking"];
//    [self.keysList addObject:@"Drinking"];
//    
//    [self.datasourceList setValue:[respDict valueForKey:@"years_in_usa"] forKey:@"Years in USA"];
//    [self.keysList addObject:@"Years in USA"];
//    
//    [self.datasourceList setValue:[respDict valueForKey:@"legal_status"] forKey:@"Legal Status"];
//    [self.keysList addObject:@"Legal Status"];
//    
//    [self.datasourceList setValue:[respDict valueForKey:@"profile_dob"] forKey:@"Date of Birth"];
//    [self.keysList addObject:@"Date of Birth"];
//    
//    [self.datasourceList setValue:@"" forKey:@"Time of Birth"];
//    [self.keysList addObject:@"Time of Birth"];
    
//    NSLog(@"%@",[respDict valueForKey:@"about_me"]);
    
//    [self.datasourceList setValue:[respDict valueForKey:@"about_me"] forKey:@"About Me"];
//    [self.keysList addObject:@"About Me"];

//    [self.collectionView reloadData];
//    [self.imgScrollerTableView reloadData];
    
//    if ([[respDict valueForKey:@"about_me"] length]) {
//        self.aboutMeLabel.text = [respDict valueForKey:@"about_me"];
//        self.aboutMeBorderView.layer.cornerRadius = 5.0;
//        self.aboutMeBorderView.layer.borderWidth = 1.0;
//        self.aboutMeBorderView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        self.imgScrollerTableView.tableFooterView = self.aboutMeView;
//    }
//    
//    NSLog(@"%@",self.datasourceList);
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(80, 100);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    self.pageControl.numberOfPages = self.imagesList.count;
    return self.imagesList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BUHomeImagePreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BUHomeImagePreviewCell"
                                                                             forIndexPath:indexPath];
    [cell setImageURL:[self.imagesList objectAtIndex:indexPath.row]];
    //
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>


- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.pageControl.currentPage = indexPath.row;
    NSLog(@"collectionView willDisplayCell: %ld",(long)indexPath.row);
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {
    NSString *key = [self.keysList objectAtIndex:indexPath.row];
    
    CGSize constraintSize = {self.view.frame.size.width/2 - 30, 20000};
    
    NSString *string = [self.datasourceList valueForKey:key];
    
//    string = [string stringByReplacingOccurrencesOfString:@". " withString:@"  "];
    
    CGRect textRect = [string boundingRectWithSize:constraintSize
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Comfortaa-Bold" size:15]}
                                         context:nil];
    
//    CGSize  neededSize   = [string sizeWithFont:[UIFont fontWithName:@"Comfortaa-Bold" size:15] constrainedToSize:constraintSize  lineBreakMode:NSLineBreakByWordWrapping];
    
    
//    if ([string rangeOfString:@"dummy text"].location != NSNotFound) {
//        NSLog(@"string does not contain bla");
//    }
    
    return  textRect.size.height <= 20 ? ([string isEqualToString:@""] ? 0 : 20) : textRect.size.height;  //[key isEqualToString:@"About Me"] ? neededSize.height : 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.keysList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    BUMatchInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BUMatchInfoCell"];
    NSString *key = [self.keysList objectAtIndex:indexPath.row];
    
    if([key isEqualToString:@"Honors"] || [key isEqualToString:@"Major"] || [key isEqualToString:@"School"] || [key isEqualToString:@"Year"] || [key isEqualToString:@"Employer"])
    {
        cell.matchTitleLabel.text = [NSString stringWithFormat:@"      %@",key];
    }
    else
    {
        cell.matchTitleLabel.text = [NSString stringWithFormat:@"%@",key];
    }
    cell.matchDescritionLabel.text = [NSString stringWithFormat:@"%@",[self.datasourceList valueForKey:key]];
    return cell;
}


-(IBAction)anonymousClicked:(id)sender
{
    self.anonymousBtn.hidden = YES;
    self.anonymousPayBtn.hidden = NO;
    self.directBtn.hidden = NO;
    self.directPayBtn.hidden = YES;
}

-(IBAction)payAnonymousClicked:(id)sende
{
    
//    http://app.thebureauapp.com/admin/accessUserProfile
    
    
    
//http://app.thebureauapp.com/admin/accessUserProfile
    
    
//    Parameters :
//    
//    userid => User id of the user who is visiting/accessing the other users profile
//    
//    visited_userid => User id of the user whose profile is being visited/accessed by the above user
//    
//    access_type => Takes only two values => Anonymous / Direct
//    
//    gold_amount => Amount of gold to be deducted from the users account for visiting the other users profile

    
    [self startActivityIndicator:YES];
    NSString *baseURl = @"pool/accesstype";
    
    NSDictionary *parameters = nil;
    parameters = @{@"userid": [BUWebServicesManager sharedManager].userID,
                   @"visited_userid": [self.datasourceList valueForKey:@"userid"],
                   @"access_type": @"Anonymous",
                   @"gold_amount": [self.goldDict objectForKey:@"anonymous"]
                   };
    
    [[BUWebServicesManager sharedManager] queryServer:parameters
                                              baseURL:baseURl
                                         successBlock:^(id response, NSError *error)
     {
         [self stopActivityIndicator];
         
         if([response valueForKey:@"msg"] != nil && [[response valueForKey:@"msg"] isEqualToString:@"Error"])
         {
             [self stopActivityIndicator];
             [self showAlert:[response valueForKey:@"response"]];
             return;
         }
         else
         {
             NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"Your Match will be notified of your interest anonymously!"];
             [message addAttribute:NSFontAttributeName
                             value:[UIFont fontWithName:@"comfortaa" size:15]
                             range:NSMakeRange(0, message.length)];
             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
             [alertController setValue:message forKey:@"attributedTitle"];
             [alertController addAction:({
                 UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                     self.anonymousBtn.enabled = NO;
                     self.anonymousPayBtn.enabled = NO;
                     self.directBtn.enabled = NO;
                     self.directPayBtn.enabled = NO;
                     [self.navigationController popViewControllerAnimated:YES];
                 }];
                 action;
             })];
             
             [self presentViewController:alertController  animated:YES completion:nil];
         }
     }
                                         failureBlock:^(id response, NSError *error)
     {
         [self stopActivityIndicator];
         [self showAlert:@"Connectivity Error"];
     }];
}
-(IBAction)directClicked:(id)sender {
    self.directBtn.hidden = YES;
    self.directPayBtn.hidden = NO;
    self.anonymousBtn.hidden = NO;
    self.anonymousPayBtn.hidden = YES;
}

-(IBAction)payDirectClicked:(id)sender
{
    
    [self startActivityIndicator:YES];
    NSString *baseURl = @"pool/accesstype";    
    NSDictionary *parameters = nil;
    parameters = @{@"userid": [BUWebServicesManager sharedManager].userID,
                   @"visited_userid": [self.datasourceList valueForKey:@"userid"],
                   @"access_type": @"Direct",
                   @"gold_amount": [self.goldDict objectForKey:@"direct"]
                   };
    
    [[BUWebServicesManager sharedManager] queryServer:parameters
                                              baseURL:baseURl
                                         successBlock:^(id response, NSError *error)
     {
         [self stopActivityIndicator];
         
         if([response valueForKey:@"msg"] != nil && [[response valueForKey:@"msg"] isEqualToString:@"Error"])
         {
             [self stopActivityIndicator];
             [self showAlert:[response valueForKey:@"response"]];
             return;
         }
         else
         {
             NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"Your Match will be notified of your interest. Good luck!"];
             [message addAttribute:NSFontAttributeName
                             value:[UIFont fontWithName:@"comfortaa" size:15]
                             range:NSMakeRange(0, message.length)];
             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
             [alertController setValue:message forKey:@"attributedTitle"];
             
             [alertController addAction:({
                 UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                     self.anonymousBtn.enabled = NO;
                     self.anonymousPayBtn.enabled = NO;
                     self.directBtn.enabled = NO;
                     self.directPayBtn.enabled = NO;
                     [self.navigationController popViewControllerAnimated:YES];
                 }];
                 
                 action;
             })];
             
             [self presentViewController:alertController  animated:YES completion:nil];
         }
     }
                                         failureBlock:^(id response, NSError *error)
     {
         [self stopActivityIndicator];
         [self showAlert:@"Connectivity Error"];
     }];
}


@end
