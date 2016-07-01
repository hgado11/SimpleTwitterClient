//
//  ViewController.h
//  EventtusTwitterClient
//
//  Created by Hassan Gado on 6/30/16.
//  Copyright © 2016 Hassan Gadou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTwitter.h"

@interface ViewController : UIViewController 

- (IBAction)twitterLogin:(id)sender;
- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verfier;
@end

