//
//  Flickr.h
//  Flickr Search
//
//  Created by Brandon Trebitowski on 6/28/12.
//  Copyright (c) 2012 Brandon Trebitowski. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <FlickrKit.h>
#import "FlickrSearch.h"
#import "FlickrInterestingness.h"


//default extras: url_[] will return the photo dimention together with url.
#define kDefaultExtras @"url_m, url_l"
//if need to fetch original photo, append below extras
#define kOriginalPhotoExtras @"url_o, original_format"

#define kSortBy @"relevance"


@class FlickrPhoto;
@class UIImage;
@class FlickrInterestingness;
@class FlickrSearch;

typedef void (^FlickrPhotoCompletionBlock)(UIImage *photoImage, NSError *error);


@interface Flickr : NSObject

@property (nonatomic, weak) FlickrKit* apiKit;

@property FlickrInterestingness* interestingness;
@property FlickrSearch* search;

+ (Flickr *)api;

@end
