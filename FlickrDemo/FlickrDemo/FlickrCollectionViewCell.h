//
//  FlickrCollectionViewCell.h
//  FlickrDemo
//
//  Created by Cristan Zhang on 9/22/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FlickrPhoto;

@interface FlickrCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@property FlickrPhoto *photo;

-(void)setPhotoInfo:(FlickrPhoto *)photo;

@end
