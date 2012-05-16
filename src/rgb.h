/*
 *  rgb.h
 *  iNeuroNet
 *
 *  Created by rockosov on 11.05.12.
 *  Copyright 2012 TIT_SFEDU. All rights reserved.
 *
 */

#ifndef __RGB_H__
#define __RGB_H__

#import <Cocoa/Cocoa.h>

#define RGB_NUM_CHLS				3
#define RED							0
#define GREEN						1
#define BLUE						2

static NSUInteger g_Black[RGB_NUM_CHLS] = {0x00, 0x00, 0x00};
static NSUInteger g_White[RGB_NUM_CHLS] = { 0xff, 0xff, 0xff };

#define PIXEL_IS(Color)											\
static inline BOOL PixelIs##Color(NSUInteger *pixel) {			\
		return (pixel[RED] == g_##Color[RED] &&					\
				pixel[GREEN] == g_##Color[GREEN] &&				\
				pixel[BLUE] == g_##Color[BLUE]);				\
}

#define BLACK_PIXEL_BIN				1
#define WHITE_PIXEL_BIN				0

PIXEL_IS(Black);
PIXEL_IS(White);

#define MIN_SCALE_FOR_GRID			4
#define PIXEL_SCALE_SIZE			4

#endif /* __RGB_H__ */
