//
//  ViewController.m
//  StringAdopter
//
//  Created by Andrei Nechaev on 3/28/15.
//  Copyright (c) 2015 Andrei Nechaev. All rights reserved.
//

#import "ViewController.h"


@interface ViewController () <NSTextViewDelegate>

@property (unsafe_unretained) IBOutlet NSTextView *textView;
@property (weak) IBOutlet NSTextField *copiedLabel;
@property (weak) IBOutlet NSComboBox *languageComboBox;

- (IBAction)chooseLanguage:(NSComboBox *)sender;

- (NSString *)convert;
- (void)animateTextAppearence;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.wantsLayer = YES;

    self.copiedLabel.alphaValue = 0.0;
    self.textView.delegate = self;
    [_languageComboBox selectItemAtIndex:0];

}

#pragma mark - IBActions
- (IBAction)convert:(NSButton *)sender {
    [[NSPasteboard generalPasteboard] clearContents];
    [[NSPasteboard generalPasteboard] setString:[self convert] forType:NSStringPboardType];
    
    [self animateTextAppearence];
}

#pragma mark - NSTextViewDelegate methods
-(void)textViewDidChangeSelection:(NSNotification *)notification
{
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.8f;
        context.allowsImplicitAnimation = YES;
        
        if ([[[self.textView textStorage] string] length] == 0) {
            self.copiedLabel.stringValue = @"Nothing to copy";
            self.view.layer.shadowColor = [NSColor redColor].CGColor;
        }else {
            self.copiedLabel.stringValue = @"Copied to clipboard";
            self.view.layer.shadowColor = [NSColor colorWithCalibratedRed:0.078 green:0.400 blue:0.604 alpha:1].CGColor;
        }
        
    } completionHandler:nil];
}

#pragma mark - Main functionality
- (IBAction)chooseLanguage:(NSComboBox *)sender {
}

- (NSString *)convert
{
    NSString *text = [[self.textView textStorage] string];
    
    text = [text stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    text = [text stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    text = [text stringByReplacingOccurrencesOfString:@"%%" withString:@"%%%%"];
    
    NSString *convertedString;
        if (self.languageComboBox.indexOfSelectedItem == 0) {
            convertedString = [NSString stringWithFormat:@"@\"%@\"", text];
        }else {
            convertedString = [NSString stringWithFormat:@"\"%@\"", text];
        }
    
    return convertedString;
}

#pragma mark - Helper methods
- (void)animateTextAppearence
{
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.5f;
        context.allowsImplicitAnimation = YES;
        self.copiedLabel.alphaValue = 1.0;
    } completionHandler:^{
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.duration = 2.5f;
            context.allowsImplicitAnimation = YES;
            self.copiedLabel.alphaValue = 0.0;
        } completionHandler:^{
            
        }];
    }];
}

@end
