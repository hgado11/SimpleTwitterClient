//
//  TwitterClient.m
//  EventtusTwitterClient
//
//  Created by Hassan Gado on 7/3/16.
//  Copyright © 2016 Hassan Gadou. All rights reserved.
//

#import "TwitterClient.h"
#import "userLoginCredential.h"

#define TWITTER_BASE_URL [NSURL URLWithString:@"https://api.twitter.com"
#define TWITTER_CONSUMER_KEY @"AcGH5DkNFIDzQb5KqIh8kqmK8"
#define TWITTER_CONSUMER_SECRET @"b1N3E00lJpHQrLI513kBqvkjLcEqnJyWUPIjMjhMU93JkqaIxg"
NSString * const kCurrentUserKey = @"kCurrentUserKey";


@implementation TwitterClient

-(id)init{
    
    UserLoginCredential* user=[UserLoginCredential currentUser];
    if(user){
        // Old User
        _twitter =[STTwitterAPI twitterAPIWithOAuthConsumerName:@""
                                                    consumerKey:TWITTER_CONSUMER_KEY
                                                 consumerSecret:TWITTER_CONSUMER_SECRET
                                                     oauthToken:[user.data objectForKey:@"oauthToken"]
                                               oauthTokenSecret:[user.data objectForKey:@"oauthTokenSecret"]];;
        
    }else{
   //New User
        self.twitter=[STTwitterAPI twitterAPIAppOnlyWithConsumerKey:TWITTER_CONSUMER_KEY consumerSecret:TWITTER_CONSUMER_SECRET];}
    return self;
}




@end
