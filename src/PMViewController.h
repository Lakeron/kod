//
//  PMViewController.h
//  kod
//
//  Created by SoftOne s.r.o. on 24.4.2012.
//  Copyright 2012 SoftOne, s.r.o. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PMViewController : NSViewController {
    id *project;
    NSTextField *titleLabel;
	NSTextField *date;
	NSTextView *note;
	NSSecureTextField *password;
    NSView *noteLock;
    NSView *noteView;
    NSString *current_password;
}

@property (assign, nonatomic) id *project;
@property (nonatomic, retain) IBOutlet NSSecureTextField *password;
@property (nonatomic, retain) IBOutlet NSTextField *titleLabel;
@property (nonatomic, retain) IBOutlet NSTextField *date;
@property (nonatomic, retain) IBOutlet NSTextView *note;
@property (nonatomic, retain) IBOutlet NSView *noteLock;
@property (nonatomic, retain) IBOutlet NSView *noteView;

-(IBAction)openProject:(id)sender;
-(IBAction)unlockNote:(id)sender;

@end
