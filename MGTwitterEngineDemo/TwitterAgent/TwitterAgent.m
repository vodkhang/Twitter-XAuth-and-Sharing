//
//  TwitterAgent.m
//  Pagination
//
//  Created by Shaikh Sonny Aman on 1/6/10.
//  Copyright 2010 SHAIKH SONNY AMAN :) . All rights reserved.
//

#import "TwitterAgent.h"
#import "BusyAgent.h"
#import "xmacros.h"

#define XAGENTS_TWITTER_CONFIG_FILE DOC_PATH(@"xagents_twitter_conifg_file.plist")

static TwitterAgent* agent;

@implementation TwitterAgent
@synthesize delegate;

@synthesize userName,password,sharedLink,parentsv,loginOnly, message;
-(id)init{
	self = [super init];
	maxCharLength = 140;
	parentsv = nil;
	
	isLogged = NO;
	txtMessage = [[UITextView alloc] initWithFrame:CGRectMake(15, 80, 250, 60)];
	UIImageView* bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fb_message_bg.png"]];
	bg.frame = txtMessage.frame;
	
	lblCharLeft = [[UILabel alloc] initWithFrame:CGRectMake(15, 142, 250, 20)];
	lblCharLeft.font = [UIFont systemFontOfSize:10.0f];
	lblCharLeft.textAlignment = UITextAlignmentRight;
	lblCharLeft.textColor = [UIColor whiteColor];
	lblCharLeft.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
	
	txtUsername = [[UITextField alloc]initWithFrame:CGRectMake(110, 60, 150, 30)];
	txtPassword = [[UITextField alloc]initWithFrame:CGRectMake(110, 95, 150, 30)];
	txtPassword.secureTextEntry = YES;
	
	lblId = [[UILabel alloc]initWithFrame:CGRectMake(5, 60, 100, 30)];
	lblPassword = [[UILabel alloc]initWithFrame:CGRectMake(5, 95, 100, 30)];
	lblId.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
	lblPassword.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
	lblId.textColor = [UIColor whiteColor];
	lblPassword.textColor = [UIColor whiteColor];
	
	
	txtMessage.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
	
	lblId.text = @"Username:";
	lblPassword.text =@"Password:";
	lblId.textAlignment = UITextAlignmentRight;
	lblPassword.textAlignment = UITextAlignmentRight;
	
	
	txtUsername.borderStyle = UITextBorderStyleRoundedRect;
	txtPassword.borderStyle = UITextBorderStyleRoundedRect;
	
	txtMessage.delegate = self;
	txtUsername.delegate = self;
	txtPassword.delegate = self;
	
	loginDialog = [[UIAlertView alloc] initWithTitle:@"Login to twitter" message:@"\n\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Log in",nil];
	
	loginDialog.tag =1;
	
	[loginDialog addSubview:txtUsername];
	[loginDialog addSubview:txtPassword];
	[loginDialog addSubview:lblId];
	[loginDialog addSubview:lblPassword];
	UIImageView* logo = [[UIImageView alloc] initWithFrame:CGRectMake(35, 0, 48, 48)];
	logo.image = [UIImage imageNamed:@"Twitter_logo.png"];
	[loginDialog addSubview:logo];

	[logo release];
	
	
	lblURL  = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, 250, 20)];
	lblURL.font = [UIFont systemFontOfSize:12];
	lblURL.backgroundColor =[UIColor colorWithRed:0 green:0 blue:0 alpha:0]; 
	lblURL.textColor = [UIColor whiteColor];
	
	messageDialog = [[UIAlertView alloc] initWithTitle:sharedLink message:@"\n\n\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send",nil];
	messageDialog.tag =2;
	[messageDialog addSubview:lblCharLeft];
	[messageDialog	addSubview:bg];
	[messageDialog addSubview:txtMessage];
	[messageDialog addSubview:lblURL];
	[messageDialog bringSubviewToFront:txtMessage];
	[bg release];
	
	
	
	UIImageView* logo1 = [[UIImageView alloc] initWithFrame:CGRectMake(25, 5, 42, 42)];
	logo1.image = [UIImage imageNamed:@"twitter-logo-twit.png"];
	[messageDialog addSubview:logo1];
	[logo1 release];
	
	//logout button
	btnLogout = [[UIButton alloc] initWithFrame:CGRectMake(250, 5, 24, 24)];
	[btnLogout setImage:[UIImage imageNamed:@"twitter_agent_sign_out.png"] forState:UIControlStateNormal];
	[btnLogout addTarget:self action:@selector(loginAgain) forControlEvents:UIControlEventTouchUpInside];
	[messageDialog addSubview:btnLogout];
	
	return self;
}
-(void)logout{
	txtUsername.text =@"";
	txtPassword.text =@"";
	isLogged = NO;
    
    [self.delegate logout];
}
- (void) loginAgain{
	[messageDialog dismissWithClickedButtonIndex:messageDialog.cancelButtonIndex animated:YES];
	[self logout];
	[self login];
}

