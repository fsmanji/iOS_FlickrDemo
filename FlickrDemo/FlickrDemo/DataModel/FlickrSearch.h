//
//  FlickrSearch.h
//  FlickrExplorer
//
//  Created by Cristan Zhang on 10/6/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FlickrSearchCompletionBlock)(NSString *searchTerm, NSArray *results, NSError *error);

@class Flickr;

@interface FlickrSearch : NSObject
@property NSMutableArray* photos; //array of FlickrPhoto
@property NSString *term;

#pragma mark constructor
-(instancetype)initWithFlickr:(Flickr*)flickr;

#pragma mark search utility methods
-(void) startSearch:(NSString *)term completionBlock:(FlickrSearchCompletionBlock) completionBlock;
-(void) loadMoreWithCompletionBlock:(FlickrSearchCompletionBlock)completionBlock;
-(void) refreshWithCompletionBlock:(FlickrSearchCompletionBlock)completionBlock;

@end
