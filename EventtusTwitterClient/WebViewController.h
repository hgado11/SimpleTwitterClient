//
//  WebViewController.h
//  EventtusTwitterClient
//
//  Created by Hassan Gado on 7/1/16.
//  Copyright © 2016 Hassan Gadou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)cancel:(id)sender;

@end
