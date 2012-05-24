//
//  BmpView.h
//
//  Created by rockosov on 11.05.12.
//  Copyright 2012 TIT_SFEDU. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ImageView.h"

@interface BmpView : NSView {
	NSString		*currentImage;
	
	NSMutableArray	*pixels;
	
	ImageView		*dependenceImageView;
	
	NSUInteger		pixelsScale;
}

-(void) setCurrentImage: (NSString*) targetImage;
-(void) setPixels: (NSMutableArray*) targetPixels;
-(NSString*) currentImage;
-(NSMutableArray *) pixels;
-(void) setDependenceImageView: (ImageView*) targetImageView;

@property(nonatomic, assign) NSUInteger pixelsScale;

@end
