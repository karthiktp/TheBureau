//
//  BUHowItWorksVC.m
//  TheBureau
//
//  Created by Manjunath on 01/03/16.
//  Copyright © 2016 Bureau. All rights reserved.
//

#import "BUHowItWorksVC.h"
#import "BUHowItWorksDetailVc.h"
#import "BUWebServicesManager.h"

@interface BUHowItWorksVC ()
@property(nonatomic) NSInteger selectedRow;
@property(strong, nonatomic) NSDictionary *textDict;
@end

@implementation BUHowItWorksVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedRow = -1;
    // Do any additional setup after loading the view.
    self.title = @"How We Work";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"logo44"] style:UIBarButtonItemStylePlain target:nil action:nil];
    
    NSDictionary *parameters = nil;
    parameters = @{@"userid": [BUWebServicesManager sharedManager].userID
                   };
    
    [self startActivityIndicator:YES];
    
    [[BUWebServicesManager sharedManager] getqueryServer:nil
                                              baseURL:@"read/howwework"
                                         successBlock:^(id response, NSError *error) {
                                             
                                             [self stopActivityIndicator];
                                             
                                             self.textDict = response;
                                             
                                         }
                                         failureBlock:^(id response, NSError *error)
     {
         [self stopActivityIndicator];
         
         if (error.code == NSURLErrorTimedOut) {
             [self showAlert:@"Connection timed out, please try again later"];
         }
         else {
             [self showAlert:@"Connectivity Error"];
         }
     }];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1"];
            break;
        }
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2"];
            break;
        }
        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell3"];
            break;
        }
        case 3:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell4"];
            break;
        }
        case 4:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell5"];
            break;
        }
        default:
            break;
    }
    //Clip whatever is out the cell frame
    cell.clipsToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat normalHeight = 70;
    CGFloat expandedHeight = 195;

    CGFloat height = 0;
    
  //  height =  self.selectedRow != indexPath.section ? normalHeight :expandedHeight;
    return 70;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /*
     
     {"About The Bureau":"TheBureau App is an exciting new way to connect individuals with their perfect counterparts in life. For all intents and purposes, our goal is to revolutionize the \u201carranged marriage\u201d concept and bring it to the 21st century. We understand that each generation thinks and acts very differently from the previous one. Given this, we want to bridge the gap by fusing the old with the new and providing one distinctive platform that caters to everyone. Whether creating an account for yourself or for a loved one, the app\u2019s unique algorithm strives to match profiles and create meaningful relationships.","Why it was created":"We have created this app because we identified an unmet need in the South Asian community. While there are several dating apps that cater to Gen X and marriage websites that cater to Gen Y there are no apps that combine the two that also provide a highly intelligent structure and a modern, fun user experience. As four single individuals in their twenties, we (the creators of the app) know the struggles associated with finding a partner in a very large world- and we want to help everyone facing the same predicament as well!","How is it different":"This app is unique in its formula, its functionality, and its audience. Utilizing our individual backgrounds, we have a creative, well thought out formula to identify perfect matches for you. In terms of functionality, the app provides an ideal match for each user per day- we will send you a push notification so that you will be wasting neither time nor effort scrolling through hundreds of profiles a day. Finally, our audience consists of both individuals planning to create a profile for themselves as well as friends and family that want to create a profile for their loved ones to help them find their soul mate. No matter the age or knowledge of technology, TheBureau strives to make the app easy to use and rewarding for the user.","How the app works":"We give you Gold! That\u2019s how the app works. We give you Gold, and you spend it. If you run out of Gold, all you have to do is visit our Gold Store and get some more. The Gold provides you with a means to connect with your match and start discussing wedding plans. Just kidding- don\u2019t panic. The Gold will indeed allow you to connect with a match as long as both sides decide to connect with each other, and then the individuals involved would take it from there!","Connection":"A connection is when both parties like each others profiles. The same way that you would view a match\u2019s profile before determining whether to speak with them, they will be viewing yours. As long as both sides decide they are interested in taking it further, you will create a connection, after which you will be able to chat with your match. ","Pool":"The pool is where you can see additional profiles that may be excellent matches for you. We will only show you profiles that hit all of your preferences or come very close to them. If you see a profile you\u2019re interested in, go ahead and request to connect with them. There are two separate ways to connect: directly or anonymously.Direct allows you to immediately notify your pool profile that you are interested. The user will receive a notification saying that you would like to connect with him\/her, and then he\/she will be required to respond to your request. If the user selects \u201cMatch\u201d, you will be connected. Anonymous, on the other hand, implies that we will send your profile to your pool match without them knowing you are interested. It may simply be their \u2018\u2019Match of the Day\u2019\u2019 or something along the lines of \u201cHere is an extra match for you today!\u201d and again, they will be given the option to either \u201cMatch\u201d or \u201cPass\u201d. This option is provided to you in case you have reservations about a direct approach.","Second chance or Rematch":"Rematch allows you to connect with a profile you previously didnt connect with. The user will be notified that you are interested and your chance of connecting increases by more than 4X.","I connected. Now what?":"Congrats on the connection, you are now pronounced Husband & Wife! \n\n Okay, maybe it\u2019s not that simple. Once a connection is made, our part is over, and it\u2019s up to you to keep the ball rolling. Step one is to start a conversation with your match. Get to know each other enough to determine if you want to pursue a relationship, at which point feel free to exchange contact information through the chat interface. ","History of the application":"The idea for this application was realized by our Founder and CEO Anand Narayan in the summer of 2015. He recruited three additional Founders to our team quickly: COO Vamsi Revuru, CTO Sai Kota, and CMO Amala Narayan. Together, the four of us have been focused on building a durable, unique platform that addresses an unmet need. Our main objective is to ensure that this app is useful to our users and that we accomplish what we have set out to do: provide the ideal dating\/ matchmaking experience. Every step of the way is exciting as it brings us new surprises, new perspectives, and ultimately, closer to realizing our goals.","Contact Us":"TheBureau Inc. can be contact via email at publicrelations@thebureauapp.com. Any business, advertising, legal, or general emails can be sent to this email address as well. It will be forwarded to the appropriate director for immediate action. You can also contact us via Facebook (this should be hyperlinked) or through our website. (again hyperlinked) We are a Delaware Corporation with our headquarters located in New Jersey."}
     
     */
    
    
//    self.selectedRow = indexPath.section;
//    [self.profileTableView beginUpdates];
//    [self.profileTableView endUpdates];
    
    
    
    
    NSString *dictStr, *titleStr;
    switch (indexPath.section) {
        case 0:
            dictStr = @"About The Bureau";
            titleStr = @"About 'TheBureau'";
            break;
        case 1:
            dictStr = @"How the app works";
            titleStr = @"How the app works";
            break;
        case 2:
            dictStr = @"Why it was created";
            titleStr = @"Why 'TheBureau'";
            break;
        case 3:
            dictStr = @"How is it different";
            titleStr = @"How is it different";
            break;
        case 4:
            dictStr = @"History of the application";
            titleStr = @"TheBureau History";
            break;
        default:
            break;
    }
    
    UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Accounts" bundle:nil];
    BUHowItWorksDetailVc *vc = [sb instantiateViewControllerWithIdentifier:@"BUHowItWorksDetailVc"];
    vc.textViewText = [self.textDict objectForKey:dictStr];
    vc.titleString = titleStr;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
