//
//  ViewController.m
//  AdmobExample
//
//  Created by DucHa on 8/4/16.
//  Copyright © 2016 DucHa. All rights reserved.
//

#import "ViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface ViewController () <GADNativeAppInstallAdLoaderDelegate, GADNativeContentAdLoaderDelegate>
@property (strong, nonatomic) GADAdLoader *adLoader;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet GADNativeExpressAdView *nativeExpressView;
@property (weak, nonatomic) IBOutlet GADNativeContentAdView *nativeContentAdView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.adLoader = [[GADAdLoader alloc] initWithAdUnitID:@"ca-app-pub-4340526482547199/9809711469" rootViewController:self adTypes:@[kGADAdLoaderAdTypeNativeContent, kGADAdLoaderAdTypeNativeAppInstall] options:nil];
    self.adLoader.delegate = self;
    GADRequest *request = [GADRequest request];
    request.testDevices = @[kGADSimulatorID];
    [self.adLoader loadRequest:request];
    
    self.bannerView.adUnitID = @"ca-app-pub-4340526482547199/7539072663";
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:request];
    
    self.nativeExpressView.adUnitID = @"ca-app-pub-4340526482547199/9809711469";
    self.nativeExpressView.rootViewController = self;
    [self.nativeExpressView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)adLoader:(GADAdLoader *)adLoader
didReceiveNativeAppInstallAd:(GADNativeAppInstallAd *)nativeAppInstallAd {
    // Create and place ad in view hierarchy.
    GADNativeAppInstallAdView *appInstallAdView =
    [[[NSBundle mainBundle] loadNibNamed:@"NativeAppInstallAdView"
                                   owner:nil
                                 options:nil] firstObject];
    
    // Associate the app install ad view with the app install ad object. This is required to make the
    // ad clickable.
    appInstallAdView.nativeAppInstallAd = nativeAppInstallAd;
    
    // Populate the app install ad view with the app install ad assets.
    // Some assets are guaranteed to be present in every app install ad.
    ((UILabel *)appInstallAdView.headlineView).text = nativeAppInstallAd.headline;
    ((UIImageView *)appInstallAdView.iconView).image = nativeAppInstallAd.icon.image;
    ((UILabel *)appInstallAdView.bodyView).text = nativeAppInstallAd.body;
    ((UIImageView *)appInstallAdView.imageView).image =
    ((GADNativeAdImage *)[nativeAppInstallAd.images firstObject]).image;
    [((UIButton *)appInstallAdView.callToActionView)setTitle:nativeAppInstallAd.callToAction
                                                    forState:UIControlStateNormal];
    
    // Other assets are not, however, and should be checked first.
    if (nativeAppInstallAd.starRating) {
        appInstallAdView.starRatingView.hidden = NO;
    } else {
        appInstallAdView.starRatingView.hidden = YES;
    }
    
    if (nativeAppInstallAd.store) {
        ((UILabel *)appInstallAdView.storeView).text = nativeAppInstallAd.store;
        appInstallAdView.storeView.hidden = NO;
    } else {
        appInstallAdView.storeView.hidden = YES;
    }
    
    if (nativeAppInstallAd.price) {
        ((UILabel *)appInstallAdView.priceView).text = nativeAppInstallAd.price;
        appInstallAdView.priceView.hidden = NO;
    } else {
        appInstallAdView.priceView.hidden = YES;
    }
    
    // In order for the SDK to process touch events properly, user interaction should be disabled.
    appInstallAdView.callToActionView.userInteractionEnabled = NO;
}

- (void)adLoader:(GADAdLoader *)adLoader
didReceiveNativeContentAd:(GADNativeContentAd *)nativeContentAd {
    // Create and place ad in view hierarchy.
    GADNativeContentAdView *contentAdView =
    [[[NSBundle mainBundle] loadNibNamed:@"NativeContentAdView"
                                   owner:nil
                                 options:nil] firstObject];
    
    // Associate the content ad view with the content ad object. This is required to make the ad
    // clickable.
    contentAdView.nativeContentAd = nativeContentAd;
    
    // Populate the content ad view with the content ad assets.
    // Some assets are guaranteed to be present in every content ad.
    ((UILabel *)contentAdView.headlineView).text = nativeContentAd.headline;
    ((UILabel *)contentAdView.bodyView).text = nativeContentAd.body;
    ((UIImageView *)contentAdView.imageView).image =
    ((GADNativeAdImage *)[nativeContentAd.images firstObject]).image;
    ((UILabel *)contentAdView.advertiserView).text = nativeContentAd.advertiser;
    [((UIButton *)contentAdView.callToActionView)setTitle:nativeContentAd.callToAction
                                                 forState:UIControlStateNormal];
    
    // Other assets are not, however, and should be checked first.
    if (nativeContentAd.logo && nativeContentAd.logo.image) {
        ((UIImageView *)contentAdView.logoView).image = nativeContentAd.logo.image;
        contentAdView.logoView.hidden = NO;
    } else {
        contentAdView.logoView.hidden = YES;
    }
    
    // In order for the SDK to process touch events properly, user interaction should be disabled.
    contentAdView.callToActionView.userInteractionEnabled = NO;
}

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Receive ad with error: %@", error);
}
@end
