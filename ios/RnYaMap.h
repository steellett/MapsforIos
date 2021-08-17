//
//  RnYaMap.h
//  RnYaMap
//
//  Created by Pavel on 17.08.2021.
//



#import <React/RCTBridgeModule.h>

@interface YMap : NSObject <RCTBridgeModule>
-(void) initWithKey:(NSString *) apiKey;
@end
