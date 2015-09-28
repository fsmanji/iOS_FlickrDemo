//
//  Flickr.m
//  Flickr Search
//
//  Created by Brandon Trebitowski on 6/28/12.
//  Copyright (c) 2012 Brandon Trebitowski. All rights reserved.
//

#import "Flickr.h"
#import "FlickrPhoto.h"

#define kFlickrAPIKey @"e94b89904a09519e72a4425f2d05722c"
#define kFlickrAPISecret @"20bd7d2b634f4f35"

//default extras: url_[] will return the photo dimention together with url.
#define kDefaultExtras @"url_m, url_l"
//if need to fetch original photo, append below extras
#define kOriginalPhotoExtras @"url_o, original_format"

#define kSortBy @"relevance"

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
    search.sort = kSortBy;
    search.extras = kDefaultExtras;
    
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


-(void)exploreWithCompletionBlock:(FlickrExploreCompletionBlock)completionBlock {
    FKFlickrInterestingnessGetList *interesting = [[FKFlickrInterestingnessGetList alloc] init];
    interesting.extras = kDefaultExtras;
    
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
