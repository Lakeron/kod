//
//  PMTodoController.h
//  kod
//
//  Created by Andrej Baran on 29.4.2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PMTodoController : NSObject <NSTableViewDataSource> {
@private
    NSMutableArray *list;
    IBOutlet NSTableView *tableView;
    NSMutableDictionary *project;
}

-(IBAction)add:(id)sender;
-(IBAction)remove:(id)sender;

-(void)reloadTodo;
-(NSMutableArray *)listToDict;

@end
