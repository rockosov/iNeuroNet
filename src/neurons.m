//
//  Neuron.m
//  iNeuroNet
//
//  Created by rockosov on 29.04.12.
//  Copyright 2012 TIT_SFEDU. All rights reserved.
//

#import "Neurons.h"

#define WEIGHT_CAPACITY			512
#define DEFAULT_WEIGHTS_SIZE	16

@implementation Neuron

-(Neuron *) InitNeuron : (int)weightsSize 
						 : (float_t)initWeight
						 : (float_t)initBias {
	int		size = 0;
	int		iter = 0;
		
	size = (weightsSize > 0) ? weightsSize : DEFAULT_WEIGHTS_SIZE;
	if (self = [super init]) {
		weights = [[NSMutableArray alloc] init];
		
		for (iter = 0; iter < size; ++iter) {
			NSNumber	*currentNum = nil;
			currentNum = [NSNumber numberWithFloat:initWeight];
			[weights addObject:currentNum];
		}
		
		bias = initBias;
	}

	return self;
		
}

-(float_t) main_function:(NSMutableArray*)values {
	// stub for children implement
	return 0;
}

-(NSMutableArray *) weights {
	return weights;
}

-(float_t) bias {
	return bias;
}

-(void) dealloc {
	
	[weights removeAllObjects];
	[weights release];
	
	return [super dealloc];
}

@end


@implementation FormalNeuron
	
-(float_t) main_function:(NSMutableArray*)values {
	float_t		totalVal = 0;
	
	NSUInteger	count = 0;
	
	for (NSNumber *currentValue in values) {
		totalVal += [currentValue floatValue] * 
		[[weights objectAtIndex:count] floatValue];
		//NSLog(@"currentValue is %f", [currentValue floatValue]);
		count++;
	}
	
	return (totalVal >= bias)?(float_t)[self sign_function:(totalVal - bias)]:0;
}
	
-(int8_t)sign_function : (float_t) value {
	return (value > 0) ? (1) : (0);
}

@end