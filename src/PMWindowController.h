//
//  PMWindow.h
//  kod
//
//  Created by SoftOne s.r.o. on 16.4.2012.
//  Copyright 2012 SoftOne, s.r.o. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PMDropView;
@class PMViewController;
@class PMListing;

@interface PMWindowController : NSWindowController {
@public
    IBOutlet NSView             *nsView;
    PMDropView            *pmDropView;
    PMViewController            *pmViewController;
    PMWindowController          *pmWindowController;
    PMListing                   *pmListing;
    NSView                      *currentView;
}

@property (retain,nonatomic) PMViewController *pmViewController;
@property (retain,nonatomic) PMDropView *pmDropView;

+(PMWindowController *)shared;

- (void)removeSubview;
- (void)changeItemView:(NSString *)selection andIdentity: (NSString *) identyty;

- (NSString*)getProjectsPlistPath;

@end
