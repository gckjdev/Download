//
//  DownloadAppDelegate.h
//  Download
//
//  Created by  on 11-11-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CoreDataUtil.h"
#import "PPApplication.h"
#import "MobClick.h"
#import "PPTabBarController.h"
#import "ReviewRequest.h"

#define kAppId			@"456494464"					// To be changed for each project
#define kMobClickKey	@"4e2d3cc0431fe371c3000029"		// To be changed for each project
#define kDbFileName     @"Download"

@interface DownloadAppDelegate : PPApplication <UIApplicationDelegate, UITabBarControllerDelegate, MobClickDelegate>
{
    UIBackgroundTaskIdentifier backgroundTask;
}

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) PPTabBarController	*tabBarController;
@property (nonatomic, retain) CoreDataManager       *dataManager;
@property (nonatomic, retain) ReviewRequest         *reviewRequest;

@end
