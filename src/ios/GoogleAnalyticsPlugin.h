#import <Cordova/CDVPlugin.h>
#import "GAI.h"

@interface GoogleAnalyticsPlugin : CDVPlugin
{
    BOOL initialized;
}

- (void) init:(CDVInvokedUrlCommand*)command;
- (void) trackEvent:(CDVInvokedUrlCommand*)command;
- (void) trackView:(CDVInvokedUrlCommand*)command;
- (void) setSessionDimensionsAndMetrics:(CDVInvokedUrlCommand*)command;

@end