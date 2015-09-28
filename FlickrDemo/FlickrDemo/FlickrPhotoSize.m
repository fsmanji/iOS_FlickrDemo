//
//  FlickrPhotoSize.m
//  FlickrExplorer
//
//  Created by Cristan Zhang on 9/28/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import "FlickrPhotoSize.h"

@implementation FlickrPhotoSize
-(NSString *)description {
    return [NSString stringWithFormat:@"Size_m: width_m = %f, height_m = %f", _size_m.width, _size_m.height ];
}
@end
