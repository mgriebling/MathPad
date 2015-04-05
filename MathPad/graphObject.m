//
//  graphObject.m
//  MathPad
//
//  Created by Michael Griebling on 2Apr2015.
//  Copyright (c) 2015 Computer Inspirations. All rights reserved.
//

#import "graphObject.h"
#import "PiNumberFormatter.h"

@implementation graphObject

@dynamic titleSize;

- (CGFloat)titleSize {
	CGFloat size;
	
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
	switch ( UI_USER_INTERFACE_IDIOM() ) {
		case UIUserInterfaceIdiomPad:
			size = 24.0;
			break;
			
		case UIUserInterfaceIdiomPhone:
			size = 16.0;
			break;
			
		default:
			size = 12.0;
			break;
	}
#else
	size = 24.0;
#endif
	
	return size;
}

- (id)init {
	if ((self = [super init])) {
		self.title   = @"Math Function Plot";
		self.graphs = [[NSMutableArray alloc] init];
		self.dataSources = [[NSMutableSet alloc] init];
	}
	return self;
}

-(void)killGraph {
	[[CPTAnimation sharedInstance] removeAllAnimationOperations];
	[self.graphs removeAllObjects];
	[self.dataSources removeAllObjects];
}

-(void)reloadData {
	for (CPTGraph *graph in self.graphs) {
		[graph reloadData];
	}
}

-(void)dealloc {
	[self killGraph];
}

-(void)renderInGraphHostingView:(CPTGraphHostingView *)hostingView withTheme:(CPTTheme *)theme animated:(BOOL)animated
{
	CGRect bounds = hostingView.bounds;
	
	CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:bounds];
	if (hostingView) {
		[self.graphs addObject:graph];
		hostingView.hostedGraph = graph;
	}
//	[self applyTheme:theme toGraph:graph withDefault:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
	
	graph.plotAreaFrame.paddingLeft += self.titleSize * CPTFloat(2.25);
	
	// Setup scatter plot space
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
	plotSpace.allowsUserInteraction = YES;
	plotSpace.xRange                = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0.0) length:CPTDecimalFromDouble(2.0 * M_PI)];
	plotSpace.yRange                = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(-1.1) length:CPTDecimalFromDouble(2.2)];
	
	// Grid line styles
	CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
	majorGridLineStyle.lineWidth = 0.75;
	majorGridLineStyle.lineColor = [[CPTColor colorWithGenericGray:CPTFloat(0.2)] colorWithAlphaComponent:CPTFloat(0.75)];
	
	CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
	minorGridLineStyle.lineWidth = 0.25;
	minorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:CPTFloat(0.1)];
	
	// Axes
	PiNumberFormatter *formatter = [[PiNumberFormatter alloc] init];
	formatter.multiplier = @4;
	
	// Label x axis with a fixed interval policy
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
	CPTXYAxis *x          = axisSet.xAxis;
	x.majorIntervalLength   = CPTDecimalFromDouble(M_PI_4);
	x.minorTicksPerInterval = 3;
	x.labelFormatter        = formatter;
	x.majorGridLineStyle    = majorGridLineStyle;
	x.minorGridLineStyle    = minorGridLineStyle;
	x.axisConstraints       = [CPTConstraints constraintWithRelativeOffset:0.5];
	
	x.title       = @"X Axis";
	x.titleOffset = self.titleSize * CPTFloat(1.25);
	
	// Label y with an automatic label policy.
	CPTXYAxis *y = axisSet.yAxis;
	y.labelingPolicy              = CPTAxisLabelingPolicyAutomatic;
	y.minorTicksPerInterval       = 4;
	y.preferredNumberOfMajorTicks = 8;
	y.majorGridLineStyle          = majorGridLineStyle;
	y.minorGridLineStyle          = minorGridLineStyle;
	y.labelOffset                 = 2.0;
	y.axisConstraints             = [CPTConstraints constraintWithLowerOffset:0.0];
	
	y.title       = @"Y Axis";
	y.titleOffset = self.titleSize * CPTFloat(1.25);
	
	// Create some function plots
	for ( NSUInteger plotNum = 0; plotNum <= 2; plotNum++ ) {
		NSString *titleString          = nil;
		CPTDataSourceFunction function = NULL;
		CPTDataSourceBlock block       = nil;
		CPTColor *lineColor            = nil;
		
		switch ( plotNum ) {
			case 0:
				titleString = @"y = sin(x)";
				function    = &sin;
				lineColor   = [CPTColor redColor];
				break;
				
			case 1:
				titleString = @"y = cos(x)";
				block       = ^(double xVal) {
					return cos(xVal);
				};
				lineColor = [CPTColor greenColor];
				break;
				
			case 2:
				titleString = @"y = tan(x)";
				function    = &tan;
				lineColor   = [CPTColor blueColor];
				break;
		}
		
		CPTScatterPlot *linePlot = [[CPTScatterPlot alloc] init];
		linePlot.identifier = [NSString stringWithFormat:@"Function Plot %lu", (unsigned long)(plotNum + 1)];
		
		NSDictionary *textAttributes = x.titleTextStyle.attributes;
		
		NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:titleString
																				  attributes:textAttributes];
		
		if ( &NSFontAttributeName != NULL ) {
			UIFont *italicFont = [UIFont italicSystemFontOfSize:self.titleSize * CPTFloat(0.5)];
			
			[title addAttribute:NSFontAttributeName
						  value:italicFont
						  range:NSMakeRange(0, 1)];
			[title addAttribute:NSFontAttributeName
						  value:italicFont
						  range:NSMakeRange(8, 1)];
			
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
			UIFont *labelFont = [UIFont fontWithName:@"Helvetica" size:self.titleSize * CPTFloat(0.5)];
#else
			NSFont *labelFont = [NSFont fontWithName:@"Helvetica" size:self.titleSize * CPTFloat(0.5)];
#endif
			[title addAttribute:NSFontAttributeName
						  value:labelFont
						  range:NSMakeRange(0, title.length)];
		}
		linePlot.attributedTitle = title;
		
		CPTMutableLineStyle *lineStyle = [linePlot.dataLineStyle mutableCopy];
		lineStyle.lineWidth    = 3.0;
		lineStyle.lineColor    = lineColor;
		linePlot.dataLineStyle = lineStyle;
		
		linePlot.alignsPointsToPixels = NO;
		
		CPTFunctionDataSource *plotDataSource = nil;
		
		if ( function ) {
			plotDataSource = [CPTFunctionDataSource dataSourceForPlot:linePlot withFunction:function];
		}
		else {
			plotDataSource = [CPTFunctionDataSource dataSourceForPlot:linePlot withBlock:block];
		}
		
		plotDataSource.resolution = 2.0;
		
		[self.dataSources addObject:plotDataSource];
		
		[graph addPlot:linePlot];
	}
	
	// Restrict y range to a global range
	CPTPlotRange *globalYRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(-2.5)
															  length:CPTDecimalFromDouble(5.0)];
	plotSpace.globalYRange = globalYRange;
	
	// Add legend
	graph.legend                 = [CPTLegend legendWithGraph:graph];
	graph.legend.fill            = [CPTFill fillWithColor:[CPTColor darkGrayColor]];
	graph.legend.borderLineStyle = x.axisLineStyle;
	graph.legend.cornerRadius    = 5.0;
	graph.legend.numberOfRows    = 1;
	graph.legend.delegate        = self;
	graph.legendAnchor           = CPTRectAnchorBottom;
	graph.legendDisplacement     = CGPointMake( 0.0, self.titleSize * CPTFloat(1.25) );
}


@end
