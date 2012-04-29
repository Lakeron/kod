//
//  PMTodo.h
//  kod
//
//  Created by SoftOne s.r.o. on 27.4.2012.
//  Copyright 2012 SoftOne, s.r.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMTodo : NSObject {
    NSString *todoName;
    BOOL todoChecked;
}

@property (copy) NSString *todoName;
@property BOOL todoChecked;

@end
