//
//  Flickr.m
//  Flickr Search
//
//  Created by Brandon Trebitowski on 6/28/12.
//  Copyright (c) 2012 Brandon Trebitowski. All rights reserved.
//

#import "Flickr.h"
#import "FlickrPhoto.h"
#import "FlickrInterestingness.h"
#import "FlickrSearch.h"

#define kFlickrAPIKey @"e94b89904a09519e72a4425f2d05722c"
#define kFlickrAPISecret @"20bd7d2b634f4f35"

@implementation Flickr

+(Flickr *)api {
    static Flickr *api = nil;
    @synchronized(self) {
        if (api == nil) {
            api = [[self alloc] init];
            [[FlickrKit sharedFlickrKit] initializeWithAPIKey:kFlickrAPIKey sharedSecret:kFlickrAPISecret];
            api.apiKit = [FlickrKit sharedFlickrKit];
        }
    }
    return api;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        self.interestingness = [[FlickrInterestingness alloc] initWithFlickr:self];
        self.search = [[FlickrSearch alloc] initWithFlickr:self];
    }
    return self;
}

@end
