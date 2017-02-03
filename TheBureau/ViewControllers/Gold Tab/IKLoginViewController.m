//
//    Copyright (c) 2015 Shyam Bhat
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy of
//    this software and associated documentation files (the "Software"), to deal in
//    the Software without restriction, including without limitation the rights to
//    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//    the Software, and to permit persons to whom the Software is furnished to do so,
//    subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "IKLoginViewController.h"
#import "InstagramKit.h"

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "BUUtilities.h"
#import "BUConstants.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface IKLoginViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation IKLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView.scrollView.bounces = NO;
    
    self.title = [_socialType isEqualToString:@"instagram"] ? @"Instagram" : @"Facebook";

    [self.navigationItem.leftBarButtonItem setEnabled:YES];
    [self.navigationItem.leftBarButtonItem setTarget:self];
    [self.navigationItem.leftBarButtonItem setAction:@selector(dismissView)];

    
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    [self.navigationItem.rightBarButtonItem setTarget:self];
    [self.navigationItem.rightBarButtonItem setAction:@selector(dismissVC)];
    
    [self.parentController stopActivityIndicator];
    
    
    NSURL *authURL = [_socialType  isEqualToString: @"instagram"] ? [NSURL URLWithString:@"https://www.instagram.com/thebureauapp/"] : [NSURL URLWithString:@"https://www.facebook.com/thebureauapp/"];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:authURL]];
    self.webView.delegate = self;
    
//    NSString *clientID = @"03c1d9841c354ae4b01d41d7751dca52";
//    
//    NSString *redirectUri = @"https://www.instagram.com/thebureauapp/";
//    
//    
//    
//    NSString *urlAddress =[NSString stringWithFormat:@"https://instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=code",clientID,redirectUri];
//    
//    NSURL *nsurl=[NSURL URLWithString:urlAddress];
//    
//    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
//    
//    [self.webView loadRequest:nsrequest];
//    
//    self.webView.delegate = self;
    
}

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//    NSString *orignalUrl =[request.URL absoluteString];
//    
////    if ([orignalUrl hasPrefix:CALLBACKURL])
////    {
////        NSString *myurl =[NSString stringWithFormat:@"https://api.instagram.com/v1/users/25025320/relationship?access_token=%@",request_token];
////
////        NSString *action=@"action=follow";
////
////        BsyncTask *task = [[BsyncTask alloc]init];
////
////        [task asynchronousPost:action url:myurl callerName:@"followTask"];//post this as you like
////
////        task.recieveAsyncResponse = self;
////    }
//    
//    NSLog(@"%@",orignalUrl);
//    
//    NSString *clientID = @"03c1d9841c354ae4b01d41d7751dca52";
//    
//    NSArray* parts = [orignalUrl componentsSeparatedByString: @"="];
//        
//    NSString *request_token = [parts objectAtIndex: 1];
//    
////    NSString *urlString=[NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/relationship?access_token=%@",clientID,request_token];
////    
////    NSURL* url = [NSURL URLWithString:urlString];
////    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:1000.0];
////    NSString *parameters=@"action=follow";
////    [theRequest setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
////    [theRequest setHTTPMethod:@"POST"];
////
////    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
////    
////    if(conn) {
////        NSLog(@"Connection Successful");
////    } else {
////        NSLog(@"Connection could not be made");
////    }
//    
//    NSString *urlString=[NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/follows?access_token=%@",request_token];
//    
//    NSLog(@"%@",urlString);
//    
//    NSURL *identityTokenURL = [NSURL URLWithString:urlString];
//    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:identityTokenURL];
//    theRequest.HTTPMethod = @"POST";
//    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    
//    NSString *parameters = @"action=follow";
//    
//    NSData *postData = [parameters dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    
//    //NSData *requestBody = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
//    theRequest.HTTPBody = postData;
//    
//    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
//    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        if (error) {
//            //completion(nil, error);
//            return;
//        }
//        
//        // Deserialize the response
//        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//        
//        NSLog(@"%@",responseObject);
//        
////        if(![responseObject valueForKey:@"error"])
////        {
////            NSString *identityToken = responseObject[@"identity_token"];
////            completion(identityToken, nil);
////        }
////        else
////        {
////            NSString *domain = @"layer-identity-provider.herokuapp.com";
////            NSInteger code = [responseObject[@"status"] integerValue];
////            NSDictionary *userInfo =
////            @{
////              NSLocalizedDescriptionKey: @"Layer Identity Provider Returned an Error.",
////              NSLocalizedRecoverySuggestionErrorKey: @"There may be a problem with your APPID."
////              };
////            
////            NSError *error = [[NSError alloc] initWithDomain:domain code:code userInfo:userInfo];
////            completion(nil, error);
////        }
//        
//    }] resume];
//    
//    
//    
//    return YES;
//}

