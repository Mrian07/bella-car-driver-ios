//
//  InfoProvider.h
//  ConfigData
//
//  Created by Admin on 11/22/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoProvider : NSObject

- (NSString *) getDataStr:(NSString *) input;
- (NSString *) getAppConfigurationStr;
@end
