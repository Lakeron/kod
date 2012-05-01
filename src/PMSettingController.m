//
//  PMSettingController.m
//  kod
//
//  Created by Andrej Baran on 30.4.2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PMSettingController.h"
#import "PMWindowController.h"
#import "PMErrorField.h"

@implementation PMSettingController

@synthesize password,repeatPassword,c_password,c_repeatPassword,c_currentPassword,title_newPass,title_changePass, path, dictionary;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        [self view];
        
        path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[[PMWindowController shared] getSettingsPlistPath]];
        dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:path];
        NSString *selection = [[NSString alloc] init];
        NSString *identity = [[NSString alloc] init];
        if([dictionary objectForKey:@"password"]) {
            selection = @"activeLock";
            identity = @"YES";
        }
        [self changeItemView: selection andIdentity: identity];
        
        [selection release];
        [identity release];
    }
    
    return self;
}

-(IBAction)setLock:(id)sender 
{
    [self changeItemView: @"activeLock" andIdentity: nil];
}

- (void)changeItemView:(NSString *)selection andIdentity: (NSString *) identity
{
    if (selection == @"activeLock") {
        [self removeSubview];
        
        if (identity == @"YES") {
            [placeholderLock addSubview: changePass];
            activeView = changePass;  
        } else {
            [placeholderLock addSubview: activePass];
            activeView = activePass;
        }
    }
    else
    {
        [self removeSubview];
        [placeholderLock addSubview: deactivePass];
        activeView = deactivePass;
    }

    NSRect newBounds;
    newBounds.origin.x = 0;
    newBounds.origin.y = 0;
    newBounds.size.width = [[activeView superview] frame].size.width;
    newBounds.size.height = [[activeView superview] frame].size.height;
    [activeView setFrame:[[activeView superview] frame]];

    // make sure our added subview is placed and resizes correctly
    [activeView setFrameOrigin:NSMakePoint(0,0)];
    [activeView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    
    [activeView displayIfNeeded];
}

-(IBAction)save:(id)sender
{
    
    // error cleaning
    for(NSView *item in [activeView subviews]) {
        if([item isKindOfClass:[PMErrorField class]]) {
            [item removeFromSuperview];
        }
    }
    
    path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[[PMWindowController shared] getSettingsPlistPath]];
    dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    if (activeView == changePass) {
        if(![c_currentPassword.stringValue isEqualToString:@""] && [c_currentPassword.stringValue isEqualToString:[dictionary objectForKey:@"password"]]) {
            if([c_password.stringValue isEqualToString: c_repeatPassword.stringValue] && ![c_password.stringValue isEqualToString: @""]) {
                [dictionary setValue: [c_password stringValue] forKey:@"password"];
                [dictionary writeToFile:path atomically:NO];
                
                [self changeItemView:@"activeLock" andIdentity:@"YES"];
            } else {
                [self errorMessage:@"Password is empty or did not match Repeat password"];
            }
        } else {
            [self errorMessage:@"Current password is empty or did not match old password"];
        }
    } else {
        if([password.stringValue isEqualToString: repeatPassword.stringValue] && ![password.stringValue isEqualToString: @""]) {
            [dictionary setValue: [password stringValue] forKey:@"password"];
            [dictionary writeToFile:path atomically:NO];
            
            [self changeItemView:@"activeLock" andIdentity:@"YES"];
        } else {
            [self errorMessage:@"Password is empty or did not match Repeat password"];
        }
    }
    
    
}

- (void)removeSubview
{
	NSArray *subViews = [placeholderLock subviews];
	if ([subViews count] > 0)
	{
        [[subViews objectAtIndex:0] removeFromSuperview];
	}
	
	[placeholderLock displayIfNeeded];	// we want the removed views to disappear right away
}

-(void)errorMessage:(NSString *)message 
{   
    PMErrorField *errorMessage;
    errorMessage = [[PMErrorField alloc] initWithFrame:NSMakeRect(10, 0, 200, 17)];
    [errorMessage setStringValue:message];
    [errorMessage setBezeled:NO];
    [errorMessage setDrawsBackground:NO];
    [errorMessage setEditable:NO];
    [errorMessage setSelectable:NO];
    [errorMessage setTextColor: [NSColor redColor]];
    [activeView addSubview:errorMessage];
}

@end
