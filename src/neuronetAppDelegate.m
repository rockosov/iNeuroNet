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
#define DEFAULT_ERA_VAL		0

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
	
	//NSLog(@"For imageNum = %i class = %i", imageNum, class);
		
	return class;
}

static void ShowMessage (NSTextField *owner, 
							  NSString *message, 
							  NSColor *color) {
	NSShadow	*messShadow = [[[NSShadow alloc] init] autorelease];
	
	[messShadow setShadowColor:color];
	[messShadow setShadowBlurRadius:10.0];
	
	[owner setTextColor:color];
	[owner setShadow:messShadow];
	[owner setStringValue:message];
	
	return;
}


@implementation neuronetAppDelegate

@synthesize window;

#define VIEW_MODE				0
#define TEACHING_MODE			1

#define FOUR_APPR_MODE			0
#define FOUR					4
#define EIGHT_APPR_MODE			1
#define EIGHT					8
#define SIXTEEN_APPR_MODE		2
#define SIXTEEN					16
#define SCALE_FOR_SEGMENT(x, y)	switch(x){					\
								case FOUR_APPR_MODE:		\
									y = FOUR;				\
									break;					\
								case EIGHT_APPR_MODE:		\
									y = EIGHT;				\
									break;					\
								default:					\
									y = SIXTEEN;			\
									break;					\
								}

#define SEGMENT_FOR_SCALE(x,y) switch(x){					\
							   case FOUR:					\
									y = FOUR_APPR_MODE;		\
									break;					\
							   case EIGHT:					\
									y = EIGHT_APPR_MODE;	\
									break;					\
							   default:						\
									y = SIXTEEN_APPR_MODE;	\
									break;					\
							   }

/**
 * @brief различная инициализация объектов формы
 */
-(void) InitNeuronet {
	[bmpViewer setCurrentImage:nil];
	
	[bmpViewer setPixelsScale:pixelsScale];
	[imageViewer setPixelsScale:pixelsScale];
	
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
	
	[eraField setStringValue:
	 [[NSNumber numberWithInteger:DEFAULT_ERA_VAL] stringValue]];
	
	perceptronILSize = [bmpViewer bounds].size.width * 
	[bmpViewer bounds].size.height / 
	(pixelsScale * pixelsScale);
	
	perceptron = [[Perceptron alloc]InitPerceptron
				  :perceptronILSize
				  :1
				  :0
				  :[[speedField stringValue] floatValue]];
	
	[modeSegControl setSelectedSegment:VIEW_MODE];
	[modeSegControl sendAction:@selector(modeSegControlSelector:)
							to:self];
	
	[errorGraph erasePlotData];
	
	ShowMessage(perceptronState,
				@"Perceptron isn't trained!", 
				[NSColor redColor]);
	
	ShowMessage(imageClass, 
				@"", [NSColor redColor]);
	
	return;
}

/**
 * @brief здесь производим деинициализацию всех объектов формы
 */
-(void) CleanupNeuronet {
		
	[perceptron release];
	
	[[speedField formatter] release];
	
	return;
}

-(void) awakeFromNib {
	[super awakeFromNib];
	
	SCALE_FOR_SEGMENT(EIGHT_APPR_MODE, pixelsScale);
	[self InitNeuronet];
	
	weightsTableElements = [[NSMutableArray alloc] init];
	
	return;
}

// закрываем приложение на кнопку Close вместе с окном
-(BOOL) applicationShouldTerminateAfterLastWindowClosed:
(NSApplication *)sender {
	return YES;
}

-(void) applicationWillTerminate:(NSNotification *)notification {

	[self CleanupNeuronet];
	
	// так пришлось сделать из-за дурацкого неработающего деструктора NSView
	[[bmpViewer pixels] release];
	
	[weightsTableElements release];
	
	return;
}

