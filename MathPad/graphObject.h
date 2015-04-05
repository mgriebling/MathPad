//
//  graphObject.h
//  MathPad
//
//  Created by Michael Griebling on 2Apr2015.
//  Copyright (c) 2015 Computer Inspirations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"

@interface graphObject : NSObject<CPTLegendDelegate>

@property (nonatomic, readwrite, strong) NSString *title;
@property (nonatomic, readonly) CGFloat titleSize;
@property (nonatomic, readwrite, strong) NSMutableArray *graphs;
@property (nonatomic, readwrite, strong) NSMutableSet *dataSources;

-(void)renderInGraphHostingView:(CPTGraphHostingView *)hostingView withTheme:(CPTTheme *)theme animated:(BOOL)animated;
-(void)killGraph;
-(void)reloadData;

@end
