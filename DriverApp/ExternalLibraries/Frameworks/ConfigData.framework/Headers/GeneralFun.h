//
//  GeneralFunctions.h
//  ConfigData
//
//  Created by Admin on 11/21/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GeneralFun : NSObject

- (NSString *) getSessionId;
- (NSString *) getMemberd;
- (void) saveValue:(NSString *) String value:(id) value;
- (NSString *) getLanguageLabelWithOrigValue:(NSString *) origValue key:(NSString *) key;
- (NSData *) createBodyWithParameters:(NSDictionary*)parameters filePathKey:(NSString*)filePathKey imageDataKey:(NSData*)imageDataKey boundary:(NSString*)boundary fileName:(NSString*)fileName;
- (NSString *) getDataStr:(NSString *) input;
- (id) getValue:(NSString *) key;
- (BOOL) isDevelopmentMode;
@end
