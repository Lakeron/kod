//
//  PMTodoController.m
//  kod
//
//  Created by Andrej Baran on 29.4.2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PMTodoController.h"
#import "PMTodo.h"
#import "ProjectManager.h"

@class KAppDelegate;

@implementation PMTodoController

- (id)init
{
    self = [super init];
    if (self) {
        list = [[NSMutableArray alloc] init];
        project = [[[[[NSApplication sharedApplication] delegate] pmWindow] pmViewController] project];
        
        for(NSDictionary *item in [project objectForKey:@"todo"]) {
            NSLog(@"item %@", item);
            PMTodo *todo = [[PMTodo alloc] init];
            todo.todoChecked = [[item objectForKey:@"checked"] boolValue];
            todo.todoName = [item objectForKey:@"name"];
            [list addObject:todo];
            
            [todo release];
        }
    }
    
    return self;
}


-(NSInteger)numberOfRowsInTableView: (NSTableView *)tableView {
    return [list count];
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    PMTodo *todo = [list objectAtIndex:row];
    NSString *identifier = [tableColumn identifier];
    
    return [todo valueForKey:identifier];
}

-(void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    PMTodo *todo = [list objectAtIndex:row];
    NSString *identifier = [tableColumn identifier];
    [todo setValue:object forKey:identifier];
    
    [self reloadTodo];
}

-(IBAction)add:(id)sender {
    [list addObject:[[PMTodo alloc] init]];
    
    [self reloadTodo];
}

-(IBAction)remove:(id)sender {
    [tableView abortEditing];
    [list removeObjectAtIndex: [tableView selectedRow]];
    
    [self reloadTodo];
}

-(void)reloadTodo {
    // ulozenie noveho todo k projektu
    ProjectManager *pm = [[ProjectManager alloc] init];
    [project setObject:[self listToDict] forKey:@"todo"];
    
    [pm saveProject: project];
    
    [tableView reloadData];
}

-(NSMutableArray *)listToDict {
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    for(PMTodo *item in list) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject: [NSNumber numberWithBool: [item todoChecked]] forKey:@"checked"];
        [dict setObject: [item todoName] forKey:@"name"];
        [returnArray addObject:dict];
        
        [dict release];
    }
    
    return [returnArray autorelease];
}

- (void)dealloc
{
    [super dealloc];
}

@end
