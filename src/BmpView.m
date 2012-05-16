//
//  BmpView.m
//
//  Created by rockosov on 11.05.12.
//  Copyright 2012 TIT_SFEDU. All rights reserved.
//

#import "BmpView.h"
#import "rgb.h"

static void DrawBanner (BmpView *owner) {
	
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
	
	NSRectFill([owner bounds]);
	
	[banner drawInRect:[owner bounds]];
	
	[banner release];
	[mutParaStyle release];
	
	return;
}

NSUInteger GetCurrentPixelBin (NSUInteger x, 
							   NSUInteger y, 
							   NSUInteger pixelSide,
							   NSBitmapImageRep *bitmapImageRep) {
	NSUInteger			*rgba = nil;
	
	NSUInteger			i, j;
	
	NSUInteger			blackCounter = 0;
	NSUInteger			whiteCounter = 0;
	
	rgba = malloc(sizeof(NSInteger) * 4);
	memset (rgba, 0, sizeof(NSInteger) * 4);
	
	for ( i = x; i < x + pixelSide; ++i ) {
		for ( j = y; j < y + pixelSide; ++j ) {
			[bitmapImageRep getPixel:rgba
								 atX:i
								   y:j];
			if ( PixelIsBlack(rgba) ) {
				blackCounter++;
			}
			else {
				if (PixelIsWhite(rgba)) {
					whiteCounter++;
				}
				else {
					whiteCounter++;
				}
			}
		}
	}
	
	free(rgba);
	
	return ( blackCounter >= whiteCounter ) ? BLACK_PIXEL_BIN : WHITE_PIXEL_BIN;
}

static void FillPixels (NSImage *targetImage, BmpView *owner) {
	NSBitmapImageRep	*bitmapImageRep = [[NSBitmapImageRep alloc]
										   initWithData:
										   [targetImage TIFFRepresentation]];
	
	NSInteger			x, y;
	
	NSNumber			*pixelBin = nil;
	
	assert (targetImage != nil);
	
	[[owner pixels] removeAllObjects];
	
	for ( y = 0; y < [bitmapImageRep pixelsHigh]; y += PIXEL_SCALE_SIZE ) {
		for ( x = 0; x < [bitmapImageRep pixelsWide]; x += PIXEL_SCALE_SIZE ) {
			pixelBin = [NSNumber numberWithUnsignedInteger:
						GetCurrentPixelBin(x,
										   y, 
										   PIXEL_SCALE_SIZE,
										   bitmapImageRep)];
			[[owner pixels] addObject:pixelBin];
		}
	}
			
	[bitmapImageRep release];
	
	return;
}

static void DrawImage (BmpView *owner) {
	NSImage		*image = nil;
	
	NSString	*targetImagePath = nil;
	
	targetImagePath = [[NSBundle mainBundle] 
					   pathForResource:[owner currentImage]
					   ofType:@"bmp"];
	
	image = [[NSImage alloc]
			 initWithContentsOfFile:targetImagePath];
	
	FillPixels(image, owner);
	
	[image  drawInRect:[owner bounds] 
			  fromRect:[image alignmentRect]
			 operation:NSCompositeSourceOver
			  fraction:1.0];
	
	[image release];
	
	return;
}

@implementation BmpView

- (void) drawRect:(NSRect)aRect {
	if (currentImage == nil) {
		DrawBanner(self);
	}
	else {
		DrawImage(self);
	}
	
	[dependenceImageView setNeedsDisplay:YES];
	
	return;
}

-(void) setCurrentImage:(NSString *)targetImage {
	
	currentImage = targetImage;
	
	[self setNeedsDisplay:YES];
	
	return;
}

-(void) setPixels:(NSMutableArray *)targetPixels {
	
	pixels = targetPixels;
	
	[self setNeedsDisplay:YES];
	
	return;
}

-(NSString*) currentImage {
	return currentImage;
}

-(NSMutableArray *) pixels {
	return pixels;
}

-(void) setDependenceImageView:(ImageView *)targetImageView {
	dependenceImageView = targetImageView;
	
	return;
}

@end
