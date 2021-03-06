//
//  Perceptron.m
//  iNeuroNet
//
//  Created by rockosov on 30.04.12.
//  Copyright 2012 TIT_SFEDU. All rights reserved.
//

#import "Perceptron.h"
#import "Neurons.h"

@interface Perceptron()

-(void) deltaRule : (float_t) terminalOuput
				  : (float_t) currentOutput
				  : (float_t) currentComponent
				  : (float_t*) currentWeight;
@end

@implementation Perceptron

-(NSMutableArray *) inputLayer {
	return inputLayer;
}

-(NSMutableArray *) workingLayer {
	return workingLayer;
}

-(NSMutableArray *) outputLayer {
	return outputLayer;
}

@synthesize speed;
@synthesize era;
@synthesize errorLevel;
@synthesize isTrained;

-(Perceptron*)InitPerceptron : (NSUInteger)inputLayerNum
								 : (NSUInteger)workingLayerNum
								 : (NSUInteger)outputLayerNum
								 : (float_t)targetSpeed {
	FormalNeuron			*currentFormalNeuron = nil;
	
	/*
	NSLog(@"Init with inputLayerNum = %u,\
		  workingLayerNum = %u,\
		  outputLayerNum = %u,\
		  speed = %f",
		  inputLayerNum,
		  workingLayerNum,
		  outputLayerNum,
		  targetSpeed);
	 */
	
	if (self = [super init]) {
		inputLayer = [[NSMutableArray alloc] init];
		workingLayer = [[NSMutableArray alloc] init];
		outputLayer = [[NSMutableArray alloc] init];
		
		for (NSUInteger iter = 0; iter < inputLayerNum; ++iter) {
			currentFormalNeuron = (FormalNeuron*)[[FormalNeuron alloc] 
												  InitNeuron:
												  INPUT_LAYER_WEIGHTS_SIZE
													  :DEFAULT_WEIGHT_VAL
													  :DEFAULT_BIAS];
			[inputLayer addObject:currentFormalNeuron];
		}
		
		for (NSUInteger iter = 0; iter < workingLayerNum; ++iter) {
			currentFormalNeuron = (FormalNeuron*)[[FormalNeuron alloc] 
												  InitNeuron:inputLayerNum
													  :DEFAULT_WEIGHT_VAL
													  :DEFAULT_BIAS];
			[workingLayer addObject:currentFormalNeuron];
		}
		
		for (NSUInteger iter = 0; iter < outputLayerNum; ++iter) {
			// stub
		}
		
		era = 0;
		
		speed = targetSpeed;
		
		errorLevel = 0;
		
		isTrained = NO;
	}
	
	return self;
}

-(void) deltaRule : (float_t)terminalOuput
				  : (float_t)currentOutput
				  : (float_t)currentComponent
				  : (float_t *)currentWeight {
	
	float_t		delta = terminalOuput - currentOutput;
	float_t		currentDelta = delta * speed * currentComponent;
		
	*currentWeight = *currentWeight + currentDelta;
	
	return;
}

-(int) ClassifiedThis:(NSMutableArray *)image {
	NSMutableArray		*secondaryVals = [[NSMutableArray alloc] init];
	int					retVal;
	NSUInteger			count = 0;
	
	for (NSNumber *currentValue in image) {
		FormalNeuron		*currentNeuron =
		[inputLayer objectAtIndex:count];
		
		NSNumber			*currentSecondaryVal;
		
		currentSecondaryVal = [NSNumber numberWithFloat:
							   [currentNeuron main_function:
								[NSMutableArray arrayWithObject:currentValue]]];
				
		[secondaryVals addObject:currentSecondaryVal];
		count++;
	}
	
	retVal = [[workingLayer objectAtIndex:0] main_function:secondaryVals];
	
	[secondaryVals release];
	
	return retVal;
	
}

-(void) DoTeachingOnce:(NSMutableArray *)image 
					 :(int)terminal {
	int		count = 0;
	int		retVal = 0;

	retVal = [self ClassifiedThis:image];
	
	for (NSNumber *currentValue in image) {
		FormalNeuron		*workingNeuron = [workingLayer objectAtIndex:0];
		float_t				currentWeight = [[[workingNeuron weights] 
											  objectAtIndex:count] floatValue];
		
				
		[self deltaRule:terminal 
					   :retVal 
					   :[currentValue floatValue]
					   :&currentWeight];
		
		[[workingNeuron weights] replaceObjectAtIndex:count
										   withObject:
		 [NSNumber numberWithFloat:currentWeight]];
				
		count++;
	}
	
	errorLevel += (retVal - terminal) * (retVal - terminal);

	
	return;
}

-(void) calculateErrorLevel:(NSUInteger)count {
	errorLevel /= count;
	errorLevel = sqrt(errorLevel);
	
	return;
}

-(void) dealloc {
	
	for (FormalNeuron *currentFormalNeuron in inputLayer) {
		[currentFormalNeuron release];
	}
	[inputLayer removeAllObjects];
	
	for (FormalNeuron *currentFormalNeuron in workingLayer) {
		[currentFormalNeuron release];
	}
	[workingLayer removeAllObjects];
	
	for (FormalNeuron *currentFormalNeuron in outputLayer) {
		// stub
	} 
	
	[inputLayer release];
	[workingLayer release];
	[outputLayer release];
	
	return [super dealloc];
}

@end
