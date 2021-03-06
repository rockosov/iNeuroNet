//
//  ImageView.h
//
//  Created by rockosov on 02.05.12.
//  Copyright 2012 TIT_SFEDU. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ImageView : NSView {
	NSMutableArray	*pixels;
	
	NSUInteger		pixelsScale;
}

-(void) setPixels: (NSMutableArray*) targetPixels;
-(NSMutableArray*) pixels;

@property(nonatomic, assign) NSUInteger pixelsScale;

@end
