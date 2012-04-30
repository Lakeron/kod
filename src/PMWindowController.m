//
//  PMWindow.m
//  kod
//
//  Created by SoftOne s.r.o. on 16.4.2012.
//  Copyright 2012 SoftOne, s.r.o. All rights reserved.
//

#import "PMWindowController.h"
#import "PMListing.h"
#import "PMViewController.h"
#import "PMDropView.h"

@implementation PMWindowController

static PMWindowController* _shared = nil;

@synthesize pmViewController, pmDropView;

+(PMWindowController *)shared
{
	@synchronized([PMWindowController class])
	{
		if (!_shared)
			[[self alloc] init];
        
		return _shared;
	}
    
	return nil;
}

+(id)alloc
{
	@synchronized([PMWindowController class])
	{
		NSAssert(_shared == nil, @"Attempted to allocate a second instance of a singleton.");
		_shared = [super alloc];
		return _shared;
	}
    
	return nil;
}

- (void)awakeFromNib
{
	// load the icon view controller for later use
	pmViewController = [[PMViewController alloc] initWithNibName:@"PMViewController" bundle:nil];
    pmDropView = [[PMDropView alloc] initWithFrame: [nsView frame]];
	pmListing = [[PMListing alloc] init];
    
}

- (NSString*)getProjectsPlistPath {
    return [[NSString alloc] initWithFormat:@"Contents/Resources/projects.plist"];
}

- (void)changeItemView:(NSString *)selection andIdentity: (id *) identity
{
    if (selection) {
        if (selection == @"project")
        {
            NSLog(@"project %@", identity);
            // avoid a flicker effect by not removing the icon view if it is already embedded
            [self removeSubview];
            
            pmViewController.project = identity;
            
            // change to icon view to display folder contents
            [nsView addSubview:[pmViewController view]];
            currentView = [pmViewController view];
        }
        else if (selection == @"setting")
        {
            // zatial je tu drop ale malo by sem prist settings
            [self removeSubview];
            
            [nsView addSubview:pmDropView];
            currentView = pmDropView;
        }
        
        NSRect newBounds;
        newBounds.origin.x = 0;
        newBounds.origin.y = 0;
        newBounds.size.width = [[currentView superview] frame].size.width;
        newBounds.size.height = [[currentView superview] frame].size.height;
        [currentView setFrame:[[currentView superview] frame]];
                
        // make sure our added subview is placed and resizes correctly
        [currentView setFrameOrigin:NSMakePoint(0,0)];
        [currentView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
        [currentView displayIfNeeded];
    }
    else
    {
        // there's no url associated with this node
        // so a container was selected - no view to display
        [self removeSubview];
        
        [nsView addSubview:pmDropView];
        currentView = pmDropView;
    }
}

- (void)removeSubview
{
	// empty selection
	NSArray *subViews = [nsView subviews];
	if ([subViews count] > 0)
	{
		[[subViews objectAtIndex:0] removeFromSuperview];
	}
	
	[nsView displayIfNeeded];	// we want the removed views to disappear right away
}

@end
