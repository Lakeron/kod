//
//  PMViewController.m
//  kod
//
//  Created by SoftOne s.r.o. on 26.4.2012.
//  Copyright 2012 SoftOne, s.r.o. All rights reserved.
//

#import "PMViewController.h"
#import "PMTodo.h"

@class KAppDelegate;
@class KDocumentController;
@class ProjectManager;

@implementation PMViewController

@synthesize project, titleLabel, date, note;


-(void) awakeFromNib
{
    list = [[NSMutableArray alloc] init];
    
	[titleLabel setStringValue: [project objectForKey:@"name"]];
	[date setStringValue: [project objectForKey:@"date"]];
    [note setString:[project objectForKey:@"note"]];
}

- (void)textViewDidChangeSelection:(NSNotification *)aNotification {
    ProjectManager *pm = [[ProjectManager alloc] init];
    [project setObject:[note string] forKey:@"note"];
    [pm saveProject: project];
}

- (IBAction)openProject:(id)sender 
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
    
    NSArray *urls = [[NSArray alloc] init];
    if([contents count]) {
//        NSLog(@"kurva %@", contents);
        urls = [NSArray arrayWithObject:[files objectAtIndex:0]];
    } else {
        // open a untitle
        
    } 
    
    KAppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
    
    [appDelegate application:[NSApplication sharedApplication] openFiles: [NSArray arrayWithObject:dir]]; 
    KDocumentController *documentController =
    (KDocumentController*)[NSDocumentController sharedDocumentController];
    
    [documentController openDocumentsWithContentsOfURLs: urls
                        withWindowController: nil
                        priority:0
                        nonExistingFilesAsNewDocuments:NO
                        callback:nil];
}


#pragma TODO Section

-(NSInteger)numberOfRowsInTableView: (NSTableView *)tableView {
    return [list count];
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSLog(@"rooow");
    PMTodo *todo = [list objectAtIndex:row];
    NSString *identifier = [tableColumn identifier];
    
    return [todo valueForKey:identifier];
}

-(void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    PMTodo *todo = [list objectAtIndex:row];
    NSString *identifier = [tableColumn identifier];
    [todo setValue:object forKey:identifier];
    
    [tableView reloadData];
}

-(IBAction)add:(id)sender {
    [list addObject:[[PMTodo alloc] init]];
    
    NSLog(@"superclass %@", [self superclass]);
    
    // ulozenie noveho todo k projektu
    //    ProjectManager *pm = [[ProjectManager alloc] init];
    //    [project setObject:list forKey:@"todo"];
    //    [pm saveProject: project];
    
    
    [tableView reloadData];
}

-(IBAction)remove:(id)sender {
    [tableView abortEditing];
    [list removeObjectAtIndex: [tableView selectedRow]];
    [tableView reloadData];
}


@end
