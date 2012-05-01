//
//  DBManager.m
//  kod
//
//  Created by iamrado on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Database.h"
#import "sqlite3.h"

@implementation Database
{
    NSString *_databasePath;
    sqlite3 *_db;
}

static Database *sharedDatabase;

+ (Database*)shared
{
    if (sharedDatabase == nil) {
        sharedDatabase = [[Database alloc] init];
        [sharedDatabase openConnection];
    }
    
    return sharedDatabase;
}

+ (void)releaseShared
{
    [[Database shared] closeConnection];
    [sharedDatabase release];
}

- (void)openConnection
{
    _databasePath = [[[NSBundle mainBundle] pathForResource:@"CodeCompletionData" ofType:@"sqlite"] retain];
    
    (sqlite3_open([_databasePath UTF8String], &_db) == SQLITE_OK) ? NSLog(@"DB connection opened") : NSLog(@"DB coonection FAILED");
}

- (void)closeConnection
{
    if (sqlite3_close(_db) == SQLITE_OK) {
        NSLog(@"Connection closed");
    }
    else {
        NSLog(@"Failed closing connection: %@", [NSString stringWithCString:sqlite3_errmsg(_db) encoding:NSUTF8StringEncoding]);
    }
}

- (int)selectFromDatabase:(NSString *)selectString forEachRow:(void (^) (DatabaseRow *databaseRow))rowBlock
{
    int resultCount = 0;
    // Setup the SQL Statement and compile it for faster access
    const char *sqlStatement = [selectString UTF8String];
    sqlite3_stmt *compiledStatement;
    DatabaseRow *dbRow = nil;
    
    if (sqlite3_prepare_v2(_db, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        int x = sqlite3_step(compiledStatement);
        while (x == SQLITE_ROW)
        {
            resultCount++;
            if (dbRow == nil)
                dbRow = [[DatabaseRow alloc] initWithStatement:compiledStatement];
            if (rowBlock != NULL)
                rowBlock(dbRow);
            x = sqlite3_step(compiledStatement);
        }
        if (x != SQLITE_ROW && x != SQLITE_DONE)
        {
            NSLog(@"SQLITE ERROR: %i :%@", x, [NSString stringWithCString:sqlite3_errmsg(_db) encoding:NSUTF8StringEncoding]);
        }
    }
    // Release the compiled statement from memory
    sqlite3_finalize(compiledStatement);
    
    return resultCount;
}

@end
