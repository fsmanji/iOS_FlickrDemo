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
    JustifiedRow * row = [[JustifiedRow alloc]init];
    row.items = [items copy];
    row.rangeStart = end - [items count];
    row.rangeEnd = end;
    
    return row;
}

-(void) justifyItemSizes:(CGFloat)maxWidth minimalSpace:(CGFloat)minimalSpace{
    if ([self.items count] > 0) {
        
        __block CGFloat currentWidth = 0;
        __block CGFloat ratio = 0;
        //calculate the current item width;
        [self.items enumerateObjectsUsingBlock:^(JustifiedItem* item, NSUInteger idx, BOOL *stop) {
            
            currentWidth += item.size.width;
        }];
        
        CGFloat finalWidth = minimalSpace * ([self.items count] -1) + currentWidth;
        
        //get the ratio to increase
        if (finalWidth < maxWidth ) {
           
            ratio = maxWidth / finalWidth;
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
