//
//  FInfoViewController.h
//  EventtusTwitterClient
//
//  Created by Hassan Gado on 7/4/16.
//  Copyright © 2016 Hassan Gadou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FInfoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIImageView *profile_background;
@property (strong, nonatomic) IBOutlet UIImageView *profile_image;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UITableView *fTweets;
@property (nonatomic, strong) NSMutableArray * tweets;

@property (nonatomic, strong) NSMutableDictionary * user;

@end
