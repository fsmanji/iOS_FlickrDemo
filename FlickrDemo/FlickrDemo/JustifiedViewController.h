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

@interface JustifiedViewController : UIViewController

@property(nonatomic, strong) NSArray *photos;
@property JustifiedType layoutType;


-(void)updatePhotos:(NSArray *)newPhotos;
-(void)updateJustifiedType:(JustifiedType)layoutType;

@end
