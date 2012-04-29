//
//  PMListing.h
//  chromium-tabs
//
//  Created by Andrej Baran on 9.2.2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXListView.h"


@interface PMListing : NSObject <NSApplicationDelegate, PXListViewDelegate>{
@public
    //veci k listingom
    IBOutlet NSWindow *window;
    IBOutlet PXListView *listView;
    NSMutableArray *_listItems;
    PXListView *listViewDelegate;
}

-(void) reloadData;
- (NSUInteger)numberOfRowsInListView: (PXListView*)aListView;
- (CGFloat)listView:(PXListView*)aListView heightOfRow:(NSUInteger)row;
- (void)listViewSelectionDidChange:(NSNotification*)aNotification;
- (BOOL)listView:(PXListView*)aListView writeRowsWithIndexes:(NSIndexSet*)rowIndexes toPasteboard:(NSPasteboard*)dragPasteboard;
- (NSDragOperation)listView:(PXListView*)aListView validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSUInteger)row
      proposedDropHighlight:(PXListViewDropHighlight)dropHighlight;
@end