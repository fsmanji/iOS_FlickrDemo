//
//  FlickrPhoto.h
//  Flickr Search
//
//  Created by Brandon Trebitowski on 6/28/12.
//  Copyright (c) 2012 Brandon Trebitowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class FlickrPhotoSize;

@interface FlickrPhoto : NSObject
@property(nonatomic,strong) UIImage *thumbnail;
@property(nonatomic,strong) UIImage *largeImage;

// Lookup info
@property NSString* title;
@property(nonatomic) long long photoID;
@property(nonatomic) NSInteger farm;
@property(nonatomic) NSInteger server;
@property(nonatomic,strong) NSString *secret;

@property FlickrPhotoSize *size;

- (NSString *)flickrPhotoURLForSize:(NSString *) size;

+ (FlickrPhoto *) initWithJson:(NSDictionary *)json;
@end
