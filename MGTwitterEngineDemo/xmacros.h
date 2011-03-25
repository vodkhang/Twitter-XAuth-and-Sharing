/*
 *  xmacros.h
 *  eatlate
 *
 *  Created by Shaikh Sonny Aman on 1/24/10.
 *  Copyright 2010 SHAIKH SONNY AMAN :) . All rights reserved.
 *
 */

#define DEVICE_ID [[UIDevice currentDevice] uniqueIdentifier]
#define DOC_PATH(path)[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:path]
#define ALERT(title,msg){UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];[alert show];[alert release];}
