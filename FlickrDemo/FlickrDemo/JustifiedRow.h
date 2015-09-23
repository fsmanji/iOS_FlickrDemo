//
//  JustifiedRowInfo.h
//  FlickrDemo
//
//  Created by Cristan Zhang on 9/23/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JustifiedRow : NSObject

@property(nonatomic, strong) NSMutableArray *items;

//index of the first and last item in this row.
@property NSUInteger rangeStart;
@property NSUInteger rangeEnd;

+(id) initWithArray:(NSArray *)items endIndex:(NSUInteger)end;

-(void) justifyItemSizes:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight minSpace:(CGFloat)minSpace;

@end
