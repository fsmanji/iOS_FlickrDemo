//
//  Flickr.m
//  Flickr Search
//
//  Created by Brandon Trebitowski on 6/28/12.
//  Copyright (c) 2012 Brandon Trebitowski. All rights reserved.
//

#import "Flickr.h"
#import "FlickrPhoto.h"

#define kFlickrAPIKey @"92d8aa6f87c042c896ae5893a2f51f6b"
#define kFlickrAPISecret @"8d08e88f3c9960de"

@implementation Flickr

+(id)api {
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

- (void)searchFlickrForTerm:(NSString *) term completionBlock:(FlickrSearchCompletionBlock) completionBlock
{
    FKFlickrPhotosSearch * search = [[FKFlickrPhotosSearch alloc] init];
    search.text = term;
    search.sort = @"relevance";
    [_apiKit call:search completion:^(NSDictionary *response, NSError *error) {
        
        if(error){
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(term,nil,error);
            });
        } else {
            NSArray *objPhotos = response[@"photos"][@"photo"];
            NSMutableArray *flickrPhotos = [NSMutableArray array];
            for(NSMutableDictionary *objPhoto in objPhotos)
            {
                FlickrPhoto *photo = [FlickrPhoto initWithJson:objPhoto];
                
                [flickrPhotos addObject:photo];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(term,flickrPhotos,nil);
            });
            
        }
        
    }];
}

+ (void)loadImageForPhoto:(FlickrPhoto *)flickrPhoto thumbnail:(BOOL)thumbnail completionBlock:(FlickrPhotoCompletionBlock) completionBlock
{
    
    NSString *size = thumbnail ? @"m" : @"b";
    
    NSString *photoURL = [flickrPhoto flickrPhotoURLForSize:size];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        NSError *error = nil;
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoURL]
                                                  options:0
                                                    error:&error];
        if(error)
        {
            completionBlock(nil,error);
        }
        else
        {
            UIImage *image = [UIImage imageWithData:imageData];
            if([size isEqualToString:@"m"])
            {
                flickrPhoto.thumbnail = image;
            }
            else
            {
                flickrPhoto.largeImage = image;
            }
            completionBlock(image,nil);
        }
        
    });
}


-(void)exploreWithCompletionBlock:(FlickrExploreCompletionBlock)completionBlock {
    FKFlickrInterestingnessGetList *interesting = [[FKFlickrInterestingnessGetList alloc] init];
    
    [_apiKit call:interesting completion:^(NSDictionary *response, NSError *error) {
        // Note this is not the main thread!
        if(error){
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil,error);
            });
        } else {
            NSArray *objPhotos = response[@"photos"][@"photo"];
            NSMutableArray *flickrPhotos = [NSMutableArray array];
            for(NSMutableDictionary *objPhoto in objPhotos)
            {
                FlickrPhoto *photo = [FlickrPhoto initWithJson:objPhoto];
                
                [flickrPhotos addObject:photo];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(flickrPhotos,nil);
            });
            
        }
        
    }];
    
    
}



@end
