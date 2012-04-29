//
//  PMTodo.m
//  kod
//
//  Created by SoftOne s.r.o. on 27.4.2012.
//  Copyright 2012 SoftOne, s.r.o. All rights reserved.
//

#import "PMTodo.h"

@implementation PMTodo

@synthesize todoName, todoChecked;

- (id)init
{
    self = [super init];
    if (self) {
        
        todoName = @"New TODO";
        todoChecked = NO;
    }
    
    return self;
}

@end
