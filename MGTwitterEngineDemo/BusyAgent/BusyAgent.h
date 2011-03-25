//
//  BusyAgent.h
//  Pagination
//
//  Created by Shaikh Sonny Aman on 1/12/10.
//  Copyright 2010 SHAIKH SONNY AMAN :) . All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Simple class to show a gray screen overlay above all view
 */
@interface BusyAgent : NSObject {
	UIView* view;
	UIActivityIndicatorView* wait;
	UILabel* busyLabel;
	int busyCount;
}

/**
 * call this function. Pass yes if want to set busy mode.
 * pass No if your done with your busy state
 */
- (void) makeBusy:(BOOL)yesOrno;

/**
 * Better use these methods
 */
- (void) queueBusy;
- (void) dequeueBusy;

/**
 * Messed up with updateBusyState? call this method to remove busy state
 */
- (void) forceRemoveBusyState;

/**
 * Factory method
 */
+ (BusyAgent*)defaultAgent;

@end
