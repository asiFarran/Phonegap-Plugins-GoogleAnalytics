#import "GAI.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "AppDelegate.h"
#import "GoogleAnalyticsPlugin.h"


@implementation GoogleAnalyticsPlugin


- (void) init:(CDVInvokedUrlCommand*)command
{
    
    NSString    *accountID = [command.arguments objectAtIndex:0];
    NSInteger   dispatchPeriod = [[command.arguments objectAtIndex:1] intValue];
    
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    [GAI sharedInstance].dispatchInterval = dispatchPeriod;
    
    // Optional: set debug to YES for extra debugging information.
    //[GAI sharedInstance].dryRun = YES;
    
     // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Create tracker instance.
    [[GAI sharedInstance] trackerWithTrackingId:accountID];
    
    initialized = YES;
    
    [self successWithMessage:[NSString stringWithFormat:@"init: accountID = %@; Interval = %d seconds",accountID, dispatchPeriod] toID:command.callbackId];
}

- (void) trackView:(CDVInvokedUrlCommand*)command
{
    NSString   *viewName = [command.arguments objectAtIndex:0];
    NSArray   *dimensions = [command.arguments objectAtIndex:1];
    NSArray   *metrics = [command.arguments objectAtIndex:2];
    
    if (initialized)
    {
        GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createAppView];
        [builder set:viewName forKey:kGAIScreenName];
        
        if(dimensions.count > 0){
            
            for (NSArray *dimension in dimensions) {
               
                [builder set:[dimension objectAtIndex:1]  forKey:[GAIFields customDimensionForIndex:[[dimension objectAtIndex:0] intValue]]];
            }
        }
        
        if(metrics.count > 0){
            
            for (NSArray *metric in metrics) {
                [builder set:[metric objectAtIndex:1]  forKey:[GAIFields customMetricForIndex:[[metric objectAtIndex:0] intValue]]];
            }
        }
        
        
        [[[GAI sharedInstance] defaultTracker] send:[builder build]];
    }
    else
    {
        [self failWithMessage:@"trackView failed - not initialized" toID:command.callbackId withError:nil];
    }
}


- (void) trackEvent:(CDVInvokedUrlCommand*)command
{
    
    NSString *category = [command.arguments objectAtIndex:0];
    NSString *action = [command.arguments objectAtIndex:1];
    NSString *label = [command.arguments objectAtIndex:2];
    NSNumber *value = [command.arguments objectAtIndex:3];
    NSArray  *dimensions = [command.arguments objectAtIndex:4];
    NSArray  *metrics = [command.arguments objectAtIndex:5];
    
    if (initialized)
    {
        GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createEventWithCategory:category action: action label:label value:value];
        
        if(dimensions.count > 0){
            
            for (NSArray *dimension in dimensions) {
                
                [builder set:[dimension objectAtIndex:1]  forKey:[GAIFields customDimensionForIndex:[[dimension objectAtIndex:0] intValue]]];
            }
        }
        
        if(metrics.count > 0){
            
            for (NSArray *metric in metrics) {
                [builder set:[metric objectAtIndex:1]  forKey:[GAIFields customMetricForIndex:[[metric objectAtIndex:0] intValue]]];
            }
        }
        
        
        
        [[[GAI sharedInstance] defaultTracker] send:[builder build]];
    }
    else
    {
        [self failWithMessage:@"trackView failed - not initialized" toID:command.callbackId withError:nil];
    }
}

- (void) setSessionDimensionsAndMetrics:(CDVInvokedUrlCommand*)command
{
    NSArray   *dimensions = [command.arguments objectAtIndex:0];
    NSArray   *metrics = [command.arguments objectAtIndex:1];
    
    if (initialized)
    {
        id tracker = [[GAI sharedInstance] defaultTracker];
        
        if(dimensions.count > 0){
            
            for (NSArray *dimension in dimensions) {
                
                [tracker set:[GAIFields customDimensionForIndex:[[dimension objectAtIndex:0] intValue]]
                       value:[dimension objectAtIndex:1]];
            }
        }
        
        if(metrics.count > 0){
            
            for (NSArray *metric in metrics) {
                
                [tracker set:[GAIFields customMetricForIndex:[[metric objectAtIndex:0] intValue]]
                       value:[metric objectAtIndex:1]];
            }
        }
    }
    else
    {
        [self failWithMessage:@"trackView failed - not initialized" toID:command.callbackId withError:nil];
    }

}

-(void)successWithMessage:(NSString *)message toID:(NSString *)callbackID
{
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];

    [self.commandDelegate sendPluginResult:commandResult callbackId:callbackID];
}

-(void)failWithMessage:(NSString *)message toID:(NSString *)callbackID withError:(NSError *)error
{
    NSString        *errorMessage = (error) ? [NSString stringWithFormat:@"%@ - %@", message, [error localizedDescription]] : message;
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:errorMessage];

    [self.commandDelegate sendPluginResult:commandResult callbackId:callbackID];
}


@end