-(BOOL)isConnected{
	return isLogged;
}
-(void)login{
    [loginDialog show];
}

- (void)willPresentAlertView:(UIAlertView *)alertView{
	currentAlertTag = alertView.tag;
	//loginDialog.transform = CGAffineTransformTranslate(loginDialog.transform, 10, -100);
	if(currentAlertTag==1){
		NSDictionary* config = [NSDictionary dictionaryWithContentsOfFile:XAGENTS_TWITTER_CONFIG_FILE];
		if(config){
			NSString* uname = [config valueForKey:@"username"];
			if(uname){
				txtUsername.text = uname;
			}
			
			NSString* pw = [config valueForKey:@"password"];
			if(pw){
				txtPassword.text = pw;
			}
		}
		
		alertView.frame = CGRectMake(alertView.frame.origin.x, 50,alertView.frame.size.width, alertView.frame.size.height);
	}else{
		alertView.frame = CGRectMake(alertView.frame.origin.x, 30,alertView.frame.size.width, alertView.frame.size.height);
	}
}
- (void)didPresentAlertView:(UIAlertView *)alertView{
	
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	if(buttonIndex ==alertView.cancelButtonIndex){
		[[BusyAgent defaultAgent] makeBusy:NO];
		return;
	}
	
	if(currentAlertTag==1){
		if([[alertView buttonTitleAtIndex:buttonIndex] compare:@"Log in"] == NSOrderedSame){
			if([txtUsername.text length] >0 && [txtPassword.text length] > 0){
	//			SET_BUSY_MODE
				
				[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(OnLogin:) userInfo:nil repeats:NO];
			}else {
	//			UNSET_BUSY_MODE
				[[BusyAgent defaultAgent] makeBusy:NO];
			}

		}else {
	//		UNSET_BUSY_MODE
			[[BusyAgent defaultAgent] makeBusy:NO];
		}

	}else{
		if([[alertView buttonTitleAtIndex:buttonIndex] compare:@"Send"] == NSOrderedSame){
	//		SET_BUSY_MODE
			//[[BusyAgent defaultAgent] makeBusy:YES];
			// used timer to avoid random crashes
			[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(OnSend:) userInfo:nil repeats:NO];
		}
	}
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
	const char* str = [text UTF8String];
	
	int s = str[0];
	if(s!=0)
	if((range.location + range.length) > maxCharLength){
		return NO;
	}else{
		int left = 139 - ([sharedLink length] + [textView.text length]);
		lblCharLeft.text= [NSString stringWithFormat:@"%d",left];
		
		
		// this fix was done by Jackie
		//http://amanpages.com/sample-iphone-example-project/twitteragent-tutorial-tweet-from-iphone-app-in-one-line-code-with-auto-tinyurl/#comment-38026299
		if([text isEqualToString:@"\n"]){
			[textView resignFirstResponder];
			return FALSE;
		}else{
			return YES;
		}
	}
	
	int left = 139 - ([sharedLink length] + [textView.text length]);
	lblCharLeft.text= [NSString stringWithFormat:@"%d",left];
	return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
	[textField becomeFirstResponder];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	//[self startUpload];
	return NO;
}
-(void)viewWillAppear:(BOOL)animated{
	//txtMessage.text = @"Check out this SUPER cute puppy!";
	NSString* msg = @"Check this out!";
	txtMessage.text =msg;
	txtUsername.text = userName;
	txtPassword.text = password;
}


- (IBAction)OnCancel:(id)sender {
	//UNSET_BUSY_MODE
	[[BusyAgent defaultAgent] makeBusy:NO];
}

- (void)OnLogin:(id)sender {
    self.userName = txtUsername.text;
    self.password = txtPassword.text;
    [self.delegate loginWithUserName:self.userName password:self.password];
}

- (void)OnSend:(id)sender {
    [self.delegate sendWithText:txtMessage.text];
}

- (void)sendMessage:(NSString *)sentMessage {
    
	if(message){
		txtMessage.text = message;
	}	
	maxCharLength = 139 - ([sharedLink length] + [message length]);
	messageDialog.title = @"Tweet this post";
    
	lblCharLeft.text = [NSString stringWithFormat:@"%d", maxCharLength];
	lblURL.text = sharedLink; 
    
    [messageDialog show];
}

+ (TwitterAgent*)defaultAgentWithDelegate:(id <TwitterAgentDelegate>)delegate {
	if(!agent){
		agent = [TwitterAgent new];
        agent.delegate = delegate;
	}
	return agent;
}
-(void)dealloc{
	[message release];
	[txtMessage release];
	[txtUsername release];
	[txtPassword release];
	
	[lblId release];
	[lblPassword release];
	[lblURL release];
	
	
	[loginDialog release];
	[messageDialog release];
	//[btnSend release];
	//[btnCancel release];
	[super dealloc];
}
@end