# iOS_SimpleFlickrClient

A simple flickr client demo use UICollectionView for implementing flickr style justified View.

This is initially based on Ray's UICollectionView tutarial and used all of his assets:
http://www.raywenderlich.com/22324/beginning-uicollectionview-in-ios-6-part-12


#### Features
- [x] No log in required to use.
- [x] Daily polular flickr photos in 'Explore'
- [x] Free searching in flickr's huge photo gallery.
- [x] Flickr official Justified Layout style (strict spacing, Flow Layout vertical)
- [x] Stack layout (Three photos together, second and third are stacked up, Flow Layout Horizontal with fixed height 100pts)
- [x] Other Justified Layout Variations.
  - [x] Left Aligned (with custom FlowLayout)
  - [x] auto stretching space to fill contentView width (with same row height)
  - [x] free sized cells (default as in Ray's demo)

The flickr photos are from these two APIs:

- [x] Search & Explore
   - [x] Show search result by taking the user input as keyword
   - [x] api link:https://www.flickr.com/services/api/explore/flickr.photos.search
- [x] Show flickr interestingness / explore photos
   - [x] api link: https://www.flickr.com/services/api/explore/flickr.interestingness.getList



### Walkthrough

![Video Walkthrough](myflickr.gif)

