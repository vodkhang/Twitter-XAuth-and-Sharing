//
//  XAuthTwitterEngineDemoViewController.h
//  XAuthTwitterEngineDemo
//
//  Created by Aral Balkan on 28/02/2010.
//  Copyright Naklab 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XAuthTwitterEngineDelegate.h"
#import "OAToken.h"

#define kOAuthConsumerKey		@""		// Replace these with your consumer key 
#define	kOAuthConsumerSecret	@""		// and consumer secret from 
										// http://twitter.com/oauth_clients/details/<your app id>

#define kCachedXAuthAccessTokenStringKey	@"cachedXAuthAccessTokenKey"

@class XAuthTwitterEngine;

@interface XAuthTwitterEngineDemoViewController : UIViewController <XAuthTwitterEngineDelegate> {
	IBOutlet UIButton *sendTweetButton;
	
	XAuthTwitterEngine *twitterEngine;
}

@property (nonatomic, retain) UIButton *sendTweetButton;
@property (nonatomic, retain) XAuthTwitterEngine *twitterEngine;

- (IBAction)xAuthAccessTokenRequestButtonTouchUpInside;
- (IBAction)sendTestTweetButtonTouchUpInside;

@end

