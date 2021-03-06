//
//  JustifiedLayout.m
//  FlickrDemo
//
//  Created by Cristan Zhang on 9/22/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import "JustifiedLayout.h"

#define kMaxSpacing 5

#define kMaxHeight 120

#define kMaxCellPerRow 4

@implementation JustifiedLayout

- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *answer = [super layoutAttributesForElementsInRect:rect];
    
    for(int i = 1; i < [answer count]; ++i) {
        UICollectionViewLayoutAttributes *currentLayoutAttributes = answer[i];
        UICollectionViewLayoutAttributes *prevLayoutAttributes = answer[i - 1];

        NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
        if(origin + kMaxSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width
           && currentLayoutAttributes.frame.origin.x > 0) {
            
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = origin + kMaxSpacing;

            frame.origin.y = prevLayoutAttributes.frame.origin.y;
            currentLayoutAttributes.frame = frame;
        }
    }
    return answer;
}

@end
