//
//  JSInterface.h
//  WKEasyJSWebView
//
//  Created by 吉久东 on 2019/8/13.
//  Copyright © 2019 JIJIUDONG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKJSWebView.h"
@interface JSInterface : NSObject
- (void)testWithParams:(NSString*)_params callback:(WKJSDataFunction*)_callback;
@end
