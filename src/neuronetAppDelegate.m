//
//  neuronetAppDelegate.m
//  neuronet
//
//  Created by rockosov on 25.04.12.
//  Copyright 2012 TIT_SFEDU. All rights reserved.
//

#import "neuronetAppDelegate.h"

@implementation neuronetAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[imageViewer setCurrentImage:nil];
}

// закрываем приложение на кнопку Close вместе с окном
-(BOOL) applicationShouldTerminateAfterLastWindowClosed:
(NSApplication *)sender {
	return YES;
}

-(void) selectImage:(id)sender {
	[imageViewer setCurrentImage: [(NSPopUpButton *)sender title]];
	
	return;
}

@end
