//
//  WildClickButton.m
//  HyperBidDemo
//
//  Created by HyperBid Tech Support on 2025/1/7.
//

#import "WildClickButton.h"

@implementation WildClickButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event {
    CGRect bounds = self.bounds;
 
    CGFloat widthDelta = MAX(26, 0);
    CGFloat heightDelta = MAX(26, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}

@end
