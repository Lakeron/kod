// Copyright (c) 2010-2011, Rasmus Andersson. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

#import <ChromiumTabs/ChromiumTabs.h>

@class KFileOutlineView, KFileTreeController, KStatusBarView,
       KStatusBarController, KSplitView, KPopUp;

@interface KBrowserWindowController : CTBrowserWindowController {
  IBOutlet KFileOutlineView *fileOutlineView_;
  IBOutlet KStatusBarController *statusBarController_;
  IBOutlet KSplitView *splitView_;
  KFileTreeController *fileTreeController_;

  NSInteger goToLineLastValue_;
  KPopUp *goToLinePopUp_; // non-nil while active
    
  NSString *projectAndrej;
}

@property(readonly) NSSplitView *verticalSplitView;
@property(readonly) CGFloat statusBarHeight;
@property(nonatomic) NSString *projectAndrej;

// TODO: fullscreen
// implement lockBarVisibilityForOwner... and friends (see chromium source)

- (IBAction)focusLocationBar:(id)sender;
- (IBAction)toggleStatusBarVisibility:(id)sender;
- (IBAction)toggleSplitView:(id)sender;
- (IBAction)reloadStyle:(id)sender;
- (IBAction)goToLine:(id)sender;

- (BOOL)openFileDirectoryAtURL:(NSURL *)absoluteURL error:(NSError **)outError;

// Return project identifier if document set into project
- (NSString*)getProject;
- (void)setProject:(NSString *)p;

@end
