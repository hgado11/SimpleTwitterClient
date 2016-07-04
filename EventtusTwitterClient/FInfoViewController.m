//
//  FInfoViewController.m
//  EventtusTwitterClient
//
//  Created by Hassan Gado on 7/4/16.
//  Copyright © 2016 Hassan Gadou. All rights reserved.
//

#import "FInfoViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TwitterClient.h"
#import "STTwitter.h"

#define default_profile_background_image_url @"http://abs.twimg.com/images/themes/theme1/bg.png"
#define default_profile_image_url @"http://abs.twimg.com/sticky/default_profile_images/default_profile_5_normal.png"


@interface FInfoViewController ()


@end

@implementation FInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     @try {
    self.navigationItem.title=[self.user objectForKey:@"screen_name"];
    self.name.text=[self.user objectForKey:@"name"];
    
    if([self.user objectForKey:@"profile_banner_url"]!=nil){
        NSLog(@"profile_banner_url : %@",[self.user objectForKey:@"profile_banner_url"]);
    [self.profile_background sd_setImageWithURL:[NSURL URLWithString:[self.user objectForKey:@"profile_banner_url"]]
                               placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"profile_background_%@.png",[self.user objectForKey:@"screen_name"]]]];}
    else{
        //Default Background Image
        [self.profile_background sd_setImageWithURL:[NSURL URLWithString:default_profile_background_image_url]
        placeholderImage:[UIImage imageNamed:@"profile_background.png"]];
    }
    
    if([self.user objectForKey:@"profile_image_url"]!=nil){
    [self.profile_image sd_setImageWithURL:[NSURL URLWithString:[self.user objectForKey:@"profile_image_url"]]
                          placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"profile_image_url_%@.png",[self.user objectForKey:@"screen_name"]]]];
    }else{
        //Default Profile Image
        [self.profile_image sd_setImageWithURL:[NSURL URLWithString:default_profile_image_url]
                              placeholderImage:[UIImage imageNamed:@"profile_image.png"]];
        
        
    }
         [self loadUserTimeLineTweets];}
    @catch ( NSException *e ) {
        
        NSLog(@"Exception : %@",e);
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tweets count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tweetCell"];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"tweetCell"];
    }
    
    NSDictionary *status = [_tweets objectAtIndex:indexPath.row];
    
    NSString *text = [status valueForKey:@"text"];
    NSString *screenName = [status valueForKeyPath:@"user.screen_name"];
    NSString *dateString = [status valueForKey:@"created_at"];
    
    cell.textLabel.text = text;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"@%@ | %@", screenName, dateString];
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"%@ TimeLine",[self.user objectForKey:@"screen_name"]];
}

 #pragma mark - Private

-(void)loadUserTimeLineTweets{
    TwitterClient * client= [[TwitterClient alloc]init];
    [client.twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
        NSLog(@"Success");
  [client.twitter getUserTimelineWithScreenName:[self.user objectForKey:@"screen_name"] successBlock:^(NSArray *statuses) {
     
      self.tweets=[NSMutableArray arrayWithArray:statuses];
      [self.fTweets reloadData];
      
    } errorBlock:^(NSError *error) {
       // self.twitterGetTimelineStatus = error ? [error localizedDescription] : @"Unknown error";
    }];
    } errorBlock:^(NSError *error) {
        NSLog(@"Error %@",error);
    }];
}
 


@end
