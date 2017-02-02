//
//  AppNewVersionNotifier.m
//  AppBox
//
//  Created by iTamilan on 02/01/2017.
//  Copyright © 2017 iTamilan. All rights reserved.
//


#import "AppNewVersionNotifier.h"
#import <SafariServices/SafariServices.h>
static NSString *const APP_UPDATE_NOTIFIER_LATESTVERSION = @"latestVersion";
static NSString *const APP_UPDATE_NOTIFIER_IDENTIFIER = @"identifier";
static NSString *const APP_UPDATE_NOTIFIER_VERSION = @"version";
static NSString *const APP_UPDATE_NOTIFIER_BUILD = @"build";
static NSString *const APP_UPDATE_NOTIFIER_MANIFEST_LINK = @"manifestLink";
static NSString *const APP_UPDATE_NOTIFIER_TIMESTAMP = @"timestamp";
static NSString *const APP_UPDATE_NOTIFIER_UNIQUE_SHORT_URL = @"timestamp";

@implementation AppNewVersionNotifier
{
    //String URL which requires for all process
    NSString *stringDBAppInfoKey;
    NSString *stringDBAppInfoURL;
    NSString *stringTryAppInfoURL;
    //Creating a seperate queue for all process
    dispatch_queue_t appUpdaterQueue;
    //APP INFO DICT
    NSDictionary *dictAppInfo;
    //Latest APP information
    NSString *strLatestBuild;
    NSString *strLatestVersion;
    NSString *strLatestTimeStamp;
    NSString *strLatestBundleIdentifier;
    NSString *strLatestManifestLink;
    //Current APP information
    NSString *strCurrentBuild;
    NSString *strCurrentVersion;
    NSString *strCurrentBundleIdentifier;
}
//3kxuox3zwufmxec
+(instancetype)initWithKey:(NSString *)key{
    NSString *errorString = [NSString stringWithFormat:@"%s \"Key\" should not be empty",__PRETTY_FUNCTION__];
    if (errorString) {
        NSLog(@"Error %@",errorString);
    }
    NSAssert(key.length>0,errorString);
    return [[AppNewVersionNotifier alloc] initWithKey:key];
}
-(instancetype)initWithKey:(NSString *)key{
    self = [super init];
    stringDBAppInfoKey = key;
    appUpdaterQueue = dispatch_queue_create("com.iTamilan.appupdatenotifier", 0);
    dispatch_async(appUpdaterQueue, ^{
        [self initializeDataAndProcess];
    });
    return self;
}
-(instancetype)init{
    self = [super init];
    return self;
}
#pragma mark - Load Data
-(void)initializeDataAndProcess{
    stringDBAppInfoURL = [NSString stringWithFormat:@"https://www.dropbox.com/s/%@/appinfo.json?dl=1",stringDBAppInfoKey];
    stringTryAppInfoURL = [NSString stringWithFormat:@"http://i.tryappbox.com/?url=/s/%@/appinfo.json",stringDBAppInfoKey];
    strCurrentBuild = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    strCurrentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    strCurrentBundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    //Downloading the APP Info File
    [self downloadAppInfoFile];
}
#pragma mark - Downloading the APPINFO JSON FILE
-(void)downloadAppInfoFile{
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:stringDBAppInfoURL] options:NSDataReadingUncached error:&error];
    if(error)
    {
        NSLog(@"AppUpadterNotifier - Error while downloading the app info -----%@",error);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self downloadAppInfoFile];
        });
    }
    [self parseJSONDataIntoDictinory:data];
}
-(void)parseJSONDataIntoDictinory:(NSData *)jsonData{
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&error];
    if(error){
        NSLog(@"AppUpadterNotifier - Error while parsing the json data -----%@",error);
    }
    dictAppInfo = dict;
    //Parsing the app info dict
    [self parseAppInfoDictinory];
    //Compare latest version
    if([self isOlderVersion]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlertViewForLatestVersion];
        });
        NSLog(@"New version %@ (%@) is available in APP BOX.",strLatestVersion,strLatestBuild);
    }
    else{
        NSLog(@"Your app is uptodate");
    }
}
-(void)parseAppInfoDictinory{
    NSDictionary *dictLastestVersion = [dictAppInfo objectForKey:APP_UPDATE_NOTIFIER_LATESTVERSION];
    strLatestVersion = [dictLastestVersion objectForKey:APP_UPDATE_NOTIFIER_VERSION];
    strLatestBuild = [dictLastestVersion objectForKey:APP_UPDATE_NOTIFIER_BUILD];
    strLatestBundleIdentifier = [dictLastestVersion objectForKey:APP_UPDATE_NOTIFIER_IDENTIFIER];
    strLatestManifestLink = [dictLastestVersion objectForKey:APP_UPDATE_NOTIFIER_MANIFEST_LINK];
    strLatestTimeStamp = [dictLastestVersion objectForKey:APP_UPDATE_NOTIFIER_TIMESTAMP];
}
-(BOOL)isOlderVersion{
    if([strCurrentVersion isEqualToString:strLatestVersion]){
        return ![self isString1:strCurrentBuild greaterThanOrEqualString2:strLatestBuild withSeperatorStr:@"."];
    }else{
        return ![self isString1:strCurrentVersion greaterThanOrEqualString2:strLatestVersion withSeperatorStr:@"."];
    }
}
-(void)showAlertViewForLatestVersion{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"New Version!" message:[NSString stringWithFormat:@"New version %@ (%@) is available in APP BOX. Do you want to update?",strLatestVersion,strLatestBuild]  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                       handler:nil];
        [alertController addAction:action];
    UIAlertAction *actionInstall = [UIAlertAction actionWithTitle:@"Update" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       [self openSafariViewController];
                                                   }];
    [alertController addAction:actionInstall];
    [[self getTopMostViewControllerFromRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController]presentViewController:alertController animated:YES completion:nil];
}
-(void)openSafariViewController
{
    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:stringTryAppInfoURL]];
    [[self getTopMostViewControllerFromRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController]presentViewController:safariVC animated:YES completion:nil];
}
#pragma mark - Get top viewcontroller
-(UIViewController *)getTopMostViewControllerFromRootViewController:(UIViewController *)rootViewController
{
    if([rootViewController presentedViewController])
    {
        return [self getTopMostViewControllerFromRootViewController:[rootViewController presentedViewController]];
    }
    else if ([rootViewController isKindOfClass:[UINavigationController class]])
    {
        return [self getTopMostViewControllerFromRootViewController:[[(UINavigationController *)rootViewController viewControllers] lastObject]];
    }
    else if ([rootViewController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tabbarCtrl = (UITabBarController *)rootViewController;
        return [self getTopMostViewControllerFromRootViewController:tabbarCtrl.selectedViewController];
    }
    else
        return rootViewController;
}
#pragma mark - String Compare
-(BOOL)isString1:(NSString *)str1 greaterThanOrEqualString2:(NSString *)str2 withSeperatorStr:(NSString *)seperator
{
    NSMutableArray *arra1 = [[str1 componentsSeparatedByString:seperator] mutableCopy];
    NSMutableArray *arra2 = [[str2 componentsSeparatedByString:seperator] mutableCopy];
    if([[arra1 firstObject] integerValue]==[[arra2 firstObject] integerValue])
    {
        [arra1 removeObjectAtIndex:0];
        [arra2 removeObjectAtIndex:0];
        if(arra1.count==0)
        {
            return arra1.count>=arra2.count;
        }
        else
        {
            return [self isString1:[arra1 componentsJoinedByString:seperator] greaterThanOrEqualString2:[arra2 componentsJoinedByString:seperator] withSeperatorStr:seperator];
        }
    }
    else
    {
        return [[arra1 firstObject] integerValue]>[[arra2 firstObject] integerValue];
    }
    
    return YES;
}
@end
