//
//  userLoginCredential.h
//  EventtusTwitterClient
//
//  Created by Hassan Gado on 7/1/16.
//  Copyright © 2016 Hassan Gadou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface userLoginCredential : NSObject

@property ( nonatomic, copy) NSString *oauthToken;

@property ( nonatomic, copy) NSString *oauthTokenSecret;

@property ( nonatomic, copy) NSString *userID;

@property (nonatomic, copy) NSString *verifier;

@property (nonatomic,copy) NSString * screenName;


- (void)initWithToken:(NSString *)token
           secret:(NSString *)secret
          verifier:(NSString *)verifier
       userID:(NSString *)userID
          sreenName:(NSString *)sreenName;

@end
