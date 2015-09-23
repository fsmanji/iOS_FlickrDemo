//
//  StackLayout.m
//  FlickrDemo
//
//  Created by Cristan Zhang on 9/22/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import "StackLayout.h"

#define kMaxSpacing 5

#define kMaxHeight 120

#define kMaxCellPerRow 4

@interface StackLayout ()
@property CGFloat startX;
@property CGFloat lastX;
@property CGFloat lastY;
@end

@implementation StackLayout


- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *answer = [super layoutAttributesForElementsInRect:rect];
    NSLog(@"----Rect----: x=%f, y=%f", rect.origin.x, rect.origin.y);
    
    BOOL shouldContinuePreviousRect = NO;
    
    for(int i = 0; i+3 < [answer count]; i+=3) {
        UICollectionViewLayoutAttributes *currentLayoutAttributes = answer[i];
        UICollectionViewLayoutAttributes *nextUp = answer[i + 1];
        UICollectionViewLayoutAttributes *nextBottom = answer[i + 2];
        
        CGRect frame = currentLayoutAttributes.frame;
        if(i==0){
            if(_lastY < 1) {
                _startX = frame.origin.x;
                _lastX = _startX;
                _lastY = frame.origin.y;
                NSLog(@"== NewLine ==: x=%f, y=%f", frame.origin.x, frame.origin.y);

            } else {
                //******* A new Rect has started *******
                //**** we need to connect this rect with the previous one edge by edge ****
               
                shouldContinuePreviousRect = YES;
                NSLog(@"== Continue ==: lastX=%f, lastY=%f", _lastX, _lastY);
            }
        }
        
        if(i > 0 || shouldContinuePreviousRect) {
            
            if (_lastX + (frame.size.width + kMaxSpacing)*2 > self.collectionViewContentSize.width) {
                frame.origin.x = _startX;
                //-- new line needed ----
                frame.origin.y = _lastY + kMaxSpacing + frame.size.height;
                 NSLog(@"== NewLine ==: x=%f, y=%f", frame.origin.x, frame.origin.y);
            } else {
                frame.origin.x = _lastX + kMaxSpacing;
                frame.origin.y = _lastY;
                
                NSLog(@"Cell: x=%f, y=%f", frame.origin.x, frame.origin.y);

            }
            
        }
        
        currentLayoutAttributes.frame = frame;
        
        CGFloat left = CGRectGetMaxX(currentLayoutAttributes.frame);
        CGFloat top = frame.origin.y;
        _lastY = top;
        
        
        CGFloat height = frame.size.height;
        CGFloat width = frame.size.width;
        
        CGRect frame2 = nextUp.frame;
        CGRect frame3 = nextBottom.frame;
        frame2.origin.x = left + kMaxSpacing;
        frame3.origin.x = left + kMaxSpacing;
        
        
        frame2.size.height = height /2 -kMaxSpacing/2;
        frame3.size.height = height /2 -kMaxSpacing/2;
        
        frame2.size.width = width;
        frame3.size.width = width;
        
        frame2.origin.y = frame.origin.y;
        frame3.origin.y = CGRectGetMaxY(frame2) + kMaxSpacing ;
        
        nextUp.frame = frame2;
        nextBottom.frame = frame3;
        
        //update lastX
        _lastX = frame2.origin.x + frame2.size.width;


    }
    return answer;
}

@end