// This method is used to receive the data which we get using post method.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data {
    
}

// This method receives the error report in case of connection is not made to server.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@",error.description);
}

// This method is used to process the data after connection has made successfully.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
}

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//    NSString *orignalUrl =[request.URL absoluteString];
//    
//    if ([orignalUrl hasPrefix:CALLBACKURL])
//    {
//        NSArray* parts = [orignalUrl componentsSeparatedByString: @"="];
//        
//        NSString *request_token = [parts objectAtIndex: 1];
//        
//        NSString *myurl =[NSString stringWithFormat:@"https://api.instagram.com/v1/users/25025320/relationship?access_token=%@",request_token];
//        
//        NSString *action=@"action=follow";
//        
//        BsyncTask *task = [[BsyncTask alloc]init];
//        
//        [task asynchronousPost:action url:myurl callerName:@"followTask"];//post this as you like
//        
//        task.recieveAsyncResponse = self;
//    }
//    
//    return YES;
//}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    
    NSLog(@"%@",request);
    if ([_socialType isEqualToString:@"instagram"]) {
        
        NSError *error;
        if ([[InstagramEngine sharedEngine] receivedValidAccessTokenFromURL:request.URL error:&error])
        {
            [self authenticationSuccess];
        }
    }
    else
    {
        [self authenticationSuccess];
    }
   
    
    return YES;
}


- (void)webViewDidStartLoad:(UIWebView *)webView;
{
    [self.parentController startActivityIndicator:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    [self.parentController stopActivityIndicator];
}


- (void)authenticationSuccess
{
    [self.navigationItem.leftBarButtonItem setEnabled:YES];
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
}

-(void)dismissView
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)dismissVC
{
//    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
//                                  initWithGraphPath:@"/{page-id}/likes"
//                                  parameters:params
//                                  HTTPMethod:@"GET"];
//    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
//                                          id result,
//                                          NSError *error) {
//        // Handle the result
//    }];
    NSString * media = _socialType;
    
    NSDictionary *parameters = nil;
    parameters = @{@"userid": [BUWebServicesManager sharedManager].userID,
                   @"social_media": media
                   };
    [self.parentController startActivityIndicator:YES];
    
    
    NSString *baseURl = @"http://app.thebureauapp.com/admin/socialShare";
    
    [[BUWebServicesManager sharedManager] queryServer:parameters
                                              baseURL:@"profile/socialShare"
                                         successBlock:^(id response, NSError *error)
     {
         
         [self.parentController stopActivityIndicator];
         
         //{"msg":"Success","response":"Thank you for the share"}
         
       //  NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[response objectForKey:@"response"]]];
         
        
         NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:[_socialType isEqualToString:@"instagram"] ? @"Thanks for following us on Instagram": @"Thanks for liking us on Facebook" ] ;
         [message addAttribute:NSFontAttributeName
                         value:[UIFont fontWithName:@"comfortaa" size:15]
                         range:NSMakeRange(0, message.length)];
         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
         [alertController setValue:message forKey:@"attributedTitle"];
         
         [alertController addAction:({
             UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                      {
                                          
                                          
                                          if ([[response objectForKey:@"msg"] isEqualToString:@"Success"]) {
                                              if ([_socialType isEqualToString:@"instagram"]) {
                                                  self.parentController.instagramFollowDone = YES;
                                              }
                                              
                                              else{
                                                  self.parentController.fbLikeDone = YES;
                                              }
                                              
                                          }
                                          
                                          [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                                          //[self.parentController startActivityIndicator:YES];
                                          [self.parentController updateGold:50 did:@"Earned"];
                                      }];
             
             action;
         })];
         [self presentViewController:alertController  animated:YES completion:nil];
         
     }
                                         failureBlock:^(id response, NSError *error) {
                                             
                                             [self.parentController stopActivityIndicator];
                                             
                                             if (error.code == NSURLErrorTimedOut) {
                                                 
                                                 [self.parentController timeoutError:@"Connection timed out, please try again later"];
                                             }
                                             
                                             
                                             else
                                             {
                                             
                                             NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"Connectivity Error!"];
                                             [message addAttribute:NSFontAttributeName
                                                             value:[UIFont fontWithName:@"comfortaa" size:15]
                                                             range:NSMakeRange(0, message.length)];
                                             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
                                             [alertController setValue:message forKey:@"attributedTitle"];
                                             
                                             [alertController addAction:({
                                                 UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                                                          {
                                                                              [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                                                                              
                                                                          }];
                                                 
                                                 action;
                                             })];
                                                 
                                            
                                             [self presentViewController:alertController  animated:YES completion:nil];
                                                 
                                             }
                                             
                                         }];
    
                                         
    
}

@end
