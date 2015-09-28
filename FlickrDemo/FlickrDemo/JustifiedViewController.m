//
//  JustifiedViewController.m
//  FlickrDemo
//
//  Created by Cristan Zhang on 9/22/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import "JustifiedViewController.h"
#import "FlickrPhoto.h"
#import "FlickrPhotoSize.h"
#import "FlickrCollectionViewCell.h"
#import "JustifiedLayout.h"
#import "StackLayout.h"

#import "JustifiedItem.h"
#import "JustifiedRow.h"

#define MAX_HEIGHT 120
#define kMaxSpacing 5
#define kMaxItemsPerRow 5

@interface JustifiedViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

//this contains justified layout rows, where each row itself has a NSArray of JustifiedItems, so you can treat each row as a section
@property(nonatomic, strong) NSMutableArray *rows;

//this contains array of JustifiedItems, so if your collection has its own sections, you use this to get all items regardless of section.
@property(nonatomic, strong) NSMutableArray *items;

@end

@implementation JustifiedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib * nib = [UINib nibWithNibName:@"FlickrCollectionViewCell" bundle:nil];
    
    [_collectionView registerNib:nib forCellWithReuseIdentifier:@"FlickrCollectionViewCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    _rows = [NSMutableArray array];
    _items = [NSMutableArray array];
    
    if (_layoutType == kLeftAligned) {
        _collectionView.collectionViewLayout = [[JustifiedLayout alloc] init];
        //_collectionView.collectionViewLayout = [[StackLayout alloc] init];
    }
    
    
    self.navigationItem.title = @"Flickr Interestingness";
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
}


-(void)viewDidAppear:(BOOL)animated {
    //when view did appear, the collection view has the correct size.
    //especally on iPAD, the content size returned from viewDidLoad is the portrait mode size,
    //so need to wait util viewDidAppear when screen is rotated to landscope mode.
    
    //or you can only get correct size after reloadData() or you use fixed width.
    
    if (_layoutType == kStrictSpacing) {
        [self justifyCollectionView];
    }
    
    [_collectionView reloadData];
}

-(void)justifyCollectionView {
    
    [self.rows removeAllObjects];
    [self.items removeAllObjects];
    
    __block NSMutableArray *row = [NSMutableArray array];
    
    __block CGFloat maxWidth = _collectionView.contentSize.width;
    
    __block CGFloat x = 0;
    [_photos enumerateObjectsUsingBlock:^(FlickrPhoto* photo, NSUInteger idx, BOOL *stop) {
        
        CGSize size = photo.size.size_m;
        
        JustifiedItem* item = [JustifiedItem initWithData:photo originalSize:size maxHeight:MAX_HEIGHT];
        
        NSLog(@"processing item: %lu", (unsigned long)idx);
        CGFloat currentSize = item.size.width + kMaxSpacing;
        if(x +  currentSize < maxWidth && row.count < kMaxItemsPerRow){
            [row addObject:item];
            x += currentSize;
        } else {
            //add row
            NSLog(@"create row end at: %lu, right = %f, count= %ld", (unsigned long)idx, x, [row count]);
            JustifiedRow* rowObject = [JustifiedRow initWithArray:row endIndex:idx-1];
            [self.rows addObject:rowObject];
            
            //restart row
            [row removeAllObjects];
            [row addObject:item];
            x = currentSize;
        }
        
        if( idx == _photos.count - 1) {
            //add the last row
            NSLog(@"create row end at: %lu, right = %f, count= %ld", (unsigned long)idx, x, [row count]);
            JustifiedRow* rowObject = [JustifiedRow initWithArray:row endIndex:idx-1];
            [self.rows addObject:rowObject];
        }
    }];
    
    //justify the rows
    
    [_rows enumerateObjectsUsingBlock:^(JustifiedRow* rowObject, NSUInteger idx, BOOL *stop) {
        [rowObject justifyItemSizes:maxWidth maxHeight:MAX_HEIGHT minSpace:kMaxSpacing];
        [rowObject.items enumerateObjectsUsingBlock:^(JustifiedItem *item, NSUInteger idx, BOOL *stop) {
            [self.items addObject:item];
        }];
    }];
    
}


- (void)deviceOrientationDidChange:(NSNotification*)note
{
    [_collectionView.collectionViewLayout invalidateLayout];
    
    if (_layoutType == kStrictSpacing) {
        [self justifyCollectionView];
    }
}

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if (_layoutType == kStrictSpacing) {
        return [_items count];
    }
    
    return [_photos count];
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FlickrCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"FlickrCollectionViewCell" forIndexPath:indexPath];
    
    FlickrPhoto *photo;
    
    if (_layoutType == kStrictSpacing) {
        JustifiedItem *item = _items[indexPath.row];
        photo = item.photo;
    } else {
        photo = _photos[indexPath.row];
    }
    
    [cell setPhotoInfo:photo];
    
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
    if (_layoutType == kStrictSpacing) {
        JustifiedItem *item = _items[indexPath.row];
        return item.size;
    } else {
        FlickrPhoto *photo = _photos[indexPath.row];
        
        if (photo.size == nil) {
            return CGSizeMake(100, 100);
        }
        
        CGSize size_m = photo.size.size_m;
        
        if (_layoutType == kFreeSized) {
            return size_m;
        }
        
        return [JustifiedItem resizePhoto:size_m withMaxHeight:MAX_HEIGHT];
        
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kMaxSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kMaxSpacing;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
}

@end
