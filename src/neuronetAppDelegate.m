//
//  neuronetAppDelegate.m
//  neuronet
//
//  Created by rockosov on 25.04.12.
//  Copyright 2012 TIT_SFEDU. All rights reserved.
//

#import "neuronetAppDelegate.h"

#import <CorePlot/CorePlot.h>

@implementation neuronetAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
}

-(void) awakeFromNib {
	[bmpViewer setCurrentImage:nil];
	
	// так пришлось сделать из-за дурацкого неработающего деструктора NSView
	[bmpViewer setPixels:[[NSMutableArray alloc] init]];
	[imageViewer setPixels:[bmpViewer pixels]];
	[bmpViewer setDependenceImageView:imageViewer];
	
	// Create graph from theme
	CPTXYGraph			*graph;
	graph = [(CPTXYGraph *)[CPTXYGraph alloc] initWithFrame:CGRectZero];
	
	CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
	
	[graph applyTheme:theme];
	
	errorGraph.hostedGraph = graph;
	
	
	return;
}

// закрываем приложение на кнопку Close вместе с окном
-(BOOL) applicationShouldTerminateAfterLastWindowClosed:
(NSApplication *)sender {
	return YES;
}

-(void) applicationWillTerminate:(NSNotification *)notification {
	// так пришлось сделать из-за дурацкого неработающего деструктора NSView
	[[bmpViewer pixels] release];
	
	return;
}

-(void) selectImage:(id)sender {
	[bmpViewer setCurrentImage: [(NSPopUpButton *)sender title]];
	
	[imageViewer setPixels:[bmpViewer pixels]];
		
	return;
}

@end
