//
//  ProjectManager.h
//  kod
//
//  Created by SoftOne s.r.o. on 16.4.2012.
//  Copyright 2012 SoftOne, s.r.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectManager : NSObject {
    NSMutableDictionary *projects;
    NSMutableDictionary *project;
    NSString *plistPath;
}

@property (nonatomic, retain) NSMutableDictionary *projects;
@property (nonatomic, retain) NSMutableDictionary *project;
@property (nonatomic, retain) NSString *plistPath;

-(void)setProductWithName:(NSString *)n AndPath: (NSString *)p;
-(void)addActiveFile:(NSURL *)url toProject:(NSString *)p;
-(void)removeActiveFile:(NSURL *)url toProject:(NSString *)p;

-(NSString *)getName:(int)i;
-(NSString *)getPath:(int)i;

-(BOOL)isValid;
-(BOOL)saveProject:(id) project;

-(ProjectManager *)save;

-(NSMutableDictionary *)getProjectByName: (NSString *)name ;
@end