//
//  GraphController.m
//  iNeuroNet
//
//  Created by rockosov on 23.05.12.
//  Copyright 2012 TIT_SFEDU. All rights reserved.
//

#import "GraphController.h"


@implementation GraphController


-(void) release {
	[plotData release];
	[graph release];
	[dataSourceLinePlot release];
	[super release];
}

-(void)awakeFromNib
{
	[super awakeFromNib];
	
	// Create graph from theme
	graph = [(CPTXYGraph *)[CPTXYGraph alloc] initWithFrame:CGRectZero];
	CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
	[graph applyTheme:theme];
	hostView.hostedGraph = graph;
	
	// Setup scatter plot space
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
	plotSpace.xRange = [CPTPlotRange 
						plotRangeWithLocation:CPTDecimalFromFloat(-5.0) 
						length:CPTDecimalFromFloat(30)];
	plotSpace.yRange = [CPTPlotRange 
						plotRangeWithLocation:CPTDecimalFromFloat(-0.5) 
						length:CPTDecimalFromFloat(2.0)];
	
	// Axes
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
	CPTXYAxis *x		  = axisSet.xAxis;
	x.majorIntervalLength		  = CPTDecimalFromFloat(5.0);
	x.orthogonalCoordinateDecimal = CPTDecimalFromFloat(0.0);
	x.minorTicksPerInterval		  = 0;
	x.title = @"ERA";
	x.titleLocation = CPTDecimalFromFloat(13.0);
	x.titleOffset = 40.0;
	
	NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] 
										   init] autorelease];
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[numberFormatter setMaximumFractionDigits:3];
	[numberFormatter setPositiveFormat:@"###0.00"];
	
	CPTXYAxis *y = axisSet.yAxis;
	y.majorIntervalLength		  = CPTDecimalFromFloat(0.4);
	y.minorTicksPerInterval		  = 1;
	y.orthogonalCoordinateDecimal = CPTDecimalFromFloat(0);
	y.title = @"ERROR LEVEL";
	y.labelFormatter = numberFormatter;
	y.titleLocation = CPTDecimalFromFloat(0.8);
	y.titleOffset = 40.0;
	
	// Create a plot that uses the data source method
	dataSourceLinePlot = [[CPTScatterPlot alloc] init];
	dataSourceLinePlot.identifier = @"Date Plot";
	
	CPTMutableLineStyle *lineStyle = [[dataSourceLinePlot.dataLineStyle 
									   mutableCopy] autorelease];
	lineStyle.lineWidth				 = 3.f;
	lineStyle.lineColor				 = [CPTColor greenColor];
	dataSourceLinePlot.dataLineStyle = lineStyle;
	
	dataSourceLinePlot.dataSource = self;
	[graph addPlot:dataSourceLinePlot];
	
	// Add some data
	plotData = [NSArray array];
}

-(void) addErrorDataAndDisplay:(float_t)eraX :(float_t)errorY {
	NSNumber		*x = [NSNumber numberWithFloat:eraX];
	NSNumber		*y = [NSNumber numberWithFloat:errorY];
	
	NSMutableArray	*newData = [[NSMutableArray alloc] initWithArray:plotData];
	
	[plotData release];
		
	[newData addObject:
	 [NSDictionary dictionaryWithObjectsAndKeys:
	  x, [NSNumber numberWithInt:CPTScatterPlotFieldX],
	  y, [NSNumber numberWithInt:CPTScatterPlotFieldY],
	  nil]];
	
	plotData = newData;
	
	[graph reloadData];
	
	return;
}

-(void) erasePlotData {
	[plotData release];
	
	plotData = [NSArray array];
	
	[graph reloadData];
}

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
	return plotData.count;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum 
			   recordIndex:(NSUInteger)index
{
	NSDecimalNumber *num = [[plotData objectAtIndex:index] 
							objectForKey:[NSNumber numberWithInt:fieldEnum]];
		
	return num;
}

@end
