//
//  PMSettingController.h
//  kod
//
//  Created by Andrej Baran on 30.4.2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PMSettingController : NSViewController {
@public
    IBOutlet NSView *deactivePass;
    IBOutlet NSView *activePass;
    IBOutlet NSView *changePass;
    IBOutlet NSView *placeholderLock;
    NSView *activeView;
    
    NSSecureTextField *password;
    NSSecureTextField *repeatPassword;
    
    NSSecureTextField *c_password;
    NSSecureTextField *c_repeatPassword;
    NSSecureTextField *c_currentPassword;
    
    NSTextField *title_newPass;
    NSTextField *title_changePass;
    
    NSMutableDictionary *dictionary;
    NSString *path;
}

@property (retain) IBOutlet NSSecureTextField *password;
@property (retain) IBOutlet NSSecureTextField *repeatPassword;
@property (retain) IBOutlet NSSecureTextField *c_password;
@property (retain) IBOutlet NSSecureTextField *c_repeatPassword;
@property (retain) IBOutlet NSSecureTextField *c_currentPassword;
@property (retain) IBOutlet NSTextField *title_newPass;
@property (retain) IBOutlet NSTextField *title_changePass;
@property (retain,nonatomic) NSMutableDictionary *dictionary;
@property (retain,nonatomic) NSString *path;

-(void)changeItemView:(NSString *)selection andIdentity: (NSString *) identity;
-(void)removeSubview;
-(void)errorMessage:(NSString *)message;

-(IBAction)setLock:(id)sender;
-(IBAction)save:(id)sender;
@end
