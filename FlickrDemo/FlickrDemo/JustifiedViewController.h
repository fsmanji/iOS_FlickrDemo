//
//  JustifiedViewController.h
//  FlickrDemo
//
//  Created by Cristan Zhang on 9/22/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, JustifiedType) {
    kStrictSpacing,
    kLeftAligned,
    kStretchSpaces,
    kFreeSized
};

typedef NS_ENUM(NSUInteger, PhotoSource) {
    kExplore,
    kSearch
};


@protocol JustifiedViewLoadMoreDelegate <NSObject>

-(void)onLoadMore:(PhotoSource)source;
-(void)onRefresh:(PhotoSource)source;

@end

@interface JustifiedViewController : UIViewController

@property(nonatomic, strong) NSArray *photos;
@property JustifiedType layoutType;
@property PhotoSource photoSource;
@property id<JustifiedViewLoadMoreDelegate> delegate;

-(void)updatePhotos:(NSArray *)newPhotos resetState:(BOOL)reset;
-(void)updateJustifiedType:(JustifiedType)layoutType;

@end
