//
//  FlickrPhoto.m
//  Flickr Search
//
//  Created by Brandon Trebitowski on 6/28/12.
//  Copyright (c) 2012 Brandon Trebitowski. All rights reserved.
//

#import "FlickrPhoto.h"

@implementation FlickrPhoto

- (NSString *)flickrPhotoURLForSize:(NSString *) size
{
    if(!size)
    {
        size = @"m";
    }
    return [NSString stringWithFormat:@"http://farm%ld.staticflickr.com/%ld/%lld_%@_%@.jpg",(long)self.farm,(long)self.server,self.photoID,self.secret,size];
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@", _title];
}

+ (FlickrPhoto *)initWithJson:(NSDictionary *)objPhoto {
    FlickrPhoto *photo = [[FlickrPhoto alloc] init];
    
    photo.title = objPhoto[@"title"];
    photo.farm = [objPhoto[@"farm"] intValue];
    photo.server = [objPhoto[@"server"] intValue];
    photo.secret = objPhoto[@"secret"];
    photo.photoID = [objPhoto[@"id"] longLongValue];
    
    NSError * error;
    NSString *searchURL = [photo flickrPhotoURLForSize:@"m"];
     NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:searchURL]
     options:0
     error:&error];
     UIImage *image = [UIImage imageWithData:imageData];
     photo.thumbnail = image;
    NSLog(@"Downloading photo: %@", photo.title);
    
    return photo;
}

@end
