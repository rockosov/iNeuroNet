//
//  Perceptron.h
//  iNeuroNet
//
//  Created by rockosov on 30.04.12.
//  Copyright 2012 TIT_SFEDU. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define NUM_OF_CLASS				2
#define DEFAULT_WEIGHT_VAL			0.1
#define DEFAULT_BIAS				0
#define INPUT_LAYER_WEIGHTS_SIZE	1

@interface Perceptron : NSObject {
	NSMutableArray		*inputLayer;
	NSMutableArray		*workingLayer;
	NSMutableArray		*outputLayer;
	
	float_t				speed;
	float_t				errorLevel;
	
	NSUInteger			era;
}

-(Perceptron*)InitPerceptron : (NSUInteger) inputLayerNum
					  : (NSUInteger) workingLayerNum
					  : (NSUInteger) outputLayerNum
					  : (float_t) targetSpeed;

-(NSMutableArray*) inputLayer;
-(NSMutableArray*) workingLayer;
-(NSMutableArray*) outputLayer;

-(void) setSpeed : (float_t) targetSpeed;
-(float_t) speed;

-(void) setEra : (NSUInteger) targetEra;
-(NSUInteger) era;

-(void) setErrorLevel : (NSUInteger) targetErrorLevel;
-(float_t) errorLevel;

-(void) calculateErrorLevel: (NSUInteger) count;

-(void) DoTeachingOnce : (NSMutableArray*) image 
					  : (int) terminal;

@end