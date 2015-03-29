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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.wantsLayer = YES;

    self.copiedLabel.alphaValue = 0.0;
    self.textView.delegate = self;
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
    } completionHandler:^{}];
    
}

#pragma mark - Helper methods

- (NSString *)convert
{
    NSString *text = [[self.textView textStorage] string];
    
    const char *string = [text UTF8String];
    
    size_t str_size = strlen(string);
    char *buffer = (char *)malloc(sizeof(char) * str_size * 2);
    for (int i = 0, j = 0; i < str_size; i++, j++) {
        if (string[i] == '\"') buffer[j++] = '\\';
        
        buffer[j] = string[i];
        
        switch (string[i]) {
            case '\\':
                buffer[++j] = '\\';
                break;
            case '%':
                buffer[++j] = '%';
                break;
        }
        
    }

    NSString *convertedString = [NSString stringWithFormat:@"@\"%s\"", buffer];
    free(buffer);
    
    return convertedString;
}

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
