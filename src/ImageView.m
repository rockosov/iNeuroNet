//
//  ImageView.m
//
//  Created by rockosov on 02.05.12.
//  Copyright 2012 TIT_SFEDU. All rights reserved.
//

#import "ImageView.h"
#import "rgb.h"

static void DrawGrid (ImageView *owner, NSUInteger scale) {
	NSRect				ownerRect;
	NSBezierPath		*verticalLinePath = nil;
	NSBezierPath		*horizontalLinePath = nil;
	
	int					gridWidth = 0;
	int					gridHeight = 0;
	int					xyIterator = 0;
	
	NSPoint				startPoint = { 0, 0 };
	NSPoint				endPoint = { 0, 0 };

	
	if (scale < MIN_SCALE_FOR_GRID) {
		return;
	}
	
	ownerRect = [owner bounds];
	[[NSColor grayColor] set];
	verticalLinePath = [NSBezierPath bezierPath];
	
	gridWidth = ownerRect.size.width;
	gridHeight = ownerRect.size.height;
	
	while (xyIterator <= gridWidth) {
		startPoint.x = xyIterator;
		startPoint.y = 0;
		
		endPoint.x = xyIterator;
		endPoint.y = gridHeight;
				
		[verticalLinePath setLineWidth:0.1];
		[verticalLinePath moveToPoint:startPoint];
		[verticalLinePath lineToPoint:endPoint];
		[verticalLinePath stroke];
		
		xyIterator = xyIterator + scale;
	}
		
	horizontalLinePath = [NSBezierPath bezierPath];		

	xyIterator = 0;
	while (xyIterator <= gridHeight) {
		startPoint.x = 0;
		startPoint.y = xyIterator;
		
		endPoint.x = gridWidth;
		endPoint.y = xyIterator;
		
		[horizontalLinePath setLineWidth:0.1];
		[horizontalLinePath moveToPoint:startPoint];
		[horizontalLinePath lineToPoint:endPoint];
		[horizontalLinePath stroke];
		
		xyIterator = xyIterator + scale;
	}
	
	return;
}

static void DrawPixels (ImageView *owner, NSUInteger scale) {
	NSInteger		x = 0, y = 0;
	
	NSUInteger		index = 0;
	
	NSRect			currentRect = NSMakeRect(x, y, scale, scale);
	
	NSUInteger		currentPixelBin = 0;
	
	for ( y = [owner bounds].size.height - scale; y >= 0; y -= scale ) {
		for ( x = 0; x < [owner bounds].size.width; x += scale ) {
			currentRect.origin.x = x;
			currentRect.origin.y = y;
			
			currentPixelBin = [(NSNumber*)[[owner pixels] objectAtIndex:index]
							   unsignedIntegerValue];
						
			if (currentPixelBin == BLACK_PIXEL_BIN) {
				[[NSColor blackColor] set];
			}
			if (currentPixelBin == WHITE_PIXEL_BIN) {
				[[NSColor whiteColor] set];
			}
			
			NSRectFill(currentRect);
			index++;
		}
	}
	
	return;
}

@implementation ImageView

- (void) drawRect:(NSRect)aRect {
	[[NSColor whiteColor] set];
	NSRectFill([self bounds]);
	
	if (pixels != nil && [pixels count] != 0) {
		DrawPixels(self, pixelsScale);
	}
	DrawGrid(self, pixelsScale);
	
	return;
}

-(void) setPixels:(NSMutableArray *)targetPixels {
	
	pixels = targetPixels;
	
	return;
}

-(NSMutableArray *) pixels {
	return pixels;
}

@synthesize pixelsScale;

@end