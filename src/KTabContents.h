#import <ChromiumTabs/ChromiumTabs.h>

#import "common.h"
#import "KSourceHighlighter.h"
#import "HSemaphore.h"

@class KBrowser;
@class KStyle;
@class KBrowserWindowController;

// This class represents a tab. In this example application a tab contains a
// simple scrollable text area.
@interface KTabContents : CTTabContents <NSTextViewDelegate,
                                         NSTextStorageDelegate> {
  __weak NSTextView* textView_; // Owned by NSScrollView which is our view_
  __weak NSUndoManager *undoManager_; // Owned by textView_
  BOOL isDirty_;
  NSStringEncoding textEncoding_;
  KSourceHighlighterPtr sourceHighlighter_;
  HSemaphore *sourceHighlightSem_;
  KStyle *style_;
  BOOL isProcessingTextStorageEdit_;
  
  // Current language
  NSString const *langId_;
  
  // Internal state
  hatomic_flags_t stateFlags_;
}

@property(assign, nonatomic) BOOL isDirty;
@property(assign, nonatomic) NSStringEncoding textEncoding;
@property(readonly) KBrowserWindowController* windowController;
@property(readonly) NSMutableParagraphStyle *paragraphStyle; // compound
@property(retain, nonatomic) KStyle *style;
@property(retain, nonatomic) NSString *langId;


+ (NSFont*)defaultFont;
- (void)setIconBasedOnContents;

- (void)guessLanguageBasedOnUTI:(NSString*)uti textContent:(NSString*)text;

// actions
- (IBAction)debugDumpAttributesAtCursor:(id)sender;
- (IBAction)selectNextElement:(id)sender;
- (IBAction)selectPreviousElement:(id)sender;

- (BOOL)setNeedsHighlightingOfCompleteDocument;
- (BOOL)highlightCompleteDocumentInBackgroundIfQueued;
- (BOOL)highlightCompleteDocumentInBackground;
- (BOOL)highlightCompleteDocument;

- (BOOL)highlightTextStorage:(NSTextStorage*)textStorage
                     inRange:(NSRange)range;

- (void)textStorageDidProcessEditing:(NSNotification*)notification;
- (void)documentDidChangeDirtyState; // when isDirty_ changed

@end
