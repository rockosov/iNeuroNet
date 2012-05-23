//
//  GraphController.h
//  iNeuroNet
//
//  Created by rockosov on 23.05.12.
//  Copyright 2012 TIT_SFEDU. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <CorePlot/CorePlot.h>

@interface GraphController : NSObject<CPTPlotDataSource> {
	IBOutlet CPTGraphHostingView		*hostView;
	CPTXYGraph							*graph;
	NSArray								*plotData;
	CPTScatterPlot						*dataSourceLinePlot;
}

-(void) addErrorDataAndDisplay: (float_t) eraX: (float_t) errorY;
-(void) erasePlotData;

@end
