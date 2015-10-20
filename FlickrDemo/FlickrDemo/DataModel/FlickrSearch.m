//
//  FlickrSearch.m
//  FlickrExplorer
//
//  Created by Cristan Zhang on 10/6/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import "FlickrSearch.h"
#import <FlickrKit.h>
#import "Flickr.h"
#import "FlickrPhoto.h"

@interface FlickrSearch ()

@property (nonatomic, weak)Flickr* flickr;

@property NSUInteger total;//total photos;
@property NSUInteger perpage; //perpage
@property NSUInteger pages; //total pages
@property NSUInteger page; //current page index

@end

@implementation FlickrSearch

-(instancetype)initWithFlickr:(Flickr*)flickr {
    self = [super init];
    if (self) {
        self.flickr = flickr;
        
        self.photos = [NSMutableArray array];
        self.perpage = 50;
        self.page = 1;
    }
    
    return self;
}

-(void) startSearch:(NSString *)term completionBlock:(FlickrSearchCompletionBlock) completionBlock {
    _term = term;
    [self getPage:1 WithCompletionBlock:completionBlock];
}

-(void)getPage:(NSUInteger)page WithCompletionBlock:(FlickrSearchCompletionBlock)completionBlock {
    FKFlickrPhotosSearch * search = [[FKFlickrPhotosSearch alloc] init];
    search.text = _term;
    search.sort = kSortBy;
    search.safe_search=@"3";
    search.extras = kDefaultExtras;
    
    search.per_page =  [NSString stringWithFormat:@"%ld",self.perpage];
    search.page = [NSString stringWithFormat:@"%ld",page];
    
    [_flickr.apiKit call:search completion:^(NSDictionary *response, NSError *error) {
        
        if(error){
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(_term,nil,error);
            });
        } else {
            NSArray *objPhotos = response[@"photos"][@"photo"];
            
            self.pages = [response[@"photos"][@"pages"] integerValue];
            self.total = [response[@"photos"][@"total"] integerValue];
            self.page = [response[@"photos"][@"page"] integerValue];
            
            //if this is a refresh operation
            if (self.page == 1 && self.photos.count > 0) {
                [self.photos removeAllObjects];
            }
            NSMutableArray *flickrPhotos = [NSMutableArray array];
            for(NSMutableDictionary *objPhoto in objPhotos)
            {
                FlickrPhoto *photo = [FlickrPhoto initWithJson:objPhoto];
                //if photo is nil, means it doesn't contain valid size info.
                if (photo) {
                    [flickrPhotos addObject:photo];
                }
            }
            
            [self.photos addObjectsFromArray:flickrPhotos];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(_term,flickrPhotos,nil);
            });
            
        }
        
    }];

}

-(void) loadMoreWithCompletionBlock:(FlickrSearchCompletionBlock)completionBlock {
    if (self.page < self.pages) {
        [self getPage:_page+1 WithCompletionBlock:completionBlock];
    } else {
        completionBlock(_term, nil, nil);
    }
}

-(void) refreshWithCompletionBlock:(FlickrSearchCompletionBlock)completionBlock {
     [self getPage:1 WithCompletionBlock:completionBlock];
}

@end
