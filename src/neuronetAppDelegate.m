//
//  neuronetAppDelegate.m
//  neuronet
//
//  Created by rockosov on 25.04.12.
//  Copyright 2012 TIT_SFEDU. All rights reserved.
//

#import "neuronetAppDelegate.h"
#import "rgb.h"
#import "StrictNumberFormatter.h"
#import "Neurons.h"

#import <CorePlot/CorePlot.h>

#define MINIMUM_SPEED			0.01
#define DEFAULT_SPEED			0.01
#define MAXIMUM_SPEED			1.0
#define DEFAULT_ERROR_VAL		0.0

#define WORKING_NEURON_INDEX	0
static void FillWeightsTable (Perceptron *perceptron, NSTableView *table,
							  NSMutableArray *tableData) {
	FormalNeuron			*workingNeuron = [[perceptron workingLayer] 
											objectAtIndex:WORKING_NEURON_INDEX];
	
	NSMutableArray			*weights = [workingNeuron weights];
	
	NSNumber				*neuronCount = [NSNumber numberWithUnsignedInt:0];
	
	[tableData removeAllObjects];
	
	for (NSNumber *currentWeight in weights) {
		NSMutableDictionary		*dictionary = [NSMutableDictionary dictionary];

		[dictionary setObject:[neuronCount stringValue] forKey:@"neuronNumber"];
		[dictionary setObject:[currentWeight stringValue] 
					   forKey:@"weightValue"];
		[tableData addObject:dictionary];
		neuronCount = [NSNumber numberWithUnsignedInt:
					   [neuronCount unsignedIntValue] + 1];
	}
	
	[table reloadData];
	
	return;
}

#define	START_FIRST_CLASS1		1
#define END_FIRST_CLASS1		START_FIRST_CLASS1 + 5
#define START_FIRST_CLASS2		13
#define END_FIRST_CLASS2		START_FIRST_CLASS2 + 5
#define START_SECOND_CLASS1		END_FIRST_CLASS1 + 1
#define END_SECOND_CLASS1		START_SECOND_CLASS1 + 5
#define START_SECOND_CLASS2		END_FIRST_CLASS2 + 1
#define END_SECOND_CLASS2		START_SECOND_CLASS2 + 5

#define IS_FIRST_CLASS(num)										\
	(num >= START_FIRST_CLASS1 && num <= END_FIRST_CLASS1) ||	\
	(num >= START_FIRST_CLASS2 && num <= END_FIRST_CLASS2)

#define IS_SECOND_CLASS(num)										\
	(num >= START_SECOND_CLASS1 && num <= END_SECOND_CLASS1) ||	\
	(num >= START_SECOND_CLASS2 && num <= END_SECOND_CLASS2)

#define FIRST_CLASS				0
#define SECOND_CLASS			1

static int ClassForImageNum (int imageNum) {
	int			class = 0;
	
	if (IS_FIRST_CLASS(imageNum)) {
		class = FIRST_CLASS;
	}
	
	if (IS_SECOND_CLASS(imageNum)) {
		class = SECOND_CLASS;
	}
		
	return class;
}

@implementation neuronetAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
}

/**
 * @brief различная инициализация объектов формы
 */
