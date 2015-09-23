//
//  JustifiedItem.h
//  FlickrDemo
//
//  Created by Cristan Zhang on 9/23/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JustifiedItem : NSObject

@property CGSize size;
@property id photo;

+(id) initWithData:(id)photo originalSize:(CGSize)size maxHeight:(CGFloat)maxHeight;

+(CGSize) resizePhoto:(CGSize)size withMaxHeight:(CGFloat)maxHeight;

- (void)resizeToHeight:(CGFloat)height;

@end
