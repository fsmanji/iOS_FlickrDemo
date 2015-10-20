//
//  FlickrInterestingness.m
//  FlickrExplorer
//
//  Created by Cristan Zhang on 10/6/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import "FlickrInterestingness.h"
#import "Flickr.h"
#import "FlickrPhoto.h"

@interface FlickrInterestingness ()

@property (nonatomic, weak)Flickr* flickr;

@property NSUInteger total;//total photos;
@property NSUInteger perpage; //perpage
@property NSUInteger pages; //total pages
@property NSUInteger page; //current page index

@end

@implementation FlickrInterestingness

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

-(void)getPage:(NSUInteger)page WithCompletionBlock:(FlickrExploreCompletionBlock)completionBlock {
    FKFlickrInterestingnessGetList *interesting = [[FKFlickrInterestingnessGetList alloc] init];
    interesting.extras = kDefaultExtras;
    interesting.per_page =  [NSString stringWithFormat:@"%ld",self.perpage];
    interesting.page = [NSString stringWithFormat:@"%ld",page];
    
    [_flickr.apiKit call:interesting completion:^(NSDictionary *response, NSError *error) {
        // Note this is not the main thread!
        if(error){
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil,error);
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
                completionBlock(flickrPhotos,nil);
            });
        }
        
    }];
    
}

-(void)loadMoreWithCompletionBlock:(FlickrExploreCompletionBlock)completionBlock {
    if (self.page < self.pages) {
        [self getPage:_page+1 WithCompletionBlock:completionBlock];
    } else {
        completionBlock(nil, nil);
    }
}

-(void)refreshWithCompletionBlock:(FlickrExploreCompletionBlock)completionBlock {
    [self getPage:1 WithCompletionBlock:completionBlock];
}


@end
