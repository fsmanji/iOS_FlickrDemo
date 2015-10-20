//
//  JustifiedItem.m
//  FlickrDemo
//
//  Created by Cristan Zhang on 9/23/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import "JustifiedItem.h"

@implementation JustifiedItem

+(id) initWithData:(id)photo originalSize:(CGSize)size maxHeight:(CGFloat)maxHeight{
    JustifiedItem *item = [[JustifiedItem alloc] init];
    item.photo = photo;
    item.size = size;
    
    //if max height specified, conforms to it.
    if(maxHeight > 0) {
        [item resizeToHeight:maxHeight];
    }
    return item;
}

+ (CGSize) resizePhoto:(CGSize)size withMaxHeight:(CGFloat)maxHeight{
    if (size.height == maxHeight || maxHeight <= 0) {
        //NSLog(@"Error: max height equals existing height or is 0");
        return size;
    }
    int width = size.width;
    int height = size.height;
    float ratio = (float)width / (float)height;
    size.height = maxHeight;
    size.width = ratio * size.height;
    return size;
}

- (void)resizeToHeight:(CGFloat)height {
    self.size = [JustifiedItem resizePhoto:self.size withMaxHeight:height];
}
@end
