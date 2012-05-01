//
//  DatabaseRow.h
//  kod
//
//  Created by iamrado on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface DatabaseRow : NSObject
- (id) initWithStatement:(sqlite3_stmt*) aCompiledStatement;
- (NSString*) stringValueForColumn:(NSString*) columnName;
- (int) intValueForColumn:(NSString*) columnName;
@end
