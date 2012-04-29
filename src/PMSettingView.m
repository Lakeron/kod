//
//  PMSettingView.m
//  kod
//
//  Created by SoftOne s.r.o. on 24.4.2012.
//  Copyright 2012 SoftOne, s.r.o. All rights reserved.
//

#import "PMSettingView.h"

@implementation PMSettingView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Load the image through NSImage and set it as the current color.
    NSImage *backgroundImage = [NSImage imageNamed:@"label_pattern"];
    
    [backgroundImage drawInRect:[self bounds]
                       fromRect:NSMakeRect(0.0f, 0.0f, backgroundImage.size.width, backgroundImage.size.height)
                      operation:NSCompositeSourceAtop
                       fraction:1.0f];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Helvetica" size:14], NSFontAttributeName,[NSColor whiteColor], NSForegroundColorAttributeName, nil];
    
    NSAttributedString * currentText=[[NSAttributedString alloc] initWithString:@"Select your project" attributes: attributes];
    
    NSSize attrSize = [currentText size];
    [currentText drawAtPoint:NSMakePoint(20, 8)];
    
    [super drawRect:dirtyRect];
}

@end