-(void) awakeFromNib {
	[super awakeFromNib];
	
	[bmpViewer setCurrentImage:nil];
		
	// так пришлось сделать из-за дурацкого неработающего деструктора NSView
	[bmpViewer setPixels:[[NSMutableArray alloc] init]];
	[imageViewer setPixels:[bmpViewer pixels]];
	[bmpViewer setDependenceImageView:imageViewer];
	
	[speedField setStringValue:[[NSNumber numberWithFloat:DEFAULT_SPEED]
								stringValue]];
	[speedStepper setFloatValue:DEFAULT_SPEED];
	[speedField setFormatter:[[StrictNumberFormatter alloc] init]];
	[[speedField formatter] setMaximum:
	 [NSNumber numberWithFloat:MINIMUM_SPEED]];
	[[speedField formatter] setMaximum:
	 [NSNumber numberWithFloat:MAXIMUM_SPEED]];
	
	[errorLevelField setStringValue:
	 [[NSNumber numberWithFloat:DEFAULT_ERROR_VAL] stringValue]];
	
	errorGraph = [(CPTXYGraph *)[CPTXYGraph alloc] 
				  initWithFrame:CGRectZero];
		
	[errorGraph applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
		
	errorGraphView.hostedGraph = errorGraph;
	
	perceptronILSize = [bmpViewer bounds].size.width * 
	[bmpViewer bounds].size.height / 
	(PIXEL_SCALE_SIZE * PIXEL_SCALE_SIZE);
	
	perceptron = [[Perceptron alloc]InitPerceptron
				  :perceptronILSize
				  :1
				  :0
				  :[[speedField stringValue] floatValue]];
	
	weightsTableElements = [[NSMutableArray alloc] init];
		
	return;
}

// закрываем приложение на кнопку Close вместе с окном
-(BOOL) applicationShouldTerminateAfterLastWindowClosed:
(NSApplication *)sender {
	return YES;
}

/**
 * @brief здесь производим деинициализацию всех объектов формы
 * @param notification [ in ] - контекст
 */
-(void) applicationWillTerminate:(NSNotification *)notification {
	
	[errorGraphView release];

	// так пришлось сделать из-за дурацкого неработающего деструктора NSView
	[[bmpViewer pixels] release];
	
	[perceptron release];
	
	[[speedField formatter] release];
	
	[weightsTableElements release];
	
	return;
}

-(void) selectImage:(id)sender {
	[bmpViewer setCurrentImage: [(NSPopUpButton *)sender title]];
	
	[imageViewer setPixels:[bmpViewer pixels]];
		
	return;
}

-(void) stepperDidChange:(id)sender {
	
	[speedField setStringValue:[sender stringValue]];
	[perceptron setSpeed:[[sender stringValue] floatValue]];
	
	return;
}

-(void) speedFieldDidChange:(id)sender {
		
	[speedStepper setStringValue:[sender stringValue]];
	[perceptron setSpeed:[[sender stringValue] floatValue]];
	
	return;
}

#define MANUAL_TEACHING			0
#define AUTOMATIC_TEACHING		1

-(void) autoManSegControlSelector:(id)sender {
	if ([autoManSegControl selectedSegment] == MANUAL_TEACHING) {
		[stepButton setEnabled:YES];
		[runButton setEnabled:NO];
		[stopButton setEnabled:NO];
	}
	else {
		[runButton setEnabled:YES];
		[stopButton setEnabled:YES];
		[stepButton setEnabled:NO];
	}
	
	return;
}

#define VIEW_MODE				0
#define TEACHING_MODE			1

-(void) modeSegControlSelector:(id)sender {
	
	if ([modeSegControl selectedSegment] == VIEW_MODE) {
		[stepButton setEnabled:NO];
		[runButton setEnabled:NO];
		[stopButton setEnabled:NO];
		[autoManSegControl setEnabled:NO];
		
		[imageSelector selectItemAtIndex:0];
		[imageSelector setEnabled:YES];
		
		[bmpViewer setCurrentImage:nil];
	}
	else {
		[autoManSegControl setEnabled:YES];
		[autoManSegControl setSelectedSegment:MANUAL_TEACHING];
		[stepButton setEnabled:YES];
		
		[imageSelector selectItemAtIndex:1];
		[imageSelector setEnabled:NO];
		
		[bmpViewer setCurrentImage:[imageSelector title]];
	}
	
	return;
}

-(void) showPercInfButtonPressed:(id)sender {
	
	[perceptronInformation setIsVisible:YES];
	[window setIsVisible:NO];
	
	FillWeightsTable(perceptron, weightsTable, weightsTableElements);
	
	return;
}

-(void) backButtonPressed:(id)sender {
	
	[perceptronInformation setIsVisible:NO];
	[window setIsVisible:YES];
	
	return;
}

-(void) stepButtonPressed:(id)sender {
	int			imageCount = [[imageSelector itemArray] count] - 1;
	int			iter = 0;
	
	[spiningManual startAnimation:sender];
	
	[perceptron setErrorLevel:0];
	
	NSLog(@"errorLevel perceptron = %f", [perceptron errorLevel]);
	
	for (iter = 1; iter <= imageCount; ++iter) {
		[perceptron DoTeachingOnce:[imageViewer pixels]
						   :ClassForImageNum([[imageSelector title] intValue])];
		[imageSelector selectItemAtIndex:
		 ([imageSelector indexOfSelectedItem] + 1)];
		[bmpViewer setCurrentImage:[imageSelector title]];
		[bmpViewer display];
		[imageViewer display];
	}
	
	[perceptron calculateErrorLevel:imageCount];
	

	
	[errorLevelField setStringValue:
	 [[NSNumber numberWithFloat:[perceptron errorLevel]] stringValue]];
	

	
	[imageSelector selectItemAtIndex:1];
	[perceptron setEra:([perceptron era] + 1)];
	[bmpViewer setCurrentImage:[imageSelector title]];
	
	[spiningManual stopAnimation:sender];
	
	return;
}

-(NSInteger) numberOfRowsInTableView:(NSTableView *)aTableView {

	return [weightsTableElements count];
}

-(id) tableView:(NSTableView *)aTableView 
objectValueForTableColumn:(NSTableColumn *)aTableColumn 
			row:(NSInteger)rowIndex {
	NSMutableDictionary *row = [weightsTableElements 
								objectAtIndex:(NSUInteger)rowIndex];

	return [row objectForKey:[aTableColumn identifier]];
}

@end
