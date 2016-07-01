//
//  userLoginCredential.m
//  EventtusTwitterClient
//
//  Created by Hassan Gado on 7/1/16.
//  Copyright © 2016 Hassan Gadou. All rights reserved.
//

#import "userLoginCredential.h"

@implementation userLoginCredential
- (void)initWithToken:(NSString *)token
             secret:(NSString *)secret
           verifier:(NSString *)verifier
             userID:(NSString *)userID
          sreenName:(NSString *)sreenName{
    
    self.oauthToken=token;
    self.oauthTokenSecret=secret;
    self.verifier=verifier;
    self.userID=userID;
    self.screenName=sreenName;
  
}

@end
