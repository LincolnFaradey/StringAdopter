//
//  ViewController.m
//  StringAdopter
//
//  Created by Andrei Nechaev on 3/28/15.
//  Copyright (c) 2015 Andrei Nechaev. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@property (atomic, strong)NSString *text;
@property (unsafe_unretained) IBOutlet NSTextView *textView;
@property (weak) IBOutlet NSTextField *copiedLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.wantsLayer = YES;
    self.view.layerContentsRedrawPolicy = NSViewLayerContentsRedrawOnSetNeedsDisplay;
    self.copiedLabel.alphaValue = 0.0;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}
- (IBAction)convert:(NSButton *)sender {
    self.text = [[self.textView textStorage] string];
    
    const char *string = [_text UTF8String];
    size_t str_size = strlen(string);
    char *buffer = (char *)malloc(sizeof(char) * str_size * 2);
    for (int i = 0, j = 0; i < str_size; i++, j++) {
        buffer[j] = string[i];
        if (string[i] == '\\') {
            buffer[++j] = '\\';
        }
    }
    NSString *convertedString = [NSString stringWithFormat:@"\"%%@%s\"", buffer];

    [[NSPasteboard generalPasteboard] clearContents];
    [[NSPasteboard generalPasteboard] setString:convertedString forType:NSStringPboardType];
    
    [self animateSuccess];
    
    free(buffer);
}

- (void)animateSuccess
{
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.8f;
        context.allowsImplicitAnimation = YES;
        self.copiedLabel.alphaValue = 1.0;
    } completionHandler:^{
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.duration = 5.8f;
            context.allowsImplicitAnimation = YES;
            self.copiedLabel.alphaValue = 0.0;
        } completionHandler:^{
            
        }];
    }];
}

@end
