//
//  JustifiedViewController.m
//  FlickrDemo
//
//  Created by Cristan Zhang on 9/22/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import "JustifiedViewController.h"
#import "FlickrPhoto.h"
#import "FlickrCollectionViewCell.h"
#import "JustifiedLayout.h"
#import "StackLayout.h"

#import "JustifiedItem.h"
#import "JustifiedRow.h"

#define MAX_HEIGHT 120
#define kMaxSpacing 5

@interface JustifiedViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *rows;

@end

@implementation JustifiedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib * nib = [UINib nibWithNibName:@"FlickrCollectionViewCell" bundle:nil];
    
    [_collectionView registerNib:nib forCellWithReuseIdentifier:@"FlickrCollectionViewCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    _rows = [NSMutableArray array];
    
    
    //_collectionView.collectionViewLayout = [[JustifiedLayout alloc] init];
    //_collectionView.collectionViewLayout = [[StackLayout alloc] init];

    self.navigationItem.title = @"Flickr Interestingness";
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
}


-(void)viewDidAppear:(BOOL)animated {
    //when view did appear, the collection view has the correct size.
    //especally on iPAD, the content size returned from viewDidLoad is the portrait mode size,
    //so need to wait util viewDidAppear when screen is rotated to landscope mode.
    
    //or you can only get correct size after reloadData() or you use fixed width.
    
    [self justifyCollectionView];
}

-(void)justifyCollectionView {
    
    [self.rows removeAllObjects];
    
    NSArray * photos = _searchResults[_searches[0]];
    
    __block NSMutableArray *row = [NSMutableArray array];
    
    __block CGFloat maxWidth = _collectionView.contentSize.width;
    
    __block CGFloat x = 0;
    [photos enumerateObjectsUsingBlock:^(FlickrPhoto* photo, NSUInteger idx, BOOL *stop) {
        
        CGSize size = photo.thumbnail.size;
        CGSize newSize = [self adjustify:size];
        JustifiedItem* item = [JustifiedItem initWithData:photo justifiedSize:newSize];
        NSLog(@"processing item: %lu", (unsigned long)idx);
        CGFloat currentSize = newSize.width + kMaxSpacing;
        if(x +  currentSize < maxWidth){
            [row addObject:item];
            x += currentSize;
        } else {
            //add row
            NSLog(@"create row end at: %lu, right = %f, count= %ld", (unsigned long)idx, x, [row count]);
            JustifiedRow* rowObject = [JustifiedRow initWithArray:row endIndex:idx-1];
            [rowObject justifyItemSizes:maxWidth minimalSpace:kMaxSpacing];
            [self.rows addObject:rowObject];
            
            
            //restart row
            [row removeAllObjects];
            [row addObject:item];
            x = currentSize;
        }
    }];
    
    
    
    [_collectionView reloadData];
}


- (void)deviceOrientationDidChange:(NSNotification*)note
{
    [_collectionView.collectionViewLayout invalidateLayout];
    [self justifyCollectionView];
}

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    //NSString *searchTerm = self.searches[section];
    JustifiedRow * row = self.rows[section];
    return [row.items count];
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return [self.rows count];
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FlickrCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"FlickrCollectionViewCell" forIndexPath:indexPath];
    JustifiedRow * row = self.rows[indexPath.section];
    JustifiedItem *item = row.items[indexPath.row];
    [cell setPhotoInfo:item.photo];
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
    
    JustifiedRow * row = self.rows[indexPath.section];
    JustifiedItem *item = row.items[indexPath.row];
    return item.size;
    
}

//Begin: ensure there is 2.0 spacing between cells
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
}

//End: ensure there is 2.0 spacing between cells

-(CGSize) adjustify:(CGSize)size {
    int width = size.width;
    int height = size.height;
    float ratio = (float)width / (float)height;
    size.height = MAX_HEIGHT;
    size.width = ratio * size.height;
    return size;
}

@end
