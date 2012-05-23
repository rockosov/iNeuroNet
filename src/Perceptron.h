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
	
	BOOL				isTrained;
}

-(Perceptron*)InitPerceptron : (NSUInteger) inputLayerNum
					  : (NSUInteger) workingLayerNum
					  : (NSUInteger) outputLayerNum
					  : (float_t) targetSpeed;

-(NSMutableArray*) inputLayer;
-(NSMutableArray*) workingLayer;
-(NSMutableArray*) outputLayer;

@property(nonatomic, assign) float_t speed;
@property(nonatomic, assign) NSUInteger era;
@property(nonatomic, assign) float_t errorLevel;
@property(nonatomic, assign) BOOL isTrained;

-(void) calculateErrorLevel: (NSUInteger) count;

-(void) DoTeachingOnce : (NSMutableArray*) image 
					  : (int) terminal;

-(int) ClassifiedThis : (NSMutableArray*) image;

@end