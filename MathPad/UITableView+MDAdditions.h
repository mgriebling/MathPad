//********************************************************************************
//
// This source is Copyright (c) 2013 by Solinst Canada.  All rights reserved.
//
//********************************************************************************
/**
 * \file   	UITableView+MDAdditions.h
 * \details Additional helper method for UITableViews.
 * \author  Michael Griebling
 * \date   	15 July 2013
 */
//********************************************************************************

#import <UIKit/UIKit.h>

@interface UITableView (MDAdditions)

- (NSIndexPath *)mdIndexPathForRowContainingView:(UIView *)view;

@end
