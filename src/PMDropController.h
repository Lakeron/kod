//
//  CTProjectManagerController.h
//  chromium-tabs
//
//  Created by Andrej Baran on 6.1.2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PMDropController : NSView {
    NSObject * dragObject;
    NSImage * backgroundImage;
    NSMutableDictionary * dict;
    BOOL highlight;
}

@property (assign) NSImage * backgroundImage;
@property (assign) NSObject * dragObject;
@property (assign) NSMutableDictionary * dict;

//-(void)drawList:(NSMutableDictionary *)dictionary;

@end
