//
//  DDPostTweetDialog.m
//  TheInDesignGuru
//
//  Created by khangvo on 10/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DDPostTweetDialog.h"

@implementation DDPostTweetDialog
@synthesize tweet;
@synthesize placeHolder;

@synthesize tweetView;
@synthesize charactersLeft;
@synthesize submitButton;
@synthesize delegate;
@synthesize tableView;

#define TWEET_LENGTH 140

#pragma mark Object
- (id)initWithDelegate:(id)aDelegate theme:(DDSocialDialogTheme)theme placeHolder:(NSString *)tweetPlaceHolder {
    
	// Hardcode the dialog CGSize to {250, 210}, especially optimized for iPhone landscape view.
    if ((self = [super initWithFrame:CGRectMake(0, 0, 250, 250) theme:theme])) {
		// DDSocialLoginDialogDelegate
		self.delegate = aDelegate;
		// DDSocialDialogDelegate, so you can use -socialDialogDidSucceed:(socialDialog *) when user cancel the dialog. This is optional.
		self.dialogDelegate = aDelegate;
        self.placeHolder = tweetPlaceHolder;
		// Setup title
		switch (theme) {
			case DDSocialDialogThemePlurk:
				self.titleLabel.text = NSLocalizedString(@"Plurk Login", nil);
				break;
			case DDSocialDialogThemeTwitter:
			default:
				self.titleLabel.text = NSLocalizedString(@"Twitter Login", nil);
				break;
		}
		
		self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
		self.tableView.delegate = self;
		self.tableView.dataSource = self;
		self.tableView.scrollEnabled = NO;
		self.tableView.backgroundColor = [UIColor whiteColor];
		[self.contentView addSubview:self.tableView];
	}
    return self;
}

- (void)dealloc {
	delegate = nil;
	self.tableView.delegate = nil;
	self.tableView.dataSource = nil;
	[self.tableView release], self.tableView = nil;
	[tableView release];
	[delegate release];
	[charactersLeft release];
	[submitButton release];
	[placeHolder release];
	[tweet release];
    [super dealloc];
}

#pragma mark -
#pragma mark layout

- (void)layoutSubviews {
	[super layoutSubviews];
	
	self.tableView.frame = self.contentView.bounds;
}

- (void)show {
	
	// Call super first to setup dialog before adding your stuffs
	[super show];	
	[self setNeedsLayout];
}


- (UITextView *)tweetView {
    if (tweetView == nil) {
		tweetView = [[UITextView alloc] initWithFrame:CGRectMake(8., 0., self.tableView.frame.size.width - 32., 78.f)];
		tweetView.delegate = self;
        tweetView.autocorrectionType = UITextAutocorrectionTypeNo;
        tweetView.font = [UIFont systemFontOfSize:12];
	} 
    
	return tweetView;
}

- (UILabel *)charactersLeft {
    if (charactersLeft == nil) {
        charactersLeft = [[UILabel alloc] initWithFrame:CGRectMake(-3, -3, self.tableView.frame.size.width, 30.f)];
        charactersLeft.font = [UIFont systemFontOfSize:10.f];
        charactersLeft.textAlignment = UITextAlignmentLeft;
    }
    return charactersLeft;
}

- (void)updateCharactersLeft {
    NSInteger tweetLengthLeft = TWEET_LENGTH - [self.tweetView.text length];
    self.charactersLeft.text = [NSString stringWithFormat:@"%d characters left", tweetLengthLeft];
    if (tweetLengthLeft <= 0) {
        self.charactersLeft.textColor = [UIColor redColor];
    }
}


#pragma mark UITableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tweetView resignFirstResponder];
    
    if (indexPath.section == 2) {
        self.tweet = self.tweetView.text;
        // Here is a submit button
//		if ([self.delegate conformsToProtocol:@protocol(DDPostTweetDialogDelegate)]) {
			if ([self.delegate respondsToSelector:@selector(didGettingTweetFromTweetDialog:)]) {
				[self.delegate didGettingTweetFromTweetDialog:self];
			}		
//		}
        [self dismiss:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell Identifier";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if (indexPath.section == 0 || indexPath.section == 1) {
		for (UIView *subview in cell.contentView.subviews) {
			[subview removeFromSuperview];
		}
    }    

    switch (indexPath.section) {
        case 0:
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:[self tweetView]];
            if (!self.placeHolder) {
                self.placeHolder = @"";
            }
            self.tweetView.text = self.placeHolder;
//            self.tweetView.text = [NSString stringWithFormat:@"This movie is so cool %@", self.placeHolder];
            break;
        case 1:
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:self.charactersLeft];
            [self updateCharactersLeft];
            break;
        case 2:
            cell.textLabel.text = @"Tweet It";
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80.f;
    } else if (indexPath.section == 1) {
        return 10.f;
    }
    return 20.f;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

#pragma mark TextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    [self updateCharactersLeft];
}

@end