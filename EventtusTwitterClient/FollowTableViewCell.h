//
//  FollowTableViewCell.h
//  EventtusTwitterClient
//
//  Created by Hassan Gado on 7/3/16.
//  Copyright © 2016 Hassan Gadou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *followImage;
@property (strong, nonatomic) IBOutlet UILabel *followName;
@property (strong, nonatomic) IBOutlet UILabel *followBio;
@property (strong, nonatomic) IBOutlet UILabel *followHandle;

@end
