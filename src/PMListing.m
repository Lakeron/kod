//
//  PMListing.m
//  chromium-tabs
//
//  Created by Andrej Baran on 9.2.2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PMListing.h"
#import "PMWindowController.h"


#import "MyListViewCell.h"
#define LISTVIEW_CELL_IDENTIFIER		@"MyListViewCell"


@class KBrowserWindowController;
@class CTBrowserWindowController;
@class KDocumentController;
@class KAppDelegate;

@implementation PMListing

- (void)awakeFromNib {
    [self reloadList];
}

-(void) reloadList {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[[PMWindowController shared] getProjectsPlistPath]]];
    
    
    [listView setCellSpacing:2.0f];
    [listView setAllowsEmptySelection:YES];
    [listView setAllowsMultipleSelection:YES];
    [listView registerForDraggedTypes:[NSArray arrayWithObjects: NSStringPboardType, nil]];
    
    _listItems = [[NSMutableArray alloc] init];
    
    NSArray *list = [dictionary allKeys];
    
    for (NSArray *key in list) {
        NSArray *project = [dictionary objectForKey:key];
        NSString *title = [[NSString alloc] initWithFormat: [project objectForKey:@"name"]];
        [_listItems addObject:project];
        [title release];
    }
    
    [listView reloadData];
}

- (NSUInteger)numberOfRowsInListView: (PXListView*)aListView
{
	return [_listItems count];
}

- (PXListViewCell*)listView:(PXListView*)aListView cellForRow:(NSUInteger)row
{
	MyListViewCell *cell = (MyListViewCell*)[aListView dequeueCellWithReusableIdentifier:LISTVIEW_CELL_IDENTIFIER];
	
	if(!cell) {
		cell = [MyListViewCell cellLoadedFromNibNamed:@"MyListViewCell" reusableIdentifier:LISTVIEW_CELL_IDENTIFIER];
	}
	
	// Set up the new cell:
	[[cell titleLabel] setStringValue:[[_listItems objectAtIndex:row] objectForKey:@"name"]];
	[[cell date] setStringValue:[[_listItems objectAtIndex:row] objectForKey:@"date"]];
    
	return cell;
}

- (CGFloat)listView:(PXListView*)aListView heightOfRow:(NSUInteger)row
{
	return 50;
}

- (void)listViewSelectionDidChange:(NSNotification*)aNotification
{
    NSLog(@"listViewSelectionDidChange");
    [[PMWindowController shared] changeItemView:@"project" andIdentity:[_listItems objectAtIndex:[[aNotification object] selectedRow]]];
}


// The following are only needed for drag'n drop:
- (BOOL)listView:(PXListView*)aListView writeRowsWithIndexes:(NSIndexSet*)rowIndexes toPasteboard:(NSPasteboard*)dragPasteboard
{
	// +++ Actually drag the items, not just dummy data.
	[dragPasteboard declareTypes: [NSArray arrayWithObjects: NSStringPboardType, nil] owner: self];
	[dragPasteboard setString: @"Just Testing" forType: NSStringPboardType];
	
	return YES;
}

- (NSDragOperation)listView:(PXListView*)aListView validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSUInteger)row
      proposedDropHighlight:(PXListViewDropHighlight)dropHighlights
{
	return NSDragOperationCopy;
}

- (void)dealloc
{
    [super dealloc];
}

@end
