//
//  AppDelegate.m
//  AppBoxAutoUpdateDemo-ObjC
//
//  Created by Vineet Choudhary on 02/02/17.
//  Copyright © 2017 Developer Insider. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //Check for update
    [AppNewVersionNotifier initWithKey:@"49lsofdx9lsi61j"];
    return YES;
}


@end
