//
//  PMWindow.h
//  kod
//
//  Created by SoftOne s.r.o. on 16.4.2012.
//  Copyright 2012 SoftOne, s.r.o. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PMDropController;
@class PMViewController;
@class PMListing;

@interface PMWindowController : NSWindowController {
@public
    NSWindow                    *pmWindow;
    IBOutlet PMDropController   *pmDropController;
    IBOutlet NSView             *nsView;
    PMViewController            *pmViewController;
    PMWindowController          *pmWindowController;
    PMListing                   *pmListing;
    NSView                      *currentView;
}

@property (retain,nonatomic) PMViewController *pmViewController;

- (void)removeSubview;
- (void)changeItemView:(NSString *)selection andIdentity: (NSString *) identyty;

- (NSString*)getProjectsPlistPath;

@end
