//
//  ViewController.m
//  EventtusTwitterClient
//
//  Created by Hassan Gado on 6/30/16.
//  Copyright © 2016 Hassan Gadou. All rights reserved.
//
#import "ViewController.h"
#import "STTwitter.h"
#import "WebViewController.h"
#import <Accounts/Accounts.h>
#import "userLoginCredential.h"
#import <objc/runtime.h>

@interface NSDictionary(dictionaryWithObject)

+(NSDictionary *) dictionaryWithPropertiesOfObject:(id) obj;

@end
@implementation NSDictionary(dictionaryWithObject)

+(NSDictionary *) dictionaryWithPropertiesOfObject:(id)obj
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        [dict setObject:[obj valueForKey:key] forKey:key];
    }
    
    free(properties);
    
    return [NSDictionary dictionaryWithDictionary:dict];
}

@end


typedef void (^accountChooserBlock_t)(ACAccount *account, NSString *errorMessage); // don't bother with NSError for that
#define TWITTER_BASE_URL [NSURL URLWithString:@"https://api.twitter.com"]
#define TWITTER_CONSUMER_KEY @"JhmxXoWsFZsN4UOrZGwj1mhGW"
#define TWITTER_CONSUMER_SECRET @"JpNG4AlSaXbs2BkQ9gvI11LWg09sAQTaAY4Kc7qdjTtYqr0DD5"
static NSString * const kAccessTokenKey = @"kAccessTokenKey";

@interface ViewController ()
@property (nonatomic, strong) STTwitterAPI *twitter;
@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) NSArray *iOSAccounts;
@property (nonatomic, strong) accountChooserBlock_t accountChooserBlock;
@property (nonatomic, strong) NSMutableArray * followersIDs;
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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
        userLoginCredential * user= [userLoginCredential new];
        [user initWithToken:oauthToken secret:oauthTokenSecret verifier:verifier userID:userID sreenName:screenName];
        NSDictionary * userDic= [NSDictionary dictionaryWithPropertiesOfObject:user];
        [[NSUserDefaults standardUserDefaults] setObject:userDic forKey:kAccessTokenKey];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
       
        /*
                 At this point, the user can use the API and you can read his access tokens with:
         
         _twitter.oauthAccessToken;
         _twitter.oauthAccessTokenSecret;
         
         You can store these tokens (in user default, or in keychain) so that the user doesn't need to authenticate again on next launches.
         
         Next time, just instanciate STTwitter with the class method:
         
         +[STTwitterAPI twitterAPIWithOAuthConsumerKey:consumerSecret:oauthToken:oauthTokenSecret:]
         
         Don't forget to call the -[STTwitter verifyCredentialsWithSuccessBlock:errorBlock:] after that.
         */
        
    } errorBlock:^(NSError *error) {
        
       
        NSLog(@"-- %@", [error localizedDescription]);
    }];
}

@end
