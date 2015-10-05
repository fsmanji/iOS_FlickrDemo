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
#import "FlickrPhotoSize.h"

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
    //NSString * url = [photo flickrPhotoURLForSize:@"m"];
    [_imageView setImageWithURL:[NSURL URLWithString:photo.size.url_m] placeholderImage:[UIImage imageNamed:@"bg_cork"]];

}


@end