-(void) selectImage:(id)sender {
	int			retClass = -1;
	[bmpViewer setCurrentImage: [(NSPopUpButton *)sender title]];
	
	[imageViewer setPixels:[bmpViewer pixels]];
	
	if ([perceptron isTrained]) {
		retClass = [perceptron ClassifiedThis:[imageViewer pixels]];
		ShowMessage(imageClass, 
					[[NSNumber numberWithInt:retClass + 1] stringValue],
					[NSColor blueColor]);
	}
	else {
		ShowMessage(imageClass, 
					@"", [NSColor redColor]);
	}

		
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

-(void) modeSegControlSelector:(id)sender {
	
	if ([modeSegControl selectedSegment] == VIEW_MODE) {
		[stepButton setEnabled:NO];
		[runButton setEnabled:NO];
		[stopButton setEnabled:NO];
		[autoManSegControl setEnabled:NO];
		
		[imageSelector selectItemAtIndex:0];
		[imageSelector setEnabled:YES];
		
		[bmpViewer setCurrentImage:nil];
		
		[speedStepper setEnabled:NO];
		
		[approximationSegControl setEnabled:YES];
	}
	else {
		if ([perceptron isTrained]) {
			NSRunInformationalAlertPanel(@"Error of select!",
			@"Can't select teaching mode, because perceptron already trained",
			@"OK", nil, nil);
			[modeSegControl setSelectedSegment:VIEW_MODE];
		}
		else {
			[autoManSegControl setEnabled:YES];
			[autoManSegControl setSelectedSegment:MANUAL_TEACHING];
			[stepButton setEnabled:YES];
		
			[imageSelector selectItemAtIndex:1];
			[imageSelector setEnabled:NO];
		
			[bmpViewer setCurrentImage:[imageSelector title]];
		
			[speedStepper setEnabled:YES];
			
			[approximationSegControl setEnabled:NO];
		}
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

#define ERROR_END			0
-(void) stepButtonPressed:(id)sender {
	int			imageCount = [[imageSelector itemArray] count] - 1;
	int			iter = 0;
	
	ShowMessage(perceptronState, 
					 @"Perceptron training...", 
					 [NSColor greenColor]);
	
	[spiningManual startAnimation:sender];
	
	[perceptron setErrorLevel:0];
		
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
	[eraField setStringValue:
	 [[NSNumber numberWithInteger:[perceptron era]] stringValue]];
	
	[errorGraph addErrorDataAndDisplay:[perceptron era] 
									  :[perceptron errorLevel]];
	
	[bmpViewer setCurrentImage:[imageSelector title]];
	
	[spiningManual stopAnimation:sender];
	
	if ([perceptron errorLevel] == ERROR_END) {
		[perceptron setIsTrained:YES];
		[modeSegControl setSelectedSegment:VIEW_MODE];
		[modeSegControl sendAction:@selector(modeSegControlSelector:)
								to:self];
		ShowMessage(perceptronState, 
						 @"Perceptron trained!", 
						 [NSColor blueColor]);
		ShowMessage(imageClass, 
					@"", [NSColor blueColor]);
	}
	else {
		ShowMessage(perceptronState,
						 @"Perceptron isn't trained!", 
						 [NSColor redColor]);
		ShowMessage(imageClass, 
					@"", [NSColor redColor]);
	}

	
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

-(void) teachingProcess {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	do {
		[stepButton sendAction:@selector(stepButtonPressed:) to:self];
	} while ([perceptron errorLevel] != ERROR_END && !isStoppedTeachingThread);
	
	if ([perceptron errorLevel] == ERROR_END) {
		[stopButton sendAction:@selector(stopButtonPressed:) to:self];

	}
	
	[resetButton setEnabled:YES];
	
	[pool release];
	
	return;
}

-(void) runButtonPressed:(id)sender {
	isStoppedTeachingThread = NO;
	[autoManSegControl setEnabled:NO];
	[speedStepper setEnabled:NO];
	[modeSegControl setEnabled:NO];
	[showPercInfButton setEnabled:NO];
	[spiningAutomatic startAnimation:self];
	[resetButton setEnabled:NO];
	[NSThread detachNewThreadSelector:@selector(teachingProcess)
							 toTarget:self withObject:nil];
	
	return;
}

-(void) stopButtonPressed:(id)sender {
	
	[autoManSegControl setEnabled:YES];
	[speedStepper setEnabled:YES];
	[modeSegControl setEnabled:YES];
	[showPercInfButton setEnabled:YES];
	[spiningAutomatic stopAnimation:self];
	if ([perceptron errorLevel] == ERROR_END) {
		[modeSegControl setSelectedSegment:VIEW_MODE];
		[modeSegControl sendAction:@selector(modeSegControlSelector:)
								to:self];
		ShowMessage(perceptronState, 
						 @"Perceptron trained!", 
						 [NSColor blueColor]);
		ShowMessage(imageClass, 
					@"", [NSColor blueColor]);
	}
	else {
		ShowMessage(perceptronState,
						 @"Perceptron isn't trained!", 
						 [NSColor redColor]);
		ShowMessage(imageClass, 
					@"", [NSColor redColor]);
	}
	
	isStoppedTeachingThread = YES;

	return;
}

#define CANCEL		0
#define RESET		1
-(void) resetButtonPressed:(id)sender {
	int choice = NSRunInformationalAlertPanel(@"Reset Dialog",
											  @"Are you sure reset perceptron?",
											  @"Resest",
											  @"Cancel",
											  nil);
	
	if (choice == RESET) {
		[self CleanupNeuronet];
		
		[self InitNeuronet];
		
		isResetted = YES;
		
		return;
	}

	isResetted = NO;
	
	return;
}

-(void) saveToFileButtonPressed:(id)sender {
	FormalNeuron			*workingNeuron = [[perceptron workingLayer] 
											objectAtIndex:WORKING_NEURON_INDEX];
	NSMutableArray			*weights = [workingNeuron weights];
	
	NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
														 NSUserDomainMask, YES);
	NSString *documentsDirectory = [path objectAtIndex:0];
		
	NSString *weightsFilename = [documentsDirectory 
							stringByAppendingPathComponent:@"weights.plist"];
	
	[weights writeToFile:weightsFilename atomically:YES];
	
	NSRunInformationalAlertPanel(@"Save weights",
					@"Successfully save to documents directory!",
					@"OK", 
					nil, 
					nil);
	
	return;
}

-(void) loadFromFileButtonPressed:(id)sender {
	FormalNeuron			*workingNeuron = [[perceptron workingLayer] 
											objectAtIndex:WORKING_NEURON_INDEX];
	NSMutableArray			*weights = [workingNeuron weights];
	
	NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
														NSUserDomainMask, YES);
	NSString *documentsDirectory = [path objectAtIndex:0];
	
	NSString *weightsFilename = [documentsDirectory 
							stringByAppendingPathComponent:@"weights.plist"];
	
	BOOL fileExists = 
		[[NSFileManager defaultManager] fileExistsAtPath:weightsFilename];
	
	if (!fileExists) {
		NSRunCriticalAlertPanel(@"Load weights",
									 @"File weights.plist doesn't exist!",
									 @"OK", 
									 nil, 
									 nil);
		return;
	}
	
	NSArray		*temp = [[NSArray alloc] 
								 initWithContentsOfFile:weightsFilename];
	
	if ([temp count] != [weights count]) {
		NSRunCriticalAlertPanel(@"Load weights",
								@"Wrong count of weights!",
								@"OK", 
								nil, 
								nil);
		[temp release];
	}
	else {
		[weights removeAllObjects];
		[weights addObjectsFromArray:temp];
		NSRunInformationalAlertPanel(@"Load weights",
								@"Successfully load from documents directory!",
									 @"OK", 
									 nil, 
									 nil);
		FillWeightsTable(perceptron, weightsTable, weightsTableElements);
		[temp release];
	}

	return;
}

-(void) approximationSegControlSelector:(id)sender {
	isResetted = NO;
	
	NSUInteger backupPixels = pixelsScale;
	NSInteger segment = -1;
	SCALE_FOR_SEGMENT([approximationSegControl selectedSegment], pixelsScale);
	
	[resetButton sendAction:@selector(resetButtonPressed:) to:self];
	
	if (!isResetted) {
		SEGMENT_FOR_SCALE(backupPixels, segment);
		[approximationSegControl setSelectedSegment:segment];
		pixelsScale = backupPixels;
	}
	
	return;
}

@end
