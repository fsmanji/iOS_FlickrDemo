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

#define kExploreTag @"explore"

@interface HomeViewController () <UISearchBarDelegate>
@property UISearchBar *searchBar;
@property UIView* searchBarContainer;

@property(nonatomic, strong) NSMutableDictionary *searchResults;
@property(nonatomic, strong) NSMutableArray *searches;
@property(nonatomic, strong) Flickr *flickr;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self styleNavigationBar];
    
    _searchResults = [NSMutableDictionary dictionary];
    _searches = [NSMutableArray array];
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
}

-(void)dismissSearchBar{
    [_searchBarContainer removeFromSuperview];
    _searchBarContainer.hidden = YES;
}

-(void)onTapOutside:(id)sender {
    [self dismissSearchBar];
}

#pragma MARK - Nav bar button outlets

-(void)onSearchClicked:(id)sender {
    [self addSearchBar];
}

-(void)onExploreClicked:(id)sender {
    if (_searchBarContainer.hidden) {
        return;
    }
    [self dismissSearchBar];
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
        [_flickr searchFlickrForTerm:query completionBlock:^(NSString *searchTerm, NSArray *results, NSError *error) {
            
            if(results && [results count] > 0) {
                
                if(![self.searches containsObject:searchTerm]) {
                    NSLog(@"Found %ld photos matching %@", [results count],searchTerm);
                    [self.searches insertObject:searchTerm atIndex:0];
                    self.searchResults[searchTerm] = results;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    if (self.childViewControllers.count > 0) {
                        
                        JustifiedViewController* child = self.childViewControllers[0];
                        [child updatePhotos:results];
                        [self dismissSearchBar];
                        
                    } else {
                        [self embedExploreInHomeView];
                    }
                    
                });
            } else {
                NSLog(@"Error searching Flickr: %@", error.localizedDescription);
                [UIAlertView showAlert:self with:@"Flickr APIKey Expired" withMessage:@"Please replace the 'kApiKey/kAuthToken/kApiSig' with the latest ones."];
            }
        }];
    }
}


-(void)embedExploreInHomeView{
    JustifiedViewController* target = [[JustifiedViewController alloc] init];
    target.photos = _searchResults[kExploreTag];
    target.layoutType = kStrictSpacing;
    target.view.frame = self.view.bounds;
    
    [self addChildViewController:target];
    [self.view addSubview:target.view];
}

-(IBAction)showExplorePhotos:(id)sender {
    if (_searchResults[kExploreTag]) {
        [self embedExploreInHomeView];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [_flickr exploreWithCompletionBlock:^(NSArray *results, NSError *error) {
        
        if(results && [results count] > 0) {
            NSString * searchTerm = kExploreTag;
            if(![self.searches containsObject:searchTerm]) {
                NSLog(@"Found %ld photos matching %@", [results count],searchTerm);
                [self.searches insertObject:searchTerm atIndex:0];
                
            }
            self.searchResults[searchTerm] = results;
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self embedExploreInHomeView];
            
        } else {
            NSLog(@"Error searching Flickr: %@", error.localizedDescription);
            [UIAlertView showAlert:self with:@"Flickr APIKey Expired" withMessage:@"Please replace the 'kExploreUrl' with the latest url on flickr dev site."];
        }
    }];
}

@end
