//
//  DDPostTweetDialog.h
//  TheInDesignGuru
//
//  Created by khangvo on 10/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDSocialDialog.h"

@interface DDPostTweetDialog : DDSocialDialog <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate> {
  @private
    UITableView *tableView;
    id delegate;
    
    UITextView *tweetView;
    UILabel *charactersLeft;
    UIButton *submitButton;
    
    NSString *placeHolder;
    NSString *tweet;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, assign) id delegate;

@property (nonatomic, retain) IBOutlet UITextView *tweetView;
@property (nonatomic, retain) IBOutlet UILabel *charactersLeft;
@property (nonatomic, retain) IBOutlet UIButton *submitButton;
@property (nonatomic,  copy) NSString *placeHolder;
@property (nonatomic,  copy) NSString *tweet;
- (id)initWithDelegate:(id)aDelegate theme:(DDSocialDialogTheme)theme placeHolder:(NSString *)tweetPlaceHolder;

@end


@protocol DDPostTweetDialogDelegate

- (void)didGettingTweetFromTweetDialog:(DDPostTweetDialog *)tweetDialog;

@end