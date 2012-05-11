//
//  ImageView.m
//
//  Created by rockosov on 02.05.12.
//  Copyright 2012 TIT_SFEDU. All rights reserved.
//

#import "ImageView.h"

#define RGB_NUM_CHLS				3

NSUInteger g_blackColor[RGB_NUM_CHLS] = {0x00, 0x00, 0x00};

#define PIXEL_IS_BLACK(pixel)		\
			memcmp(pixel, g_blackColor, RGB_NUM_CHLS * sizeof(NSUInteger)) == 0
NSUInteger g_whiteColor[RGB_NUM_CHLS] = {0xff, 0xff, 0xff};
#define PIXEL_IS_WHITE(pixel)		\
			memcmp(pixel, g_whiteColor, RGB_NUM_CHLS * sizeof(NSUInteger)) == 0


void PrintPixels (NSImage *targetImage) {
	NSBitmapImageRep	*bitmapImageRep = [[NSBitmapImageRep alloc]
										initWithData:
										   [targetImage TIFFRepresentation]];

	NSUInteger			*rgba = malloc(sizeof(NSInteger) * 4);
	
	NSInteger			x, y;

	memset (rgba, 0, sizeof(NSInteger) * 4);
	
	assert (targetImage != nil);
	
	NSLog(@"pixels width = %i, height = %i", [bitmapImageRep pixelsWide], 
		  [bitmapImageRep pixelsHigh]);
	
	for (y = 0; y < [bitmapImageRep pixelsHigh]; ++y) {
		for (x = 0; x < [bitmapImageRep pixelsWide]; ++x) {
			[bitmapImageRep getPixel:rgba
								 atX:x
								   y:y];
			if ( PIXEL_IS_BLACK(rgba)) {
				NSLog(@"at x = %i, y = %i black pixel = %x%x%x",
					  x, y, rgba[0], rgba[1], rgba[2]);
			}
			else {
				if (PIXEL_IS_WHITE(rgba)) {
					NSLog(@"at x = %i, y = %i white pixel = %x%x%x", x, y,
						  rgba[0], rgba[1], rgba[2]);
				}
				else {
					NSLog(@"FAIL! at x = %i, y = %i pixel = %x%x%x", x, y,
						  rgba[0], rgba[1], rgba[2]);
				}

			}

		}
	}
	
	[bitmapImageRep release];
	free(rgba);
	
	return;
}

@implementation ImageView

- (void) drawRect:(NSRect)aRect {
	if (currentImage == nil) {

		// аттрибуты строки
		//======================================================================
		NSFont				*font = [NSFont fontWithName:@"Verdana-BoldItalic" 
													size:20.0];
		
		NSMutableParagraphStyle *mutParaStyle = [[NSMutableParagraphStyle alloc]
												 init];
		
		NSArray				*objects = [NSArray arrayWithObjects:font, 
										[NSColor blackColor],
										mutParaStyle,
										nil];
		
		NSArray				*keys = [NSArray arrayWithObjects:
									 NSFontAttributeName, 
									 NSForegroundColorAttributeName,
									 NSParagraphStyleAttributeName,
									 nil];
		
		[mutParaStyle setAlignment:NSCenterTextAlignment];
		
		NSDictionary		*attributes = [NSDictionary dictionaryWithObjects:
										   objects 
																forKeys:
										   keys];
		
		NSAttributedString	*banner = 
		[[NSAttributedString alloc] initWithString:@"\n\n\nImage not selected"
										attributes:attributes];
		//======================================================================

		[[NSColor whiteColor] set];

		NSRectFill([self bounds]);
		
		[banner drawInRect:[self bounds]];
		
		[banner release];
		[mutParaStyle release];
	}
	else {
		NSImage		*image = nil;
		
		NSString	*targetImagePath = nil;
		
		targetImagePath = [[NSBundle mainBundle] pathForResource:currentImage
														  ofType:@"bmp"];

		image = [[NSImage alloc]
				 initWithContentsOfFile:targetImagePath];
		
		PrintPixels(image);
		
		[image  drawInRect:[self bounds] 
				  fromRect:[image alignmentRect]
				 operation:NSCompositeSourceOver
				  fraction:1.0];
		
		NSLog(@"H = %f, W = %f", [image size].height, [image size].width);
		
		[image release];
	}
	
	
	return;
}

-(void) setCurrentImage:(NSString *)targetImage {
	
	currentImage = targetImage;
	
	[self setNeedsDisplay:YES];
	
	return;
}

@end