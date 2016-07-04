//
//  UserLoginCredential.h
//  EventtusTwitterClient
//
//  Created by Hassan Gado on 7/1/16.
//  Copyright © 2016 Hassan Gadou. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString *const UserDidLoginNotification;
extern NSString *const UserDidLogoutNotification;

@interface UserLoginCredential : NSObject
// public static class methods
+ (UserLoginCredential *)currentUser;
+ (void)setCurrentUser:(UserLoginCredential *)currentUser;




@property (nonatomic, strong) NSDictionary *data;


- (id)initWithDictionary:(NSDictionary *)data;

@end
