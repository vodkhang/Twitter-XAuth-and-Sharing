//
//  TwitterAgent.h
//  Pagination
//
//  Created by Shaikh Sonny Aman on 1/6/10.
//  Copyright 2010 SHAIKH SONNY AMAN :) . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/**
 *	TwitterAgent is another helper class to help you out in posting twitter.
 *	
 *	It does not use Open Auth. User has to provide his/her username and password
 */
@protocol TwitterAgentDelegate;
@interface TwitterAgent :UIViewController <UITextFieldDelegate, UITextViewDelegate,UIAlertViewDelegate>{
	/**
	 * Views  needed in the twitter alert box
	 */
	UITextView *txtMessage;
    UITextField *txtPassword;
    UITextField *txtUsername;
	
	UILabel* lblId;
	UILabel* lblPassword;
	UILabel* lblURL;
	UILabel* lblCharLeft;
	
	UIButton* btnLogout; // logout button shown on post this twit alert
	
	
	/**
	 * Holds user info and message
	 */
	NSString* userName;
	NSString* password;
	NSString* sharedLink;
	NSString* message;
    
	
	/**
	 * The login dialog
	 */
	UIAlertView* loginDialog;
	
	/** The messsage dialog
	 *
	 */
	UIAlertView* messageDialog;
	
	/**
	 * Flags needed for internal use
	 */
	int currentAlertTag;
	BOOL isLogged;
	BOOL isAuthFailed;
	BOOL loginOnly;
	
	id parentsv;
	
	int maxCharLength;
	
    id <TwitterAgentDelegate>delegate;

}

- (IBAction) OnCancel:(id)sender;
//- (IBAction) OnSend:(id)sender;
- (void) login;
- (void) logout;
- (void) loginAgain;
- (BOOL) isConnected;
- (void) OnLogin:(id)sender;

+ (TwitterAgent*)defaultAgentWithDelegate:(id <TwitterAgentDelegate>)delegate;
//- (void) twit;
//- (void) twit:(NSString*)text;
//- (void) twit:(NSString*)text withLink:(NSString*)link makeTiny:(BOOL)yesOrno;
- (void)sendMessage:(NSString *)message;

@property(nonatomic,assign) NSString* userName;
@property(nonatomic,assign) NSString* password;
@property(nonatomic,retain) NSString* sharedLink;
@property(nonatomic,retain) NSString* message;

@property(nonatomic,assign) id parentsv;

@property(nonatomic,assign) BOOL loginOnly;
@property (nonatomic, retain) id <TwitterAgentDelegate>delegate;
@end


@protocol TwitterAgentDelegate
- (void)sendWithText:(NSString *)text;
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password;

@end