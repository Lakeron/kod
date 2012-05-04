//
//  PMCustomView.m
//  kod
//
//  Created by Andrej Baran on 4.5.2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PMCustomView.h"


@implementation PMCustomView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor whiteColor] setFill];
    NSRectFill(dirtyRect);
}

@end
