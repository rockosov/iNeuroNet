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

+(Neuron *) CreateNeuron : (int)weightsSize 
						 : (float_t)initWeight
						 : (float_t)initBias {
	int		size = 0;
	Neuron	*newNeuron = nil;
	int		iter = 0;
		
	size = (weightsSize > 0) ? weightsSize : DEFAULT_WEIGHTS_SIZE;
	newNeuron = [Neuron new];
	
	newNeuron->weights = [NSMutableArray arrayWithCapacity:WEIGHT_CAPACITY];
	
	for (iter = 0; iter < size; ++iter) {
		NSNumber	*currentNum = nil;
		currentNum = [NSNumber numberWithFloat:initWeight];
		[newNeuron->weights addObject:currentNum];
	}
	
	newNeuron->bias = initBias;
	
	return newNeuron;
		
}

-(float_t) main_function:(float_t)value {
	// stub for children implement
	return 0;
}

@end


@implementation FormalNeuron
	
-(float_t) main_function:(float_t)value {
	return (float_t)[self sign_function:value];
}
	
-(int8_t)sign_function : (float_t) value {
	return (value > 0) ? (1) : (0);
}

@end