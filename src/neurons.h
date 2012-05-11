//
//  Neuron.h
//  iNeuroNet
//
//  Created by rockosov on 29.04.12.
//  Copyright 2012 TIT_SFEDU. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define INPUT_NUM		16

@interface Neuron : NSObject

{
	@protected
		NSMutableArray	*weights;
		float_t			bias;
}

+(Neuron*)CreateNeuron : (int) weightsSize
					   : (float_t) initWeight
					   : (float_t) initBias;

-(float_t)main_function : (float_t) value;

@end 


@interface FormalNeuron : Neuron 
{}

-(int8_t)sign_function : (float_t) value;

@end
