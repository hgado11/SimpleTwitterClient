//
//  AppDelegate.m
//  EventtusTwitterClient
//
//  Created by Hassan Gado on 6/30/16.
//  Copyright © 2016 Hassan Gadou. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "AFOAuth1Client.h"
#import "FollowersTableViewController.h"
#import "userLoginCredential.h"

@interface AppDelegate ()

- (void)userDidLogin:(id)notification;
- (void)userDidLogout:(id)notification;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
       return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma Private

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([[url scheme] isEqualToString:@"eventapp"] == NO) return NO;
    
    NSDictionary *d = [self parametersDictionaryFromQueryString:[url query]];
    
    NSString *token = d[@"oauth_token"];
    NSString *verifier = d[@"oauth_verifier"];
    NSNotification *notification = [NSNotification notificationWithName:kAFApplicationLaunchedWithURLNotification object:nil userInfo:[NSDictionary dictionaryWithObject:url forKey:kAFApplicationLaunchOptionsURLKey]];
    
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    

    
    LoginViewController *vc = (LoginViewController *)[[self window] rootViewController];
    [vc setOAuthToken:token oauthVerifier:verifier];
    
    return YES;
}
- (NSDictionary *)parametersDictionaryFromQueryString:(NSString *)queryString {
    
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
    NSArray *queryComponents = [queryString componentsSeparatedByString:@"&"];
    
    for(NSString *s in queryComponents) {
        NSArray *pair = [s componentsSeparatedByString:@"="];
        if([pair count] != 2) continue;
        
        NSString *key = pair[0];
        NSString *value = pair[1];
        
        md[key] = value;
    }
    
    return md;
}
#pragma private methods for handling changes from OAuth1Client notifications

- (void)userDidLogin:(id)notification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogout:) name:UserDidLogoutNotification object:nil];
     FollowersTableViewController *followsTableViewController = [[FollowersTableViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:followsTableViewController];
    self.window.rootViewController = navigationController;
}

- (void)userDidLogout:(id)notification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin:) name:UserDidLoginNotification object:nil];
    self.window.rootViewController = [[LoginViewController alloc] init];
}



@end
