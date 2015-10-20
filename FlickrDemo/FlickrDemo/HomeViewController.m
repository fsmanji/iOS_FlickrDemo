//
//  HomeViewController.m
//  FlickrExplorer
//
//  Created by Cristan Zhang on 9/28/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import "HomeViewController.h"
#import "JustifiedViewController.h"
#import "UIAlertView+FSMANJI.h"
#import "MBProgressHUD.h"
#import "Flickr.h"
#import "FlickrInterestingness.h"

#define kExploreTag @"explore"

@interface HomeViewController () <UISearchBarDelegate, JustifiedViewLoadMoreDelegate>
@property UISearchBar *searchBar;
@property UIView* searchBarContainer;

@property(nonatomic, strong) Flickr *flickr;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self styleNavigationBar];

    _flickr = [Flickr api];
    
    [self showExplorePhotos:nil];
}

- (void)styleNavigationBar {
    //1. color the navigation bar: this uses
    UIColor * const navBarBgColor = [UIColor colorWithRed:89/255.0f green:174/255.0f blue:235/255.0f alpha:1.0f];
    
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    //ios 7+
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        self.navigationController.navigationBar.barTintColor = navBarBgColor;
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }else{
        //ios 6 and older
        self.navigationController.navigationBar.tintColor = navBarBgColor;
    }
    
    
    //3. add left buttons
    
    UIBarButtonItem* searchButton = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(onSearchClicked:)];
    UIBarButtonItem* exploreButton = [[UIBarButtonItem alloc] initWithTitle:@"Explore" style:UIBarButtonItemStylePlain target:self action:@selector(onExploreClicked:)];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:searchButton, exploreButton, nil];
    
    //4. add right buttons;
    UIBarButtonItem* justifiedLayout1 = [[UIBarButtonItem alloc] initWithTitle:@"JustifiedLayout" style:UIBarButtonItemStylePlain target:self action:@selector(onJustified1Clicked:)];
    
    UIBarButtonItem* justifiedLayout2 = [[UIBarButtonItem alloc] initWithTitle:@"LeftAligned" style:UIBarButtonItemStylePlain target:self action:@selector(onJustified2Clicked:)];
    UIBarButtonItem* justifiedLayout3 = [[UIBarButtonItem alloc] initWithTitle:@"StretchSpace" style:UIBarButtonItemStylePlain target:self action:@selector(onJustified3Clicked:)];
    UIBarButtonItem* justifiedLayout4 = [[UIBarButtonItem alloc] initWithTitle:@"DefaultStyle" style:UIBarButtonItemStylePlain target:self action:@selector(onJustified4Clicked:)];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:justifiedLayout1, justifiedLayout2,justifiedLayout3, justifiedLayout4,nil];
    
    //5. font size
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"Helvetica-Bold" size:12.0],NSFontAttributeName,
      nil]];
    
}

-(void)addSearchBar{
    if (_searchBarContainer) {
        _searchBar.text = @"";
        _searchBarContainer.hidden = NO;
        [self.view addSubview:_searchBarContainer];
        
    } else {
        _searchBarContainer = [[UIView alloc] initWithFrame:self.view.bounds];
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(20, 20, self.view.bounds.size.width - 40, 44)];
        [_searchBar setPlaceholder:@"Search Flickr ..."];
        //make sure search bar is always on top of every thing.
        _searchBar.layer.zPosition = MAXFLOAT;
        _searchBar.delegate = self;
        
        _searchBarContainer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
        UITapGestureRecognizer *tapHandler = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapOutside:)];
        [_searchBarContainer addGestureRecognizer:tapHandler];
        
        [_searchBarContainer addSubview:_searchBar];
        [self.view addSubview:_searchBarContainer];
    }
    //bounce animatino to the search bar
    _searchBar.frame = CGRectMake(20, 600, _searchBar.frame.size.width, _searchBar.frame.size.height);
    [UIView animateWithDuration:0.8f delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        _searchBar.frame = CGRectMake(20, 20, self.view.bounds.size.width - 40, 44);
    } completion:nil];
}

-(void)dismissSearchBar{
    if (!_searchBarContainer || _searchBarContainer.hidden) {
        return;
    }
    CGSize size = self.view.bounds.size;
    CGRect center = CGRectMake(size.width/2, size.height/2, 0, 0);
    CGRect oldFrame = _searchBar.frame;
    
    [UIView animateWithDuration:0.6f animations:^{
        
        //animate with fade out and zoom out.
        _searchBarContainer.alpha = 0;
        _searchBar.frame = center;
        
    }completion:^(BOOL finished){
        [_searchBarContainer removeFromSuperview];
        
        //restore previous states
        _searchBarContainer.hidden = YES;
        _searchBarContainer.alpha = 1;
        _searchBar.frame = oldFrame;
    }];
    
    
}

-(void)onTapOutside:(id)sender {
    [self dismissSearchBar];
}

#pragma MARK - Nav bar button outlets

-(void)onSearchClicked:(id)sender {
    [self addSearchBar];
}

