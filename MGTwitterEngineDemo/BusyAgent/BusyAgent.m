//
//  BusyAgent.m
//  Pagination
//
//  Created by Shaikh Sonny Aman on 1/12/10.
//  Copyright 2010 SHAIKH SONNY AMAN :) . All rights reserved.
//

#import "BusyAgent.h"

static BusyAgent* agent;

@implementation BusyAgent
- (id)init{
	return nil;
}

- (id)myinit{
	if( (self = [super init])){
		busyCount = 0;
		UIWindow* keywindow = [[UIApplication sharedApplication] keyWindow];
		view = [[UIView alloc] initWithFrame:[keywindow frame]];
		view.backgroundColor = [UIColor blackColor];
		view.alpha = 0.85;
		
		wait = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		wait.hidesWhenStopped = NO;
		//wait.frame = CGRectMake(147.5,227.5,25,25);
		wait.center = view.center;
		
		// Label idea +code by rocotilos at iphonedevsdk.com(http://www.iphonedevsdk.com/forum/members/rocotilos.html)
		busyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 170, 320, 21)];
		busyLabel.textColor = [UIColor whiteColor];
		busyLabel.backgroundColor = [UIColor clearColor];
		busyLabel.shadowColor = [UIColor blackColor];
		busyLabel.shadowOffset = CGSizeMake(-1,-1);
		busyLabel.textAlignment = UITextAlignmentCenter;
		busyLabel.text = @"Processing Request... Please Wait";
		
		[view addSubview:wait];
		[view addSubview:busyLabel];
		[wait startAnimating];
		
		return self;
	}
	
	return nil;
}

- (void) makeBusy:(BOOL)yesOrno{
	if(yesOrno){
		busyCount++;
	}else {
		busyCount--;
		if(busyCount<0){
			busyCount = 0;
		}
	}
	
	if(busyCount == 1){
		[[[UIApplication sharedApplication] keyWindow] addSubview:view];
		[[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:view];
	}else if(busyCount == 0) {
		[view removeFromSuperview];
	}else {
		[[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:view];
	}

}

- (void) queueBusy{
	[self makeBusy:YES];
}
- (void) dequeueBusy{
	[self makeBusy:NO];
}


- (void) forceRemoveBusyState{
	busyCount = 0;
	[view removeFromSuperview];
}
+ (BusyAgent*)defaultAgent{
	if(!agent){
		agent =[[BusyAgent alloc] myinit];
	}
	return agent;
}
- (void)dealloc{
	[view release];
	[wait release];
	[busyLabel release];
	
	[super dealloc];
}
@end
