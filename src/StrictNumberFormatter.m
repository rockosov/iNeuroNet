//
//  StrictNumberFormatter.m
//  iNeuroNet
//
//  Created by rockosov on 17.05.12.
//  Copyright 2012 TIT_SFEDU. All rights reserved.
//

#import "StrictNumberFormatter.h"

@implementation StrictNumberFormatter

-(NSString*)stringForObjectValue:(id)anObject
{
	if(![anObject isKindOfClass:[NSString class]])
		return nil;
	return anObject;
}

-(BOOL)getObjectValue:(id*)obj forString:(NSString*)string
	 errorDescription:(NSString**)error
{
	if(obj)
		*obj = string;
	return YES;
}


-(BOOL)isPartialStringValid:(NSString*)partialString
		   newEditingString:(NSString**)newString
		   errorDescription:(NSString**)error
{
	BOOL			answer = YES;
	
	if([partialString isEqual:@""])
		return YES;
		
	for ( NSUInteger iter = 0; iter < [partialString length]; iter++) {
		char		testChar;
		
		testChar = [partialString characterAtIndex:iter];
		
		if (testChar != '.' && (testChar < '0' || testChar > '9')) {
			answer = NO;
			break;
		}
	}
/*	
	NSLog(@"%f, %f, %f", [partialString floatValue],
		  [[self minimum] floatValue],
		  [[self maximum] floatValue]);
*/	
	if (answer == YES) {
		if ([partialString floatValue] < [[self minimum] floatValue] ||
			[partialString floatValue] > [[self maximum] floatValue]) {
			answer = NO;
			goto exit;
		}
		*newString = partialString;
	}
		
exit:
	if (answer == NO) {
		NSBeep();
	}
	return answer;
}

@end