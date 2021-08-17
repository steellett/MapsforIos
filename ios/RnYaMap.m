//
//  RnYaMap.m
//  RnYaMap
//
//  Created by Pavel on 17.08.2021.
//

#import <Foundation/Foundation.h>
#import "RNYaMap.h"
#import <YandexMapsMobile/YMKMapKitFactory.h>

@implementation YMap

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(initWithKey:(NSString*)apiKey){
  // вызов кода в main потоке
  dispatch_async(dispatch_get_main_queue(), ^{
    [YMKMapKit setApiKey: apiKey];
  });
}

@end
