//
//  ExeServerUrlNew.h
//  DriverApp
//
//  Created by Admin on 11/20/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ExeServerTask : NSObject <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate>
{
    NSMutableDictionary * dict_data;
    BOOL isOpenLoader;
    UIView *currentView;
    BOOL isDeviceTokenGenerate;
    NSString *currentPostString;
    NSMutableURLRequest *currRequest;
    ExeServerTask *currInstance;
    NSURLSessionDataTask *currentTask;
    BOOL isTaskKilled;
    UIColor *tintcolor;
    NSString *webServerPath;
    NSString *isDevelopmentMode;
    
}

- (void) cancel;

- (void)executeGetProcess:(NSString *)urlString CompletionHandler:(void (^)(NSString *response))block;
- (void)executePostProcess:(void (^)(NSString *response))block;
- (id) uploadImage:(NSData *) fileData fileName:(NSString *) fileName completionHandler:(void (^)(NSString *response))block;
- (instancetype)init:(NSDictionary *) dict_data currentView:(UIView *) currentView isOpenLoader:(BOOL) isOpenLoader url:(NSString*)urlPath appColor:(UIColor *)appThemeColor;
- (instancetype)init:(NSDictionary *) dict_data currentView:(UIView *) currentView isOpenLoader:(BOOL) isOpenLoader isDeviceTokenGenerate:(BOOL) isDeviceTokenGenerate url:(NSString*)urlPath appColor:(UIColor *)appThemeColor;
- (instancetype)init:(NSDictionary *) dict_data currentView:(UIView *) currentView url:(NSString*)urlPath appColor:(UIColor *)appThemeColor;

@end
