//
//  DatabaseRow.m
//  kod
//
//  Created by iamrado on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DatabaseRow.h"

@implementation DatabaseRow
{
    sqlite3_stmt *compiledStatement;
    NSDictionary *columnsMap;
}

- (void) setupColumnsMap
{
    int colCount = sqlite3_column_count(compiledStatement);
    NSMutableDictionary *colNames = [NSMutableDictionary dictionaryWithCapacity:colCount];
    
    for (int i=0; i<colCount; i++) 
    {
        NSString *colname = [NSString stringWithUTF8String:(char *)sqlite3_column_name(compiledStatement, i)];
        [colNames setObject:[NSNumber numberWithInt:i] forKey:colname];
    }
    columnsMap = colNames;
}

- (int) indexOfColName:(NSString*) columnName
{
    NSNumber *number = [columnsMap objectForKey:columnName];
    return [number intValue];
}

- (id) initWithStatement:(sqlite3_stmt*) aCompiledStatement
{
    self = [super init];
    if (self)
    {
        compiledStatement = aCompiledStatement;
        [self setupColumnsMap];
    }
    
    return self;
}

- (NSString*) stringValueForColumn:(NSString*) columnName
{
    char *str = (char *) sqlite3_column_text(compiledStatement, [self indexOfColName:columnName]);
    return (str == NULL) ? @"" : [NSString stringWithUTF8String:str];
}

- (int) intValueForColumn:(NSString*) columnName
{
    return sqlite3_column_int(compiledStatement, [self indexOfColName:columnName]);
}

@end
