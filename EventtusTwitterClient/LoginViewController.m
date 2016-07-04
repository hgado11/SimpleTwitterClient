//
//  LoginViewController.m
//  EventtusTwitterClient
//
//  Created by Hassan Gado on 6/30/16.
//  Copyright © 2016 Hassan Gadou. All rights reserved.
//
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "STTwitter.h"
#import "WebViewController.h"
#import <Accounts/Accounts.h>
#import "UserLoginCredential.h"
#import "FollowersTableViewController.h"

typedef void (^accountChooserBlock_t)(ACAccount *account, NSString *errorMessage); // don't bother with NSError for that
#define TWITTER_BASE_URL [NSURL URLWithString:@"https://api.twitter.com"]
#define TWITTER_CONSUMER_KEY @"AcGH5DkNFIDzQb5KqIh8kqmK8"
#define TWITTER_CONSUMER_SECRET @"b1N3E00lJpHQrLI513kBqvkjLcEqnJyWUPIjMjhMU93JkqaIxg"
static NSString * const kAccessTokenKey = @"kAccessTokenKey";

@interface LoginViewController ()
@property (nonatomic, strong) STTwitterAPI *twitter;
@end


@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UserLoginCredential* user=[UserLoginCredential currentUser];
    if(user){
        self.continueButton.hidden=NO;
        [self.continueButton setTitle:[NSString stringWithFormat:@"Continue With %@",[user.data objectForKey:@"screenName"]] forState:UIControlStateNormal];
    }else{
        self.continueButton.hidden=YES;
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)twitterLogin:(id)sender {
    self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:TWITTER_CONSUMER_KEY
                                                 consumerSecret:TWITTER_CONSUMER_SECRET];
    
    
    [_twitter postTokenRequest:^(NSURL *url, NSString *oauthToken) {
        NSLog(@"-- url: %@", url);
        NSLog(@"-- oauthToken: %@", oauthToken);
        
        
        WebViewController *webViewVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
        
        [self presentViewController:webViewVC animated:YES completion:^{
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [webViewVC.webView loadRequest:request];
        }];
        
        
    } authenticateInsteadOfAuthorize:NO
                    forceLogin:@(YES)
                    screenName:nil
                 oauthCallback:@"eventapp://twitter_access_tokens/"
                    errorBlock:^(NSError *error) {
                        NSLog(@"-- error: %@", error);
                        
                    }];

}
- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier {
    
    // in case the user has just authenticated through WebViewVC
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
    
    [_twitter postAccessTokenRequestWithPIN:verifier successBlock:^(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName) {
        NSLog(@"-- screenName: %@", screenName);
        NSDictionary * userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:oauthToken,@"oauthToken",
                                         oauthTokenSecret,@"oauthTokenSecret",
                                         userID,@"userID",
                                         screenName,@"screenName",
                                         verifier,@"verifier",
                                         nil];
        [UserLoginCredential setCurrentUser:[[UserLoginCredential alloc] initWithDictionary:userDictionary]];
        [self continueAsPrevUser:nil];

           } errorBlock:^(NSError *error) {
        
       
        NSLog(@"-- %@", [error localizedDescription]);
    }];
    }
-(AppDelegate*) app
{
    return (AppDelegate*) [[UIApplication sharedApplication] delegate];
}
- (IBAction)continueAsPrevUser:(id)sender {
    FollowersTableViewController *followsTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FollowersTableViewController"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:followsTableViewController];
    [self app].window.rootViewController = navigationController;
}

@end
