//
//  JustifiedItem.m
//  FlickrDemo
//
//  Created by Cristan Zhang on 9/23/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import "JustifiedItem.h"

@implementation JustifiedItem

+(id) initWithData:(id)photo justifiedSize:(CGSize)size {
    JustifiedItem *item = [[JustifiedItem alloc] init];
    item.photo = photo;
    item.size = size;
    return item;
}

@end
