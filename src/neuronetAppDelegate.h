//
//  neuronetAppDelegate.h
//  neuronet
//
//  Created by rockosov on 25.04.12.
//  Copyright 2012 TIT_SFEDU. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <CorePlot/CorePlot.h>

#import "ImageView.h"
#import "BmpView.h"

@interface neuronetAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow						*window;
	
	IBOutlet NSBox					*imageViewerBox;
	IBOutlet BmpView				*bmpViewer;
	IBOutlet ImageView				*imageViewer;
	
	IBOutlet NSBox					*learningBox;
	IBOutlet NSSegmentedControl		*autoManSegControl;
		
	IBOutlet NSBox					*automaticBox;
	IBOutlet NSButton				*runButton;
	IBOutlet NSButton				*stopButton;
	
	IBOutlet NSBox					*perceptronBox;
	IBOutlet NSButton				*showPercInfButton;
	IBOutlet CPTGraphHostingView	*errorGraph;
}

@property (assign) IBOutlet NSWindow *window;

-(IBAction)selectImage: (id)sender;

@end
