//
//  FlickrCollectionViewCell.m
//  FlickrDemo
//
//  Created by Cristan Zhang on 9/22/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import "FlickrCollectionViewCell.h"
#import "FlickrPhoto.h"
#import <UIImageView+AFNetworking.h>

@implementation FlickrCollectionViewCell

/**
 *
 * You must call registerNib:nib to regist, don't use registerClass, otherwise you always get empty view
 *
 * [_collectionView registerNib:nib forCellWithReuseIdentifier:@"FlickrCollectionViewCell"];
 *
 */


-(void)setPhotoInfo:(FlickrPhoto *)photo {
    
    _photo = photo;
    NSString * url = [photo flickrPhotoURLForSize:@"m"];
    //[_imageView setImageWithURL:[NSURL URLWithString:url]];
    _imageView.image = photo.thumbnail;
}

- (id)initWithFrame:(CGRect)aRect
{
    if ((self = [super initWithFrame:aRect])) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)coder
{
    if ((self = [super initWithCoder:coder])) {
        [self commonInit];
    }
    return self;
}

-(void)commonInit {
    NSString * url = [_photo flickrPhotoURLForSize:@"m"];
    //[_imageView setImageWithURL:[NSURL URLWithString:url]];
    _imageView.image = _photo.thumbnail;
}

@end
