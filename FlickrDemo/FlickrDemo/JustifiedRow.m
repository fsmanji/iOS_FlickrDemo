//
//  JustifiedRowInfo.m
//  FlickrDemo
//
//  Created by Cristan Zhang on 9/23/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import "JustifiedRow.h"
#import "JustifiedItem.h"



@implementation JustifiedRow

+(id) initWithArray:(NSArray *)items endIndex:(NSUInteger)end {
    if (items && items.count > 0 && [items[0] isKindOfClass:[JustifiedItem class]]) {
        JustifiedRow * row = [[JustifiedRow alloc]init];
        row.items = [items copy];
        row.rangeStart = end - [items count];
        row.rangeEnd = end;
        
        return row;
    }
    NSLog(@"JustifiedRow init failed: row item is empty or its content is not of type JustifiedItem.");
    return nil;
}

-(void) justifyItemSizes:(CGFloat)maxWidth  maxHeight:(CGFloat)maxHeight minSpace:(CGFloat)minSpace{
    if ([self.items count] > 0) {
        
        __block CGFloat currentWidth = 0;
        __block CGFloat ratio = 0;
        //calculate the current item width;
        [self.items enumerateObjectsUsingBlock:^(JustifiedItem* item, NSUInteger idx, BOOL *stop) {
            //resize to same height;
            [item resizeToHeight:maxHeight];
            
            //advance the total width
            currentWidth += item.size.width;
        }];
        
        CGFloat finalWidth = minSpace * ([self.items count] -1) + currentWidth;
        
        //get the ratio. If finalWidth is far from filling width, don't stretch them, that
        //usually is the last row.
        if (finalWidth < maxWidth && finalWidth > maxWidth*0.7f) {
            ratio = maxWidth / finalWidth;
        } else {
            ratio = 1.0f;
        }
        
        //multiply each item's width and height with the same ratio
        [self.items enumerateObjectsUsingBlock:^(JustifiedItem* item, NSUInteger idx, BOOL *stop) {
            CGSize size = item.size;
            size.height *= ratio;
            size.width *= ratio;
            
            item.size = size;
        }];
    }
}

@end
