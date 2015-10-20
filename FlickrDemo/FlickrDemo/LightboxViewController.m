//
//  LightboxViewController.m
//  FlickrExplorer
//
//  Created by Cristan Zhang on 9/30/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import "LightboxViewController.h"
#import <UIImageView+AFNetworking.h>
#import "FlickrPhotoSize.h"
#import "FlickrPhoto.h"
#import <MWPhoto.h>
#import <MWPhotoBrowser.h>

@interface LightboxViewController () <MWPhotoBrowserDelegate>

@property NSArray *flickrPhotos;
@property NSUInteger currentIndex;

@property NSMutableArray *mwPhotos; //aray of MWPhoto objects

@property BOOL waitToShow;
@property BOOL didShow;
@end

@implementation LightboxViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        _mwPhotos = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];

    if (_waitToShow) {
        [self presentLightbox];
    }

}

-(void)showPhotos:(NSArray *)photos fromPosition:(NSUInteger)index{
    _flickrPhotos = photos;
    _currentIndex = index;
    
    _waitToShow = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [_flickrPhotos enumerateObjectsUsingBlock:^(FlickrPhoto* obj, NSUInteger idx, BOOL *stop) {
            NSString* url = obj.size.url_l != nil? obj.size.url_l : obj.size.url_m;
            MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:url]];
            photo.caption = obj.title;
            [_mwPhotos addObject:photo];
        }];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //present MWPhotoBrowser;
            if (self.isViewLoaded) {
                _waitToShow = NO;
                [self presentLightbox];
            } else {
                _waitToShow = YES;
            }
            
        });
    });
    
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.mwPhotos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.mwPhotos.count) {
        return [self.mwPhotos objectAtIndex:index];
    }
    return nil;
}

-(void)presentLightbox {
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.delegate = self;
    
    // Set options
    browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid = NO; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    browser.autoPlayOnAppear = NO; // Auto-play first video

    
    // Optionally set the current visible photo before displaying
    [browser setCurrentPhotoIndex:_currentIndex];
    
    // Manipulate
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
    
    // Present
    [self.navigationController pushViewController:browser animated:YES];
    
    _didShow = YES;
    
}

-(void)viewWillAppear:(BOOL)animated {
    //remove myself as I'm just a helper view controller.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    NSMutableArray *allVCs = [NSMutableArray arrayWithArray: self.navigationController.viewControllers];
    if (_didShow && [allVCs containsObject:self]) {
        [allVCs removeObject:self];
    }
    self.navigationController.viewControllers = allVCs;
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}


@end
