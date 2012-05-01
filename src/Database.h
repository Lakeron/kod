//
//  DBManager.h
//  kod
//
//  Created by iamrado on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseRow.h"

@interface Database : NSObject

- (int)insertOrUpdateTable:(NSString*) tableName data:(NSDictionary*) columnValueDictionary;
- (int)selectFromDatabase:(NSString*) selectString forEachRow:(void (^) (DatabaseRow *dbRow)) rowBlock;

+ (Database*)shared;
+ (void)releaseShared;
- (void)closeConnection;
- (void)openConnection;

@end
