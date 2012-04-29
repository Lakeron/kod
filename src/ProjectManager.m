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
        
        plistPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[[PMWindowController alloc] getProjectsPlistPath]];
        
        
//        plistPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[[[[NSApplication sharedApplication] delegate] pmWindow] getProjectsPlistPath]];
        projects = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];    
        
    }
    
    return self;
}

-(void)setProductWithName: (NSString *)n AndPath: (NSString *)p {
    project = [[NSMutableDictionary alloc] init];
    
    [project setObject:n forKey:@"name"];
    [project setObject:p forKey:@"path"];
    [project setObject:@"(Keep your data organized. You can store FTP, GIT or any valuable information about your project.)" forKey:@"note"];
    NSArray *todo = [[NSArray alloc] init];
    [project setObject: todo forKey:@"todo"];
    [todo release];
    
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

-(BOOL)save {
    [projects writeToFile:plistPath atomically:NO];
    
    [[[[NSApplication sharedApplication] delegate] pmWindow] changeItemView:@"project" andIdentity:nil];
    
    return YES;
}

-(BOOL)saveProject:(id) project
{
    [projects setObject:project forKey:[project objectForKey:@"path"]];
    
    [projects writeToFile:plistPath atomically:NO];
}

@end
