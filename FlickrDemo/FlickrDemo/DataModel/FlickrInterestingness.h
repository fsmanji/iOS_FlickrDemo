//
//  FlickrInterestingness.h
//  FlickrExplorer
//
//  Created by Cristan Zhang on 10/6/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import <Foundation/Foundation.h>
//
//api link:  https://www.flickr.com/services/api/explore/flickr.interestingness.getList
//

typedef void (^FlickrExploreCompletionBlock)(NSArray *results, NSError *error);
@class Flickr;

@interface FlickrInterestingness : NSObject

@property NSMutableArray* photos; //array of FlickrPhoto


#pragma mark - methods

-(instancetype)initWithFlickr:(Flickr*)flickr;

-(void) loadMoreWithCompletionBlock:(FlickrExploreCompletionBlock)completionBlock;
-(void) refreshWithCompletionBlock:(FlickrExploreCompletionBlock)completionBlock;

@end
