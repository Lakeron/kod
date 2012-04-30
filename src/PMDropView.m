//
//  PMDropNewProjectController.m
//  chromium-tabs
//
//  Created by Andrej Baran on 6.1.2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PMDropView.h"
#import "ProjectManager.h"

@implementation PMDropView

@class PMWindowController;

@synthesize dragObject;
@synthesize backgroundImage;
@synthesize dict;

- (id)initWithFrame:(NSRect)frameRect{
    self = [super initWithFrame:frameRect];
    if (self) {
        // Initialization code here.
        self.dragObject = nil;
        [self registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];
        
        // nacitanie projektov z plistu
        NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"projects.plist"];
        // Insert code here to initialize your application
        NSLog(@"%@", path);
        dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
        
//        [dict removeAllObjects];
//        [dict writeToFile:path atomically:NO];
        

//        NSLog(@"%@", dict);
    }

    return self;
}

-(NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender{
    highlight = YES;
    [self setNeedsDisplay:YES];
    
    if((NSDragOperationGeneric & [sender draggingSourceOperationMask]) == NSDragOperationGeneric) {
        NSLog(@"start dragovania");
        return NSDragOperationGeneric;
    }
    
    return NSDragOperationNone;
}

-(void)draggingExited:(id<NSDraggingInfo>)sender{
    highlight = NO;
    [self setNeedsDisplay:YES];
    NSLog(@"ukoncenie dragovania");
}

-(BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender{
    highlight = NO;
    [self setNeedsDisplay:YES];
    NSLog(@"priprava dragovania");
    return YES;
}

-(BOOL)performDragOperation:(id<NSDraggingInfo>)sender{
    NSPasteboard *pbObject = [sender draggingPasteboard];
    NSLog(@"pbObject %@", pbObject);
    NSArray *pbTypesArray = [NSArray arrayWithObject:NSFilenamesPboardType];
    NSString *pbType = [pbObject availableTypeFromArray:pbTypesArray];
    NSLog(@"pbType %@", pbType);
    
    if ([pbType isEqualToString:NSFilenamesPboardType]) {
        NSArray *pbFileArray = [pbObject propertyListForType:@"NSFilenamesPboardType"];
        NSString *pbPath = [pbFileArray objectAtIndex:0];
        
        // zistovanie typy suboru
        NSFileManager *pbFileManger = [[NSFileManager alloc] init];
        NSDictionary *attrs = [pbFileManger attributesOfItemAtPath: pbPath error: NULL];
        
        if([[attrs objectForKey:@"NSFileType"] isEqualToString:@"NSFileTypeDirectory"]) {
            NSArray *components = [pbPath componentsSeparatedByString:@"/"];
            NSString *pbName = [components objectAtIndex:[components count]-1];
            
            ProjectManager *project = [[ProjectManager alloc] init];
            [project setProductWithName:pbName AndPath: pbPath];
            [project save];
            
            // dokoncit load noveho zoznamu a otvorenie programu
            
            return NO;
        } else {
            NSLog(@"Error: Only folders are accepted");
            return NO;
        }
    }
    
    NSLog(@"Error: CTProjectManagerControll performDragOperation no file for drag");
    return NO;
}

-(void)concludeDragOperation:(id<NSDraggingInfo>)sender{
    [self setNeedsDisplay:YES];
}

-(void)drawRect:(NSRect)dirtyRect{
    if(highlight) {
        self.backgroundImage = [NSImage imageNamed:@"drag-active.png"];
    } else {
        self.backgroundImage = [NSImage imageNamed:@"drag-deactive.png"];
    }
    [backgroundImage drawInRect:[self bounds]
                       fromRect:NSMakeRect(0.0f, 0.0f, backgroundImage.size.width, backgroundImage.size.height)
                      operation:NSCompositeSourceAtop
                       fraction:1.0f];
    
    [super drawRect:dirtyRect];
}

- (void)dealloc{
    [super dealloc];
}

@end
