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

@interface LightboxViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation LightboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   NSURL * urlm = [NSURL URLWithString:self.photo.size.url_l];
   // NSURL * urll = [NSURL URLWithString:self.photo.size.url_l];
    [self.imageView setImageWithURL:urlm];
    //[self.imageView setImageWithURL:urll];
}
- (IBAction)onTapGesture:(UITapGestureRecognizer *)sender {
}
- (IBAction)onSwipeGesture:(UISwipeGestureRecognizer *)sender {
}
- (IBAction)onPinchGesture:(UIPinchGestureRecognizer *)sender {
}
- (IBAction)onRotationGesture:(id)sender {
}

- (IBAction)onPanGesture:(UIPanGestureRecognizer *)sender {
}

-(void)updatePhoto:(FlickrPhoto *)photo {
    _photo = photo;
    if ([self isViewLoaded]) {
        NSURL * url = [NSURL URLWithString:self.photo.size.url_l];
        [self.imageView setImageWithURL:url];
    }
    
}


@end
