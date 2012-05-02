//
//  PMViewController.m
//  kod
//
//  Created by SoftOne s.r.o. on 26.4.2012.
//  Copyright 2012 SoftOne, s.r.o. All rights reserved.
//

#import "PMViewController.h"
#import "PMWindowController.h"

@class KAppDelegate;
@class KDocumentController;
@class ProjectManager;
@class KBrowserWindowController;

@implementation PMViewController

@synthesize project, titleLabel, date, note, noteLock, noteView, password;


-(void) awakeFromNib
{
    [titleLabel setStringValue: [project objectForKey:@"name"]];
    [date setStringValue: [project objectForKey:@"date"]];
    [note setString:[project objectForKey:@"note"]];
    
    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[[PMWindowController shared] getSettingsPlistPath]];
    current_password = [[NSMutableDictionary dictionaryWithContentsOfFile:path] objectForKey:@"password"];
    
    if(current_password) {
        [noteView setHidden:YES];
        [noteLock setHidden:NO];
    } else {
        [noteView setHidden:NO];
        [noteLock setHidden:YES];
    }
}

-(void)textViewDidChangeSelection:(NSNotification *)aNotification {
    ProjectManager *pm = [[ProjectManager alloc] init];
    [project setObject:[note string] forKey:@"note"];
    [pm saveProject: project];
}

-(IBAction)unlockNote:(id)sender
{
    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[[PMWindowController shared] getSettingsPlistPath]];
    current_password = [[NSMutableDictionary dictionaryWithContentsOfFile:path] objectForKey:@"password"];
    
    if(![password.stringValue isEqualToString:@""] && [password.stringValue isEqualToString:current_password]) {        
        [noteLock setHidden:YES];
        [noteView setHidden:NO];
    }
}

-(IBAction)openProject:(id)sender 
{
   // otvorit dokument
    // find item under project folder
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *dir = [project objectForKey:@"path"];
    NSMutableArray *files = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray *contents = [[[NSMutableArray alloc] init] autorelease];
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir;    
    if (dir && ([fm fileExistsAtPath:dir isDirectory:&isDir] && isDir))
    {
        if (![dir hasSuffix:@"/"])
        {
            dir = [dir stringByAppendingString:@"/"];
    }
        // this walks the |dir| recurisively and adds the paths to the |contents| set
        NSDirectoryEnumerator *de = [fm enumeratorAtPath:dir];
        NSString *f;
        NSString *fqn;
        while ((f = [de nextObject]))
        {
            // make the filename |f| a fully qualifed filename
            fqn = [dir stringByAppendingString:f];
            if ([fm fileExistsAtPath:fqn isDirectory:&isDir] && isDir)
            {
                // append a / to the end of all directory entries
                fqn = [fqn stringByAppendingString:@"/"];
            } else {
//                [contents addObject:fqn];
                @try {
//                    [contents addObject:[NSURL URLWithString:[fqn stringByExpandingTildeInPath]]];
                    [files addObject:[[NSURL alloc] initFileURLWithPath: fqn]];
                    
                } @catch ( NSException *e ) {
                    // error handle
//                    NSLog(@"error %@", e);
                }
            }
            [contents addObject:fqn];
            
        }
    } else {
        printf("%s must be directory and must exist\n", [dir UTF8String]);
    }
    
    // choose files to open
    
    NSMutableArray *urls = [[NSMutableArray alloc] init];
    if ([[project objectForKey:@"activeFiles"] count] > 0) {
        for(NSString *item in [project objectForKey:@"activeFiles"]) {
            [urls addObject:[[NSURL alloc] initFileURLWithPath: item]];
        }
    } else if([contents count]) {
//        NSLog(@"contents %@", contents);
        urls = [NSArray arrayWithObject:[files objectAtIndex:0]];
    } else {
        // open a untitle
        
    } 
    
    NSLog(@"urls %@", urls);
    
    KBrowserWindowController* windowController = (KBrowserWindowController*)
    [[KBrowserWindowController browserWindowController] retain];
    
    [windowController setProject:[project objectForKey:@"path"]];
    NSLog(@"windowController andrej %@", windowController);
    NSLog(@"windowController andrej project %@", [windowController getProject]);
    
    KDocumentController *documentController =
    (KDocumentController*)[NSDocumentController sharedDocumentController];
    
    [documentController openDocumentsWithContentsOfURLs: urls
                        withWindowController: windowController
                        priority:0
                        nonExistingFilesAsNewDocuments:NO
                        callback:nil];
    
    NSURL *dirURL = [NSURL fileURLWithPath:dir
                               isDirectory:YES];
    NSError *error = nil;
    if (![windowController openFileDirectoryAtURL:dirURL error:&error]) {
        NSLog(@"failed to read directory %@ -- %@", dirURL, error);
    }
}

@end
