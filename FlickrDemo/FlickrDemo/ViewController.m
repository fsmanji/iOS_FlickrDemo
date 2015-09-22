//
//  ViewController.m
//  FlickrDemo
//
//  Created by Cristan Zhang on 9/21/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import "ViewController.h"
#import "Flickr.h"
#import "FlickrPhoto.h"
#import "FlickrCollectionViewCell.h"

#define MAX_HEIGHT 80

@interface ViewController () <UISearchBarDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet UIView *rootView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@property(nonatomic, strong) NSMutableDictionary *searchResults;
@property(nonatomic, strong) NSMutableArray *searches;
@property(nonatomic, strong) Flickr *flickr;


@end


@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self styleViews];
    
    _searchResults = [NSMutableDictionary dictionary];
    _searches = [NSMutableArray array];
    _flickr = [Flickr api];
    [_searchBar setDelegate:self];
    
    UINib * nib = [UINib nibWithNibName:@"FlickrCollectionViewCell" bundle:nil];
    //[self.collectionView registerClass:[FlickrCollectionViewCell class] forCellWithReuseIdentifier:@"FlickrCollectionViewCell"];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:@"FlickrCollectionViewCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
}

- (void)styleViews {
    [super didReceiveMemoryWarning];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_cork.png"]];
    
    UIImage *navBarImage = [[UIImage imageNamed:@"navbar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(27, 27, 27, 27)];
    [self.toolBar setBackgroundImage:navBarImage forToolbarPosition:UIToolbarPositionAny
                          barMetrics:UIBarMetricsDefault];
    
    UIImage *shareButtonImage = [[UIImage imageNamed:@"button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    [self.shareButton setBackgroundImage:shareButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIImage *textFieldImage = [[UIImage imageNamed:@"search_field.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.searchBar setBackgroundImage:textFieldImage];
    _collectionView.backgroundColor = [UIColor clearColor];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [_searchBar endEditing:YES];
    [_searchBar resignFirstResponder];
    
    NSString * query = searchBar.text;
    if (query && query.length > 0) {

        [_flickr searchFlickrForTerm:query completionBlock:^(NSString *searchTerm, NSArray *results, NSError *error) {
            if(results && [results count] > 0) {
            // 2
            if(![self.searches containsObject:searchTerm]) {
                NSLog(@"Found %ld photos matching %@", [results count],searchTerm);
                [self.searches insertObject:searchTerm atIndex:0];
                self.searchResults[searchTerm] = results;
            }
            // 3
            dispatch_async(dispatch_get_main_queue(), ^{
                [_collectionView reloadData];
            });
        } else { // 1
            NSLog(@"Error searching Flickr: %@", error.localizedDescription);
        }
        }];
    } else {
        
        [_flickr exploreWithCompletionBlock:^(NSArray *results, NSError *error) {
            if(results && [results count] > 0) {
                NSString * searchTerm = @"explore";
                if(![self.searches containsObject:searchTerm]) {
                    NSLog(@"Found %ld photos matching %@", [results count],searchTerm);
                    [self.searches insertObject:searchTerm atIndex:0];
                    self.searchResults[searchTerm] = results;
                }

                dispatch_async(dispatch_get_main_queue(), ^{
                    [_collectionView reloadData];
                });
            } else {
                NSLog(@"Error searching Flickr: %@", error.localizedDescription);
            }
        }];
    }
}

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    NSString *searchTerm = self.searches[section];
    return [self.searchResults[searchTerm] count];
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return [self.searches count];
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FlickrCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"FlickrCollectionViewCell" forIndexPath:indexPath];
    NSString *searchTerm = self.searches[indexPath.section];
    [cell setPhotoInfo:self.searchResults[searchTerm][indexPath.row]];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;

}
// 4
/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

#pragma mark – UICollectionViewDelegateFlowLayout

// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *searchTerm = self.searches[indexPath.section];
    FlickrPhoto *photo =
    self.searchResults[searchTerm][indexPath.row];
    // 2
    CGSize retval = photo.thumbnail.size.width > 0 ? photo.thumbnail.size : CGSizeMake(100, 100);
    
    return [self adjustify:retval];
}

// 3
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(50, 20, 50, 20);
}

-(CGSize) adjustify:(CGSize)size {
    int width = size.width;
    int height = size.height;
    float ratio = (float)width / (float)height;
    size.height = MAX_HEIGHT;
    size.width = ratio * size.height;
    return size;
}


@end
