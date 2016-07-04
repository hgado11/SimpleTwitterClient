//
//  FollowersTableViewController.m
//  EventtusTwitterClient
//
//  Created by Hassan Gado on 7/3/16.
//  Copyright © 2016 Hassan Gadou. All rights reserved.
//

#import "FollowersTableViewController.h"
#import "FollowTableViewCell.h"
#import "TwitterClient.h"
#import "userLoginCredential.h"
#import "UIImageView+AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FInfoViewController.h"
NSString * const kCurrentUserKey = @"kCurrentUserKey";
#define TWITTER_CONSUMER_KEY @"AcGH5DkNFIDzQb5KqIh8kqmK8"
#define TWITTER_CONSUMER_SECRET @"b1N3E00lJpHQrLI513kBqvkjLcEqnJyWUPIjMjhMU93JkqaIxg"



@interface FollowersTableViewController ()
@property (nonatomic,strong) NSMutableArray * followers;
@property (nonatomic,strong) STTwitterAPI * twitter;

@end

@implementation FollowersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self loadFollowerData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadFollowerData{
    UserLoginCredential* user=[UserLoginCredential currentUser];
    if(user){
        // Old User
        _twitter = [STTwitterAPI twitterAPIWithOAuthConsumerName:@""
                                                      consumerKey:TWITTER_CONSUMER_KEY
                                                   consumerSecret:TWITTER_CONSUMER_SECRET
                                                       oauthToken:[user.data objectForKey:@"oauthToken"]
                                                oauthTokenSecret:[user.data objectForKey:@"oauthTokenSecret"]];
        NSLog(@"oauthToken: %@",[user.data objectForKey:@"oauthToken"]);
        NSLog(@"oauthTokenSecret: %@",[user.data objectForKey:@"oauthTokenSecret"]);
        
        [_twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
            [_twitter getFollowersForScreenName:username successBlock:^(NSArray *followers) {
                NSLog(@"-- success, more to come: %lu", (unsigned long)[followers count]);
                self.followers=[NSMutableArray arrayWithArray:followers];
                [self.tableView reloadData];
            }errorBlock:^(NSError *error) {
                NSLog(@"-- %@", error);
            }];
        
        } errorBlock:^(NSError *error) {
                NSLog(@"-- %@", error);
            }];
        
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.followers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FollowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"followerCell" forIndexPath:indexPath];
    
    NSDictionary *follower = [_followers objectAtIndex:indexPath.row];
    [self configureCell:cell forFollowerStyle:follower];
    
    return cell;
}

- (void)configureCell:(FollowTableViewCell *)cell forFollowerStyle:(NSDictionary *)style {
    cell.followName.text=[style objectForKey:@"name"];    //Download
    cell.followHandle.text=[style objectForKey:@"screen_name"];
        [cell.followImage sd_setImageWithURL:[NSURL URLWithString:[style objectForKey:@"profile_image_url"]]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    cell.followBio.text= [style objectForKey:@"description"];
    
}




#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"toFollowDetails"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        FInfoViewController * followDeatil = [segue destinationViewController];
         followDeatil.user=[NSMutableDictionary dictionaryWithDictionary:[_followers objectAtIndex:indexPath.row]];
    }
}



@end
