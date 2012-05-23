//
//  neuronetAppDelegate.h
//  neuronet
//
//  Created by rockosov on 25.04.12.
//  Copyright 2012 TIT_SFEDU. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ImageView.h"
#import "BmpView.h"
#import "Perceptron.h"
#import "GraphController.h"

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
	BOOL							isStoppedTeachingThread;
	IBOutlet NSProgressIndicator	*spiningAutomatic;
	
	IBOutlet NSBox					*perceptronBox;
	IBOutlet NSTextField			*speedField;
	IBOutlet NSStepper				*speedStepper;
	IBOutlet NSTextField			*errorLevelField;
	IBOutlet NSSegmentedControl		*modeSegControl;
	IBOutlet NSButton				*showPercInfButton;
	IBOutlet NSTextField			*eraField;
	IBOutlet NSTextField			*perceptronState;
	IBOutlet NSTextField			*imageClass;
	
	IBOutlet NSWindow				*perceptronInformation;
	IBOutlet NSTableView			*weightsTable;
	NSMutableArray					*weightsTableElements;
	IBOutlet NSButton				*backButton;
	IBOutlet NSButton				*saveToFileButton;
	IBOutlet NSButton				*loadFromFileButton;
	
	Perceptron						*perceptron;
	NSUInteger						perceptronILSize;
	IBOutlet GraphController		*errorGraph;
	NSArray							*plotData;
	
	IBOutlet NSButton				*resetButton;
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
-(IBAction) runButtonPressed: (id) sender;
-(IBAction) stopButtonPressed: (id) sender;
-(IBAction) resetButtonPressed: (id) sender;
-(IBAction) saveToFileButtonPressed: (id) sender;
-(IBAction) loadFromFileButtonPressed: (id) sender;
-(void)	teachingProcess;

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView;
- (id)tableView:(NSTableView *)aTableView 
objectValueForTableColumn:(NSTableColumn *)aTableColumn 
			row:(NSInteger)rowIndex;

@end
