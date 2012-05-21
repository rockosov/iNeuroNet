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
#import "Perceptron.h"

@interface neuronetAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow						*window;
		
	IBOutlet NSBox					*imageViewerBox;
	IBOutlet BmpView				*bmpViewer;
	IBOutlet ImageView				*imageViewer;
	IBOutlet NSPopUpButton			*imageSelector;
	
	IBOutlet NSBox					*teachingBox;
	IBOutlet NSSegmentedControl		*autoManSegControl;
	
	IBOutlet NSBox					*manualBox;
	IBOutlet NSButton				*stepButton;
	IBOutlet NSProgressIndicator	*spiningManual;
		
	IBOutlet NSBox					*automaticBox;
	IBOutlet NSButton				*runButton;
	IBOutlet NSButton				*stopButton;
	
	IBOutlet NSBox					*perceptronBox;
	IBOutlet CPTGraphHostingView	*errorGraphView;
	IBOutlet NSTextField			*speedField;
	IBOutlet NSStepper				*speedStepper;
	IBOutlet NSTextField			*errorLevelField;
	IBOutlet NSSegmentedControl		*modeSegControl;
	IBOutlet NSButton				*showPercInfButton;
	
	IBOutlet NSWindow				*perceptronInformation;
	IBOutlet NSTableView			*weightsTable;
	NSMutableArray					*weightsTableElements;
	IBOutlet NSButton				*backButton;
	
	Perceptron						*perceptron;
	NSUInteger						perceptronILSize;
	CPTXYGraph						*errorGraph;
	
	BOOL							alreadyAwakeFromNib;
}

@property (assign) IBOutlet NSWindow *window;

-(IBAction) selectImage: (id)sender;
-(IBAction) stepperDidChange: (id)sender;
-(IBAction) speedFieldDidChange: (id)sender;
-(IBAction) autoManSegControlSelector: (id)sender;
-(IBAction) modeSegControlSelector: (id)sender;
-(IBAction) showPercInfButtonPressed: (id)sender;
-(IBAction) backButtonPressed: (id) sender;
-(IBAction) stepButtonPressed: (id) sender;

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView;
- (id)tableView:(NSTableView *)aTableView 
objectValueForTableColumn:(NSTableColumn *)aTableColumn 
			row:(NSInteger)rowIndex;

@end
