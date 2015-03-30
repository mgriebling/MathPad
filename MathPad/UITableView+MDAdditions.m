//********************************************************************************
//
// This source is Copyright (c) 2013 by Solinst Canada.  All rights reserved.
//
//********************************************************************************
/**
 * \file   	UITableView+MDAdditions.m
 * \details Additional helper method for UITableViews.
 * \author  Michael Griebling
 * \date   	15 July 2013
 */
//********************************************************************************

#import "UITableView+MDAdditions.h"

@implementation UITableView (MDAdditions)

//********************************************************************************
/**
 * \details Helper method for UITableViews to return the index path for the
 *          table cell which contains the \e view.
 * \author  Michael Griebling
 * \date   	15 July 2013
 */
//********************************************************************************
- (NSIndexPath *)mdIndexPathForRowContainingView:(UIView *)view {
    CGPoint correctedPoint = [view convertPoint:view.bounds.origin toView:self];
    return [self indexPathForRowAtPoint:correctedPoint];
}

@end