-(void)onExploreClicked:(id)sender {
    
    [self dismissSearchBar];
    if (self.childViewControllers.count > 0) {
        JustifiedViewController* child = self.childViewControllers[0];
        child.photoSource = kExplore;
        [child updatePhotos:_flickr.interestingness.photos  resetState:YES];
        return;
    }

    [self showExplorePhotos:sender];
}

-(void)onJustified1Clicked:(id)sender {
    JustifiedViewController* child = self.childViewControllers[0];
    [child updateJustifiedType:kStrictSpacing];
}

-(void)onJustified2Clicked:(id)sender {
    JustifiedViewController* child = self.childViewControllers[0];
    [child updateJustifiedType:kLeftAligned];
}
-(void)onJustified3Clicked:(id)sender {
    JustifiedViewController* child = self.childViewControllers[0];
    [child updateJustifiedType:kStretchSpaces];
}
-(void)onJustified4Clicked:(id)sender {
    JustifiedViewController* child = self.childViewControllers[0];
    [child updateJustifiedType:kFreeSized];
}


#pragma search delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self doSearch:_searchBar.text];
    
    //searchbar needs explicity call to resign first responder
    [_searchBar resignFirstResponder];
    [self.view endEditing:YES];
}


#pragma PRIVATE methods

- (void)doSearch:(NSString *)query{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (query && query.length > 0) {
        [_flickr.search startSearch:query completionBlock:^(NSString *searchTerm, NSArray *results, NSError *error) {
            
            NSLog(@"Found %ld photos matching %@", [results count],searchTerm);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if(results && [results count] > 0) {
                    if (self.childViewControllers.count > 0) {
                        
                        JustifiedViewController* child = self.childViewControllers[0];
                        child.photoSource = kSearch;
                        
                        [child updatePhotos:_flickr.search.photos resetState:YES];
                        [self dismissSearchBar];
                        
                    } else {
                        //TODO:
                        //[self embedExploreInHomeView];
                    }
                } else {
                    NSLog(@"Error searching Flickr: %@", error.localizedDescription);
                    [UIAlertView showAlert:self with:@"Flickr APIKey Expired" withMessage:@"There is no photos found matching your query."];
                    _searchBar.text = nil;
                }
            });
            
        }];
    }
}


-(void)embedExploreInHomeView{
    //already added
    if (self.childViewControllers.count > 0) {
        NSLog(@"Error: Justified child view controller already added");
        return;
    }
    JustifiedViewController* target = [[JustifiedViewController alloc] init];
    target.photos = _flickr.interestingness.photos;
    target.photoSource = kExplore;
    target.layoutType = kStrictSpacing;
    
    target.delegate = self;
    
    
    target.view.frame = self.view.bounds;
    [self addChildViewController:target];
    [self.view addSubview:target.view];
}

-(IBAction)showExplorePhotos:(id)sender {
    if (_flickr.interestingness.photos.count > 0) {
        [self embedExploreInHomeView];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_flickr.interestingness refreshWithCompletionBlock:^(NSArray *results, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(results && [results count] > 0) {
            [self embedExploreInHomeView];
        } else {
            DLog(@"Error searching Flickr: %@", error.localizedDescription);
            ULog(@"Please replace the 'kExploreUrl' with the latest url on flickr dev site.");
        }
        
    }];

}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    self.searchBarContainer.frame = self.view.bounds;
    _searchBar.frame = CGRectMake(20, 20, self.view.bounds.size.width - 40, 44);
}

-(void)onLoadMore:(PhotoSource)source {
    if (kExplore == source) {
        [_flickr.interestingness loadMoreWithCompletionBlock:^(NSArray *results, NSError *error) {
            [_flickr.search loadMoreWithCompletionBlock:^(NSString* term, NSArray *results, NSError *error) {
                JustifiedViewController* child = self.childViewControllers[0];
                [child updatePhotos:_flickr.interestingness.photos resetState:NO];
            }];
        }];
    } else if (kSearch == source) {
        [_flickr.search loadMoreWithCompletionBlock:^(NSString* term, NSArray *results, NSError *error) {
            JustifiedViewController* child = self.childViewControllers[0];
            [child updatePhotos:_flickr.search.photos  resetState:NO];
        }];
    }
}

-(void)onRefresh:(PhotoSource)source {
    if (kExplore == source) {
        [_flickr.interestingness refreshWithCompletionBlock:^(NSArray *results, NSError *error) {
            [_flickr.search loadMoreWithCompletionBlock:^(NSString* term, NSArray *results, NSError *error) {
                JustifiedViewController* child = self.childViewControllers[0];
                [child updatePhotos:_flickr.interestingness.photos  resetState:NO];
            }];
        }];
    } else if (kSearch == source) {
        [_flickr.search refreshWithCompletionBlock:^(NSString* term, NSArray *results, NSError *error) {
            JustifiedViewController* child = self.childViewControllers[0];
            [child updatePhotos:_flickr.search.photos  resetState:NO];
        }];
    }
}


@end
