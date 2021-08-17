//
//  RnMapManager.m
//  RnMapManager
//
//  Created by Pavel on 17.08.2021.
//

#import <Foundation/Foundation.h>
#import <React/RCTViewManager.h>
#import <YandexMapsMobile/YMKMapKitFactory.h>
#import <iosProject-Swift.h>

@interface RNTMapManager : RCTViewManager
@end

@implementation RNTMapManager

RCT_EXPORT_MODULE(RNTMap)
RCT_EXPORT_VIEW_PROPERTY(zoom, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(apiKey, NSString)
RCT_EXPORT_VIEW_PROPERTY(onPointPress, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onMapPress, RCTBubblingEventBlock)

RCT_CUSTOM_VIEW_PROPERTY(points, NSString, MapView) {
  view.data = [RCTConvert NSString:json];
}

- (UIView *)view
{
  return  [[MapView alloc] init];
}

@end
