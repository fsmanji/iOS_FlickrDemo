//
//  FlickrPhoto.m
//  Flickr Search
//
//  Created by Brandon Trebitowski on 6/28/12.
//  Copyright (c) 2012 Brandon Trebitowski. All rights reserved.
//

#import "FlickrPhoto.h"
#import "FlickrPhotoSize.h"

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
    
    //parse size info.
    FlickrPhotoSize *size = [[FlickrPhotoSize alloc] init];
    size.url_l = objPhoto[@"url_l"];
    size.url_m = objPhoto[@"url_m"];
    
    size.size_l = CGSizeMake([objPhoto[@"width_l"] integerValue], [objPhoto[@"height_l"] integerValue]);
    size.size_m = CGSizeMake([objPhoto[@"width_m"] integerValue], [objPhoto[@"height_m"] integerValue]);
    if (size.size_l.height <= 0 || size.size_l.width <= 0) {
        ALog(@"Error: photo L size is 0");
    }
    if (size.size_m.height <= 0 || size.size_m.width <= 0) {
        ALog(@"Error: photo M size is 0");
        return nil;
    }
    
    photo.size = size;
    
    ALog(@"Photo: %@ - %@", photo.title, size);
    return photo;
}

@end
