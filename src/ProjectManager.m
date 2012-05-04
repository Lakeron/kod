//
//  ProjectManager.m
//  kod
//
//  Created by SoftOne s.r.o. on 16.4.2012.
//  Copyright 2012 SoftOne, s.r.o. All rights reserved.
//

#import "ProjectManager.h"
#import "PMWindowController.h"

@implementation ProjectManager

@synthesize projects;
@synthesize project;
@synthesize plistPath;


- (id)init
{
    self = [super init];
    if (self) {
        // nacitanie aktualnych projektov
        
        plistPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[[PMWindowController shared] getProjectsPlistPath]];
        projects = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];    
        
    }
    
    return self;
}

-(void)setProductWithName: (NSString *)n AndPath: (NSString *)p {
    project = [[NSMutableDictionary alloc] init];
    
    [project setObject:n forKey:@"name"];
    [project setObject:p forKey:@"path"];
    [project setObject:@"ftp://mysite.com \nu: username \np: mystrongpass \n\ngit://git.mysite.com \n(ed:00:b1:4e:00:a7:f7:00:00:9d:68:54:dc:13:00:99)" forKey:@"note"];
    NSArray *emptyArray = [[NSArray alloc] init];
    [project setObject: emptyArray forKey:@"todo"];
    [project setObject: emptyArray forKey:@"activeFiles"];
    [emptyArray release];
    
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    [project setObject:[formatter stringFromDate:date] forKey:@"date"];
    
    if(self.isValid==YES) {
        [projects setObject:project forKey:p];
    }
}


-(NSString *)getName:(int)i {
    return @"";
}

-(NSString *)getPath:(int)i {
    return @"";
}

-(BOOL)isValid{
    BOOL r=YES;
    
    // Osetrenie aby sa do PM nedostavali duplicitne projekty (duplicita vychadza z korenoveho priecinku)
    if([projects objectForKey: [project objectForKey:@"path"]]) {
        r=NO;
    }            
    
    return r;
}

-(ProjectManager *)save {
    [projects writeToFile:plistPath atomically:NO];
    
    return project;
}

-(BOOL)saveProject:(id) project
{
    [projects setObject:project forKey:[project objectForKey:@"path"]];
    
    [projects writeToFile:plistPath atomically:NO];
    
    //reload project list
    [[[PMWindowController shared] pmListing] reloadList];
    
    return YES;
}

-(void)addActiveFile:(NSURL *)url toProject:(NSString *)p 
{
    if(p) {
        project = [projects objectForKey:p];
        if(project) {
            NSMutableArray *activeFiles = [project objectForKey:@"activeFiles"];
            if(activeFiles) {
                for(NSString *item in activeFiles) {
                    if([item isEqualToString:[url path]]) {
                        return;
                    }
                }
                [activeFiles addObject:[url path]];
                [project setObject:activeFiles forKey:@"activeFiles"];
                
                [self saveProject:project];
            }
        }
    }
}

-(void)removeActiveFile:(NSURL *)url toProject:(NSString *)p
{
    if(p) {
        project = [projects objectForKey:p];
        if(project) {
            NSMutableArray *activeFiles = [project objectForKey:@"activeFiles"];
            if(activeFiles) {
                for (int i =0; i < [activeFiles count]; i++) {
                    if([[activeFiles objectAtIndex:i] isEqualToString:[url path]]) {
                        [activeFiles removeObjectAtIndex:i];
                    }
                }
                [project setObject:activeFiles forKey:@"activeFiles"];
                
                [self saveProject:project];
            }
        }
    }
}

@end
